{ pkgs, lib, ... }:

let
  # The directory containing the modules you want to import.
  # This path is relative to the current file.
  modulesDir = ./packages;

  # Get a list of all files in the directory that end with .nix
  moduleFiles = builtins.filter
    (file: lib.strings.hasSuffix ".nix" file)
    (builtins.attrNames (builtins.readDir modulesDir));

  # Import each file and create a list of module attributes.
  # The map function applies a function to each item in a list.
  importedModules = builtins.map
    (file: import (modulesDir + "/${file}") { inherit pkgs lib; })
    moduleFiles;

in
{
  imports = importedModules;
}
