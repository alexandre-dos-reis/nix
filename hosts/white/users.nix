{ globals, ...}: {

  users.users.${globals.user} = {
    isNormalUser = true;
    description = "alex";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
