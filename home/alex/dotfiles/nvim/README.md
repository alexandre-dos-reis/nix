# Nvim Config

- version: NVIM v0.11.5

## How to

- Change default branch : `gh api repos/{owner}/{repo} --method PATCH --field 'default_branch=main' --silent`

## Installation

Apply git hooks with this command : `git config --local core.hooksPath .githooks/`

## Todo

- Replace nodejs with bun for lsp
  - [Example](https://github.com/letieu/nvim-config/commit/237a314d06f87c528582d6da50d84ecac0fa7b27)
- Set keymaps for `Neogit`.
- Investigate :
  - [gopher.nvim](https://github.com/olexsmir/gopher.nvim)
  - [rustaceanvim](https://github.com/mrcjkb/rustaceanvim)
- Set some toggle keymap:
  - between lsp lines and default diagnostic errors.
- Tweek noice.nvim to had border to hover.
- [Add which key](https://github.com/folke/which-key.nvim)
- [See example for implementing dap](https://www.youtube.com/watch?v=G7-qUMKSH_Y)
- [Implement test](https://www.youtube.com/watch?v=G7-qUMKSH_Y)

## Undercurl

- `echo $TERM` has to be `xterm-256color` inside TMUX.
- Execute in terminal `infocmp > /tmp/${TERM}.ti`
- Open nvim `/tmp/${TERM}.ti`
- Add `Smulx=\E[4\:%p1%dm,` after `smul=\E[4m,`
- Execute in terminal `tic -x /tmp/${TERM}.ti`

## Sources:

- [How to get error underline to be like it is in vscode?](https://www.reddit.com/r/neovim/comments/11xsz20/comment/jd8cwvt/)
- [Curly Underlines in Kitty + Tmux + Neovim](https://evantravers.com/articles/2021/02/05/curly-underlines-in-kitty-tmux-neovim/)

## Resources:

- [ThePrimeahen config](https://github.com/ThePrimeagen/init.lua/tree/master)
- [Neovim - Bufferline Buffers vs Tabs vs Windows Explanation](https://www.youtube.com/watch?v=vJAmjAax2H0)
- [Why do Vim experts prefer buffers over tabs?](https://stackoverflow.com/questions/26708822/why-do-vim-experts-prefer-buffers-over-tabs/26710166#26710166)
