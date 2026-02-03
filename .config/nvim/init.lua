-- ======================
-- BASIC IDE BEHAVIOR
-- ======================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.scrolloff = 8

-- Enable persistent undo
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Leader key
vim.g.mapleader = " "

-- ======================
-- VSCODE-LIKE KEYMAPS
-- ======================

-- Undo/Redo (VSCode style)
vim.keymap.set("n", "<C-z>", "u", { desc = "Undo" })
vim.keymap.set("i", "<C-z>", "<C-o>u", { desc = "Undo" })
vim.keymap.set("n", "<C-y>", "<C-r>", { desc = "Redo" })
vim.keymap.set("i", "<C-y>", "<C-o><C-r>", { desc = "Redo" })

-- Save (VSCode style)
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save" })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save" })

-- Select all
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Copy
vim.keymap.set("v", "<C-c>", '"+y',  { desc = "Copy selection" })
vim.keymap.set("n", "<C-c>", '"+yy', { desc = "Copy line" })

-- Cut
vim.keymap.set("v", "<C-x>", '"+d',  { desc = "Cut selection" })
vim.keymap.set("n", "<C-x>", '"+dd', { desc = "Cut line" })

-- Paste
vim.keymap.set("n", "<C-v>", '"+p',  { desc = "Paste" })
vim.keymap.set("i", "<C-v>", '<C-r>+', { desc = "Paste" })

-- Rename → F2
vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Find (handled by Telescope below)
-- Replace will use spectre plugin

-- Move lines up/down (Alt+j/k like VSCode Alt+Up/Down)
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Duplicate line (Shift+Alt+Down/Up)
vim.keymap.set("n", "<S-A-j>", "yyp", { desc = "Duplicate line down" })
vim.keymap.set("n", "<S-A-k>", "yyP", { desc = "Duplicate line up" })

-- Tab navigation
vim.keymap.set("n", "<C-Tab>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<C-S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<C-w>", ":bd<CR>", { desc = "Close buffer" })

-- Split navigation (Ctrl+h/j/k/l)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right split" })

-- Window management
vim.keymap.set("n", "<C-\\>", ":vsplit<CR>", { desc = "Vertical split" })

vim.keymap.set({ "n", "v" }, "<A-S-f>", function()
require("conform").format({
  async = true,
  lsp_fallback = true,
})
end, { desc = "Format with Conform" })

