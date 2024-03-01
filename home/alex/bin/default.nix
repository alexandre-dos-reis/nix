let
  filePath = "bin";
in {
  # TODO: Add config folder...
  home.file."${filePath}".source = ./files;
  home.file."${filePath}".recursive = true;
}
