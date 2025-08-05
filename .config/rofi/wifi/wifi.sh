dir="$HOME/.config/rofi"

# Get BSSID of selected network with rofi
bssid=$(nmcli -f SSID,BARS,BSSID device wifi list | awk 'NR==1 {print; next} {if ($1 == "--") $1="Hidden Network"; print}' | sed '1d' | rofi -theme $HOME/.config/rofi/themes/wifi.rasi -dmenu -p " " -lines 10 | awk '{print $NF}')

# Exit if no selection
[ -z "$bssid" ] && exit 1

# Save security of given WiFi
security=$(nmcli -f SECURITY,BSSID device wifi list | grep "$bssid" | awk '{print $1}')

# Prompt for pass if required
if [ "$security" != '--'] && [ -n "$security" ]
  pass=$(echo "" | rofi -theme $HOME/.config/rofi/themes/wifi.rasi -dmenu -theme-str 'textbox-prompt-colon {str: "";}' -p "Enter password")
  [ -z "$pass" ] && notify-send "🔑 Password not entered" && exit 1
  nmcli device wifi connect $bssid password $pass
else
  nmcli device wifi connect $bssid

notify-send " New WiFi Connected"
