# linux-env-config
My linux workspace configuration. Mostly related to vim and bash

## Install

```bash
git clone git@github.com:omer1ben/linux-env-config.git
cd linux-env-config
./install.sh            # aborts without changes if any config already exists and differs
./install.sh --skip     # leave existing configs alone, install the rest
./install.sh --force    # back up existing configs (<file>.bak.<timestamp>) and overwrite
./install.sh --link ... # symlink instead of copy, so `git pull` updates your live config
```

Installs: `~/.bashrc`, `~/.inputrc`, `~/.tmux.conf`, `~/.config/ghostty/config`, the nvim config (`~/.config/nvim/init.lua` + `lua/`), and `~/.vim/vimrc` + `~/.vim/base.vim`, plus vim-plug (nvim) and Vundle (vim). Then run `:PlugInstall` in nvim and `:PluginInstall` in vim.

## Layout

- `vim/base.vim`: options and keybindings shared by vim and nvim. Plain `set`/`map` only.
- `vim/vimrc`: vim plugins (Vundle), ALE, vim-lsp. Sources `base.vim`.
- `neovim/nvim/init.lua`: loads `lua/plugins.lua`, then `base.vim`, then `lua/completion.lua` and `lua/lsp.lua`.
