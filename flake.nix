{
  description = "Purescript-Lua Flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    purescript-overlay.url = "github:thomashoneyman/purescript-overlay";
    purescript-overlay.inputs.nixpkgs.follows = "nixpkgs";
    pslua.url = "github:purescript-lua/purescript-lua";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      purescript-overlay,
      pslua,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ purescript-overlay.overlays.default ];
        };
        lpkgs = pkgs.lua51Packages;
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.purs-bin.purs-0_15_16
            pkgs.spago-bin.spago-1_0_4
            pkgs.purs-tidy
            lpkgs.lua
            lpkgs.luacheck
            pkgs.httpie
            pkgs.nil
            pkgs.nixfmt-rfc-style
            pkgs.openresty
            pslua.packages.${system}.default
          ];
        };
      }
    );
}
