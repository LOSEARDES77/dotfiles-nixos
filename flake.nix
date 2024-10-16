{
  description = "Configurations of LOSEARDES77";

  outputs = inputs @ {
    self,
    home-manager,
    nixpkgs,
    ...
  }: {
    packages.x86_64-linux = let
      iconDir = "${self}/Hypr-Bibata-Modern-Ice";
    in {
      default = nixpkgs.legacyPackages.x86_64-linux.callPackage ./ags {inherit inputs;};

      copy-icons = nixpkgs.stdenv.mkDerivation {
        name = "copy-icons";

        installPhase = ''
          mkdir -p $HOME/.local/share/icons
          cp -r ${iconDir}/* $HOME/.local/share/icons/
        '';
      };
    };
    overlays = [
      (_: _final: prev: {
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
        ];
      };
    };

    # macos hm config
    homeConfigurations = {
      "loseardes77" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-darwin;
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ({pkgs, ...}: {
            nix.package = pkgs.nix;
            home.username = "loseardes77";
            home.homeDirectory = "/Users/loseardes77";
            imports = [./macos/home.nix];
          })
        ];
      };
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprland-hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    matugen.url = "github:InioX/matugen?ref=v2.2.0";
    ags.url = "github:Aylur/ags";
    astal.url = "github:Aylur/astal";

    lf-icons = {
      url = "github:gokcehan/lf";
      flake = false;
    };
  };
}
