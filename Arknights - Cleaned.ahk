#Requires AutoHotkey v2.0
; =========================================================================
; Akrnight MuMu Macro to AutoHotkey v2 Conversion
; AutoHotkey v2.0+
;
; This is the converted script for AutoHotkey v2. It performs the same
; actions as the original, but with updated syntax. You will still need to
; adjust the coordinates to match your screen.
;
; Hotkey to get coordinates: F3
; Hotkey to run the script: F1
; Hotkey to suspend the script: F2
; =========================================================================

; --- F3 Hotkey to get current mouse coordinates ---
; This hotkey is used for finding the exact X and Y coordinates of the mouse cursor on the screen.
F3:: {
    ; Set the coordinate mode for the mouse to be relative to the entire screen.
    CoordMode("Mouse", "Screen")
    ; Get the current X and Y coordinates of the mouse cursor. The "&" symbol means the variables are passed by reference.
    MouseGetPos(&x, &y)
    ; Display a message box with the current mouse coordinates.
    MsgBox("Current mouse position is:`n`nX: " x "`nY: " y)
}

; --- F2 Hotkey to suspend/resume the script ---
; This hotkey toggles the suspension of all other hotkeys and hotstrings.
; It will not affect the F2 hotkey itself.

F2::Suspend
; --- F1 Hotkey to reload script ---
; This hotkey reloads the script, applying any changes made to the file.
F1::Reload()

; =========================================================================
; --- Converted Macros ---
; All coordinates are estimated based on a 1920x1080 resolution.
; Adjust them using the F3 hotkey.
; =========================================================================


; Use this directive to make all following hotkeys active only when a
; specific window is active.
IsBluestacksFullScreen() {
    ; Check if the "BlueStacks App Player" window is currently active.
    if !WinActive("BlueStacks App Player")
        return false
    ; Get the position and size of the active window.
    WinGetPos(&x, &y, &w, &h, "A")
    ; Return true if the window is positioned at (0,0) and has the same width and height as the screen.
    return (x=0 && y=0 && w=A_ScreenWidth && h=A_ScreenHeight)
}

; This directive makes all hotkeys below it active only when the IsBluestacksFullScreen() function returns true.
#HotIf IsBluestacksFullScreen()

; This custom function performs a mouse click. It can accept either absolute pixel coordinates or relative coordinates (as a decimal between 0 and 1).
ClickRel(x, y) {
    ; Determine if the X coordinate is a relative value (less than or equal to 1). If so, calculate the absolute screen coordinate. Otherwise, use the provided X value.
    cx := (x <= 1) ? A_ScreenWidth * x : x
    ; Determine if the Y coordinate is a relative value (less than or equal to 1). If so, calculate the absolute screen coordinate. Otherwise, use the provided Y value.
    cy := (y <= 1) ? A_ScreenHeight * y : y

    ; Save the current mouse position so it can be restored later.
    MouseGetPos(&mx, &my)

    ; Perform a left mouse click at the calculated absolute coordinates.
    Click(cx, cy)

    ; Move the mouse back to its original position at the fastest possible speed (speed 0).
    MouseMove(mx, my, 0)
}
; This will set mouse click speed to 0
SetDefaultMouseSpeed 0

;---

; Click at absolute screen coordinates without moving the visible mouse
NoMoveMouse(x, y) {
    ; Save the original mouse position
    MouseGetPos &origX, &origY

    ; Set cursor to target position temporarily
    DllCall("SetCursorPos", "int", x, "int", y)

    ; Simulate left mouse button down
    DllCall("mouse_event"
        , "UInt", 0x0002   ; MOUSEEVENTF_LEFTDOWN
        , "UInt", 0        ; dx (ignored in absolute mode)
        , "UInt", 0        ; dy
        , "UInt", 0        ; dwData
        , "UInt", 0        ; dwExtraInfo
    )

    ; Simulate left mouse button up
    DllCall("mouse_event"
        , "UInt", 0x0004   ; MOUSEEVENTF_LEFTUP
        , "UInt", 0
        , "UInt", 0
        , "UInt", 0
        , "UInt", 0
    )

    ; Restore the original cursor position
    MouseMove origX, origY, 0
}

