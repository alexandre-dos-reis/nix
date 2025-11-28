{pkgs, ...}: {
  # Optional, but makes sure that when you type the make palm rejection work with keyd
  # https://github.com/rvaiya/keyd/issues/723
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';

  environment.systemPackages = with pkgs; [
    keyd
  ];

  # https://wiki.nixos.org/wiki/Keyd
  # Replace the `caplock` key with `control`
  services.keyd = {
    enable = true;
    keyboards = {
      # The name is just the name of the configuration file, it does not really matter
      default = {
        ids = ["*"]; # what goes into the [id] section, here we select all keyboards
        # Everything but the ID section:
        settings = {
          # The main layer, if you choose to declare it in Nix
          main = {
            capslock = "layer(control)"; # you might need to also enclose the key in quotes if it contains non-alphabetical symbols
            rightalt = "layer(french)";
          };

          otherlayer = {};
        };
        extraConfig = ''
          # put here any extra-config, e.g. you can copy/paste here directly a configuration, just remove the ids part

          # Combo: Control + ' => esc
          [control:C]
          ' = esc

          [french]
          f = æ
          ; = œ
          c = ç
          a = à
          g = â
          w = è
          r = é
          e = ê
          d = ë
          i = î
          l = ï
          o = ô
          u = ù
          j = û
          k = ü
          y = ÿ
          s = €

          [french+shift]
          f = Æ
          ; = Œ
          c = Ç
          a = À
          h = Â
          w = È
          r = É
          d = Ë
          e = Ê
          i = Î
          l = Ï
          o = Ô
          u = Ù
          j = Û
          k = Ü
          y = Ÿ
        '';
      };
    };
  };
}
