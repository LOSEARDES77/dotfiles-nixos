{
  pkgs,
  inputs,
  config,
  asztal,
  lib,
  ...
}: {
  options.hyprland = {
    enable = lib.mkEnableOption "Hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };

    services.xserver.displayManager.startx.enable = true;

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };

    security = {
      polkit.enable = true;
      pam.services.ags = {};
    };

    environment.systemPackages = with pkgs; [
      morewaita-icon-theme
      adwaita-icon-theme
      bibata-cursors
      loupe
      nautilus
      baobab
      gnome-text-editor
      gnome-calendar
      gnome-boxes
      gnome-system-monitor
      gnome-control-center
      gnome-weather
      gnome-calculator
      gnome-clocks
      gnome-software # for flatpak
      wl-gammactl
      wl-clipboard
      wayshot
      pavucontrol
      brightnessctl
    ];

    systemd = {
      user.services.polkit-hyprland-authentication-agent = {
        description = "polkit-gnome-authentication-agent";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${inputs.hyprpolkitagent.packages.${pkgs.system}.hyprpolkitagent}/libexec/hyprpolkitagent";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };

    services = {
      gvfs.enable = true;
      devmon.enable = true;
      udisks2.enable = true;
      upower.enable = true;
      power-profiles-daemon.enable = true;
      accounts-daemon.enable = true;
      gnome = {
        evolution-data-server.enable = true;
        glib-networking.enable = true;
        gnome-keyring.enable = true;
        gnome-online-accounts.enable = true;
        localsearch.enable = true;
        tinysparql.enable = true;
      };
    };

    services.greetd = {
      enable = true;
      settings.default_session.command = pkgs.writeShellScript "greeter" ''
        export XKB_DEFAULT_LAYOUT=${config.services.xserver.xkb.layout}
        export XCURSOR_THEME=Bibata-Modern-Ice
        export XCURSOR_SIZE=24
        ${asztal}/bin/greeter
      '';
    };

    systemd.tmpfiles.rules = [
      "d '/var/cache/greeter' - greeter greeter - -"
    ];

    system.activationScripts.starship = {
      text = ''
        mkdir -p /home/loseardes77/.cache/starship
        ${pkgs.starship}/bin/starship init zsh > /home/loseardes77/.cache/starship/init.zsh
      '';
    };

    system.activationScripts.wallpaper = let
      wp = pkgs.writeShellScript "wp" ''
        CACHE="/var/cache/greeter"
        OPTS="$CACHE/options.json"
        HOME="/home/$(find /home -maxdepth 1 -printf '%f\n' | tail -n 1)"

        mkdir -p "$CACHE"
        chown greeter:greeter $CACHE

        if [[ -f "$HOME/.cache/ags/options.json" ]]; then
          cp $HOME/.cache/ags/options.json $OPTS
          chown greeter:greeter $OPTS
        fi

        if [[ -f "$HOME/.config/background" ]]; then
          cp "$HOME/.config/background" $CACHE/background
          chown greeter:greeter "$CACHE/background"
        fi
      '';
    in
      builtins.readFile wp;
  };
}
