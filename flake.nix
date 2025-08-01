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
              geomtextpath
              gganimate
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
              pagedown
              quarto
              remotes
              rgl
              shiny
              styler
              tidyr
              tidyverse
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
