vim.g.mapleader = "\\"
vim.cmd.colorscheme "catppuccin"

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldtext = "getline(v:foldstart).'...'.trim(getline(v:foldend))"
vim.opt.fillchars = "fold: "
vim.opt.foldenable = false
vim.opt.relativenumber = true
vim.opt.scrolloff = 10         --sets the amount of room below and above the cursor
vim.opt.ttyfast = true         --speed up scrolling

vim.api.nvim_exec([[
  autocmd BufWritePost *.go lua RunGoimports()
]], false)

function RunGoimports()
  vim.cmd('Dispatch goimports -w %')
end

-- undo and swap
HOME = os.getenv("HOME")
vim.opt.undofile = true
vim.opt.undolevels = 1000      -- How many undos
vim.opt.undoreload = 10000     -- number of lines to save for undo
vim.opt.undodir = HOME .. "/.config/nvim/tmp/undo"     -- undo files
vim.opt.backupdir = HOME .. "/.config/nvim/tmp/backup" -- backups
vim.opt.directory = HOME .. "/.config/nvim/tmp/swap"   -- swap files
vim.opt.backup = true                          -- enable backups
vim.opt.swapfile = true                        -- enable swaps


vim.opt.lcs.trail = true

vim.api.nvim_set_keymap('n', 'k', 'v:count > 1 ? "m\'" . v:count . "k" : "k"', { expr = true, noremap = true })
vim.api.nvim_set_keymap('n', 'j', 'v:count > 1 ? "m\'" . v:count . "j" : "j"', { expr = true, noremap = true })
vim.api.nvim_set_keymap('n', '*', '*N', { noremap = true, silent = true })

vim.g.ale_fixers = { ["*"] = { "remove_trailing_lines", "trim_whitespace" },
                     ["css"] = { "prettier" } ,
                     ["erb"] =  { "rubocop" },
                     ["html"] = { "prettier" },
                     ["javascript"] = { "eslint" },
                     ["ruby"] = { "rubocop" },
                     ["rb"] = { "rubocop" },
                     ["python"] = { "prettier" },
                     ["rust"] = { "rustfmt" },
                     ["go"] = { "goimports", "gofmt", "gopls" },
}

-- dan copy
function _G.CopyFilePathAndLineNumber()
  local file_path = vim.fn.expand('%')
  local line_number = vim.fn.line('.')
  local full_path_line = file_path .. ':' .. line_number
  vim.fn.setreg('+', full_path_line)
end
vim.cmd('command! CopyPathAndLine lua CopyFilePathAndLineNumber()')

require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "ruby", "go", "rust", "javascript", "html", "css" },
  sync_install = false,
  auto_install = true,
  ignore_install = { },
  highlight = {
    enable = true,
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = false,
    disable = {},
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      scope_incremental = '<CR>',
      node_incremental = '<TAB>',
      node_decremental = '<S-TAB>',
    },
  },
  endwise = {
      enable = true,
  },
}

require'lspconfig'.ruby_lsp.setup{}
require'lspconfig'.pyright.setup{}
require'lspconfig'.gopls.setup{}
require'lspconfig'.rubocop.setup{}
require'lspconfig'.ts_ls.setup{
  root_dir = require('lspconfig.util').root_pattern('tsconfig.json', '.git'),
  on_attach = function()
    print("TypeScript LSP attached")
  end
}
require'lspconfig'.rust_analyzer.setup{
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = false;
      }
    }
  }
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

require'lspconfig'.tsp_server.setup{}
