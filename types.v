module main

import malisipi.mui
import malisipi.mui.webview

const (
	open_file_emoji="⤵"
	play_emoji="▶️"
	pause_emoji="⏸️"
	youtube_emoji="📹"
	audio_ext = ["mp3", "wav", "ogg", "aiff", "m4a", "mp2", "flac"]
	video_ext = ["mp4", "mpg", "mkv", "webm", "m4v", "m2v", "flv", "avi", "3gp"]
	playback_rates = ["0.25","0.5","1","1.5","2"]
	playback_rates_map = {
		"0.25": 0
		"0.5" : 1
		"1"   : 2
		"1.5" : 3
		"2"   : 4
	}
)

struct AppData{
mut:
	app		&mui.Window		= voidptr(0)
	web		webview.Webview_t
	web_hwnd	voidptr
	file		string
	plays		bool
}

fn map_play_time(time int) string {
	return (time/60).str()+":"+(time%60).str()
}
