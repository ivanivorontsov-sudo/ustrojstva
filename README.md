# Устройства

## vpngate — клиент VPN Gate для Linux (SoftEther / L2TP / OpenVPN)

Готовый файл: релиз `vpn` → `VPNGate-x86_64.AppImage`.

    chmod +x VPNGate-x86_64.AppImage
    ./VPNGate-x86_64.AppImage            # запуск (при первом запуске спросит пароль и поставит SoftEther в /opt/vpngate-se)
    ./VPNGate-x86_64.AppImage --install  # добавить в меню

Нужно: python3 (есть в Debian). Для L2TP: `sudo apt install strongswan-starter libcharon-extra-plugins xl2tpd ppp`, для OpenVPN: `sudo apt install openvpn`.
Сборка: `vpngate/build-appimage.sh`.
