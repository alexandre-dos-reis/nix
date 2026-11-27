-- Editor-aware pane navigation.
--
-- ctrl+h/j/k/l move between Rex panes, but they are also Neovim's window
-- movements. When the focused pane runs an editor, focus_pane hands the key
-- to it instead of moving: Neovim moves its own window, and once it is
-- against a wall it runs `rex do focus_pane_direct` to cross the pane border.
-- Same handoff as tmux's send-keys, and the editor half lives in
-- nvim/after/plugin/herdr_nav.lua.
--
-- Renux has no client.key.forward, so a key bound to a Lua function never
-- reaches the server. That rules out the tidier way of doing this, where the
-- binding declines the key and Rex passes it on by itself.

local TERMINAL = "com.superlogical.terminal"

-- Programs that take ctrl+h/j/k/l for their own window movements.
local EDITORS = {
	vim = true,
	nvim = true,
	["nvim.bin"] = true,
}

-- The key each direction is bound to, named as Rex names physical keys, with
-- the codepoint it types on a US layout. Rex needs both to encode the key for
-- the terminal.
local KEYS = {
	left = { key = "key_h", codepoint = 104 },
	down = { key = "key_j", codepoint = 106 },
	up = { key = "key_k", codepoint = 107 },
	right = { key = "key_l", codepoint = 108 },
}

local M = {}

local function basename(path)
	return path and path:match("([^/\\]+)$")
end

-- Whether a pane's foreground program moves its own windows with these keys.
-- Only the foreground program counts, as in tmux: if the editor shelled out
-- to something else, that program owns the keyboard.
function M.handles_movement(block_id)
	local info = rex.block.call(TERMINAL, "process", { block_id = block_id })
	local fg = info and info.foreground
	if not fg then
		return false
	end
	-- Rex labels a process by the first of script, argv0 and name it has; any
	-- of them naming an editor is good enough, and argv0 can be a full path.
	return EDITORS[basename(fg.script)] == true or EDITORS[basename(fg.argv0)] == true or EDITORS[fg.name] == true
end

-- Type ctrl+<direction's key> into a pane. The event goes straight to the
-- block, so the binding that got us here doesn't see it again.
function M.send_movement(session_id, block_id, direction)
	local key = KEYS[direction]
	if not key then
		return false
	end
	for _, action in ipairs({ "press", "release" }) do
		local ok, err = rex.call("block.event", {
			session_id = session_id,
			block_id = block_id,
			event = {
				type = "key",
				payload = {
					key = key.key,
					mods = "ctrl",
					consumed_mods = "",
					text = "",
					unshifted_codepoint = key.codepoint,
					composing = false,
					action = action,
				},
			},
		})
		if not ok then
			rex.log("warn", "editor-nav: " .. tostring(err))
			return false
		end
	end
	return true
end

return M
