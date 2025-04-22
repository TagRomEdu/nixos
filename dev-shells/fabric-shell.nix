{ pkgs, python3, ... }:

pkgs.mkShell {
  name = "fabric-shell";
  buildInputs = with pkgs; [
    ruff
    gtk3
    gtk-layer-shell
    cairo
    gobject-introspection
    libdbusmenu-gtk3
    gdk-pixbuf
    gnome-bluetooth
    cinnamon-desktop
    (python3.withPackages (
      ps: with ps; [
        setuptools
        wheel
        build
        click
        pycairo
        pygobject3
        pygobject-stubs
        loguru
        psutil
        python-fabric
      ]
    ))
  ];
};
