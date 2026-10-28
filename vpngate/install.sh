#!/bin/bash
set -e
[ "$(id -u)" = 0 ] || exec sudo bash "$0" "$@"
D="$(cd "$(dirname "$0")" && pwd)"
/opt/vpngate-se/vpnclient stop >/dev/null 2>&1 || true
mkdir -p /opt/vpngate-se
export DEBIAN_FRONTEND=noninteractive
apt-get install -y strongswan-starter strongswan-charon libcharon-extra-plugins xl2tpd ppp python3-pyqt6 || { apt-get update && apt-get install -y strongswan-starter strongswan-charon libcharon-extra-plugins xl2tpd ppp python3-pyqt6; } || echo "ВНИМАНИЕ: пакеты для L2TP не установились, будет работать только SoftEther"
systemctl disable --now strongswan-starter xl2tpd >/dev/null 2>&1 || true
printf "l2tp_ppp\nppp_generic\n" > /etc/modules-load.d/l2tp.conf
modprobe l2tp_ppp 2>/dev/null || true
for f in vpnclient vpncmd hamcore.se2 busybox dh.sh;do install -m 755 "$D/$f" /opt/vpngate-se/$f;done
modprobe tun 2>/dev/null || true
echo tun > /etc/modules-load.d/tun.conf
[ -e /dev/net/tun ] || { mkdir -p /dev/net; mknod /dev/net/tun c 10 200; chmod 666 /dev/net/tun; }
[ -e /dev/net/tun ] && echo "tun: OK" || echo "ВНИМАНИЕ: нет /dev/net/tun"
install -m 755 "$D/vpngate" /usr/local/bin/vpngate
cat > /usr/share/applications/vpngate.desktop <<X
[Desktop Entry]
Type=Application
Name=VPN Gate
Exec=/usr/local/bin/vpngate
Icon=network-vpn
Categories=Network;
X
/opt/vpngate-se/vpncmd /TOOLS /CMD check >/dev/null 2>&1 && echo "SoftEther: проверка пройдена" || echo "SoftEther: проверка не пройдена"
echo ГОТОВО
