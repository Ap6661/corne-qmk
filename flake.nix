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
        ${keymapApp}/bin/keymap draw assets/keymap.yaml > assets/keymap.svg
        echo Images Updated!
    '';
  };

}



