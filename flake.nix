{
  description = "Configurations of LOSEARDES77";

  outputs = inputs @ {
    self,
    home-manager,
    nixpkgs,
    ...
  }: {
    packages.x86_64-linux = {
      default = nixpkgs.legacyPackages.x86_64-linux.callPackage ./ags {inherit inputs;};
    };
    # nixos config
    nixosConfigurations = {
      "loseardes77-laptop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          asztal = self.packages.x86_64-linux.default;
        };
        modules = [
          ./nixos/nixos.nix
          home-manager.nixosModules.home-manager
          {networking.hostName = "loseardes77-laptop";}
          {
            nixpkgs.overlays = [
              (
                final: prev: {
                  vscode = prev.vscode.overrideAttrs (old: {
                    patches =
                      (old.patches or [])
                      ++ [
                        /home/loseardes77/.config/dotfiles-nixos/vscode.patch
                      ];
                  });
                }
              )
            ];
          }
        ];
      };
    };
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprlock.url = "github:hyprwm/hyprlock";
    hypridle.url = "github:hyprwm/hypridle";
    hyprpaper.url = "github:hyprwm/hyprpaper";
    hyprpolkitagent.url = "github:hyprwm/hyprpolkitagent";
    hyprsysteminfo.url = "github:hyprwm/hyprsysteminfo";

    matugen.url = "github:InioX/matugen?ref=v2.3.0";
    ags.url = "github:Aylur/ags";
    astal.url = "github:Aylur/astal";

    lf-icons = {
      url = "github:gokcehan/lf";
      flake = false;
    };
  };
}
