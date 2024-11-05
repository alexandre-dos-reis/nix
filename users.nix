{
  alex = {
    username = "alex";
    email = "ajm.dosreis.daponte@gmail.com";
    fullname = "Alexandre Dos Reis";
    font = "Maple Mono NF"; # This is not the nix package name but rather the name installed on the system
    editor = "nvim";
    colors = {
      background = "#072329";
      cursor = "#708183";
    };
    # This allows to install npm packages globally with: `npm i -g <some-package>`
    npm.packages.path = "~/.npm-packages";
  };
}
