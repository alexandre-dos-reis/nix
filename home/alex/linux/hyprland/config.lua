-- Hyprland configuration (Lua, Hyprland >= 0.55).
-- This file is hand-maintained. See https://wiki.hypr.land/Configuring/Using-Lua/
-- LSP: `hl` is a global; stubs live in the hyprland package's share/hypr/stubs.

---------------------
---- MY PROGRAMS ----
---------------------

local mod         = "SUPER"
local terminal    = "ghostty -e fish"
local fileManager = "nautilus"
local menu        = "wofi --show drun"

-- App window classes, used by moveToWorkspace below.
local class = {
  terminal = "com.mitchellh.ghostty",
  zed      = "dev.zed.Zed",
  chrome   = "google-chrome",
  browser  = "zen",
}

------------------
---- MONITORS ----
------------------

hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto",      scale = "2" })
hl.monitor({ output = "DP-3",  mode = "preferred", position = "auto-left", scale = "1.666667" }) -- top-left USB-C

-- Pin workspaces to monitors (was `workspace = "N, monitor:..."`).
for i = 1, 4 do
  hl.workspace_rule({ workspace = tostring(i),      monitor = "eDP-1" })
  hl.workspace_rule({ workspace = tostring(i + 10), monitor = "DP-3" })
end

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("GTK_CURSOR_BLINK", "1")
hl.env("GTK_CURSOR_BLINK_TIME", "1200")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
  general = {
    gaps_in     = 5,
    gaps_out    = 0,
    border_size = 0,

    -- https://wiki.hypr.land/Configuring/Variables/#variable-types for colors
    col = {
      active_border   = "rgb(073541)",
      inactive_border = "rgba(07354100)",
    },

    resize_on_border = true,
    allow_tearing    = false,
    layout           = "dwindle",
  },

  decoration = {
    rounding         = 0,
    rounding_power   = 2,
    active_opacity   = 1.0,
    inactive_opacity = 1.0,

    shadow = { enabled = false, range = 4, render_power = 3, color = "rgba(1a1a1aee)" },
    blur   = { enabled = true,  size = 3,  passes = 1,       vibrancy = 0.1696 },
  },

  animations = { enabled = true },

  dwindle = { preserve_split = true },
  master  = { new_status = "master" },

  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo   = true,
  },

  cursor = { no_hardware_cursors = true }, -- replaces WLR_NO_HARDWARE_CURSORS=1

  input = {
    kb_layout      = "us",
    follow_mouse   = 1,
    repeat_rate    = 55,
    repeat_delay   = 200,
    sensitivity    = 0, -- -1.0 - 1.0, 0 means no modification.
    natural_scroll = true,
    touchpad       = { natural_scroll = true },
  },
})

-- Bezier curves (was `bezier = "name,x1,y1,x2,y2"`).
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1.0} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1} } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

---------------------
---- KEYBINDINGS ----
---------------------

-- Gather every window whose class is in `classes` onto workspace `ws`, then
-- switch to it. Native reimplementation of the old moveToWorkspace.sh: no
-- shelling out to hyprctl/jq, so it's a single in-process pass per keypress.
--
-- `class` is matched exactly (same as the old `jq .class == $class`).
-- `follow = false` moves silently, so we don't flicker through workspaces
-- window-by-window; one focus at the end lands us there.
local function moveToWorkspace(key, ws, classes)
  hl.bind(mod .. " + " .. key, function()
    for _, cls in ipairs(classes) do
      for _, win in ipairs(hl.get_windows({ class = cls })) do
        hl.dispatch(hl.dsp.window.move({ window = win, workspace = ws, follow = false }))
      end
    end
    hl.dispatch(hl.dsp.focus({ workspace = ws }))
  end)
end

-- >>> Presets
moveToWorkspace("u", 1, { class.terminal })
moveToWorkspace("i", 2, { class.browser, class.terminal })
moveToWorkspace("o", 3, { class.chrome })
moveToWorkspace("p", 4, { class.browser })
moveToWorkspace("y", 5, { class.zed })
-- <<< Presets

-- Apps
hl.bind(mod .. " + e",     hl.dsp.exec_cmd(fileManager))
hl.bind(mod .. " + g",     hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + w",     hl.dsp.window.close())
hl.bind(mod .. " + m",     hl.dsp.exit())
hl.bind(mod .. " + t",     hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + SPACE", hl.dsp.exec_raw(menu))
hl.bind(mod .. " + c",     hl.dsp.exec_cmd("kitty --class clipse -e clipse"))

-- Move focus
hl.bind(mod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + j", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + l", hl.dsp.focus({ direction = "right" }))

-- Swap windows.
-- NOTE: SUPER+CTRL+{h,j,k,l} is *also* bound to a pixel-nudge below; this
-- collision existed in the previous config too. Pick one if you don't want both.
hl.bind(mod .. " + CTRL + h", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mod .. " + CTRL + l", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mod .. " + CTRL + k", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mod .. " + CTRL + j", hl.dsp.window.swap({ direction = "down" }))

-- Send active window to workspace
hl.bind(mod .. " + SHIFT + u", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mod .. " + SHIFT + i", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mod .. " + SHIFT + o", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mod .. " + SHIFT + p", hl.dsp.window.move({ workspace = 4 }))

hl.bind(mod .. " + SHIFT + CTRL + u", hl.dsp.window.move({ workspace = 11 }))
hl.bind(mod .. " + SHIFT + CTRL + i", hl.dsp.window.move({ workspace = 12 }))
hl.bind(mod .. " + SHIFT + CTRL + o", hl.dsp.window.move({ workspace = 13 }))
hl.bind(mod .. " + SHIFT + CTRL + p", hl.dsp.window.move({ workspace = 14 }))

-- Nudge active window by pixels, repeating while held (was `binde`/`moveactive`).
hl.bind(mod .. " + CTRL + h", hl.dsp.window.move({ x = -50, y = 0,   relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + l", hl.dsp.window.move({ x = 50,  y = 0,   relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + k", hl.dsp.window.move({ x = 0,   y = -50, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + j", hl.dsp.window.move({ x = 0,   y = 50,  relative = true }), { repeating = true })

-- Move/resize with the mouse (was `bindm`).
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume / brightness, active even when locked and repeating (was `bindel`).
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),   { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),  { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),{ locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s 10%+"),                        { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"),                        { locked = true, repeating = true })

-- Media keys, active when locked (was `bindl`). Requires playerctl.
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Nautilus
hl.window_rule({ match = { class = "org.gnome.Nautilus" }, float = true, size = "50% 50%", stay_focused = true })

-- clipse
hl.window_rule({ match = { class = "clipse" }, float = true, size = "50% 50%", stay_focused = true })

-- Ignore maximize requests
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

-- Fix some XWayland dragging issues
hl.window_rule({
  match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
  no_focus = true,
})

-- Example per-device config. See https://wiki.hypr.land/Configuring/Core/Devices/
hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })

-------------------
---- AUTOSTART ----
-------------------

-- dbus-update-activation-environment is handled by home-manager's systemd hook.
hl.on("hyprland.start", function()
  hl.exec_cmd("waybar")
  hl.exec_cmd("swaync")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("clipse -listen")
  hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 32")
  hl.exec_cmd("ghostty")
  hl.exec_cmd("zen")
end)
