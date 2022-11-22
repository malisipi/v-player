module main

import malisipi.mui
import malisipi.mui.webview
import malisipi.mui.window
import json

fn media_info_handler (seq &char, req &char, mut app_data &AppData) {
	unsafe {
		args:=json.decode([]string,req.vstring())or{return}
		app_data.app.get_object_by_id("play_slider")[0]["val"].num=args[0].int()
		app_data.app.get_object_by_id("play_slider")[0]["vlMax"].num=args[1].int()
		app_data.app.get_object_by_id("playback_rate")[0]["s"].num=playback_rates_map[args[2]]
		app_data.app.get_object_by_id("playback_rate")[0]["text"].str=args[2]
		if app_data.plays != ( args[3] == "true" ) {
			app_data.plays = !app_data.plays
			set_play_button_state(mut app_data.app, app_data.plays)
		}
	}
}

fn webview_loaded (seq &char, req &char, mut app_data &AppData) {
	set_webview_visibility(mut app_data, false)
}

fn init_webview (mut app_data &AppData){
	app_data.web=webview.create(0)
	app_data.web.set_html("<video></video><style>body{background:black !important; cursor:default !important;}</style><script>webview_loaded();</script>")
	app_data.web.set_title("V-Player | Video")
	app_data.web.set_size(640, 480)
	app_data.web.bind("return_media_info", media_info_handler, mut &app_data)
	app_data.web.bind("webview_loaded", webview_loaded, mut &app_data)
	app_data.web.init("window.addEventListener('DOMContentLoaded', ()=>{window[\"the_video\"]=document.querySelector(\"video\");\
		if(!the_video){document.write(\"<center><b>Unable to Load Media<br>(Please Try Again Later)</b></center>\");};\
		the_video.controls=false;\
		the_video.volume=1;\
		the_video.playbackRate=1;\
		document.body.insertAdjacentHTML(\"beforeend\",\"<style>body{background:black !important} *{-webkit-user-select: none !important; user-select: none !important; color:white !important; cursor:default !important;} video {width:-webkit-fill-available !important; width:fill-available !important; pointer-events:none !important;}</style>\");\
		document.addEventListener('contextmenu', event => event.preventDefault());\
		if (\"mediaSession\" in navigator) {\
			navigator.mediaSession.metadata = new MediaMetadata({\
				title: \"V-Player\",\
				artist: \"malisipi\"\
			});\
		}\
		setInterval(()=>{\
			return_media_info(String(the_video.currentTime), String(the_video.duration), String(the_video.playbackRate), String(!the_video.paused))\
		},500)});")
	app_data.web_hwnd=app_data.web.get_window()
	app_data.web.run()
	exit(0)
}

fn set_webview_visibility(mut app_data &AppData, visible bool){
	if visible {
		window.show(app_data.web_hwnd)
	} else {
		window.hide(app_data.web_hwnd)
	}
}

fn change_playback_rate(event_details mui.EventDetails, mut app &mui.Window, mut app_data &AppData){
	app_data.web.eval("the_video.playbackRate="+event_details.value+";")
}

fn toggle_music(event_details mui.EventDetails, mut app &mui.Window, mut app_data &AppData){
	if !app_data.plays {
		app_data.plays=true
		app_data.web.eval("the_video.play();")
		set_play_button_state(mut app, app_data.plays)
	} else {
		app_data.plays=false
		app_data.web.eval("the_video.pause();")
		set_play_button_state(mut app, app_data.plays)
	}
}

fn set_play_button_state (mut app &mui.Window, state bool){
	unsafe {
		if state {
			app.get_object_by_id("play_button")[0]["text"].str=pause_emoji
		} else {
			app.get_object_by_id("play_button")[0]["text"].str=play_emoji
		}
	}
}

fn change_volume (event_details mui.EventDetails, mut app &mui.Window, mut app_data &AppData) {
	app_data.web.eval("the_video.volume="+(event_details.value.f32()/100).str()+";")
}

fn seek_to_time (event_details mui.EventDetails, mut app &mui.Window, mut app_data &AppData) {
	app_data.web.eval("the_video.currentTime="+event_details.value+";")
}
