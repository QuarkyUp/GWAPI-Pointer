#RequireAdmin
#include-once
;~ #include '../gwApi.au3' ; or GWA2.au3 depending on which API you use
#include "../gwApi.au3"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ObsDetect.au3
; by 4D 1

; Func _ObsDetect_Init() 						- Call after Initialize(), sets up obstruction callback.
; Func _ObsDetect_SetCallback($aCallback = 0) 	- Call with the callback function as the argument, or send no argument to kill the callback.
; Func _ObsDetect_Restore() 					- Call to restore everything and stop callbacks from being send, is automatically called when the script terminates.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Global $_g_ObsDetect_GUI
Global $_g_ObsDetect_Callback = 0

Global $_g_ObsDetect_Address = 0x007BC910 ;Sig: 8B C8 8B 46 0C 85 C0 89 4D EC (-0x1D)
Global $_g_ObsDetect_CodeCave
Global $_g_ObsDetect_Restore = DllStructCreate('byte[6]')


Func _ObsDetect_Init()
#cs
proc ObsDetect_Detour:
	MOV EAX,DWORD PTR DS:[ECX]
	CMP EAX, 0x8AB
	JNE TRAMPOLINE
	PUSH 0
	PUSH 0
	PUSH 0x510
	PUSH hwnd
	CALL DWORD PTR DS:[postmsgfunc]
	TRAMPOLINE:
	PUSH EBP
	MOV EBP,ESP
	SUB ESP,0x18
	PUSH ret
	RET
#ce
	Local $lBinaryPayload = DllStructCreate('align 1;byte[20];dword;byte[2];dword;byte[8];dword;byte')

	DllStructSetData($lBinaryPayload,1,'0x8B013DAB0800007516606A006A00681005000068')
	DllStructSetData($lBinaryPayload,3,'0xFF15')
	DllStructSetData($lBinaryPayload,5,'0x615589E583EC1868')
	DllStructSetData($lBinaryPayload,7,'0xC3')

	DllStructSetData($lBinaryPayload,4,GetValue('PostMessage'))
	DllStructSetData($lBinaryPayload,6,$_g_ObsDetect_Address + 6)

	$_g_ObsDetect_GUI = GUICreate('obsdetect')
	GUIRegisterMsg(0x510,"__ObsDetect_WndProc")

	DllStructSetData($lBinaryPayload,2,$_g_ObsDetect_GUI)

	$_g_ObsDetect_CodeCave = DllCall($mKernelHandle, 'PTR', 'VirtualAllocEx', 'HANDLE', $mGWProcHandle, "PTR", Null, 'ULONG_PTR', DllStructGetSize($lBinaryPayload), 'DWORD', 0x3000, 'DWORD', 0x40)[0]
	DllCall($mKernelHandle, 'BOOL', 'WriteProcessMemory', 'HANDLE', $mGWProcHandle, 'PTR', $_g_ObsDetect_CodeCave, 'STRUCT*',$lBinaryPayload, 'ULONG_PTR', DllStructGetSize($lBinaryPayload), 'ULONG_PTR', 0)

	Local $lFuncDetour = DllStructCreate('align 1;byte;dword;byte')
	DllStructSetData($lFuncDetour,1,0x68)
	DllStructSetData($lFuncDetour,2,$_g_ObsDetect_CodeCave)
	DllStructSetData($lFuncDetour,3,0xC3)

	DllCall($mKernelHandle, 'BOOL', 'ReadProcessMemory', 'HANDLE', $mGWProcHandle, 'PTR', $_g_ObsDetect_Address, 'STRUCT*', $_g_ObsDetect_Restore, 'ULONG_PTR', 6, 'ULONG_PTR', 0)
	DllCall($mKernelHandle, 'BOOL', 'WriteProcessMemory', 'HANDLE', $mGWProcHandle, 'PTR', $_g_ObsDetect_Address, 'STRUCT*', $lFuncDetour, 'ULONG_PTR', 6, 'ULONG_PTR', 0)

	OnAutoItExitRegister("_ObsDetect_Restore")
EndFunc

Func _ObsDetect_SetCallback($aCallback = 0)
	$_g_ObsDetect_Callback = $aCallback
EndFunc


Func _ObsDetect_Restore()
	DllCall($mKernelHandle, 'BOOL', 'WriteProcessMemory', 'HANDLE', $mGWProcHandle, 'PTR', $_g_ObsDetect_Address, 'STRUCT*', $_g_ObsDetect_Restore, 'ULONG_PTR', 6, 'ULONG_PTR', 0)
	DllCall($mKernelHandle, 'BOOL', 'VirtualFreeEx', 'HANDLE', $mGWProcHandle, "PTR", $_g_ObsDetect_CodeCave, 'ULONG_PTR', 0, 'DWORD', 0x8000)
	OnAutoItExitUnRegister("_ObsDetect_Restore")
EndFunc

Func __ObsDetect_WndProc($aHwnd,$aMsg,$aWParam,$aLParam)
	If $_g_ObsDetect_Callback <> 0 Then $_g_ObsDetect_Callback()
EndFunc