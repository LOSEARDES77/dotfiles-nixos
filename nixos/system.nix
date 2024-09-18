{pkgs, ...}: {
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
    kdePackages.plasma-browser-integration
    nixos-bgrt-plymouth
  ];

  # services
  services = {
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
  };

  # logind
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleLidSwitch=suspend
    HandleLidSwitchExternalPower=ignore
  '';

  # Httpd
  services.httpd = {
    enable = true;
    virtualHosts."localhost".documentRoot = "/var/www/html";
  };
  
  # kde connect
  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedTCPPorts = [22];
    allowedUDPPortRanges = allowedTCPPortRanges;
    enable = false;
  };

  # network
  networking.networkmanager.enable = true;

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings.General.Experimental = true; # for gnome-bluetooth percentage
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
    loader = {
      timeout = 2;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  system.stateVersion = "23.05";
}
