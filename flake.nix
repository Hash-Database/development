{
  description = "A flake to build the environment for the Hash Database project";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-21.05;
    rgrunbla-pkgs.url = github:rgrunbla/Flakes;
  };

  outputs = { self, nixpkgs, rgrunbla-pkgs }:
    with import nixpkgs { system = "x86_64-linux"; };
    {
      nixosModules.hashdb = import ./modules/hashdb.nix;
      nixosModule = self.nixosModules.hashdb;

      devShell.x86_64-linux =
        with import nixpkgs { system = "x86_64-linux"; };
        let customPython = python3.withPackages
          (p: [
            rgrunbla-pkgs.packages.x86_64-linux.neo4j
          ]);
        in
        mkShell
          {
            buildInputs = [
              rgrunbla-pkgs.packages.x86_64-linux.swh-model # swh-identify
              nix # nix-prefetch-url, nix-hash
              nix-prefetch-scripts # nix-prefetch-{bzr,cvs,git,hg,svn}
              coreutils # various hashes
              customPython
            ];
          };
    };
}