-- ======================
-- LAZY.NVIM SETUP
-- ======================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  end
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup({
    -- ======================
    -- LOOK & FEEL
    -- ======================
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = false,
        styles = {
          sidebars = "dark",
          floats = "dark",
        },
      })
      vim.cmd("colorscheme tokyonight")
      end,
    },
    { "nvim-tree/nvim-web-devicons" },

    -- ======================
    -- FILE EXPLORER (VS CODE SIDEBAR)
  -- ======================
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
    -- Enable mouse support
    vim.o.mouse = "a"

    require("neo-tree").setup({
      close_if_last_window = false,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = false,

      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          show_hidden_count = true,
        },

        follow_current_file = {
          enabled = true,
        },

        window = {
          position = "left",
          width = 35,
          mappings = {
            -- Explorer-like shortcuts
            ["<F2>"]  = "rename",
            ["<Del>"] = "delete",
            ["<F12>"] = "add",

            ["<C-c>"] = "copy",
            ["<C-x>"] = "cut",
            ["<C-v>"] = "paste",

            -- Mouse
            ["<RightMouse>"] = "show_help",

            -- Navigation
            ["<CR>"] = "open",
            ["o"] = "open",
          },
        },
      },

      default_component_configs = {
        git_status = {
          symbols = {
            ignored = "",
          },
        },
      },
    })

    -- Ctrl+B toggles the sidebar
    vim.keymap.set(
      "n",
      "<C-b>",
      "<cmd>Neotree filesystem toggle left<CR>",
      { desc = "Toggle file explorer" }
    )
    end,
  },

  -- ======================
  -- STATUS LINE
  -- ======================
  {
    "nvim-lualine/lualine.nvim",
    config = function()
    require("lualine").setup({
      options = {
        theme = "tokyonight",
        section_separators = '',
        component_separators = '|'
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
    })
    end,
  },

  -- ======================
  -- TABS (BUFFER LINE)
  -- ======================
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
    require("bufferline").setup({
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        separator_style = "thin",
        show_buffer_close_icons = true,
        show_close_icon = false,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left"
          }
        },
      }
    })
    end,
  },

  -- ======================
  -- TERMINAL TOGGLE (CTRL+J)
  -- ======================
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
    require("toggleterm").setup({
      size = 15,
      open_mapping = [[<C-j>]],
      direction = "horizontal",
      shade_terminals = true,
      persist_size = true,
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
      },
    })

    -- Terminal mode mappings
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
    vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Navigate left" })
    vim.keymap.set("t", "<C-j>", [[<C-j>]], { desc = "Toggle terminal" })
    vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Navigate right" })
    end,
  },

  -- ======================
  -- FUZZY FINDER (CTRL+P)
  -- ======================
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          },
        },
        file_ignore_patterns = { "node_modules", ".git/" },
        layout_strategy = "horizontal",
        layout_config = {
          preview_width = 0.6,
        },
      },
    })

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<C-f>", builtin.live_grep, { desc = "Live grep" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
    vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
    vim.keymap.set("n", "<leader>fg", builtin.git_status, { desc = "Git status" })
    end,
  },

  -- Better search/replace UI
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
    require("spectre").setup()
    vim.keymap.set("n", "<C-S-f>", '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
    vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { desc = "Search current word" })
    end,
  },

  -- ======================
  -- AUTOCOMPLETE (INTELLISENSE)
  -- ======================
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
    },
    config = function()
    local cmp = require("cmp")
    local lspkind = require("lspkind")

    cmp.setup({
      snippet = {
        expand = function(args)
        require("luasnip").lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
              documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
                                          ["<Tab>"] = cmp.mapping.select_next_item(),
                                          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                                          ["<CR>"] = cmp.mapping.confirm({ select = true }),
                                          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                                          ["<C-f>"] = cmp.mapping.scroll_docs(4),
                                          ["<C-e>"] = cmp.mapping.abort(),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol_text',
          maxwidth = 50,
        })
      },
    })
    end,
  },

  -- ======================
  -- LSP (REAL IDE BRAIN)
  -- ======================

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
    -- ======================
    -- Mason
    -- ======================
    require("mason").setup()

    require("mason-lspconfig").setup({
      ensure_installed = {
        "ts_ls",
        "pyright",
        "rust_analyzer",
        "lua_ls",
      },
    })

    -- ======================
    -- LSP Attach (keymaps)
  -- ======================
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
                              callback = function(ev)
                              local opts = { buffer = ev.buf }

                              vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                              vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                              vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                              vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
                              vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                              vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                              vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                              end,
  })

  -- ======================
  -- Capabilities (completion)
  -- ======================
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- ======================
  -- Server configs (NEW API)
  -- ======================
  local servers = {
    ts_ls = {},
    pyright = {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          },
        },
      },
    },
    rust_analyzer = {},
    lua_ls = {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    },
  }

  -- Register configs
  for server, config in pairs(servers) do
    vim.lsp.config(server, vim.tbl_extend("force", {
      capabilities = capabilities,
    }, config))
    end

    -- Enable servers
    vim.lsp.enable(vim.tbl_keys(servers))
    end,
  },

  -- ======================
  -- GIT INTEGRATION
  -- ======================
  {
    "lewis6991/gitsigns.nvim",
    config = function()
    require("gitsigns").setup({
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      -- Navigation
      vim.keymap.set("n", "]c", function()
      if vim.wo.diff then return "]c" end
        vim.schedule(function() gs.next_hunk() end)
        return "<Ignore>"
        end, { expr = true, buffer = bufnr, desc = "Next hunk" })

      vim.keymap.set("n", "[c", function()
      if vim.wo.diff then return "[c" end
        vim.schedule(function() gs.prev_hunk() end)
        return "<Ignore>"
        end, { expr = true, buffer = bufnr, desc = "Previous hunk" })

      -- Actions
      vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
      vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
      vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
      vim.keymap.set("n", "<leader>hb", function() gs.blame_line{full=true} end, { buffer = bufnr, desc = "Blame line" })
      end
    })
    end,
  },

  -- Git conflict resolution
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = function()
    require("git-conflict").setup({
      default_mappings = true,
      default_commands = true,
      disable_diagnostics = false,
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      }
    })

    -- VSCode-like conflict resolution keymaps
    vim.keymap.set("n", "<leader>co", "<Plug>(git-conflict-ours)", { desc = "Accept current changes" })
    vim.keymap.set("n", "<leader>ct", "<Plug>(git-conflict-theirs)", { desc = "Accept incoming changes" })
    vim.keymap.set("n", "<leader>cb", "<Plug>(git-conflict-both)", { desc = "Accept both changes" })
    vim.keymap.set("n", "<leader>c0", "<Plug>(git-conflict-none)", { desc = "Accept none" })
    vim.keymap.set("n", "[x", "<Plug>(git-conflict-prev-conflict)", { desc = "Previous conflict" })
    vim.keymap.set("n", "]x", "<Plug>(git-conflict-next-conflict)", { desc = "Next conflict" })
    end,
  },

  -- Enhanced git UI
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
    vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "LazyGit" })
    end,
  },

  -- ======================
  -- CODE EDITING
  -- ======================
  {
    "windwp/nvim-autopairs",
    config = function()
    require("nvim-autopairs").setup({})
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  {
    "numToStr/Comment.nvim",
    config = function()
    require("Comment").setup()
    end,
  },

  { "kylechui/nvim-surround", config = true },
  { "tpope/vim-repeat" },

  -- Multi-cursor support
  {
    "mg979/vim-visual-multi",
    branch = "master",
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    config = function()
    require("neoscroll").setup()
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
    require("ibl").setup({
      indent = { char = "│" },
      scope = { enabled = true },
    })
    end,
  },

  -- Better quickfix
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },

  -- Trouble (better diagnostics)
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
    require("trouble").setup()
    vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
    vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
    end,
  },

  -- Which-key (shows keybindings)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
    require("which-key").setup()
    end,
  },

  -- Leap for fast navigation
  {
    url = "https://codeberg.org/andyg/leap.nvim",
    config = function()
    local leap = require("leap")

    -- Sneak-style mappings
    vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
    vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
    vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")
    end,
  },

  -- Better UI for inputs/selections
  {
    "stevearc/dressing.nvim",
    config = function()
    require("dressing").setup()
    end,
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    })
    end,
  },

  -- Visual structure
  {
    "echasnovski/mini.indentscope",
    version = false,
  },
  })

  -- Mason
  require("mason").setup()

  require("mason-lspconfig").setup({
    ensure_installed = {
      -- Python
      "pyright",

      -- TypeScript / React
      "ts_ls", -- modern replacement for tsserver
    },
  })
