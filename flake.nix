{
  description = "Aggregated flake with sbt-overlay-flakes and riscv-toolchain-flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";

    # 引用子 Flakes
    sbt-overlay-flakes.url = "path:./sbt-overlay-flakes";
    riscv-toolchain-flakes.url = "path:./riscv-toolchain-flakes";
  };

  outputs = { self, nixpkgs, flake-utils, sbt-overlay-flakes, riscv-toolchain-flakes }:
    flake-utils.lib.eachDefaultSystem (system: {
      packages = {
        # 导出 sbt-overlay-flakes 的包
        sbt = sbt-overlay-flakes.packages.${system}.sbt;

        # 导出 riscv-toolchain-flakes 的包
        riscv-gcc = riscv-toolchain-flakes.packages.${system}.riscv-gcc;
        riscv-gdb = riscv-toolchain-flakes.packages.${system}.riscv-gdb;
      };
    });
}
