-- https://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=NeoVim
return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  opts = function(_, opts)
    local logo

    if vim.env.PROJECT_NAME == nil then
      logo = [[
    @@@  @@@  @@@@@@@@   @@@@@@   @@@  @@@  @@@  @@@@@@@@@@
    @@@@ @@@  @@@@@@@@  @@@@@@@@  @@@  @@@  @@@  @@@@@@@@@@@
    @@!@!@@@  @@!       @@!  @@@  @@!  @@@  @@!  @@! @@! @@!
    !@!!@!@!  !@!       !@!  @!@  !@!  @!@  !@!  !@! !@! !@!
    @!@ !!@!  @!!!:!    @!@  !@!  @!@  !@!  !!@  @!! !!@ @!@
    !@!  !!!  !!!!!:    !@!  !!!  !@!  !!!  !!!  !@!   ! !@!
    !!:  !!!  !!:       !!:  !!!  :!:  !!:  !!:  !!:     !!:
    :!:  !:!  :!:       :!:  !:!   ::!!:!   :!:  :!:     :!:
     ::   ::   :: ::::  ::::: ::    ::::     ::  :::     ::
    ::    :   : :: ::    : :  :      :      :     :      :
        ]]
    else
      logo = vim.env.PROJECT_NAME
    end
    logo = string.rep("\n", 8) .. logo .. "\n\n"
    opts.config.header = vim.split(logo, "\n")
  end,
}
