{
  description = "Flake for combining riscv-toolchain-flakes and sbt-overlay-flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # 引入 riscv-toolchain-flakes
    # 用 follows 引用相对路径的 flake
    riscv-toolchain-flakes.follows = "self";
    sbt-overlay-flakes.follows = "self";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, riscv-toolchain-flakes, sbt-overlay-flakes, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system: 
      let
        pkgs = nixpkgs.legacyPackages.${system};
        riscv-toolchain = riscv-toolchain-flakes.packages.${system};
        sbt = sbt-overlay-flakes.packages.${system}.sbt;
      in
      {
        packages = {
          # 将 riscv-toolchain 和 sbt 组合在一起
          riscv-toolchain = riscv-toolchain;
          sbt = sbt;
        };

        # # 如果需要默认导出某个包
        # defaultPackage = pkgs.buildEnv {
        #   name = "combined-env";
        #   paths = [ riscv-toolchain sbt ];
        # };
      }
    );
}
