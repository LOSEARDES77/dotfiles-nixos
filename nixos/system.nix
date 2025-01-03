{pkgs, ...}: let
  alejandra =
    (import (builtins.fetchTarball {
      url = "https://github.com/kamadorueda/alejandra/tarball/3.0.0";
      sha256 = "18jm0d5xrxk38hw5sa470zgfz9xzdcyaskjhgjwhnmzd5fgacny4";
    }) {})
    .outPath;
in {
  # nix
  documentation.nixos.enable = false; # .desktop
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };
  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        firefox
      '';
      mode = "0755";
    };
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # virtualisation
  programs.virt-manager.enable = true;
  virtualisation = {
    virtualbox.host.enable = true;
    podman.enable = true;
    docker.enable = true;
    libvirtd.enable = true;
  };

  # dconf
  programs.dconf.enable = true;

  # packages
  environment.systemPackages = with pkgs; [
    home-manager
    neovim
    git
    wget
    gh
    nixos-bgrt-plymouth
    mission-center
    lightly-qt
    libsForQt5.qt5ct
    egl-wayland
    alejandra
    rustup
    llvmPackages_19.bintools
    clang
    clippy
  ];

  # services
  services = {
    ratbagd.enable = true;
    xserver = {
      enable = true;
      excludePackages = [pkgs.xterm];
    };
    printing.enable = true;
    flatpak.enable = true;
    openssh = {
      enable = true;
      ports = [22];
      settings = {
        PasswordAuthentication = true;
        AllowUsers = ["loseardes77"];
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "prohibit-password";
      };
    };
    ollama.enable = true;
  };

  # fonts
  fonts.packages = with pkgs; [
    (
      nerdfonts.override {
        fonts = [
          "FiraCode"
          "DroidSansMono"
          "JetBrainsMono"
          "CascadiaCode"
        ];
      }
    )
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];

  # logind
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleLidSwitch=suspend
    HandleLidSwitchExternalPower=ignore
  '';

  # Httpd
  services.httpd = {
    enable = false;
    virtualHosts."localhost".documentRoot = "/var/www/html";
  };

  services.samba = {
    enable = true;
    openFirewall = true;
  };

  # network
  networking = {
    firewall = rec {
      # kdeconnect
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedTCPPorts = [22];
      allowedUDPPortRanges = allowedTCPPortRanges;
      enable = false;
      allowPing = true;
    };
    networkmanager.enable = true;
    nameservers = ["1.1.1.1" "9.9.9.9"];
  };

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings.General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  # bootloader
  boot = {
    plymouth.enable = true;
    tmp.cleanOnBoot = true;
    supportedFilesystems = ["ntfs"];
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      timeout = 2;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  system.stateVersion = "23.05";
}
