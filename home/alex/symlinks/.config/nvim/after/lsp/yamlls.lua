---@type vim.lsp.Config
return {
  before_init = function(_, config)
    config.settings.yaml.schemas = require("schemastore").yaml.schemas()
  end,
  settings = {
    yaml = {
      schemaStore = {
        enable = false,
        url = "",
      },
    },
  },
}
