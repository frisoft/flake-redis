{
  description = "redis server";

  inputs = {
    nixpkgs.url = "nixpkgs"; # Resolves to github:NixOS/nixpkgs
    # Helpers for system-specific outputs
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    # Create system-specific outputs for the standard Nix systems
    # https://github.com/numtide/flake-utils/blob/master/default.nix#L3-L9
    flake-utils.lib.eachDefaultSystem (system:
      let
      	pkgs = import nixpkgs { inherit system; };
        redis = pkgs.redis;
      in
      {
        apps.default = let
          serv = pkgs.writeShellApplication {
            name = "redis";
            runtimeInputs = [redis];
            text = ''
              echo "Starting Redis..."
              redis-server --daemonize yes
              REDIS_PID=$!
              echo "$REDIS_PID"
              echo "Started redis with pid $REDIS_PID"
            '';
          };
        in {
          type = "app";
          program = "${serv}/bin/redis";
        };

        apps.stop = let
          serv = pkgs.writeShellApplication {
            name = "redisstop";
            runtimeInputs = [redis];
            text = ''
              echo "Stopping Redis..."
              redis-cli shutdown
            '';
          };
        in {
          type = "app";
          program = "${serv}/bin/redisstop";
        };
      });
}
