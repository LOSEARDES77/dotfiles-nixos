{config, ...}: {
  news.display = "show";

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    warn-dirty = false;
  };

  home = {
    sessionVariables = {
      QT_XCB_GL_INTEGRATION = "none"; # kde-connectQT_QT_
      QT_QPA_PLATFORMTHEME = lib.mkDefault "qt6ct";
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      BAT_THEME = "base16";
      GOPATH = "${config.home.homeDirectory}/.local/share/go";
      GOMODCACHE = "${config.home.homeDirectory}/.cache/go/pkg/mod";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
    ];
  };

  gtk.gtk3.bookmarks = let
    home = config.home.homeDirectory;
  in [
    "file://${home} Home"
    "file://${home}/Documents Documents"
    "file://${home}/Downloads Downloads"
    "file://${home}/Projects Projects"
    "file://${home}/.config Config"
  ];

  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "21.11";
}