ClickNoMove(x, y, windowTitle := "") {
    local hwnd, cx, cy, wx, wy, ww, wh, relX, relY
    hwnd := windowTitle ? WinExist(windowTitle) : WinExist("BlueStacks App Player")
    if !hwnd
        return

    cx := (x <= 1) ? Round(A_ScreenWidth * x) : Round(x)
    cy := (y <= 1) ? Round(A_ScreenHeight * y) : Round(y)

    WinGetPos &wx, &wy, &ww, &wh, "ahk_id " hwnd
    relX := cx - wx
    relY := cy - wy

    ControlClick(
        "", "ahk_id " hwnd, "Left", 1, "NA", relX, relY
    )
}

ClickLeft()
{
    ; Get the current mouse position.
    MouseGetPos(&x_curr, &y_curr)
    ; Click at the current mouse position.
    NoMoveMouse(x_curr, y_curr)
}

NoMoveMouseDown() {
    ; Save the original mouse position
    MouseGetPos &X, &Y

    ; Move cursor temporarily to target position
    DllCall("SetCursorPos", "int", X, "int", Y)

    ; Simulate left mouse button down (hold)
    DllCall("mouse_event"
        , "UInt", 0x0002   ; MOUSEEVENTF_LEFTDOWN
        , "UInt", 0
        , "UInt", 0
        , "UInt", 0
        , "UInt", 0
    )

    ; Return the mouse to its original position
    DllCall("SetCursorPos", "int", X, "int", Y)
}

NoMoveMouseUp() {
    ; Simulate left mouse button up (release)
    DllCall("mouse_event"
        , "UInt", 0x0004   ; MOUSEEVENTF_LEFTUP
        , "UInt", 0
        , "UInt", 0
        , "UInt", 0
        , "UInt", 0
    )
}

MouseMoveF()
{
global X,Y
MouseGetPos(&x_curr, &y_curr)
DllCall("SetCursorPos", "int", X := x_curr + 3, "int", Y := y_curr - 6)
}

MouseMoveF_2()
{
DllCall("SetCursorPos", "int", X - 3, "int", Y + 6)
}


;---


; "2" Key Macro
; This hotkey performs a mouse click and then simulates pressing the Escape key.
2:: {
    ; Save the original mouse coordinates before the action starts.
    MouseGetPos(&x_orig, &y_orig)
    ; Perform a click at the fixed coordinates 1700, 384.
    Click(1700, 384)
    ; Return the mouse to its original position.
    MouseMove(x_orig, y_orig, 0)
    ; Pause the script for 50 milliseconds.
    Sleep(50)
    ; Simulate pressing the Escape key.
    Send("{Esc}")
}

; "right_mouse" Macro
; This hotkey performs a series of clicks and pauses.
RButton:: {
	NoMoveMouse(1801, 84)
    
    ; Get the current mouse position.
    ;MouseGetPos(&x_curr, &y_curr)
    ; Click at the current mouse position.
    SendInput("{LButton}")
    
    ; Pause the script for 30 milliseconds.
    Sleep(30)
    
	NoMoveMouse(1801, 84)
	Sleep 30
}
 
; "F" Key Macro
; This hotkey is designed to simulate a "press and hold" action.
F:: {
    ; Release all currently pressed keys.
    SendInput "{AllKeysUp}"
    ; Click at the specified coordinates using the custom function.
    NoMoveMouse(1801, 84)
	; Pause the script for 30 milliseconds.
    ;Sleep 30
    ; Press and hold the left mouse button down.
    SendInput("{LButton down}")
    ; Pause the script for 80 milliseconds.
	MouseMoveF()
	;Test1()
    ; Send the Escape keypress.
	Sleep 30
    SendInput "{Esc}"
	Sleep 30
	MouseMoveF_2()
	;Test2()
	;Sleep 10
	
    ; Wait for the "F" key to be released before proceeding.
    KeyWait "F"
}
; This separate hotkey handles the action when the "F" key is released.
F Up:: SendInput("{LButton up}")

