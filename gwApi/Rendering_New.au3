
; by Tecka, implemented by 4D 1

#include-once

#include "..\headers.au3"

Global $g__NewRenderer_Function = Ptr(0x00618620) ; 53 8D 0C 40 A1 (-0x2B)
Global $g__NewRenderer_Return	= Ptr($g__NewRenderer_Function + 0x3)
Global $g__NewRenderer_DetourBuffer
Global $g__NewRenderer_DetourASM

#cs
mov ebp,esp
cmp dword ptr ds:[0xABABABAB],0
jnz 0xCDCDCDCD
pop ebp
pop eax
push 0x32
push eax
jmp dword ptr ds:[0xEFEFEFEF]
#ce

Func _NewRenderer_Init()

	$g__NewRenderer_DetourBuffer = DllCall($mKernelHandle, 'ptr', 'VirtualAllocEx', 'handle', $mGWProcHandle, 'ptr', 0, 'ulong_ptr', 0x100, 'dword', 0x1000, 'dword', 0x40)[0]
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $g__DetourNewRenderer_Buffer = ' & $g__NewRenderer_DetourBuffer & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	$g__NewRenderer_DetourASM = Ptr($g__NewRenderer_DetourBuffer + 0x4)
	Local $lASM = DllStructCreate('align 1;byte[4];ptr;byte[3];ptr;byte[7];ptr')
	DllStructSetData($lASM,1,'0x89E5833D')
	DllStructSetData($lASM,2,$g__NewRenderer_DetourBuffer)
	DllStructSetData($lASM,3,'0x000F84')
	DllStructSetData($lASM,4,$g__NewRenderer_Return - ($g__NewRenderer_DetourASM + 15))
	DllStructSetData($lASM,5,'0x5D586A6450FF25')
	DllStructSetData($lASM,6,GetValue('Sleep'))

	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', $g__NewRenderer_DetourASM, 'struct*', $lASM, 'int', DllStructGetSize($lASM), 'int', '')

	Local $lDetour = DllStructCreate('align 1;byte;ptr;byte[4]')
	DllStructSetData($lDetour,1,0x68)
	DllStructSetData($lDetour,2,$g__NewRenderer_DetourASM)
	DllStructSetData($lDetour,3,'0xC355EBF7')

	DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', $g__NewRenderer_Function - 0x6, 'struct*', $lDetour, 'int', DllStructGetSize($lDetour), 'int', '')

EndFunc


Func _NewRenderer_SetHook($aValue)
	MemoryWrite($g__NewRenderer_DetourBuffer,Int($aValue))
EndFunc
