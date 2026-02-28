{
  description = "default rust workspace";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, ... } @ inputs: 
  let 
    overlays = [ (import inputs.rust-overlay) ];
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system overlays;
    };
  in 
  {
    devShells.x86_64-linux.default = pkgs.mkShell {

      packages = with pkgs;
      [
        (rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rust-analyzer" ];
        })
        pkg-config
        openssl
        just
        cargo-watch
        cargo-edit
        cargo-nextest
      ];

      shellHook = ''
        export TMPDIR=/tmp
      '';
    };
  };
}
