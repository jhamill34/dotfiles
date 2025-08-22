{ pkgs, ... }:

{
    home.packages = [
        pkgs.imagemagick
        pkgs.d2
        pkgs.ffmpeg
    ];
}
