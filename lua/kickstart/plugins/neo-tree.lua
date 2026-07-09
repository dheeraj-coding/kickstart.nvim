-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local function toggle_filesystem_tree()
  local command = require 'neo-tree.command'
  local manager = require 'neo-tree.sources.manager'
  local renderer = require 'neo-tree.ui.renderer'

  local state = manager.get_state('filesystem', nil, nil)
  if state and renderer.window_exists(state) then
    command.execute { action = 'close', source = 'filesystem', position = 'left' }
    return
  end

  command.execute { action = 'focus', source = 'filesystem', position = 'left', reveal = true }
end

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  init = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'neo-tree',
      callback = function()
        vim.opt_local.foldenable = false
        vim.opt_local.foldmethod = 'manual'
        vim.opt_local.foldexpr = '0'
      end,
    })
  end,
  keys = {
    { '\\', toggle_filesystem_tree, desc = 'NeoTree toggle', silent = true },
  },
  opts = {
    default_source = 'filesystem',
    filesystem = {
      async_directory_scan = 'never',
      bind_to_cwd = false,
      follow_current_file = {
        enabled = false,
        leave_dirs_open = true,
      },
      window = {
        mappings = {
          ['h'] = 'close_node',
          ['l'] = 'open',
          ['\\'] = 'close_window',
        },
      },
    },
    buffers = {
      bind_to_cwd = false,
      follow_current_file = {
        enabled = false,
        leave_dirs_open = true,
      },
    },
    git_status = {
      bind_to_cwd = false,
    },
  },
}
