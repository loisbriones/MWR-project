{
  description = "Entorno de la demo MWR: Ghidra + toolchain C";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          ghidra
          jdk21
          gcc
          gnumake
          gdb
          binutils
          python3
          file
        ];

        JAVA_HOME = "${pkgs.jdk21}";

        shellHook = ''
          echo "MWR demo shell"
          echo "  ghidra   -> abrir Ghidra"
          echo "  make/gcc -> compilar demo/vuln"
          echo "  gdb      -> depurar el crash"
        '';
      };
    };
}
