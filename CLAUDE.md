# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Neovim configuration written in Lua, managed by lazy.nvim, bootstrapped from `init.lua`.

## Development workflow

There is no build step, no Lua linter/formatter config (`.luarc.json` only sets `lua_ls` diagnostics globals — no `stylua.toml` or `selene.toml` exists, even though `lua/lsp/servers/lua_ls.lua` lists them as possible root markers), and no automated test suite.

To verify a change, restart/reload Neovim and exercise the feature manually. Useful commands:
- `:checkhealth`, `:messages`, `:Lazy` — catch plugin/config load errors. Failed auto-loaded modules are caught with `pcall` and reported via `vim.notify(WARN)` rather than crashing Neovim.
- `bin/clear_nvim.sh` — wipes `~/.local/share/nvim`, `~/.cache/nvim`, `~/.local/state/nvim` for a clean plugin reinstall (full `:Lazy sync` from scratch).
- `:NvimLogEnable` / `:NvimLogDisable` — toggle whether `NVIM_LOG_FILE` points at `stdpath("state")/log` or is silenced (`lua/config/logging.lua`).
- `:EnvLoad` — loads a project-local `.env` on demand; `.env.example` documents the recognized variables.

`test/` is **not** an automated test suite — it holds hand-written fixture files per language (`cpp/`, `go/`, `lua/`, `sh/`, `ts/`, each with `main`/`model`/`service`) used to manually exercise LSP servers, formatters, and treesitter per filetype.

## Architecture

**Bootstrap** — `init.lua` sets `vim.g.mapleader = ' '`, calls `require('config')`, then clones `lazy.nvim` into `stdpath("data")/lazy/lazy.nvim` if missing and calls `require('lazy').setup(require('config.plugins').load(), {...})`.

**Auto-loading convention (know this before adding files)**:
- `lua/config/init.lua` globs every `*.lua` under `lua/config/**` (excluding `init.lua` files) and `require`s each automatically. Adding a new file under `lua/config/` (or `lua/config/ai/`) is sufficient to activate it — there is no manual import list.
- `lua/config/plugins.lua` does the same for plugin specs: it reads `lua/plugins/*.lua`, requires each as `plugins.<name>`, and collects the returned lazy.nvim spec tables.
- `lua/lsp/init.lua` mirrors this for LSP servers via `vim.api.nvim_get_runtime_file('lua/lsp/servers/*.lua', true)`, returning `{name, config}` pairs consumed by the mason-lspconfig wiring in `lua/plugins/nvim-lsp.lua`.
- Net effect: to add a plugin or a config module, add a new file in the matching directory — don't look for (or create) a central registry to edit.

**Where things live**:
- Options, global autocmds, diagnostic config, terminal `<Esc>` mapping: `lua/config/config.lua`.
- Keymaps are not centralized — they're defined per-feature, either inside a `lua/config/*.lua` module (e.g. `message.lua`, `yank.lua`, `shell_insert.lua`, `ai/translate.lua`, `ai/help.lua`) or inside a plugin's own spec file under `lua/plugins/` via lazy.nvim's `keys = {...}` or `config = function()`.
- `lua/plugins/which-key.lua` only centralizes *descriptions/icons* for leader-key groups (`<leader>f` Find, `<leader>g` Git, `<leader>t` Translate, `<leader>y` Yank, `<leader>c` Comment, `<leader>m` Msg, `<leader>s` Shell, `<leader>l` LSP, `<leader>h` Help) — it does not bind the actions itself.
- LSP server configs: one file per server under `lua/lsp/servers/*.lua` (bashls, clangd, gopls, lua_ls, pyright, ts_ls), each returning a plain `{cmd, filetypes, root_markers, settings}` table.

**`.env` handling** — `lua/config/env.lua` is a hand-rolled dotenv parser (handles quoted/escaped values) that auto-loads a config-root `.env` at startup; `:EnvLoad` loads a project-local `.env` on demand. Recognized vars (per `.env.example`): `GEMINI_API_KEY` / `GEMINI_MODEL` (consumed by `lua/config/ai.lua`'s `send_ai_request`, a `curl`-based Gemini API call used by the translate/help AI features), plus `NVIM_LOG_FILE`, `VIRTUAL_ENV`, `PYTHONPATH`.

**Highlight/theme handling** — `lua/config/highlight.lua` clears background on every highlight group except a small exclusion list (for terminal transparency), then reapplies custom Search/Pmenu/BlinkCmp colors; this runs on every `ColorScheme` autocmd, so a new colorscheme plugin doesn't need its own transparency handling.

**Lockfile note** — `lazy-lock.json` pins each plugin to a branch+commit. It still has a `copilot.lua` entry even though commit history shows the plugin was removed — a stale entry, not evidence that copilot.lua is in use.
