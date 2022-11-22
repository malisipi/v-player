module main

import malisipi.mui
import malisipi.mui.window

fn main(){
	window.hide_console()
	
	mut app_data:=AppData{}

	go init_webview(mut &app_data)

	app_data.app=mui.create(title:"V-Player", height: 144, width:640, app_data:&app_data, file_handler:load_file_handler)

	app_data.app.label(id:"now_playing" x: 10, y:10, width: "100%x -20", height:"100%y -55", text:"No Media Playing")
	app_data.app.selectbox(id:"playback_rate", x:"# 10", y:10, width: "75", height: "20" , list:playback_rates, text:"1", onchange:change_playback_rate)
	app_data.app.button(id:"load_button", x: 10, y:"# 10", width:"25", height:"25" text:open_file_emoji, onclick:load_file_button, icon:true)
	app_data.app.button(id:"youtube_button", x: 40, y:"# 10", width:"25", height:"25" text:youtube_emoji, onclick:load_youtube_button, icon:true)
	app_data.app.button(id:"play_button", x: 70, y:"# 10", width:"25", height:"25" text:play_emoji, onclick:toggle_music, icon:true)
	app_data.app.slider(id:"play_slider", x: 100, y:"# 10", width:"100%x -250", height:25, value_max:1, onunclick:seek_to_time, value_map:map_play_time)
	app_data.app.slider(id:"volume_slider", x: "# 40", y:"# 10", width:"60", height:25, value:100, value_max:100, step:1, onunclick:change_volume)

	app_data.app.run()
	app_data.web.destroy()
	exit(0)
}
