#!/bin/bash
# Сборка VPNGate-x86_64.AppImage (Debian 13 / python3 + PyQt6 из pip)
set -e; cd "$(dirname "$0")"; ROOT="$PWD"; B="$ROOT/build"; rm -rf $B/AppDir; mkdir -p $B/AppDir/usr/{lib/py,bin,share/vpngate-se}
pip download PyQt6 --only-binary :all: -d $B/wheels -q
pip install --no-deps --target $B/AppDir/usr/lib/py $B/wheels/*.whl -q
cd $B/AppDir/usr/lib/py/PyQt6/Qt6/lib; for f in *; do case "$f" in libQt6Core*|libQt6Gui*|libQt6Widgets*|libQt6DBus*|libQt6XcbQpa*|libQt6WaylandClient*|libQt6WlShellIntegration*|libQt6OpenGL.*|libQt6EglFSDeviceIntegration*|libicu*|libQt6Svg.*) ;; *) rm -rf "$f";; esac; done
cd ../plugins; for d in *; do case $d in platforms|platformthemes|platforminputcontexts|imageformats|iconengines|xcbglintegrations|wayland-*|egldeviceintegrations) ;; *) rm -rf $d;; esac; done
cd ../..; rm -rf Qt6/qml Qt6/translations bindings lupdate uic; for f in *.so; do case $f in QtCore*|QtGui*|QtWidgets*|QtDBus*|sip*) ;; *) rm -f $f;; esac; done
cd "$ROOT"
cp vpnclient vpncmd hamcore.se2 busybox dh.sh $B/AppDir/usr/share/vpngate-se/; cp vpngate $B/AppDir/usr/bin/
cp appimage/AppRun appimage/vpngate.desktop appimage/vpngate.png $B/AppDir/; ln -sf vpngate.png $B/AppDir/.DirIcon
[ -x $B/appimagetool ] || { curl -sL -o $B/appimagetool https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage; chmod +x $B/appimagetool; }
ARCH=x86_64 $B/appimagetool --appimage-extract-and-run $B/AppDir VPNGate-x86_64.AppImage
