return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        lazy = true,
        config = function()
            require("lsp-zero.settings").preset({})
        end,
    },

    {
        "neovim/nvim-lspconfig",
        cmd = "LspInfo",
        event = {
            "BufReadPre",
            "BufNewFile",
        },
        dependencies = {
            "folke/neodev.nvim",
            "hrsh7th/cmp-nvim-lsp",
            { "williamboman/mason-lspconfig.nvim" },
            {
                "williamboman/mason.nvim",
                build = ":MasonUpdate",
            },
        },
        config = function()
            local lsp = require("lsp-zero")

            lsp.on_attach(function(_)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[N]ame" })
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
                vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })
                vim.keymap.set(
                    "n",
                    "<leader>gr",
                    require("telescope.builtin").lsp_references,
                    { desc = "[G]oto [R]eference" }
                )
                vim.keymap.set("n", "<leader>gI", vim.lsp.buf.implementation, { desc = "[G]oto [I]mplementation" })
                vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
                vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Hover Documentation" })
            end)

            lsp.format_on_save({
                format_opts = {
                    async = false,
                    timeout_ms = 10000,
                },
                servers = {
                    ["null-ls"] = {
                        "javascript",
                        "typescript",
                        "typescriptreact",
                        "lua",
                    },
                },
            })

            lsp.ensure_installed({
                "tsserver",
                "lua_ls",
            })

            require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())
            require("lspconfig").tsserver.setup({
                single_file_support = false,
                root_dir = function(...)
                    return require("lspconfig.util").root_pattern(".git")(...)
                end,
                commands = {
                    TypescriptOrganizeImports = {
                        function()
                            local param = {
                                command = "_typescript.organizeImports",
                                arguments = { vim.api.nvim_buf_get_name(0) },
                                title = "Organize ts imports",
                            }
                            vim.lsp.buf.execute_command(param)
                        end,
                        description = "Organize imports",
                    },
                },
            })

            vim.keymap.set("n", "<leader>oi", "<cmd>TypescriptOrganizeImports<CR>", { silent = true, noremap = true })
            vim.keymap.set(
                "n",
                "<leader>ami",
                "<cmd>TypescriptAddMissingImports<CR>",
                { silent = true, noremap = true }
            )
            vim.keymap.set("n", "<leader>fa", "<cmd>TypescriptFixAll<CR>", { silent = true, noremap = true })
            vim.keymap.set("n", "<leader>ru", "<cmd>TypescriptRemoveUnused<CR>", { silent = true, noremap = true })

            lsp.setup()
        end,
    },

    {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                debug = true,
                sources = {
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.prettierd,
                    null_ls.builtins.formatting.eslint_d,
                },
            })
        end,
    },

    {
        "folke/neodev.nvim",
        opts = {},
        config = function()
            require("neodev").setup()
        end,
    },
}
