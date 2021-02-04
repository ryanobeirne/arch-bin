#!/usr/bin/env bash

readonly STORAGE="$HOME/.cache/snapcam"
readonly MAIL_RECIPIENT="ryanobeirne@ryanobeirne.com"

capture() {
	local dir mp4
	dir="$1"
	[[ -d "$dir" ]] || mkdir -p "$dir" || return
	mp4="$dir/$(date +%Y%m%d_%H%M%S).mp4" 

	ffmpeg \
		-f video4linux2 \
		-i /dev/v4l/by-id/usb-Sonix_Technology_Co.__Ltd._USB_Live_camera_SN0001-video-index0 \
		-vf "fps=30,scale=1920:-1" \
		-vframes 30 \
		-c:v libx264 \
		"$mp4" &>/dev/null &&
			printf '%s\n' "$mp4"
}

playback() {
	local file="$1"
	[[ -f "$file" ]] || return
	DISPLAY="${DISPLAY:-:0}" ffplay -loop -1 "$file" &>/dev/null & return
}

send_mail() {
	local attachment="$1"
	local user="$2"
	[[ -f "$attachment" ]] || return

	printf '%s: login failed' "$user" | mail \
		--subject "SnapCam Capture" \
		--attach "$attachment" \
		"$MAIL_RECIPIENT"
}

all_the_things() {
	local dir cap user
	user="$1"
	dir="$STORAGE/$(date +%Y%m%d)"
	cap="$(capture "$dir")" || return
	printf '%s\n' "$cap"
	send_mail "$cap" "$user"
	playback "$cap"
}

main() {
	journalctl -qfn0 -t unix_chkpwd |
		sed -Eu 's/^.* password check failed for user \((.*)\)$/\1/' |
		while read -r user; do
			printf '%s: login failed\n' "$user"
			all_the_things "$user"
		done
}

main
