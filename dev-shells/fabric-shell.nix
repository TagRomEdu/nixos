{ pkgs, fabric }:

pkgs.mkShell {
  name = "fabric-dev-shell";
  buildInputs = [
    pkgs.python3
    fabric.packages.${pkgs.system}.run-widget
    
    # Additional development dependencies
    pkgs.ruff  # Python linter
    pkgs.black  # Python formatter
    pkgs.gtk3  # For GTK development
    pkgs.gobject-introspection  # For GI typelibs
  ];

  # Environment variables if needed
  GI_TYPELIB_PATH = "${pkgs.gtk3}/lib/girepository-1.0";
  GDK_PIXBUF_MODULE_FILE = "${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";

  shellHook = ''
    echo "Entering Fabric development environment"
    echo "Available commands:"
    echo "  run-widget - Run the Fabric widget"
  '';
}