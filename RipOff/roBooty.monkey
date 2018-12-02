Import RipOff

'Summary: for the haulable items in the game.
Class Booty
	Global bootyListAll:List<Booty> = New List<Booty> 'Summary: A list of all booty created in the game.
	Global bootyListLoose:List<Booty> = New List<Booty> 'Summary: A list of all booty loose and available for pickup.

	Field gob:ftObject 'Summary: The physics/graphics object for the booty.
	Field homeSpot:Vector2D 'Summary: The location where the booty was spawned-- to reset the level, or in case of a powerup
	Field type:Int 'Summary: The type of booty this is. 0 is the default target pickup, but leaving room for future items.
	
	Function AddToAll:Int(newBooty:Booty)
		If bootyListLoose.Contains(newBooty) = False Then bootyListAll.AddLast(newBooty)
#IF CONFIG="debug"
		Print "Booty.AddToAll entered."
		Print "There are " + bootyListAll.Count() + " booty total, and " + bootyListLoose.Count() + " on the loose."
#ENDIF		Return 0
	End Function

	Function AddToLoose:Int(newBooty:Booty)
		If bootyListLoose.Contains(newBooty) = False Then bootyListLoose.AddLast(newBooty)
#IF CONFIG="debug"
		Print "Booty.AddToLoose entered."
		Print "There are " + bootyListAll.Count() + " booty total, and " + bootyListLoose.Count() + " on the loose."
#ENDIF
		Return 0
	End Function
	
	Function RemoveFromAll:Int(newBooty:Booty)
#IF CONFIG="debug"
		Print "Booty.RemoveFromAll entered."
		Print "There are " + bootyListAll.Count() + " booty total, and " + bootyListLoose.Count() + " on the loose."
#ENDIF
'		If bootyListAll.Contains(newBooty) = True Then
			bootyListAll.Remove(newBooty)
'		Else
'			Print "Booty.RemoveFromAll called, but Booty wasn't in the list."
'		End If
		Return 0
	End Function

	Function RemoveFromLoose:Int(newBooty:Booty)
#IF CONFIG="debug"
		Print "Booty.RemoveFromLoose entering."
		Print "There are " + bootyListAll.Count() + " booty total, and " + bootyListLoose.Count() + " on the loose."
#ENDIF
'		If bootyListLoose.Contains(newBooty) = True Then
			bootyListLoose.Remove(newBooty)
'		Else
'			Print "Booty.RemoveFromLoose called, but Booty wasn't in the list."
'		End If
'#IF CONFIG="debug"
'		Print "Booty.RemoveFromLoose exiting."
'		Print "There are " + bootyListAll.Count() + " booty total, and " + bootyListLoose.Count() + " on the loose."
'#ENDIF
		Return 0
	End Function

	Function CountAll:Int()
		Return bootyListAll.Count()
	End Function
	
	Function CountLoose:Int()
		Return bootyListLoose.Count()
	End Function
	
	Function GimmeRandom:Booty()
		If bootyListLoose.Count() > 0 Then
			Local booty:Int = Rand(0, bootyListLoose.Count)
			Return bootyListLoose.ToArray[booty]
		Else
			Return Null
		End If
	End Function
	
	Method New(type:Int = 0)
		Select type
			Default ' The default normal booty (0 or anything not covered in the cases above)
				Print "Booty.New called."
				Self.gob = eng.CreateImage(bootyImage[0], 0.0, 0.0)
				Self.gob.SetColGroup(GRPBOOTY)
				Self.gob.SetTag(-1) 'It belongs to the world.
				Self.gob.SetPosX(Rnd(fieldCenterLeftEdge, fieldCenterRightEdge))
				Self.gob.SetPosY(Rnd(fieldCenterTopEdge, fieldCenterBottomEdge))
				Self.gob.SetScale(0.25)
				Self.gob.SetVisible(True)
				Self.gob.SetActive(True)
				Self.gob.SetRadius(2)
				Self.gob.SetLayer(layGame)
				Self.gob.SetDataObj(Self)
				Self.gob.SetSpin(25) 'Give that little DJ a spin!
				Booty.AddToAll(Self) 'Add this new booty to the master booty list
				Booty.AddToLoose(Self) 'Add this new booty to the list of booty that's available for pick up.
		End Select
'#IF CONFIG="debug"
'		Print "Booty.New entered."
'		Print "There are " + bootyListAll.Count() + " booty total, and " + bootyListLoose.Count() + " on the loose."
'#ENDIF
	End Method
	
	Method Update:Void()
'#Region "Border Rules"
		Local pos:Float[] = Self.gob.GetPos()
		Local escaped:Bool = False
		If pos[0] < FIELDBORDERWIDTH Then
			Print "Booty escaped off left side."
			escaped = True
		End If
		If pos[0] > fieldWidth - FIELDBORDERWIDTH Then
			Print "Booty escaped off right side."
			escaped = True
		End If
		If pos[1] < FIELDBORDERWIDTH Then
			Print "Booty escaped off top side."
			escaped = True
		End If
		If pos[1] > fieldHeight - FIELDBORDERWIDTH Then
			Print "Booty escaped off bottom side."
			escaped = True
		End If
		If escaped = True
			Self.Score()
		End If
'#EndRegion		
	End Method
	
	Method Score:Void()
		Self.Finalize()
		Print "BOOTY LEFT, POINTS SCORED."
		'##FIXME: Add code to score points for enemy, if desired.
	End Method
	
	Method Finalize:Void()
		Print "Booty.Finalize called."
		If Self.gob <> Null Then
			Self.gob.SetDataObj(Null)
			Print "Removing Booty.gob."
			Self.gob.Remove()
			Self.gob = Null
		End If
		Self.gob = Null
		Booty.RemoveFromLoose(Self)
		Booty.RemoveFromAll(Self)
	End Method
End Class

