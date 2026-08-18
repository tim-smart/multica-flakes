{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };
  outputs = {nixpkgs, ...}: let
    forAllSystems = function:
      nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed
      (system: function nixpkgs.legacyPackages.${system});
  in {
    devShells = forAllSystems (pkgs: let
      python = pkgs.python3.withPackages (ps: [ps.setuptools]);
    in {
      default = pkgs.mkShell {
        packages = [
          pkgs.nodejs_22
          pkgs.sqlite
          python
          (pkgs.writeShellScriptBin "yarn" ''
            exec ${pkgs.nodejs_22}/bin/corepack yarn "$@"
          '')
        ];
        npm_config_python = "${python}/bin/python";
      };
    });
  };
}
