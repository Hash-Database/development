{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.hashdb;
in
{
  options = {
    services.hashdb = {
      enable = mkEnableOption "HashDatabase Service";
      passwordFile = lib.mkOption {
        type = lib.types.path;
        default = null;
        example = "/run/keys/neo4j_password";
        description = ''
          File containing the neo4j account password.

          This should be a string, not a Nix path, since Nix paths are
          copied into the world-readable Nix store.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    # Neo4J
    services.neo4j = {
      enable = true;
    };
    systemd.services.neo4j = {
      preStart = optionalString (cfg.passwordFile != null) ''
        # Is that safe ? Have to explore what's the content of the auth file.
        ${pkgs.coreutils}/bin/rm /var/lib/neo4j/data/dbms/auth
        ${pkgs.neo4j}/bin/neo4j-admin set-initial-password "$(cat ${cfg.passwordFile})"
      '';
    };
  };
}
