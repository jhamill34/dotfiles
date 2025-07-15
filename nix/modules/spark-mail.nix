{ pkgs, ... }:

let
  spark-mail-3 = pkgs.stdenv.mkDerivation rec {
    pname = "spark-mail-3";
    version = "3.24.2.111441";

    src = pkgs.fetchzip {
        url = "https://downloads.sparkmailapp.com/Spark3/mac/dist/${version}/Spark.zip";
        sha256 = "sha256-VoZAtjETTUV5Tiuk9230iJ0H9STtZO+2iZ+Dusp6f+I=";
    };

    phases = [ "installPhase" ];

    installPhase = ''
        mkdir -p $out/Applications
        cp -R $src $out/Applications/Spark\ Desktop.app
    '';
  };
in
{
  home.packages = [
    spark-mail-3
  ];
}
