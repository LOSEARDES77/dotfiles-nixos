{
  description = "Configurations of LOSEARDES77";

  outputs = inputs @ {
    self,
    home-manager,
    nixpkgs,
    ...
  }: {
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
            ];
          }
        ];
      };
    };
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpolkitagent = {
      url = "github:hyprwm/hyprpolkitagent";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprsysteminfo = {
      url = "github:hyprwm/hyprsysteminfo";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lf-icons = {
      url = "github:gokcehan/lf";
      flake = false;
    };
  };
}
