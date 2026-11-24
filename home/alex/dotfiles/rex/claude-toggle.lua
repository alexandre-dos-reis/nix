-- Toggle a centered Claude popup for the CURRENT directory.
--
-- Port of the tmux script of the same name. Each directory gets its own
-- Claude block, labelled by the directory path, so instances stay separated
-- and their state survives closing the popup: hiding detaches the block
-- (it keeps running) instead of closing it.
--
-- Rex has floating layers, so no attach/detach dance and no shared session
-- is needed — the block simply leaves and re-enters the window's layout.

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

-- Where focus was when each popup was opened, so hiding it can put the cursor
-- back instead of letting the layout pick. Keyed by the popup's block id, and
-- only as good as the current config load, which is fine for a focus hint.
local came_from = {}
local came_zoomed = {}
local debug_last = {}

local function is_placed(block_id)
  if not block_id then
    return false
  end
  for _, block in ipairs(blocks()) do
    if block.block_id == block_id then
      return block.placement == "placed"
    end
  end
  return false
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

-- Hide a popup and return focus to wherever it was opened from.
--
-- Server-side focus_block does not move the client's cursor: Renux keeps its
-- own idea of the active pane, and after a detach it lands on the first pane.
-- Its pane.focus_next walks the block list backwards and the server follows,
-- so hop from the first pane to the one we came from.
local function hide(popup_id)
  local back = came_from[popup_id]
  local rezoom = came_zoomed[popup_id]
  came_from[popup_id] = nil
  came_zoomed[popup_id] = nil

  -- Where to put focus afterwards. The popup is on its way out either way, so
  -- it never counts towards the hop arithmetic.
  local placed, target = {}, nil
  for _, block in ipairs(blocks()) do
    if block.placement == "placed" and block.block_id ~= popup_id then
      placed[#placed + 1] = block.block_id
      if block.block_id == back then
        target = #placed
      end
    end
  end
  local steps = target and (1 - target) % #placed or 0

  -- pane.minimize_floating was tried here: it acts on whatever floating pane
  -- the client has focused, which we cannot read, and it often only moved
  -- focus without hiding anything. Detaching server-side is reliable.
  rex.session.detach_block{ block_id = popup_id }

  -- The client resets focus to the first pane when it notices the detach, and
  -- that lands after this action returns. Wait it out, then hop.
  pcall(rex.sleep, 0.25)

  debug_last = { back = back, steps = steps, rezoom = tostring(rezoom) }

  for _ = 1, steps do
    pcall(rex.client.queue, "pane.focus_next")
  end

  -- Renux keeps its own zoom flag, and opening the popup over a zoomed pane
  -- leaves that flag on while the layout shows unzoomed. pane.zoom is a toggle
  -- against that flag, so the first one only clears the stale state and the
  -- second one actually zooms.
  if rezoom then
    pcall(rex.client.queue, "pane.zoom")
    pcall(rex.client.queue, "pane.zoom")
  end
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

    if block and block.placement == "placed" then
      -- Toggle off: leave the layout but keep running.
      hide(block.block_id)
      return true
    end

    if block then
      -- Toggle on: place it again, then float it back over the window.
      came_from[block.block_id] = ctx.block_id
      came_zoomed[block.block_id] = was_zoomed()
      rex.session.move_block{ block_id = block.block_id, anchor_block_id = ctx.block_id }
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
      came_from[popup_id] = ctx.block_id
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

-- Hide the focused block when it is a floating popup, so a key bound to
-- something else (moving focus, say) can act on the panes underneath.
-- Returns true when a popup was hidden. The block keeps running.
function M.hide_floating(block_id)
  if not block_id then
    return false
  end
  local view = rex.session.view{}
  for _, window in ipairs((view or {}).windows or {}) do
    for _, layer in ipairs(window.layers or {}) do
      if layer.kind == "floating" then
        for _, block in ipairs(layer.blocks or {}) do
          if block.block_id == block_id then
            hide(block_id)
            return true
          end
        end
      end
    end
  end
  return false
end

return M
