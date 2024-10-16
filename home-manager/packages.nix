{pkgs, ...}: {
  imports = [
    ./modules/packages.nix
    ./scripts/blocks.nix
    ./scripts/nx-switch.nix
    ./scripts/vault.nix
  ];

  nixpkgs.overlays = [
    (final: prev: {
      cliphist = prev.cliphist.overrideAttrs (_oldAttrs: rec {
        version = "0.6.1";

        src = prev.fetchFromGitHub {
          owner = "sentriz";
          repo = "cliphist";
          rev = "refs/tags/v${version}";
          hash = "sha256-tImRbWjYCdIY8wVMibc5g5/qYZGwgT9pl4pWvY7BDlI=";
        };

        vendorHash = "sha256-gG8v3JFncadfCEUa7iR6Sw8nifFNTciDaeBszOlGntU=";
      });
    })
  ];

  packages = with pkgs; {
    linux = [
      (mpv.override {scripts = [mpvScripts.mpris];})
      spotify
      # gnome-secrets
      fragments
      figma-linux
      pods
      # yabridge
      # yabridgectl
      # wine-staging
      nodejs
      fuse
      fuzzel
      cliphist
      warp-terminal
      localsend
      libreoffice-fresh
      kdePackages.kdenlive
      imagemagick_light
      wofi
    ];
    cli = [
      bat
      lsd
      fd
      ripgrep
      fzf
      lazydocker
      lazygit
      zoxide
      btop
    ];
  };
}
