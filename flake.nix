{
  description = "A flake to build the environment for the Hash Database project";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-21.05;
  };

  outputs = { self, nixpkgs }:
    with import nixpkgs { system = "x86_64-linux"; };
    {
      packages.x86_64-linux.neo4j = callPackage ./pkgs/neo4j.nix { };
      packages.x86_64-linux.attrs-strict = callPackage ./pkgs/attrs-strict.nix { };
      packages.x86_64-linux.swh-model = callPackage ./pkgs/swh-model.nix {
        attrs-strict = self.packages.x86_64-linux.attrs-strict;
      };
      #packages.x86_64-linux.mirakuru = callPackage ./pkgs/mirakuru.nix { };
      #packages.x86_64-linux.webtest-aiohttp = callPackage ./pkgs/webtest-aiohttp.nix { };
      #packages.x86_64-linux.aiohttp-utils = callPackage ./pkgs/aiohttp-utils.nix {
      #  python-mimeparse = self.packages.x86_64-linux.python-mimeparse;
      #  webtest-aiohttp = self.packages.x86_64-linux.webtest-aiohttp;
      #};
      #packages.x86_64-linux.python-mimeparse = callPackage ./pkgs/python-mimeparse.nix { };
      #packages.x86_64-linux.port-for = callPackage ./pkgs/port-for.nix { };
      #packages.x86_64-linux.pytest-postgresql = callPackage ./pkgs/pytest-postgresql.nix {
      # port-for = self.packages.x86_64-linux.port-for;
      # mirakuru = self.packages.x86_64-linux.mirakuru;
      #};
      # packages.x86_64-linux.dash-bootstrap-components = callPackage ./pkgs/dash-bootstrap-components.nix { };

      #packages.x86_64-linux.swh-core = callPackage ./pkgs/swh-core.nix {
      #  pytest-postgresql = self.packages.x86_64-linux.pytest-postgresql;
      #  aiohttp-utils = self.packages.x86_64-linux.aiohttp-utils;
      #};
      #packages.x86_64-linux.swh-scanner = callPackage ./pkgs/swh-scanner.nix {
      #  swh-core = self.packages.x86_64-linux.swh-core;
      #  swh-model = self.packages.x86_64-linux.swh-model;
      #  dash-bootstrap-components = self.packages.x86_64-linux.dash-bootstrap-components;
      #};

      nixosModules.hashdb = import ./modules/hashdb.nix;
      nixosModule = self.nixosModules.hashdb;

      devShell.x86_64-linux =
        with import nixpkgs { system = "x86_64-linux"; };
        let customPython = python3.withPackages
          (p: [
            self.packages.x86_64-linux.neo4j
          ]);
        in
        mkShell
          {
            buildInputs = [
              self.packages.x86_64-linux.swh-model # swh-identify
              nix # nix-prefetch-url, nix-hash
              nix-prefetch-scripts # nix-prefetch-{bzr,cvs,git,hg,svn}
              coreutils # various hashes
              customPython
            ];
          };
    };
}
