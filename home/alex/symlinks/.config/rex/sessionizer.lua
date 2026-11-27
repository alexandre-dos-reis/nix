-- Key hook for ~/bin/rex-sessionizer, the Rex port of tmux-sessionizer.
--
-- The script does the work with the rex command; this only gives it a place to
-- run, the way the tmux binding ran it through `tmux neww`. fzf needs a
-- terminal, so the script gets a floating pane, which closes itself when the
-- script exits — by then the script has already switched the app to the
-- session it picked.

local TERMINAL = "com.superlogical.terminal"
local POPUP = { 0.2, 0.2, 0.6, 0.6 } -- x, y, w, h as fractions of the window

rex.action{
	name = "sessionizer",
	title = "Jump to Project…",
	description = "Pick a directory and switch to its session, creating it if needed.",
	run = function()
		local created, err = rex.session.new_layer({
			bounds = POPUP,
			focus = true,
			layout = rex.layout.block({
				flavor = TERMINAL .. ".shell",
				label = "sessionizer",
				options = { command = { "rex-sessionizer" } },
			}),
		})
		if not created then
			return "opening the picker: " .. tostring(err)
		end
		return true
	end,
}

return {}
