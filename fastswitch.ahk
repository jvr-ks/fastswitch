/*
 *********************************************************************************
 * 
 * fastswitch.ahk
 * 
 * use UTF-8 BOM codec
 * 
 * Version -> appVersion
 * 
 * Copyright (c) 2020 jvr.de. All rights reserved.
 *
 *
 *********************************************************************************
*/

/*
 *********************************************************************************
 * 
 * MIT License
 * 
 * 
 * Copyright (c) 2020 jvr.de. All rights reserved.
 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sub-license, and/or sell copies 
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:

 * The above copyright notice and this permission notice shall be included in all 
 * copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANT-ABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE 
 * UTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
  *********************************************************************************
*/
; Has no exit, must be killed to stop
#NoEnv
#Warn
#SingleInstance force
#Persistent
#UseHook On

appName := "fastswitch"
appVersion := "0.006"
app := appName . " " . appVersion

SetWorkingDir, %A_ScriptDir%

wrkDir := A_ScriptDir . "\"

FileEncoding, UTF-8-RAW
SetTitleMatchMode, 2
SendMode Input

fastSwitchArr := {}
fastSwitchFile  := wrkDir . "cldfastswitch.txt"

hasParams := A_Args.Length()

if (hasParams == 1){
	if(A_Args[1] = "remove"){
		showHint(app . " stopped and removed from memory!",1000)
		exitApp
	}
}

showHint(app . " started!",1000)
readFastSwitch()
initFastSwitch()

return
;------------------------------ readFastSwitch ------------------------------
readFastSwitch(){
	global fastSwitchArr
	global fastSwitchFile
	
	fastSwitchArr := {}

	Loop, read, %fastSwitchFile%
	{
		LineNumber := A_Index
		fastSwitchHotkey := ""
		fastSwitchTitle := ""
		
		if (A_LoopReadLine != "") {
			Loop, parse, A_LoopReadLine, %A_Tab%`,
			{	
				if(A_Index == 1)
					fastSwitchHotkey := A_LoopField
					
				if(A_Index == 2)
					fastSwitchTitle := A_LoopField
			}
			fastSwitchArr[fastSwitchHotkey] := fastSwitchTitle
		}
	}
	
	return
}
;------------------------------ initFastSwitch ------------------------------
initFastSwitch(){
	global fastSwitchArr
	global fastSwitchFile
	
	for Key, Val in fastSwitchArr
		{
			if (InStr(Key, "off") > 0){
				s := StrReplace(Key, "off" , "")
				Hotkey, %s%, fastSwitchSelect, off
			} else {
				Hotkey, %Key%, fastSwitchSelect
			}
		}
	
	return
}
;----------------------------- fastSwitchSelect -----------------------------
fastSwitchSelect(){
	global fastSwitchArr
	global fastSwitchFile

			title := fastSwitchArr[A_ThisHotkey]
			if WinExist(title){
				winActivate,%title%
			}
			
	return
}
;--------------------------------- showHint ---------------------------------
showHint(s, n){
	Gui, hint:Font, s14, Calibri
	Gui, hint:Add, Text,, %s%
	Gui, hint:-Caption
	Gui, hint:+ToolWindow
	Gui, hint:+AlwaysOnTop
	Gui, hint:Show
	sleep, n
	Gui, hint:Destroy
	return
}







