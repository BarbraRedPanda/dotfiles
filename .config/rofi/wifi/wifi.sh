dir="$HOME/dotfiles/.config/rofi"

bssid=$(nmcli -f SSID,BARS device wifi list | sed -n '1!P' | rofi -theme $HOME/.config/rofi/themes/wifi.rasi -dmenu -p " " -lines 10 | awk '{print $1}')
[ -z "$bssid" ] && exit 1
pass=$(echo "" | rofi -theme $HOME/.config/rofi/themes/wifi.rasi -dmenu -theme-str 'textbox-prompt-colon {str: "";}' -p "Enter password")
[ -z "$pass" ] && notify-send "🔑 Password not entered" && exit 1
nmcli device wifi connect $bssid password $pass
notify-send "📶 New WiFi Connected"
