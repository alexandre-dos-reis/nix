{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  constants = import ../constants.nix;
in {
  imports = [
    # make vscode settings writable : https://github.com/nix-community/home-manager/issues/1800#issuecomment-1924321850
    (import (builtins.fetchurl {
      url = "https://gist.githubusercontent.com/piousdeer/b29c272eaeba398b864da6abf6cb5daa/raw/41e569ba110eb6ebbb463a6b1f5d9fe4f9e82375/mutability.nix";
      sha256 = "4b5ca670c1ac865927e98ac5bf5c131eca46cc20abf0bd0612db955bfc979de8";
    }) {inherit config lib;})

    (import (builtins.fetchurl {
      url = "https://gist.githubusercontent.com/piousdeer/b29c272eaeba398b864da6abf6cb5daa/raw/41e569ba110eb6ebbb463a6b1f5d9fe4f9e82375/vscode.nix";
      sha256 = "fed877fa1eefd94bc4806641cea87138df78a47af89c7818ac5e76ebacbd025f";
    }) {inherit config lib pkgs;})
  ];

  # Source: https://gist.github.com/piousdeer/b29c272eaeba398b864da6abf6cb5daa
  # Make vscode settings writable
  # https://mipmip.github.io/home-manager-option-search/?query=vscode
  programs.vscode = {
    mutableExtensionsDir = true;
    enable = true;

    # https://code.visualstudio.com/docs/getstarted/keybindings
    keybindings = [
      {
        key = "alt+1";
        command = "multiCommand.makeRoom";
      }
      {
        key = "tab";
        command = "workbench.action.nextEditor";
      }
      {
        key = "shift+tab";
        command = "workbench.action.previousEditor";
      }
      {
        key = "shift+k";
        command = "editor.action.showHover";
      }
    ];

    userSettings = {
      "workbench.colorTheme" = "poimandres";
      "terminal.integrated.fontFamily" = constants.font;
      "editor.fontFamily" = constants.font;
      "editor.lineHeight" = 14;
      "editor.fontSize" = 11;
      "editor.fontLigatures" = true;
      "workbench.iconTheme" = "material-icon-theme";
      "material-icon-theme.hidesExplorerArrows" = true;
      "editor.minimap.enabled" = false;
      "editor.formatOnSave" = true;
      "editor.formatOnPaste" = false;
      "editor.formatOnType" = true;
      "editor.renderWhitespace" = "trailing";
      "editor.linkedEditing" = true;
      "editor.occurrencesHighlight" = false;
      "editor.suggest.insertMode" = "replace";
      "editor.acceptSuggestionOnCommitCharacter" = false;
      "files.autoSave" = "afterDelay";
      "explorer.autoReveal" = true;
      "explorer.confirmDragAndDrop" = true;
      "explorer.confirmDelete" = true;
      "explorer.confirmUndo" = "default";
      "workbench.tree.indent" = 15;
      "workbench.tree.renderIndentGuides" = "always";
      "workbench.editor.enablePreview" = true;
      "emmet.triggerExpansionOnTab" = true;
      "editor.bracketPairColorization.enabled" = true;
      "scm.defaultViewMode" = "tree";

      # Vim preference
      "editor.lineNumbers" = "relative";
      "editor.cursorStyle" = "block";
      "vim.leader" = " ";
      "vim.insertModeKeyBindings" = [
        {
          "before" = ["j" "j;"];
          "after" = ["<Esc>"];
        }
      ];
      "vim.normalModeKeyBindingsNonRecursive" = [
        {
          before = ["<C-d>"];
          after = ["<C-d>" "z" "z"];
        }
        {
          before = ["<C-u>"];
          after = ["<C-u>" "z" "z"];
        }
        {
          before = ["<Tab>"];
          commands = ["workbench.action.nextEditor"];
        }
        {
          before = ["<S-Tab>"];
          commands = ["workbench.action.nextEditor"];
        }
        {
          before = ["<Esc>"];
          commands = [
            "workbench.action.closeSidebar"
          ];
        }
        {
          before = ["<leader>" "e"];
          commands = [
            "workbench.action.toggleActivityBarVisibility"
            "workbench.action.toggleSidebarVisibility"
            "workbench.view.explorer"
          ];
        }
        {
          before = ["<leader>" "z"];
          commands = [
            "workbench.action.toggleZenMode"
          ];
        }
      ];
      "vim.statusBarColorControl" = true;
      "editor.cursorSmoothCaretAnimation" = "on";
      # End vim preference
      #
      "multiCommand.commands" = [
        {
          "command" = "multiCommand.makeRoom";
          "sequence" = [
            "workbench.action.toggleSidebarVisibility"
            "workbench.action.toggleActivityBarVisibility"
          ];
        }
      ];
      "[typescriptreact]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      # Problème avec Prettier
      "files.saveConflictResolution" = "overwriteFileOnDisk";
      "eslint.lintTask.enable" = true;
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "totalTypeScript.hideAllTips" = true;
      "totalTypeScript.hideBasicTips" = true;
      "totalTypeScript.showTLDRTranslation" = true;
      "totalTypeScript.showFullTranslation" = true;
      "totalTypeScript.hiddenTips" = ["passing-generics-to-types"];
      "window.zoomLevel" = 1;
      "[css]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "workbench.colorCustomizations" = {
        "statusBar.background" = "#005f5f";
        "statusBar.noFolderBackground" = "#005f5f";
        "statusBar.debuggingBackground" = "#005f5f";
        "editor.selectionBackground" = "#717cb483";
        "statusBar.foreground" = "#ffffff";
        "statusBar.debuggingForeground" = "#ffffff";
      };
      "[html]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "nxConsole.showNodeVersionOnStartup" = false;
    };

    extensions = let
      extensions = inputs.vscode-extensions.extensions.${pkgs.system};
      # https://marketplace.visualstudio.com/vscode
      mkt = extensions.vscode-marketplace;
      # https://open-vsx.org
      vsx = extensions.open-vsx-release;
    in [
      # Essentials
      mkt.ms-vsliveshare.vsliveshare
      mkt.vscodevim.vim # vim key bindings https://marketplace.visualstudio.com/items?itemName=vscodevim.vim
      mkt.ms-vscode.live-server
      mkt.redhat.vscode-yaml

      # linter and formatter
      mkt.dbaeumer.vscode-eslint

      # themes
      mkt.pmndrs.pmndrs

      # Graphql
      mkt.graphql.vscode-graphql
      mkt.graphql.vscode-graphql-syntax

      # Languages specific
      mkt.bradlc.vscode-tailwindcss
      # mkt.vadimcn.vscode-lldb

      # Docker
      mkt.ms-azuretools.vscode-docker
      mkt.p1c2u.docker-compose
      mkt.broadcommfd.cobol-language-support

      #astro-build.astro-vscode
      #matthewpi.caddyfile-support
      #dsznajder.es7-react-js-snippets
      #hashicorp.terraform
      #ms-kubernetes-tools.vscode-kubernetes-tools
      #pkief.material-icon-theme
      #unifiedjs.vscode-mdx
      #ryuta46.multi-command
      #nrwl.angular-console
      #fabiospampinato.vscode-open-in-github
      #esbenp.prettier-vscode
      #yoavbls.pretty-ts-errors
      #prisma.prisma
      #rust-lang.rust-analyzer
      #joe-re.sql-language-server
      #bourhaouta.tailwindshades
    ];
  };

  # make `settings.json` writeable as it is required by vscode
  # https://github.com/nix-community/home-manager/issues/1800#issuecomment-2262881846
  # home.activation.makeVSCodeConfigWritable = let
  #   configDirName =
  #     {
  #       "vscode" = "Code";
  #       "vscode-insiders" = "Code - Insiders";
  #       "vscodium" = "VSCodium";
  #     }
  #     .${config.programs.vscode.package.pname};
  #   configPath = "${config.xdg.configHome}/${configDirName}/User/settings.json";
  # in {
  #   after = ["writeBoundary"];
  #   before = [];
  #   data = ''
  #     install -m 0640 "$(readlink ${configPath})" ${configPath}
  #   '';
  # };
}
