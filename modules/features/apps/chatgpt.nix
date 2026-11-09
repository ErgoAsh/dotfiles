{ inputs, ... }:
let
  package =
    { pkgs }:

    with pkgs;
    stdenv.mkDerivation rec {
      pname = "chatgpt";
      version = "26.1103.60933";

      src = fetchurl {
        url = "https://persistent.oaistatic.com/codex-app-prod/linux/deb/pool/main/c/chatgpt/chatgpt_${version}_amd64.deb";
        hash = "sha256-B0bpuldRgvXb4yYXuCpkXrk61XyliOWpNYaVprZa7nE=";
      };

      nativeBuildInputs = [
        autoPatchelfHook
        dpkg
        makeWrapper
        python3
        wrapGAppsHook3
      ];

      buildInputs = [
        alsa-lib
        at-spi2-atk
        cairo
        cups
        dbus
        expat
        gdk-pixbuf
        glib
        gtk3
        libglvnd
        libnotify
        libusb1
        libxcb
        libxkbcommon
        libx11
        libxcomposite
        libxdamage
        libxext
        libxfixes
        libxrandr
        (lib.getLib libsForQt5.qt5.qtbase)
        mesa
        nspr
        nss
        pango
        (lib.getLib qt6.qtbase)
        stdenv.cc.cc.lib
        systemd
        vulkan-loader
      ];

      autoPatchelfIgnoreMissingDeps = [ "libc.musl-x86_64.so.1" ];
      dontWrapQtApps = true;

      unpackPhase = ''
        runHook preUnpack
        dpkg-deb -x "$src" .
        runHook postUnpack
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p "$out/bin"
        cp -r usr/lib usr/share "$out/"

        # @parcel/watcher aborts Electron with SIGILL on NixOS. Keep the ASAR
        # offsets unchanged and use the app's built-in file watcher instead.
        python3 - "$out/lib/chatgpt/resources/app.asar" <<'PY'
        from pathlib import Path
        import sys

        path = Path(sys.argv[1])
        data = path.read_bytes()
        replacements = [
            (
                b'"linux"===process.platform&&!1!==r.recursive?CA(r,{ignoredPaths:[]}):t.startFileWatch(r)',
                b'"win32"===process.platform&&!1!==r.recursive?CA(r,{ignoredPaths:[]}):t.startFileWatch(r)',
            ),
            (
                b'if("linux"===process.platform)return CA(r,{ignoredPaths:[cz().join(r.path,".git"),...n]});',
                b'if("win32"===process.platform)return CA(r,{ignoredPaths:[cz().join(r.path,".git"),...n]});',
            ),
            (
                b'"linux"===process.platform?async function(e,t){return new Kx(await Promise.resolve().then(r.t.bind(r,16242,23)),e,t).start()}(t,{ignoredPaths:lM.map(e=>ee().join(i,e))}):new ed._2M().startFileWatch(t)',
                b'"win32"===process.platform?async function(e,t){return new Kx(await Promise.resolve().then(r.t.bind(r,16242,23)),e,t).start()}(t,{ignoredPaths:lM.map(e=>ee().join(i,e))}):new ed._2M().startFileWatch(t)',
            ),
        ]

        for old, new in replacements:
            if len(old) != len(new) or data.count(old) != 1:
                raise RuntimeError("unexpected ChatGPT app.asar layout")
            data = data.replace(old, new)

        path.write_bytes(data)
        PY

        makeWrapper "${lib.getExe' util-linux "setpriv"}" "$out/bin/chatgpt" \
          --add-flags "--inh-caps=-all --ambient-caps=-all -- $out/lib/chatgpt/codex-launcher" \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libglvnd ]}:/run/opengl-driver/lib" \
          --prefix PATH : "${lib.makeBinPath [ xdg-utils ]}"

        runHook postInstall
      '';

      meta = {
        description = "Official ChatGPT desktop application";
        homepage = "https://chatgpt.com/";
        license = lib.licenses.unfree;
        platforms = [ "x86_64-linux" ];
        sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
        mainProgram = "chatgpt";
      };
    };
in
{
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      packages.chatgpt = pkgs.callPackage package { };
    };
  flake.modules.homeManager.chatgpt = { pkgs, ... }: {
    home.packages = [ (pkgs.callPackage package { }) ];
  };
}
