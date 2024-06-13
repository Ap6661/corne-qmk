{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      keymapApp = (pkgs.callPackage ./keymap-drawer.nix {  });
  in
  {
    packages.${system}.default = pkgs.writeShellScriptBin "draw-keymap" ''
        sudo ${pkgs.qmk}/bin/qmk flash;
        sudo ${pkgs.qmk}/bin/qmk flash;
        ${pkgs.qmk}/bin/qmk c2json ./keymap.c |
        ${keymapApp}/bin/keymap parse -q - > assets/keymap.yaml;

        ${pkgs.coreutils}/bin/cat assets/combos.yaml >> assets/keymap.yaml;

        ${pkgs.coreutils}/bin/cat assets/macros |
        ${pkgs.findutils}/bin/xargs -I '{}' ${pkgs.gnused}/bin/sed -i 's/{}/g' assets/keymap.yaml

        ${pkgs.coreutils}/bin/cat assets/README_Template.md > README.md;
        ${pkgs.gawk}/bin/awk -F'/' '{print "| ",  $1, " | ", $2, " |"}' assets/macros >> README.md;

        ${keymapApp}/bin/keymap -c assets/config.yaml draw assets/keymap.yaml > assets/keymap.svg;
        echo Images Updated!
    '';
    devShells.${system}.default = pkgs.mkShellNoCC {
        packages = [
            keymapApp
            pkgs.qmk
        ];
    };
  };

}



