{pkgs, ...}: {
  home.packages = with pkgs; [
    jetbrains-toolbox
    zed-editor
    cmake
    libtool
    gnumake
    direnv
    ccls
    sbcl
    godot_4
    scons
    marksman
    texlive.combined.scheme-full
    # python311Packages.pygments
    discord
    vscode
    jdk
    synology-drive-client
    dotnet-sdk_8
    php
    hugo
    slack
  ];
}
