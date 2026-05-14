{
  description = "annot dev shell — Tauri v2 + SvelteKit on Linux";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            pkg-config
            cargo
            rustc
            rustfmt
            clippy
            nodejs_22
            pnpm
          ];

          buildInputs = with pkgs; [
            # Tauri v2 requires WebKit2GTK 4.1 (not 4.0)
            webkitgtk_4_1
            gtk3
            glib
            glib-networking   # TLS support for WebKit
            libsoup_3
            openssl
            cairo
            pango
            gdk-pixbuf
            librsvg
            at-spi2-atk
            at-spi2-core

            # arboard (clipboard) — X11 backend
            libxcb
            xclip

            # tauri-plugin-opener uses xdg-open on Linux
            xdg-utils
          ];

          # PKG_CONFIG_PATH is usually set automatically by mkShell for buildInputs,
          # but openssl sometimes needs a nudge.
          shellHook = ''
            export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig:${pkgs.webkitgtk_4_1.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"

            # Workaround for WebKit rendering issues with some GPU drivers on NixOS
            export WEBKIT_DISABLE_COMPOSITING_MODE=1

            # GIO modules path so glib-networking (TLS) is found by WebKit at runtime
            export GIO_MODULE_DIR="${pkgs.glib-networking}/lib/gio/modules"

            # pnpm@8.10.2 is pinned in package.json via corepack.
            # nixpkgs ships a different pnpm version — disable strict corepack enforcement.
            export COREPACK_ENABLE_STRICT=0

            echo "annot dev shell ready"
            echo "  pnpm install     — install JS deps"
            echo "  pnpm tauri dev   — start dev server + Tauri window"
            echo "  pnpm tauri build — production build"
          '';
        };
      }
    );
}
