#!/usr/bin/env bash
# Install these configs into $HOME.
#
#   ./install.sh           install; abort without changes if any target exists and differs
#   ./install.sh --skip    install, leaving existing differing targets untouched
#   ./install.sh --force   install, backing up existing targets as <file>.bak.<timestamp>
#   add --link             symlink instead of copy, so `git pull` updates the live config
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
MODE=copy
ON_CONFLICT=error

for arg in "$@"; do
  case "$arg" in
    --link)  MODE=link ;;
    --force) ON_CONFLICT=force ;;
    --skip)  ON_CONFLICT=skip ;;
    -h|--help) sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $arg (see --help)" >&2; exit 2 ;;
  esac
done

# repo path -> destination
FILES=(
  "bash/bashrc:$HOME/.bashrc"
  "bash/inputrc:$HOME/.inputrc"
  "tmux/tmux.conf:$HOME/.tmux.conf"
  "neovim/nvim/init.lua:$HOME/.config/nvim/init.lua"
  "neovim/nvim/lua/plugins.lua:$HOME/.config/nvim/lua/plugins.lua"
  "neovim/nvim/lua/completion.lua:$HOME/.config/nvim/lua/completion.lua"
  "neovim/nvim/lua/lsp.lua:$HOME/.config/nvim/lua/lsp.lua"
  "vim/vimrc:$HOME/.vim/vimrc"
  "vim/base.vim:$HOME/.vim/base.vim"
  "ghostty/config:$HOME/.config/ghostty/config"
)

# Old files that must go: nvim refuses to start with both init.vim and init.lua.
OBSOLETE=(
  "$HOME/.config/nvim/init.vim"
)

backup() {
  local dst="$1" bak="$1.bak.$STAMP" n=1
  while [ -e "$bak" ] || [ -L "$bak" ]; do bak="$dst.bak.$STAMP.$n"; n=$((n + 1)); done
  mv "$dst" "$bak"
  echo "  backup   $dst -> $bak"
}

# Already installed: a symlink to our file, or (copy mode) identical contents.
is_installed() {
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then
    [ "$(readlink "$dst")" = "$src" ]
  else
    [ "$MODE" = copy ] && [ -f "$dst" ] && cmp -s "$src" "$dst"
  fi
}

is_conflict() {
  local src="$1" dst="$2"
  { [ -e "$dst" ] || [ -L "$dst" ]; } && ! is_installed "$src" "$dst"
}

conflicts=()
for entry in "${FILES[@]}"; do
  src="$REPO/${entry%%:*}" dst="${entry#*:}"
  is_conflict "$src" "$dst" && conflicts+=("$dst")
done
for old in "${OBSOLETE[@]}"; do
  { [ -e "$old" ] || [ -L "$old" ]; } && conflicts+=("$old (obsolete, will be moved away)")
done

if [ "${#conflicts[@]}" -gt 0 ] && [ "$ON_CONFLICT" = error ]; then
  echo "These files already exist and differ from the repo:" >&2
  printf '  %s\n' "${conflicts[@]}" >&2
  echo "Nothing was changed. Re-run with --force (back up and overwrite) or --skip (leave them)." >&2
  exit 1
fi

echo "Installing configs ($MODE mode)..."
for entry in "${FILES[@]}"; do
  src="$REPO/${entry%%:*}" dst="${entry#*:}"

  if is_installed "$src" "$dst"; then
    echo "  ok       $dst"
    continue
  fi
  if is_conflict "$src" "$dst"; then
    if [ "$ON_CONFLICT" = skip ]; then
      echo "  skipped  $dst (exists)"
      continue
    fi
    backup "$dst"
  fi

  mkdir -p "$(dirname "$dst")"
  if [ "$MODE" = link ]; then
    ln -s "$src" "$dst"
    echo "  linked   $dst"
  else
    cp "$src" "$dst"
    echo "  copied   $dst"
  fi
done

for old in "${OBSOLETE[@]}"; do
  { [ -e "$old" ] || [ -L "$old" ]; } || continue
  if [ "$ON_CONFLICT" = skip ]; then
    echo "  WARNING  left $old in place; remove it or nvim will refuse to start"
  else
    backup "$old"
  fi
done

# Login shells (macOS Terminal, tmux panes, ssh) read .bash_profile, not .bashrc.
if [ ! -e "$HOME/.bash_profile" ]; then
  echo '[ -f ~/.bashrc ] && . ~/.bashrc' > "$HOME/.bash_profile"
  echo "  created  $HOME/.bash_profile (sources .bashrc)"
fi

# Plugin managers: vim-plug for nvim, Vundle for vim.
plug="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
if [ ! -f "$plug" ]; then
  if command -v curl >/dev/null; then
    curl -fsSLo "$plug" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "  fetched  vim-plug -> $plug"
  else
    echo "  WARNING  curl not found; install vim-plug manually to $plug"
  fi
fi
vundle="$HOME/.vim/bundle/Vundle.vim"
if [ ! -d "$vundle" ]; then
  if command -v git >/dev/null; then
    git clone -q https://github.com/VundleVim/Vundle.vim.git "$vundle"
    echo "  cloned   Vundle -> $vundle"
  else
    echo "  WARNING  git not found; clone Vundle manually to $vundle"
  fi
fi

echo
echo "Done. Next steps:"
echo "  - open a new shell (or: source ~/.bashrc)"
echo "  - in nvim, run :PlugInstall (LSP servers install on the next start)"
echo "  - in vim, run :PluginInstall"
echo "  - reload tmux if it's running: tmux source-file ~/.tmux.conf"
for tool in nvim tmux fzf ag; do
  command -v "$tool" >/dev/null || echo "  note: '$tool' is not installed on this machine"
done
