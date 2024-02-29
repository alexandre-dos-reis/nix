{ pkgs, ... }:
{
  # https://mipmip.github.io/home-manager-option-search/?query=vscode
  programs.vscode = {
    enable = true;

    keybindings = [
      {
        key = "alt+1";
        command = "multiCommand.makeRoom";
      }
    ];
    
    # TODO:
    extensions = with pkgs.vscode-extensions; [
      astro-build.astro-vscode
      matthewpi.caddyfile-support
      vadimcn.vscode-lldb
      ms-azuretools.vscode-docker
      p1c2u.docker-compose
      dsznajder.es7-react-js-snippets
      graphql.vscode-graphql
      graphql.vscode-graphql-syntax
      hashicorp.terraform
      ms-kubernetes-tools.vscode-kubernetes-tools
      ms-vscode.live-server
      ms-vsliveshare.vsliveshare
      ms-vsliveshare.vsliveshare-pack
      pkief.material-icon-theme
      unifiedjs.vscode-mdx
      ryuta46.multi-command
      nrwl.angular-console
      fabiospampinato.vscode-open-in-github
      pmndrs.pmndrs
      esbenp.prettier-vscode
      yoavbls.pretty-ts-errors
      prisma.prisma
      rust-lang.rust-analyzer
      joe-re.sql-language-server
      bradlc.vscode-tailwindcss
      bourhaouta.tailwindshades
      vscodevim.vim
      redhat.vscode-yaml
    ];

    userSettings = {
      "workbench.colorTheme" = "poimandres";
      "terminal.integrated.fontFamily" = "MesloLGS NF";
      "editor.fontFamily" = "Jetbrains Mono; Menlo, Monaco, 'Courier New', monospace";
      "editor.lineHeight" = 20;
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
      "editor.fontLigatures" = true;
      "editor.bracketPairColorization.enabled" = true;
      "scm.defaultViewMode" = "tree";
      # Vim preference
      "editor.lineNumbers" = "relative";
      "editor.cursorStyle" = "block";
      "vim.insertModeKeyBindings" = [
        {
          "before" = ["j" "j"];
          "after" = ["<Esc>"];
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

  };
}
