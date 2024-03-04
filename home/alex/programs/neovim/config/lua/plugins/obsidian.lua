return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  keys = {
    { "<leader>ot", "<Cmd>ObsidianTemplate<CR>", desc = "Obsidian: Add the default template." },
    { "<leader>on", "<Cmd>ObsidianNew<CR>", desc = "Obsidian: Create a new file." },
  },
  opts = {
    workspaces = {
      {
        name = "notes",
        path = "~/obsidian/notes",
      },
    },

    notes_subdir = "content",
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    templates = {
      subdir = "templates",
    },

    daily_notes = {
      folder = "content",
      template = "0-note.md",
    },

    note_frontmatter_func = function(note)
      local out = { id = note.id, tags = note.tags }

      if #note.aliases > 1 then
        out.aliases = note.aliases
      end

      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          if k == "updatedAt" then
            out[k] = os.date("%Y-%m-%d")
          else
            out[k] = v
          end
        end
      end
      return out
    end,
    -- disable_frontmatter = true,

    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return suffix .. "_" .. tostring(os.time())
    end,
  },
}
