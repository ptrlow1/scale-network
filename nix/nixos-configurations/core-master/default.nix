{
  release = "2405";

  modules =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (lib.modules)
        mkForce
        ;
    in
    {
      imports = [
        ./configuration.nix
        ./hardware-configuration.nix
      ];

      config = {
        nixpkgs.hostPlatform = "x86_64-linux";

        scale-network = {
          base.enable = true;
          services.prometheus.enable = true;
          services.ssh4vms.enable = true;
          timeServers.enable = true;

          users.berkhan.enable = true;
          users.dlang.enable = true;
          users.jsh.enable = true;
          users.kylerisse.enable = true;
          users.owen.enable = true;
          users.rhamel.enable = true;
          users.rob.enable = true;
          users.root.enable = true;
          users.ruebenramirez.enable = true;
        };
        scale-network.facts = {
          ipv4 = "10.128.3.20/24";
          ipv6 = "2001:470:f026:503::20/64";
          eth = "virbr0";
        };

        networking.hostName = "coremaster";

        # disable legacy networking bits as recommended by:
        #  https://github.com/NixOS/nixpkgs/issues/10001#issuecomment-905532069
        #  https://github.com/NixOS/nixpkgs/blob/82935bfed15d680aa66d9020d4fe5c4e8dc09123/nixos/tests/systemd-networkd-dhcpserver.nix
        networking = {
          extraHosts = ''
            10.128.3.20 coreconf.scale.lan
          '';
        };

        systemd.services.systemd-networkd-wait-online.enable = mkForce false;
        # Make sure that the nix/machines/core/master.nixmakes of these files are actually lexicographically before 99-default.link provides by systemd defaults since first match wins
        # Ref: https://github.com/systemd/systemd/issues/9227#issuecomment-395500679
        networking.useDHCP = false;
        systemd.network = {
          enable = true;

          netdevs.virbr0.netdevConfig = {
            Kind = "bridge";
            Name = "virbr0";
          };

          networks = {
            "1-virbr0" = {
              matchConfig.Name = "virbr0";
              enable = true;
              address = [
                config.scale-network.facts.ipv4
                config.scale-network.facts.ipv6
              ];
              routes = [
                { routeConfig.Gateway = "10.128.3.1"; }
                { routeConfig.Gateway = "2001:470:f026:503::1"; }
              ];
            };
            "10-lan-eno2" = {
              matchConfig.Name = "eno2";
              networkConfig = {
                Bridge = "virbr0";
                LLDP = true;
                EmitLLDP = true;
              };
            };
            "10-lan-eno3" = {
              matchConfig.Name = "eno3";
              networkConfig = {
                Bridge = "virbr0";
                LLDP = true;
                EmitLLDP = true;
              };
            };
            # Keep this for troubleshooting
            "10-lan-eno1" = {
              matchConfig.Name = "eno1";
              enable = true;
              networkConfig = {
                DHCP = "yes";
                LLDP = true;
                EmitLLDP = true;
              };
            };
          };
        };
      };
    };
}
