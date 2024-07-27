package main

import webview "github.com/webview/webview_go"


func main() {
	w := webview.New(false)
	defer w.Destroy()
	w.SetTitle("Bind Example")
	w.SetSize(480, 320, webview.HintNone)
	w.Navigate("https://www.google.de")
	w.Run()
}
