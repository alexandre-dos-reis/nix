-- Actions https://www.superlogical.com/rex/docs/reference/ios-actions

local claude = require("claude-toggle")
require("sessionizer")

-- tmux behavior: moving focus out of a zoomed pane unzooms it.
-- Rex zoom follows focus, so unzoom first, then move.
rex.action({
	name = "focus_pane",
	title = "Focus Pane",
	args = { direction = "string" },
	run = function(ctx, args)
		-- From inside a floating popup: hide it, then move as usual.
		claude.hide_floating(ctx.block_id)

		local zoomed = false
		local view = rex.session.view({})
		if view then
			for _, window in ipairs(view.windows or {}) do
				if window.window_id == view.active_window_id and window.zoomed_block_id then
					zoomed = true
				end
			end
		end
		if zoomed then
			rex.session.zoom_block({ zoom = false })
		end
		rex.session.focus_direction({ direction = args.direction })
		return true
	end,
})

-- FIXME: not working atm
-- rex.bind("ctrl+a", "client.mode.enter", { name = "tmux" })

-- Movements
rex.bind("ctrl+l", "focus_pane", { direction = "right" })
rex.bind("ctrl+h", "focus_pane", { direction = "left" })
rex.bind("ctrl+j", "focus_pane", { direction = "down" })
rex.bind("ctrl+k", "focus_pane", { direction = "up" })

-- Pane
rex.bind("ctrl+a>-", "pane.split.down")
rex.bind("ctrl+a>shift+\\", "pane.split.right")
rex.bind("ctrl+a>z", "pane.zoom")

rex.bind("ctrl+a>s", "client.sidebar.toggle")

-- Claude
rex.bind("ctrl+o", "claude_toggle")

-- Agent board: every agent across sessions and windows, in Idle/Running/
-- Attention/Done columns. Needs agent-board=true in Renux's settings.
rex.bind("ctrl+i", "client.board.toggle")

-- Projects
rex.bind("ctrl+f", "sessionizer")
