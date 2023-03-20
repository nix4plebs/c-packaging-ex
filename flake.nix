{
  description = "C development environment for xNVMe and libvfn";

  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11"; };

  outputs = { self, nixpkgs }:
    let
      allSystems = [
        "x86_64-linux" # AMD/Intel Linux
        "aarch64-linux" # ARM Linux
      ];

      forAllSystems = fn:
        nixpkgs.lib.genAttrs allSystems
        (system: fn {
          pkgs = import nixpkgs { inherit system; }; });

    in {
      # used when calling `nix fmt <path/to/flake.nix>`
      formatter = forAllSystems ({ pkgs }: pkgs.nixfmt);

      # nix develop <flake-ref>#<name>
      # -- 
      # $ nix develop <flake-ref>#blue
      # $ nix develop <flake-ref>#yellow
      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell {
          name = "nixdev";
          nativeBuildInputs = [
            self.packages.${pkgs.system}.xnvme
            self.packages.${pkgs.system}.libvfn
          ];
        };
      });

      # nix run|build <flake-ref>#<pkg-name>
      # -- 
      # $ nix run <flake-ref>#hello
      # $ nix run <flake-ref>#cowsay
      packages = forAllSystems ({ pkgs }: rec {
        libvfn = pkgs.callPackage ./packages/libvfn {};
        xnvme = pkgs.callPackage ./packages/xnvme { inherit libvfn; };
      });
    };
}