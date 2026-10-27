-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'yetone/avante.nvim',
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ must add this setting! ! !
    build = vim.fn.has 'win32' ~= 0 and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false' or 'make',
    event = 'VeryLazy',
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      -- add any opts here
      -- this file can contain specific instructions for your project
      instructions_file = 'avante.md',
      -- for example
      provider = 'openai',
      providers = {
        openai = {
          endpoint = 'https://api.openai.com/v1',
          model = 'gpt-5.6-sol',
          api_key_name = 'AVANTE_OPENAI_API_KEY',
          timeout = 30000, -- Timeout in milliseconds
          use_response_api = true,
          -- Replay the complete tool-call history on every Responses API request.
          -- This keeps nested dispatch_agent loops isolated from the parent loop.
          support_previous_response_id = false,
          extra_request_body = {
            reasoning_effort = 'medium',
            max_completion_tokens = 20480,
          },
        },
        claude = {
          endpoint = 'https://api.anthropic.com',
          model = 'claude-opus-4-8',
          api_key_name = 'ANTHROPIC_API_KEY',
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            max_tokens = 20480,
          },
        },
        gemini = {
          endpoint = 'https://generativelanguage.googleapis.com/v1beta/models',
          model = 'gemini-3.1-flash-lite-preview',
          api_key_name = 'GEMINI_API_KEY',
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
      },
    },
    config = function(_, opts)
      require('avante').setup(opts)
      -- Avante stores one Responses API ID on the shared OpenAI provider. A
      -- dispatch_agent sub-loop can overwrite the parent's ID, which makes old
      -- tool outputs look unmatched. Force full, paired history replay instead.
      -- Responses reasoning and all tools remain enabled.
      local openai = require('avante.providers').openai
      if not openai._manual_response_replay_fix then
        local original_parse_curl_args = openai.parse_curl_args
        openai.parse_curl_args = function(self, prompt_opts)
          self.last_response_id = nil
          return original_parse_curl_args(self, prompt_opts)
        end
        openai._manual_response_replay_fix = true
      end
      -- Claude Opus 4.8 rejects the `temperature` param, but avante deep-merges
      -- a default (0.75) into the claude provider that opts can't remove. Strip
      -- it from the resolved/cached provider so it's never sent.
      local claude = require('avante.providers').claude
      if claude and claude.extra_request_body then
        claude.extra_request_body.temperature = nil
      end
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'nvim-mini/mini.pick', -- for file_selector provider mini.pick
      'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
      'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
      'ibhagwan/fzf-lua', -- for file_selector provider fzf
      'stevearc/dressing.nvim', -- for input provider dressing
      'folke/snacks.nvim', -- for input provider snacks
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      'zbirenbaum/copilot.lua', -- for providers='copilot'
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    'FabijanZulj/blame.nvim',
    lazy = false,
    config = function()
      require('blame').setup {}
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        direction = 'vertical',
      }
      vim.api.nvim_set_keymap('n', '<C-t>', '<Cmd>:ToggleTerm size=80 <CR>', { noremap = true, silent = true })
    end,
  },
  {
    'rmagatti/auto-session',
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
      -- log_level = 'debug',
    },
  },
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function()
      vim.g.barbar_auto_setup = true
    end,
    opts = {
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      -- animation = true,
      -- insert_at_start = true,
      -- …etc.
    },
    config = function()
      local map = vim.api.nvim_set_keymap
      local opts = { noremap = true, silent = true }
      map('n', 'P', '<Cmd>BufferPrevious<CR>', opts)
      map('n', 'N', '<Cmd>BufferNext<CR>', opts)
      map('n', '<C-x>', '<Cmd>BufferClose<CR>', opts)
    end,
  },
}