; "W" Key Macro
; This hotkey simply sends an Escape keypress.
W::
{
    ; Send the Escape keypress.
    SendInput "{Esc}"
    ; Wait for the "W" key to be released before proceeding.
    KeyWait "W"
}

; "Q" Key Macro
; This hotkey waits for a moment and then performs a click.
Q:: {
    ; Pause the script for 70 milliseconds.
    Sleep(70)
    ; Use the custom ClickRel function to click at the specified coordinates.
    NoMoveMouse(914.88, 330.372)
    ; Wait for the "Q" key to be released.
	Sleep 30
    KeyWait("Q")
}

; "E" Key Macro
; This hotkey is similar to the Q macro, with a slightly longer delay.
E:: {
    ; Pause the script for 100 milliseconds.
    Sleep(120)
    ; Use the custom ClickRel function to click at the specified coordinates.
    NoMoveMouse(1239.552, 607.932) 
	;ClickRel(1277, 585)
    ; Wait for the "E" key to be released.
	Sleep 30
    KeyWait("E")
}

; "Space" Key Macro
; This hotkey performs a click at a fixed location.
Space:: {
    ; Use the custom ClickRel function to click at the specified coordinates.
    ;ClickRel(1654, 86)
    NoMoveMouse(1801, 84)
	Sleep 30
    ; Wait for the "Space" key to be released.
    KeyWait "Space"
}

; "S" Key Macro
; This hotkey sends a sequence of keypresses and clicks, with delays in between.
S:: {
    ; Send the "S" key down without triggering other hotkeys.
    SendInput("{Blind}{S Down}")
    ; Pause for 70 milliseconds.
    Sleep 70
    ; Click at the specified coordinates using the custom function.
	NoMoveMouse(1801, 84)
    ; Pause for 50 milliseconds.
    Sleep 50
    ; Click at the specified coordinates again.
    NoMoveMouse(1801, 84)
    ; Release the "S" key without triggering other hotkeys.
    SendInput("{Blind}{S Up}")
	;sleep 50
    ; Wait for the "S" key to be released.
    ;KeyWait "S"
}
; "A" Key Macro
; This hotkey performs a series of clicks and sends an Escape keypress.
A:: {
    ; Click at the specified coordinates using the custom function.
    NoMoveMouse(1801, 84)
	; Pause the script for 30 milliseconds.
    Sleep 30
    ; Perform a standard left mouse click.
    SendInput("{LButton}")
    ; Pause the script for 150 milliseconds.
    Sleep 30
    ; Send the Escape keypress.
    NoMoveMouse(1801, 84)
	; Pause the script for 20 milliseconds.
    Sleep 120
    ; Click at the specified coordinates using the custom function.
    NoMoveMouse(914.88, 330.372)
	sleep 30
	KeyWait "A"
}
; "D" Key Macro
; This hotkey performs a series of clicks and sends an Escape keypress.
D:: {
    ; Click at the specified coordinates using the custom function.
    NoMoveMouse(1801, 84)
	; Pause the script for 30 milliseconds.
    Sleep 30
    ; Perform a standard left mouse click.
    SendInput("{LButton}")
    ; Pause the script for 150 milliseconds.
    Sleep 30
    ; Send the Escape keypress.
    NoMoveMouse(1801, 84)
	; Pause the script for 20 milliseconds.
    Sleep 100
    ; Click at the specified coordinates using the custom function.
    NoMoveMouse(1239.552, 607.932)
	sleep 30
	KeyWait "D"
}
R::
{
NoMoveMouse(1831, 996)
KeyWait "R"
}
T::
{
NoMoveMouse(1654, 86)
KeyWait "T"
}
; This directive resets the hotkey context, making all subsequent hotkeys active globally.
#HotIf

