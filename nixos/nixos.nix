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
      "input"
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

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      SDL
      SDL2
      SDL2_image
      SDL2_mixer
      SDL2_ttf
      SDL_image
      SDL_mixer
      SDL_ttf
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      bzip2
      cairo
      cups
      curlWithGnuTls
      dbus
      dbus-glib
      desktop-file-utils
      e2fsprogs
      expat
      flac
      fontconfig
      freeglut
      freetype
      fribidi
      fuse
      fuse3
      gdk-pixbuf
      glew110
      glib
      gmp
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-ugly
      gst_all_1.gstreamer
      gtk2
      harfbuzz
      icu
      keyutils.lib
      libGL
      libGLU
      libappindicator-gtk2
      libcaca
      libcanberra
      libcap
      libclang.lib
      libdbusmenu
      libdrm
      libgcrypt
      libgpg-error
      libidn
      libjack2
      libjpeg
      libmikmod
      libogg
      libpng12
      libpulseaudio
      librsvg
      libsamplerate
      libthai
      libtheora
      libtiff
      libudev0-shim
      libusb1
      libuuid
      libvdpau
      libvorbis
      libvpx
      libxcrypt-legacy
      libxkbcommon
      libxml2
      mesa
      nspr
      nss
      openssl
      p11-kit
      pango
      pixman
      python3
      speex
      stdenv.cc.cc
      tbb
      udev
      vulkan-loader
      wayland
      xorg.libICE
      xorg.libSM
      xorg.libX11
      xorg.libXScrnSaver
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXft
      xorg.libXi
      xorg.libXinerama
      xorg.libXmu
      xorg.libXrandr
      xorg.libXrender
      xorg.libXt
      xorg.libXtst
      xorg.libXxf86vm
      xorg.libpciaccess
      xorg.libxcb
      xorg.xcbutil
      xorg.xcbutilimage
      xorg.xcbutilkeysyms
      xorg.xcbutilrenderutil
      xorg.xcbutilwm
      xorg.xkeyboardconfig
      xz
      zlib
    ];
  };
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
