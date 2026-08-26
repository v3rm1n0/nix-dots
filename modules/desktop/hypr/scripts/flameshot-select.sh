# flameshot's Wayland picker opens as a small floating window, then resizes
# itself in place to exactly its monitor's resolution once you pick a
# screen. Hyprland's floating-window auto-centering re-centers that resize
# within the monitor's *working area* (excluding the noctalia bar's
# exclusive zone), pushing the window a few pixels below the monitor's true
# origin and clipping the bottom of the selectable area. windowrule
# move/size are one-shot (they only apply to the window's very first open,
# as the small picker), so a windowrule can't catch this later
# self-triggered resize — watch for it and correct it once it happens
# instead.

flameshot gui -c -p "$HOME/Pictures" &

for _ in $(seq 1 300); do
  sleep 0.05

  win=$(hyprctl clients -j | jq -c '
    [.[] | select(.title == "flameshot" and .floating == true)] | .[0] // empty
  ')
  if [ -z "$win" ]; then
    continue
  fi

  mon_id=$(jq -r '.monitor' <<< "$win")
  win_w=$(jq -r '.size[0]' <<< "$win")
  win_h=$(jq -r '.size[1]' <<< "$win")
  win_x=$(jq -r '.at[0]' <<< "$win")
  win_y=$(jq -r '.at[1]' <<< "$win")
  addr=$(jq -r '.address' <<< "$win")

  read -r mon_x mon_y mon_w mon_h < <(
    hyprctl monitors -j | jq -r --argjson id "$mon_id" \
      '.[] | select(.id == $id) | "\(.x) \(.y) \(.width) \(.height)"'
  )

  if [ "$win_w" = "$mon_w" ] && [ "$win_h" = "$mon_h" ] \
    && { [ "$win_x" != "$mon_x" ] || [ "$win_y" != "$mon_y" ]; }; then
    hyprctl dispatch movewindowpixel "exact $mon_x $mon_y,address:$addr"
    exit 0
  fi
done
