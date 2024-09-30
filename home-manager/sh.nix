{
  pkgs,
  config,
  lib,
  ...
}: let
  aliases = {
    "db" = "distrobox";
    "tree" = "lsd --tree";
    "nv" = "nvim";

    "ls" = "lsd -h";
    "l" = "lsd -h";
    "la" = "lsd -ah";
    "ll" = "lsd -lah";

    "cat" = "bat";
    "vim" = "nvim";
    "c" = "clear";
    "gp" = "git push";
    "ga" = "git add .";
    "gcm" = "git commit -m";
    "update" = "sudo nixos-rebuild switch --flake /home/loseardes77/.config/dotfiles-nixos --impure";
    "flake-update" = "cd $HOME/.config/dotfiles-nixos && git pull && nix flake update && git add flake.lock && git commit -m 'Update flake.lock' && git push && update";
    "fol" = "firefox -new-window file:///home/loseardes77/Downloads/empresa-e-iniciativa-emprendedora-2022-libro_compress.pdf && gnome-calculator &> /dev/null & disown && exit";
  };
in {
  options.shellAliases = with lib;
    mkOption {
      type = types.attrsOf types.str;
      default = {};
    };

  config.programs = {
    zsh = {
      shellAliases = aliases // config.shellAliases;
      enable = true;
      history = {
        append = true;
        ignoreAllDups = true;
        ignoreSpace = true;
        save = 5000;
        share = true;
      };
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";

          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
      ];

      initExtra = ''
        SHELL=\${pkgs.zsh}/bin/zsh
        zstyle ':completion:*' menu select
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        unsetopt BEEP

        # Set the directory we want to store zinit and plugins
        ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"
        PATH=$PATH:/home/loseardes77/.cargo/bin:/home/loseardes77/.fzf/bin

        # Download Zinit, if it's not there yet
        if [ ! -d "$ZINIT_HOME" ]; then
          mkdir -p "$(dirname $ZINIT_HOME)"
          git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
        fi

        # Source/Load zinit
        source "$ZINIT_HOME/zinit.zsh"

        # Add in starship
        zinit light 'starship/starship'

        # Add in zsh plugins
        zinit light zsh-users/zsh-syntax-highlighting
        zinit light zsh-users/zsh-completions
        zinit light zsh-users/zsh-autosuggestions
        zinit light Aloxaf/fzf-tab

        # Add in snippets
        zinit snippet OMZP::git
        zinit snippet OMZP::sudo
        zinit snippet OMZP::aws
        zinit snippet OMZP::kubectl
        zinit snippet OMZP::kubectx
        zinit snippet OMZP::command-not-found

        # Load completions
        autoload -Uz compinit && compinit

        zinit cdreplay -q

        # Keybindings
        bindkey 'UPAR' history-search-backward
        bindkey 'DOWNAR' history-search-forward
        bindkey '^w' kill-region
        bindkey  "^[[H"   beginning-of-line
        bindkey  "^[[F"   end-of-line
        bindkey  "^[[3~"  delete-char
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word

        # Completion styling
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

        # Shell integrations
        eval "$(fzf --zsh)"
        eval "$(zoxide init --cmd cd zsh)"
      '';
    };

    bash = {
      shellAliases = aliases // config.shellAliases;
      enable = true;
      initExtra = "SHELL=${pkgs.bash}";
    };

    nushell = {
      shellAliases = aliases // config.shellAliases;
      enable = true;
      environmentVariables = {
        PROMPT_INDICATOR_VI_INSERT = "\"  \"";
        PROMPT_INDICATOR_VI_NORMAL = "\"∙ \"";
        PROMPT_COMMAND = ''""'';
        PROMPT_COMMAND_RIGHT = ''""'';
        NIXPKGS_ALLOW_UNFREE = "1";
        NIXPKGS_ALLOW_INSECURE = "1";
        SHELL = ''"${pkgs.nushell}/bin/nu"'';
        EDITOR = ''"${config.home.sessionVariables.EDITOR}"'';
        VISUAL = ''"${config.home.sessionVariables.VISUAL}"'';
      };
      extraConfig = let
        conf = builtins.toJSON {
          show_banner = false;
          edit_mode = "vi";

          ls.clickable_links = true;
          rm.always_trash = true;

          table = {
            mode = "compact"; # compact thin rounded
            index_mode = "always"; # alway never auto
            header_on_separator = false;
          };

          cursor_shape = {
            vi_insert = "line";
            vi_normal = "block";
          };

          menus = [
            {
              name = "completion_menu";
              only_buffer_difference = false;
              marker = "? ";
              type = {
                layout = "columnar"; # list, description
                columns = 4;
                col_padding = 2;
              };
              style = {
                text = "magenta";
                selected_text = "blue_reverse";
                description_text = "yellow";
              };
            }
          ];
        };
        completions = let
          completion = name: ''
            source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/${name}/${name}-completions.nu
          '';
        in
          names:
            builtins.foldl'
            (prev: str: "${prev}\n${str}") ""
            (map (name: completion name) names);
      in ''
        $env.config = ${conf};
        ${completions ["cargo" "git" "nix" "npm" "poetry" "curl"]}

        alias pueue = ${pkgs.pueue}/bin/pueue
        alias pueued = ${pkgs.pueue}/bin/pueued
        use ${pkgs.nu_scripts}/share/nu_scripts/modules/background_task/task.nu
      '';
    };
  };
}
