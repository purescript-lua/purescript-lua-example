{
  description = "Purescript-Lua Flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    easyps.url = "github:justinwoo/easy-purescript-nix";
    pslua.url = "github:purescript-lua/purescript-lua";
  };

  outputs = { self, nixpkgs, flake-utils, easyps, pslua }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        epkgs = easyps.packages.${system};
        pkgs = nixpkgs.legacyPackages.${system};
        lpkgs = pkgs.lua51Packages;
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs;
            with lpkgs; [
              dhall
              dhall-lsp-server
              httpie
              lua
              luacheck
              nil
              nixfmt-rfc-style
              openresty
              pslua.packages.${system}.default
              epkgs.purs-0_15_15
              epkgs.purs-tidy
              epkgs.spago
            ];
        };
      });
}

