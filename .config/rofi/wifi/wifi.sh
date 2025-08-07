dir="$HOME/.config/rofi"

# Get BSSID of selected network with rofi
bssid=$(nmcli -f SSID,BARS,BSSID device wifi list | sed '1d' | awk 'NR==1 {print; next} {if ($1 == "--") $1="Hidden Network"; print}' | rofi -theme $HOME/.config/rofi/themes/wifi.rasi -dmenu -p " " -lines 10 | awk '{print $NF}')

# Exit if no selection
[ -z "$bssid" ] && exit 1

# Save security of given WiFi
security=$(nmcli device wifi list | grep "$bssid" | awk '{print $1}')

# Prompt for pass if required
if [ "$security" != "--" ]; then
  pass=$(echo "" | rofi -theme $HOME/.config/rofi/themes/password.rasi -dmenu -theme-str 'textbox-prompt-colon {str: "";}' -p "Enter password")
  [ -z "$pass" ] && notify-send "🔑 Password not entered" && exit 1
  nmcli device wifi connect "$bssid" password "$pass"
else
  nmcli device wifi connect "$bssid"
fi

notify-send " New WiFi Connected"
