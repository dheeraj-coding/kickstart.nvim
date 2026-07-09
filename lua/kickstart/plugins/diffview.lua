return {
  {
    'sindrets/diffview.nvim',
    cmd = {
      'DiffviewClose',
      'DiffviewFileHistory',
      'DiffviewFocusFiles',
      'DiffviewOpen',
      'DiffviewRefresh',
      'DiffviewToggleFiles',
    },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '<leader>dh', '<cmd>DiffviewFileHistory %<cr>', desc = '[D]iffview file [H]istory' },
      { '<leader>dv', '<cmd>DiffviewOpen<cr>', desc = '[D]iffview open' },
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = '[G]it [D]iff view' },
      { '<leader>gD', '<cmd>DiffviewOpen HEAD~1<cr>', desc = '[G]it [D]iff last commit' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = '[G]it file [H]istory' },
      { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = '[G]it repo [H]istory' },
      { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = '[G]it close diffview' },
    },
    opts = {},
  },
}
