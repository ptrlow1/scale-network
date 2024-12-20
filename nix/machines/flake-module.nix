{ lib, inputs, ... }:

let
  # All scale common modules
  system = "x86_64-linux";
  common = {
    imports = [
      inputs.microvm.nixosModules.microvm
      inputs.self.nixosModules.facts
      ./_common
      ./_common/time.nix
      ./_common/ssh/vm.nix
    ];
  };
in
{
  flake.nixosConfigurations = {
    bootstrapImage = lib.nixosSystem {
      inherit system;
      modules = [
        (
          { modulesPath, ... }:
          {
            imports = [
              "${toString modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
            ];
          }
        )
        ./_common/base.nix
        ./_common/users.nix
        ./bootstrap
      ];
    };
    devServer = lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.disko.nixosModules.disko
        ./devServer/disko.nix
        ./_common/base.nix
        ./_common/users.nix
        ./devServer/default.nix
        ./devServer/hardware-configuration.nix
      ];
    };
    loghost = lib.nixosSystem {
      inherit system;
      modules = [
        common
        ./loghost.nix
      ];
      specialArgs = {
        inherit inputs;
      };
    };
    monitor = lib.nixosSystem {
      inherit system;
      modules = [
        common
        ./monitor/monitor.nix
        ./monitor/microvm-config.nix
      ];
      specialArgs = {
        inherit inputs;
      };
    };
    massflash = lib.nixosSystem {
      inherit system;
      modules = [
        (
          { modulesPath, ... }:
          {
            imports = [
              "${toString modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
            ];
          }
        )
        ./_common/base.nix
        ./_common/users.nix
        ./massflash.nix
      ];
      specialArgs = {
        inherit inputs;
      };
    };
    coreMaster = lib.nixosSystem {
      inherit system;
      modules = [
        common
        ./core/microvm-config.nix
        ./core/master.nix
      ];
      specialArgs = {
        inherit inputs;
      };
    };
    coreSlave = lib.nixosSystem {
      inherit system;
      modules = [
        common
        ./core/microvm-config.nix
        ./core/slave.nix
      ];
      specialArgs = {
        inherit inputs;
      };
    };
    hypervisor1 = lib.nixosSystem {
      inherit system;
      modules = [
        ./_common
        inputs.microvm.nixosModules.host
        ./hypervisor/hypervisor1.nix
        ./hypervisor/hardware-configuration.nix
      ];
      specialArgs = {
        inherit inputs;
      };
    };
    hypervisor2 = lib.nixosSystem {
      inherit system;
      modules = [
        ./_common
        inputs.microvm.nixosModules.host
        ./hypervisor/hypervisor2.nix
        ./hypervisor/hardware-configuration.nix
      ];
      specialArgs = {
        inherit inputs;
      };
    };
    signs = lib.nixosSystem {
      inherit system;
      modules = [
        common
        ./signs/microvm-config.nix
        ./signs/signs.nix
      ];
      specialArgs = {
        inherit inputs;
      };
    };
    cache = lib.nixosSystem {
      inherit system;
      modules = [
        common
        ./cache/microvm-config.nix
        ./cache/cache.nix
      ];
      specialArgs = {
        inherit inputs;
      };
    };

  };

}
