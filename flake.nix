{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.05";

    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      #packageOverrides = pkgs.callPackage ./python-packages.nix {};
      #python3 = pkgs.python3.override { inherit packageOverrides; };
    in {
      devShell = pkgs.mkShell {
        name = "python-venv";
        venvDir = "./.venv";
        buildInputs = with pkgs; [
            R
            chromium
            pandoc
            texlive.combined.scheme-full
            rstudio
            quarto
            (with rPackages; [
              concaveman
              corrplot
              gcookbook
              geomtextpath
              ggblend
              ggcorrplot
              ggdensity
              ggdist
              ggforce
              ggpointdensity
              ggrepel
              ggtext
              ggiraph
              ggridges
              gt
              hexbin
              igraph
              mapproj
              maps
              MASS
              pagedown
              palmerpenguins
              patchwork
              quarto
              remotes
              rgl
              sf
              tidyr
              tidyverse
              vcd
              webshot2
            ])
         ];

        shellHook = ''
            export BROWSER=zen
            #jupyter lab
        '';

      };
    }
  );
}
