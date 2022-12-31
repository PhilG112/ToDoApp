{ mkDerivation, base, lib }:
mkDerivation {
  pname = "ToDoApp-Api";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base ];
  executableHaskellDepends = [ base ];
  license = "unknown";
  mainProgram = "ToDoApp-Api";
}
