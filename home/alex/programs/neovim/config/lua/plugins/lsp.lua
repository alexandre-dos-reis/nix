return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "shfmt",
        "tailwindcss-language-server",
        "typescript-language-server",
        "css-lsp",
        "graphql-language-service-cli",
        "marksman",
        "clangd",

        -- Checks that the followinf are working...
        -- "astro-language-server",
        -- "codelldb",
        -- "css-lsp",
        -- "cueimports",
        -- "cuelsp",
        -- "eslint-lsp",
        -- "gofumpt",
        -- "gopls",
        -- "graphql-language-service-cli",
        -- "json-lsp",
        -- "lua-language-server",
        -- "marksman",
        -- "nil",
        -- "prettier",
        -- "prisma-language-server",
        -- "rust-analyzer",
        -- "selene",
        -- "shellcheck",
        -- "shfmt",
        -- "stylua",
        -- "tailwindcss-language-server",
        -- "taplo",
        -- "templ",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      ---@type lspconfig.options
      servers = {
        nixd = {
          mason = false,
        },
      },
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- https://www.lazyvim.org/plugins/lsp
      -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/keymaps.lua
      -- https://github.com/LazyVim/LazyVim/issues/893

      -- keys[#keys + 2] = { "<leader>cr", false }
      -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/keymaps.lua#L42C3-L55C6
      if require("lazyvim.util").has("inc-rename.nvim") then
        keys[#keys + 1] = {
          "<leader>rn",
          function()
            local inc_rename = require("inc_rename")
            return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
          end,
          expr = true,
          desc = "Rename",
          has = "rename",
        }
      else
        keys[#keys + 1] = { "<leader>rn", vim.lsp.buf.rename, desc = "Rename", has = "rename" }
      end

      keys[#keys + 1] = {
        "gd",
        function()
          require("telescope.builtin").lsp_definitions({
            jump_type = "tab",
          })
        end,
        desc = "Goto Definition (new tab)",
        has = "definition",
      }
      keys[#keys + 1] = { "gt", false, mode = "n" }
      keys[#keys + 1] =
        { "<leader>lsp", ":LspRestart<CR> | :echo 'Reloading LSP...'<CR>", desc = "Restart LSP", mode = "n" }
    end,
  },
}
