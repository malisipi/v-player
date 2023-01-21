module main

import malisipi.mui
import os

fn load_music(mut app &mui.Window, mut app_data &AppData, url string, title string, is_video bool){
	app_data.web.navigate(url)
	app_data.plays=true
	set_play_button_state(mut app, true)
	set_webview_visibility(mut app_data, is_video)
	app.set_title(title + " | V-Player")
	unsafe {
		app_data.app.get_object_by_id("volume_slider")[0]["val"].num=100
		app.get_object_by_id("now_playing")[0]["text"].str=title.clone()
	}
}

fn load_file(mut app &mui.Window, mut app_data &AppData, file_path string){
	if file_path!="" {
		file_ext:=file_path.split(".")#[-1..][0]
		mut is_video := false
		if file_ext in audio_ext {
			is_video = false
		} else if file_ext in video_ext {
			is_video = true
		} else {
			mui.messagebox("V-Player", file_ext+" is not supported", "ok", "warning")
			return
		}
		load_music(mut app, mut app_data,"file://"+file_path,file_path.split("\\")#[-1..][0].split("/")#[-1..][0], is_video)
	}
}

fn load_file_button(event_details mui.EventDetails, mut app &mui.Window, mut app_data &AppData){
	file_path:=mui.openfiledialog("V-Player")
	load_file(mut app, mut app_data, file_path)
}

fn load_file_handler(event_details mui.EventDetails, mut app &mui.Window, mut app_data &AppData){
	file_path:=event_details.value
	load_file(mut app, mut app_data, file_path)
}

fn load_youtube_button(event_details mui.EventDetails, mut app &mui.Window, mut app_data &AppData){
	video_title:=mui.inputbox("V-Player","Youtube Video:","")
	youtube_dl_url:=os.execute("youtube-dl --get-url -f \"[ext=mp4]\" \"ytsearch1:"+video_title.replace(":","").replace("\"","")+"\"").output
	if video_title!="" {
		load_music(mut app, mut app_data, youtube_dl_url, video_title, true)
	}
}
