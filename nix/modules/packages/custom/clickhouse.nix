{ pkgs, ... }:

let
  clickhouse-client = pkgs.stdenv.mkDerivation rec {
    pname = "clickhouse-client";
    version = "25.6.3.116";

    src = pkgs.fetchurl {
        url = "https://github.com/ClickHouse/ClickHouse/releases/download/v${version}-stable/clickhouse-macos-aarch64";
        sha256 = "31a48beac1c192e65024487d5626fddedd0f24b93cebb13725ad5a8a5749307d";
    };

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/bin
      install -m755 $src $out/bin/clickhouse
    '';
  };
in
{
  home.packages = [
    clickhouse-client
  ];
}
