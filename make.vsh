import net.http

working_dir:=getwd()

if !exists(vmodules_dir()+"/malisipi/mui"){
	system("v install malisipi.mui")
}

if !exists(vmodules_dir()+"/malisipi/mui/webview/webview.o"){
	$if windows {
		if getenv("W10_SDK")=="" {
			setenv("W10_SDK", input("SDK Location:"), true)
		}
		
		chdir("${vmodules_dir()}/malisipi/mui/webview/") or {exit(1)}
		system("build_webview_for_windows.cmd ")
	}
}

chdir(working_dir) or {exit(2)}

if exists_in_system_path("gcc") {
	$if windows {
		system("v -cc gcc -prod -cflags \"-static\" -skip-unused .")
	} $else $if linux {
		system("v -cc gcc -prod -skip-unused .")
	}
	
	mut arch:="undef"
	$if x32 {
		arch="x86"
	} $else $if arm64 {
		arch="arm64"
	} $else $if x64 {
		arch="x64"
	}

	$if windows {
		if arch=="undef" {exit(3)}
		cp("${vmodules_dir()}/malisipi/mui/webview/webview2/runtimes/win-${arch}/native/WebView2Loader.dll", "WebView2Loader.dll") or {exit(4)}	
	}

	$if x64 && windows {
		if input("Do you want to install Youtube-DL? [Y/N]")=="Y"{
			println("This executables provided from third-party.")
			http.download_file("https://github.com/ytdl-org/youtube-dl/releases/download/2021.12.17/youtube-dl.exe","youtube-dl.exe") or {println("Unable to download")}
		}
	} $else {
		println("Automatic Youtube-DL install not supported by your arch or OS")
	}

} else {
	println("Install GCC")
}
