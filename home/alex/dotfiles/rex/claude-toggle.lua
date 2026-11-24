-- Toggle a centered Claude popup for the CURRENT directory.
--
-- Port of the tmux script of the same name. Each directory gets its own
-- Claude block, labelled by the directory path, so instances stay separated
-- and their state survives closing the popup: hiding minimizes the block's
-- floating layer (it keeps running) instead of closing it.
--
-- Rex has floating layers, so no attach/detach dance and no shared session
-- is needed — the layer simply goes minimized and comes back.

local TERMINAL = "com.superlogical.terminal"
local POPUP = { 0.05, 0.05, 0.9, 0.9 } -- x, y, w, h as fractions of the window

local PREFIX = "claude:"

local function blocks()
  return (rex.session.list_blocks{} or {}).blocks or {}
end

-- The label is the directory path itself: stable and unique.
local function find_block(label)
  for _, block in ipairs(blocks()) do
    if block.label == label then
      return block
    end
  end
end

-- The floating layer a block sits in, if any. Minimized layers stay in the
-- view with state == "minimized", which is what keeps them in the sidebar.
local function floating_layer(block_id)
  if not block_id then
    return nil
  end
  local view = rex.session.view{}
  for _, window in ipairs((view or {}).windows or {}) do
    for _, layer in ipairs(window.layers or {}) do
      if layer.kind == "floating" then
        for _, block in ipairs(layer.blocks or {}) do
          if block.block_id == block_id then
            return layer
          end
        end
      end
    end
  end
end

-- Whether the active window has a zoomed pane. Opening the popup clears the
-- zoom, because Rex's zoom follows focus and the popup takes it.
local function was_zoomed()
  local view = rex.session.view{}
  for _, window in ipairs((view or {}).windows or {}) do
    if window.window_id == (view or {}).active_window_id then
      return window.zoomed_block_id ~= nil
    end
  end
  return false
end

-- Whether the pane the popup was opened from was zoomed, keyed by the popup's
-- block id, so hiding it can put the zoom back. Only as good as the current
-- config load, which is fine for a hint.
local came_zoomed = {}
local debug_last = {}

-- Hide a popup by minimizing its layer. The block keeps running and stays in
-- session.view, so the sidebar still lists it. The server moves focus back to
-- the layer used before it (or the nearest visible pane) on its own, so no
-- focus-hopping is needed here.
local function hide(popup_id)
  local layer = floating_layer(popup_id)
  if not layer then
    return false
  end

  local rezoom = came_zoomed[popup_id]
  came_zoomed[popup_id] = nil

  rex.session.set_layer_state{ layer_id = layer.layer_id, state = "minimized" }

  debug_last = { layer = layer.layer_id, rezoom = tostring(rezoom) }

  -- Renux keeps its own zoom flag, and opening the popup over a zoomed pane
  -- leaves that flag on while the layout shows unzoomed. pane.zoom is a toggle
  -- against that flag, so the first one only clears the stale state and the
  -- second one actually zooms.
  if rezoom then
    pcall(rex.client.queue, "pane.zoom")
    pcall(rex.client.queue, "pane.zoom")
  end

  return true
end

-- Which directory this keypress is about. Claude runs as the block's command,
-- with no shell integration to report a directory, so when the popup itself is
-- focused the directory comes from its label instead.
local function current_dir(ctx)
  for _, block in ipairs(blocks()) do
    if block.block_id == ctx.block_id and block.label:sub(1, #PREFIX) == PREFIX then
      return block.label:sub(#PREFIX + 1)
    end
  end
  -- Otherwise the focused terminal reports it as file://HOST/path.
  local pwd = rex.block.call(TERMINAL, "pwd", {})
  if not pwd or not pwd.pwd then
    return nil
  end
  return (pwd.pwd:gsub("^%a+://[^/]*", ""))
end

rex.action{
  name = "claude_toggle",
  title = "Toggle Claude",
  description = "Open Claude for the current directory in a floating window, or hide it.",
  run = function(ctx)
    local dir = current_dir(ctx)
    if not dir then
      return "no directory for the focused block"
    end

    local label = PREFIX .. dir
    local block = find_block(label)

    if block then
      local layer = floating_layer(block.block_id)

      if layer and layer.state == "minimized" then
        -- Toggle on: bring the layer back, raised and focused, in one change.
        came_zoomed[block.block_id] = was_zoomed()
        rex.session.set_layer_state{
          layer_id = layer.layer_id,
          state = "normal",
          focus = true,
        }
        return true
      end

      if layer then
        -- Toggle off: minimize, keeping it running and in the sidebar.
        hide(block.block_id)
        return true
      end

      -- No floating layer: either detached (left over from an older run) or
      -- sitting in the window's layout. Get it into the layout, then float it.
      came_zoomed[block.block_id] = was_zoomed()
      if block.placement ~= "placed" then
        rex.session.move_block{ block_id = block.block_id, anchor_block_id = ctx.block_id }
      end
      rex.session.float_block{ block_id = block.block_id, bounds = POPUP }
      rex.session.focus_block{ block_id = block.block_id }
      return true
    end

    -- First time for this directory: start Claude in a new floating layer.
    -- Read the zoom before creating it, since creating it clears the zoom.
    local zoomed = was_zoomed()
    local created = rex.session.new_layer{
      bounds = POPUP,
      focus = true,
      layout = rex.layout.block{
        flavor = TERMINAL .. ".shell",
        label = label,
        options = { cwd = dir, command = { "claude" } },
      },
    }
    local popup_id = created and (created.block_ids or {})[1]
    if popup_id then
      came_zoomed[popup_id] = zoomed
    end
    return true
  end,
}

rex.action{
  name = "claude_debug",
  title = "Claude popup diagnostics",
  run = function()
    return debug_last
  end,
}

local M = {}

-- Hide the focused block when it is a visible floating popup, so a key bound
-- to something else (moving focus, say) can act on the panes underneath.
-- Returns true when a popup was hidden. The block keeps running.
function M.hide_floating(block_id)
  local layer = floating_layer(block_id)
  if not layer or layer.state == "minimized" then
    return false
  end
  return hide(block_id)
end

return M
