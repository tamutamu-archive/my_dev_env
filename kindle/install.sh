#!/bin/bash -eu


### Launch lxd container.
lxc launch ubuntu:16.04 kindle
sleep 10


### Base container.
lxc exec kindle systemctl stop open-iscsi iscsid
lxc exec kindle systemctl mask open-iscsi iscsid
lxc exec kindle apt update
lxc exec kindle -- apt full-upgrade -y
lxc exec kindle -- apt install -y language-pack-ja fonts-takao avahi-daemon
lxc exec kindle update-locale LANG=ja_JP.UTF-8
lxc exec kindle timedatectl set-timezone Asia/Tokyo
lxc exec kindle timedatectl status
lxc file push ~/.ssh/id_rsa.pub kindle/home/ubuntu/.ssh/authorized_keys
lxc exec kindle -- chown ubuntu:ubuntu /home/ubuntu/.ssh/authorized_keys


### Wine and Firefox install.
lxc exec kindle -- dpkg --add-architecture i386
lxc exec kindle -- add-apt-repository -y ppa:wine/wine-builds
lxc exec kindle apt update
lxc exec kindle -- apt install -y winehq-devel firefox


### Init config Wine.
ssh -o 'StrictHostKeyChecking no' -X ubuntu@kindle.local wineboot
sleep 15

echo "Takao.."

lxc exec kindle -- /bin/bash -lc  \
        ' cat << EOT >> /home/ubuntu/.wine/user.reg

[Software\\\\Wine\\\\Fonts\\\\Replacements]
"MS Gothic"="Takaoゴシック"
"MS Mincho"="Takao明朝"
"MS PGothic"="Takao Pゴシック"
"MS PMincho"="Takao P明朝"
"MS UI Gothic"="TakaoExゴシック"
"ＭＳ ゴシック"="Takaoゴシック"
"ＭＳ 明朝"="Takao明朝"
"ＭＳ Ｐゴシック"="Takao Pゴシック"
"ＭＳ Ｐ明朝"="Takao P明朝"
EOT'

echo "Fin.."

lxc file push ./kindle-for-pc-1-17-44183.exe kindle/home/ubuntu/
lxc exec kindle -- chown ubuntu:ubuntu /home/ubuntu/kindle-for-pc-1-17-44183.exe

ssh -o 'StrictHostKeyChecking no' -X ubuntu@kindle.local wine kindle-for-pc-1-17-44183.exe


lxc file pull "kindle/home/ubuntu/.local/share/icons/hicolor/256x256/apps/0914_Kindle.0.png" \
      kindle_256.png
xdg-icon-resource install --novendor --size 256 kindle_256.png kindle

cat > kindle.desktop <<EOF
[Desktop Entry]
Name=Kindle
GenericName=Kindle for PC
Comment=Ebook reader
Exec=ssh -X ubuntu@kindle.local QT_IM_MODULE=fcitx XMODIFIERS=@im=fcitx wine ".wine/drive_c/Program\ Files\ \(x86\)/Amazon/Kindle/Kindle.exe"
Terminal=false
Type=Application
Icon=kindle
Categories=Office;Viewer;
EOF

desktop-file-validate kindle.desktop
desktop-file-install --dir=$HOME/.local/share/applications/ kindle.desktop
