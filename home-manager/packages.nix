{pkgs, ...}: {
  imports = [
    ./modules/packages.nix
    ./scripts/blocks.nix
    ./scripts/nx-switch.nix
    ./scripts/vault.nix
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
      _1password-gui
      fuse
      fuzzel
      cliphist
      warp-terminal
      localsend
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
