-- Repository https://github.com/jackMort/ChatGPT.nvim
local config = require 'kickstart.plugins.chatgpt_config'

return {
  'jackMort/ChatGPT.nvim',
  event = 'VeryLazy',
  config = function()
    require('chatgpt').setup(config)
  end,
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
    'folke/trouble.nvim', -- optional
    'nvim-telescope/telescope.nvim',
  },
}
