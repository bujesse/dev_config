### Installation
- Linux/WSL2 (nightly)
    1. Download nvim.appimage: https://github.com/neovim/neovim/releases/tag/nightly

- Mac (stable)
    1. `brew install nvim`

### Setup
- Install plugins (either vim-plug or packer)
    - `:Lazy sync` - shouldn't have to do this but just in case
        - Lazy should take care of this, but `:TSInstall \<language>`
    - `:checkhealth` - and take care of whatever other dependencies
- Install LSP, DAP, Linters and Formatters with `:Mason`
  - python: 
    - ruff

### Structure
- All vimscripts are in `plugin/`
- Lua files are either `lua/core/` or `lua/plugins/`
  - `lua/core/`
    - global settings that don't belong to plugins such as autocommands, keymaps, macros, etc.
    - `lazy.lua` plugin manager settings
    - These are all initialized individually by `init.lua` on startup by calling each module's `config()`
  - `lua/plugins/`
    - every file in here is loaded as a Lazy plugin
