{
  description = "MEMU";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zig-overlay.url = "github:mitchellh/zig-overlay";
  };

  outputs = {
    self,
    zig-overlay,
    nixpkgs,
    flake-utils,
  } @ inputs:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [zig-overlay.overlays.default];
        };
        deps = with pkgs; [
          git
          gnumake
          autoconf
          automake
          cmake
          ninja
          zigpkgs.master
          pkgsCross.riscv64-embedded.buildPackages.gcc
        ];
      in {
        legacyPackages = pkgs;
        formatter = pkgs.alejandra;
        devShells.default = pkgs.mkShell.override {stdenv = pkgs.clangStdenv;} {
          buildInputs = deps;
          RV64_TOOLCHAIN_ROOT = "${pkgs.pkgsCross.riscv64-embedded.buildPackages.gcc}";
          shellHook = ''
            export EMU_CC=$RV64_TOOLCHAIN_ROOT/bin/riscv64-none-elf-gcc
            export EMU_OBJCOPY=$RV64_TOOLCHAIN_ROOT/bin/riscv64-none-elf-objcopy
            make test-img
            unset EMU_CC
            unset EMU_OBJCOPY
          '';
        };
      }
    )
    // {inherit inputs;};
}
