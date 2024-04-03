# Nvim Config

## Undercurl

- `echo $TERM` has to be `xterm-256color` inside TMUX.
- Execute in terminal `infocmp > /tmp/${TERM}.ti`
- Open nvim `/tmp/${TERM}.ti`
- Add `Smulx=\E[4\:%p1%dm,` after `smul=\E[4m,`
- Execute in terminal `tic -x /tmp/${TERM}.ti`

Sources:

- [How to get error underline to be like it is in vscode?](https://www.reddit.com/r/neovim/comments/11xsz20/comment/jd8cwvt/)
- [Curly Underlines in Kitty + Tmux + Neovim](https://evantravers.com/articles/2021/02/05/curly-underlines-in-kitty-tmux-neovim/)
