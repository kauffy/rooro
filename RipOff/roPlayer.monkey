Import roTank

'Summary: Represents a player, containing its in-game object, score, keyboard settings, etc.
Class Player
	Field tank:Tank 'Summary: Contains the playpiece for this player.
	Field score:Int 'Summary: Contains score for this player.
	Field keyF:Int 'Summary: Contains "go" key for this player.
	Field keyL:Int 'Summary: Contains "left" key for this player.
	Field keyR:Int 'Summary: Contains "right" key for this player.
	Field keyB:Int 'Summary: Contains "brake"/"back-up" key for this player.
	Field keyS:Int 'Summary: Contains "fire" key for this player.
	Field respawn:Int 'Summary: Contains time in milliseconds player was last spawned
	
#REM	
Summary:Creates a New player object of a given number 1 - 4
	The player number determines starting position and which model is used for the tank
#END
	
	Method New(playerNum:Int)
#IF CONFIG="debug"
		Print "Player.New entered."
#ENDIF
		Select playerNum
			Case 1
				Self.keyF = KEY_W
				Self.keyL = KEY_A
				Self.keyR = KEY_D
				Self.keyB = KEY_S
				Self.keyS = KEY_SHIFT
			Case 2
			Case 3
			Case 4
		End Select
		Self.IssueTank(playerNum)

		Self.score = 0
	End Method
	Method IssueTank:Tank(playerNum:Int)
		Local x:Float
		Local y:Float
		Select playerNum
			Case 1
				'Top left starting position
				x = fieldCenterLeftEdge
				y = fieldCenterTopEdge
			Case 2
				'Top right starting position
				x = fieldCenterRightEdge
				y = fieldCenterTopEdge
			Case 3
				'Bottom left starting position
				x = fieldCenterLeftEdge
				y = fieldCenterBottomEdge
			Case 4
				'Bottom right starting position
				x = fieldCenterRightEdge
				y = fieldCenterBottomEdge
		End Select
		If Self.tank = Null Then Self.tank = New Tank(True, 1) 'If, for some reason, you don't have a tank, then let's get you a new one.
		Self.tank.gob.SetPosX(x)
		Self.tank.gob.SetPosY(y)
		Self.tank.gob.SetAngle(0.0)
		Self.tank.gob.SetSpeed(0)
		Self.tank.gob.SetActive(True)
		Self.tank.gob.SetVisible(True)
		Self.tank.gob.SetLayer(layGame)
		Self.tank.gob.SetFriction(1)
		Self.tank.gob.collGroup = GRPPLAYER
		Self.tank.gob.tag = playerNum
		Self.tank.gob.dataObj = Self
		Self.respawn = Millisecs()'eng.clock.GetTime()
	End Method
	Method Update:Void()
		If Self.tank = Null OR Self.tank.gob.GetVisible() = False Then 'We don't have a tank, or our tank is hidden
			'Print "Player.Update() Self.tank = Null"
			'Print "Clock time, msec: " + eng.clock.GetTime() + "  Self.Respawn + 3000: " + (Self.respawn + 3000)
			If (eng.GetTime > Self.respawn + 3000) Then '##FIXME Hardcoded respawn time
				Self.IssueTank(1) '##FIXME Hardcoded player number
			Else
				Return
			End If
		End If
		Local player:Player = Self
'#Region "Player Keypresses"		
				If KeyDown(player.keyF) Then 'Pressing down 'thrust' key
					player.tank.Accel()
				End If
				If KeyDown(player.keyB) Then 'Pressing down 'brake/reverse' key
					player.tank.Decel()
				End If

				If KeyDown(player.keyL) Then 'Pressing down 'left' key
					player.tank.TurnLeft()
				End If
				If KeyDown(player.keyR) Then 'Pressing down 'right' key
					player.tank.TurnRight()
				End If
				If KeyHit(player.keyS) Then 'Has hit the fire key
					player.tank.Fire1()
				End If
'#EndRegion
'#Region "Border Rules"
				Local pos:Float[] = player.tank.gob.GetPos()
				If pos[0] < FIELDBORDERWIDTH Then
					player.tank.gob.SetSpeedX(0)
					player.tank.gob.SetPosX(player.tank.gob.GetPosX() +1)
				End If
				If pos[0] > fieldWidth - FIELDBORDERWIDTH Then
					player.tank.gob.SetSpeedX(0)
					player.tank.gob.SetPosX(player.tank.gob.GetPosX() -1)
				End If
				If pos[1] < FIELDBORDERWIDTH Then
					player.tank.gob.SetSpeedY(0)
					player.tank.gob.SetPosY(player.tank.gob.GetPosY() +1)
				End If
				If pos[1] > fieldHeight - FIELDBORDERWIDTH Then
					player.tank.gob.SetSpeedY(0)
					player.tank.gob.SetPosY(player.tank.gob.GetPosY() -1)
				End If
				If player.tank.gob.GetSpeed() > player.tank.topSpeed Then
					player.tank.gob.SetSpeed(player.tank.topSpeed)
				End If
'#EndRegion

	End Method
End Class
