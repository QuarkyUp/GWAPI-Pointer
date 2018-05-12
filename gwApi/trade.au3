#include-once

#include "..\headers.au3"

;~ Description: Open trade window.
Func TradePlayer($aAgent)
   If IsPtr($aAgent) <> 0 Then
	  Local $lAgentID = MemoryRead($aAgent + 44, 'long')
   ElseIf IsDllStruct($aAgent) <> 0 Then
	  Local $lAgentID = DllStructGetData($aAgent, 'ID')
   Else
	  Local $lAgentID = ConvertID($aAgent)
   EndIf
   SendPacket(0x08, $HEADER_TRADE_PLAYER, $lAgentID)
EndFunc   ;==>TradePlayer

;~ Description: Like pressing the "Accept" button in a trade. Can only be used after both players have submitted their offer.
Func AcceptTrade()
   Return SendPacket(0x4, $HEADER_TRADE_ACCEPT)
EndFunc   ;==>AcceptTrade

;~ Description: Like pressing the "Cancel" button in a trade.
Func CancelTrade()
   Return SendPacket(0x4, $HEADER_TRADE_CANCEL)
EndFunc   ;==>CancelTrade

;~ Description: Like pressing the "Change Offer" button.
Func ChangeOffer()
   Return SendPacket(0x4, $HEADER_TRADE_CHANGE_OFFER)
EndFunc   ;==>ChangeOffer

;~ Description: Like pressing the "Submit Offer" button, but also including the amount of gold offered.
Func SubmitOffer($aGold = 0)
   Return SendPacket(0x8, $HEADER_TRADE_SUBMIT_OFFER, $aGold)
EndFunc   ;==>SubmitOffer

;~ Description: Offer item.
Func OfferItem($aItemID, $aQuantity = 1)
   If IsPtr($aItemID) <> 0 Then
	  Local $lItemID = MemoryRead($aItemID, 'long')
	  Local $lQuantity = MemoryRead($aItemID + 75, 'byte')
   ElseIf IsDllStruct($aItemID) <> 0 Then
	  Local $lItemID = DllStructGetData($aItemID, 'ID')
	  Local $lQuantity = DllStructGetData($aItemID, 'Quantity')
   Else
	  Local $lItemID = $aItemID
	  Local $lQuantity = MemoryRead(GetItemPtr($aItemID) + 75, 'byte')
   EndIf
   If $aQuantity > $lQuantity Then
	  Return SendPacket(0xC, $HEADER_TRADE_OFFER_ITEM, $lItemID, $lQuantity)
   Else
	  Return SendPacket(0xC, $HEADER_TRADE_OFFER_ITEM, $lItemID, $aQuantity)
   EndIf
EndFunc   ;==>OfferItem