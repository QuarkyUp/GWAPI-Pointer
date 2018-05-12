#include-once

#include "..\headers.au3"

#Region All
;~ Description: Donate Kurzick or Luxon faction.
Func DonateFaction($aFaction)
   If StringLeft($aFaction, 1) = 'k' Then
	  Return SendPacket(0x10, $HEADER_FACTION_DONATE, 0, 0, 5000)
   Else
	  Return SendPacket(0x10, $HEADER_FACTION_DONATE, 0, 1, 5000)
   EndIf
EndFunc   ;==>DonateFaction
#EndRegion

#Region Kurzick
;~ Description: Returns current Kurzick faction.
Func GetKurzickFaction()
   Local $lOffset[4] = [0, 0x18, 0x2C, 0x748]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetKurzickFaction

;~ Description: Returns max Kurzick faction.
Func GetMaxKurzickFaction()
   Local $lOffset[4] = [0, 0x18, 0x2C, 0x7B8]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetMaxKurzickFaction
#EndRegion

#Region Luxon
;~ Description: Returns current Luxon faction.
Func GetLuxonFaction()
   Local $lOffset[4] = [0, 0x18, 0x2C, 0x758]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetLuxonFaction

;~ Description: Returns max Luxon faction.
Func GetMaxLuxonFaction()
   Local $lOffset[4] = [0, 0x18, 0x2C, 0x7BC]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetMaxLuxonFaction
#EndRegion

#Region Imperial
;~ Description: Returns current Imperial faction.
Func GetImperialFaction()
   Local $lOffset[4] = [0, 0x18, 0x2C, 0x708]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetImperialFaction

;~ Description: Returns max Imperial faction.
Func GetMaxImperialFaction()
   Local $lOffset[4] = [0, 0x18, 0x2C, 0x760]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetMaxImperialFaction
#EndRegion

#Region Balth
;~ Description: Returns current Balthazar faction.
Func GetBalthazarFaction()
   Local $lOffset[4] = [0, 0x18, 0x2C, 0x734]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetBalthazarFaction

;~ Description: Returns max Balthazar faction.
Func GetMaxBalthazarFaction()
   Local $lOffset[4] = [0, 0x18, 0x2C, 0x75C]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetMaxBalthazarFaction
#EndRegion

