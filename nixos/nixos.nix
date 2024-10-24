{
  inputs,
  lib,
  pkgs,
  ...
}: let
  username = "loseardes77";
in {
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./system.nix
    ./audio.nix
    ./locale.nix
    ./nautilus.nix
    #    ./laptop.nix
    ./hyprland.nix
    ./gnome.nix
  ];

  hyprland.enable = true;
  programs.zsh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    initialPassword = username;
    shell = pkgs.zsh;
    extraGroups = [
      "nixosvmtest"
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "libvirtd"
      "docker"
      "vboxusers"
      "user-with-access-to-virtualbox"
    ];
  };
  environment.systemPackages = [
    inputs.zen-browser.packages."x86_64-linux".default
    inputs.hyprsysteminfo.packages."x86_64-linux".default
    inputs.hyprlock.packages."x86_64-linux".default
    inputs.hypridle.packages."x86_64-linux".default
    inputs.hyprpaper.packages."x86_64-linux".default
    inputs.hyprpolkitagent.packages."x86_64-linux".default
  ];

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        zen-bin
        .zen-wrapped
        zen
      '';
      mode = "0755";
    };
  };

  programs.nix-ld.enable = true;
  programs._1password-gui.enable = true;
  programs._1password.enable = true;
  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.${username} = {
      home.username = username;
      home.homeDirectory = "/home/${username}";
      imports = [
        ../home-manager/kitty.nix
        ../home-manager/nvim.nix
        ../home-manager/ags.nix
        # ../home-manager/blackbox.nix
        ../home-manager/browser.nix
        ../home-manager/dconf.nix
        ../home-manager/distrobox.nix
        ../home-manager/git.nix
        ../home-manager/hyprland.nix
        ../home-manager/lf.nix
        ../home-manager/packages.nix
        ../home-manager/sh.nix
        ../home-manager/starship.nix
        ../home-manager/theme.nix
        ../home-manager/tmux.nix
        # ../home-manager/wezterm.nix
        ../home-manager/dev.nix
        ../home-manager/nwg-dock.nix
        ./home.nix
      ];
    };
  };

  specialisation = {
    gnome.configuration = {
      system.nixos.tags = ["Gnome"];
      hyprland.enable = lib.mkForce false;
      gnome.enable = true;
    };
  };
}
