{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "keymap-drawer";
  version = "0.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "caksoylar";
    repo = "keymap-drawer";
    rev = "v${version}";
    hash = "sha256-izqgYr5n28ON/xg0pm9rrnofnoJ48xciEGpGOV53gG4=";
  };

  nativeBuildInputs = [ python3.pkgs.poetry-core ];

  propagatedBuildInputs = with python3.pkgs; [
    pcpp
    platformdirs
    pydantic
    pydantic-settings
    pyparsing
    pyyaml
  ];

  nativeCheckInputs = with python3.pkgs; [ pythonRelaxDepsHook ];

  pythonImportsCheck = [ "keymap_drawer" ];

  pythonRelaxDeps = [ "platformdirs" ];

  meta = with lib; {
    description = "Visualize keymaps that use advanced features like hold-taps and combos, with automatic parsing";
    homepage = "https://github.com/caksoylar/keymap-drawer";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "keymap-drawer";
  };
}
