Import kauffygrounds
Import RipOff
#REM
Summary: All drivables in the game, both player and enemy.
THE ERROR #TODO ##FIXME IS HERE. A new ftObject is to be created by a call to eng.CreateImage (why image and not object, I do not know).
#END


Class Tank
	Field gob:ftObject 'Summary: The ftObject to represent the physics/graphical element of the tank.
	Field ammo:Int 'Summary: Weapon type (cannon - pop-pop!, or laser - pew-pew!)
	Field rof:Int 'Summary: Rate of fire, expressed as msec between fire times.
	Field lastFired:Int 'Summary: Time last shot was fired, to moderate ROF.
	Field towedItem:Booty 'Summary: Points to the Booty being towed, or is Null if not towing
	Field topSpeed:Float 'Summary: Top speed for this tank (allows speeds to go up with level)
	Field accel:Float 'Summary: Acceleration factor for this tank
	Field topTurn:Float 'Summary: Top turning radius per unit (how fast can this tank turn?)
	Field hitPoints:Int 'Summary: How many hits can this tank take before being destroyed?
	
#REM
	Summary: Creates a New Tank.Takes in IsPlayer bool and num int.
	If isPlayer is True, then num indicates which player number it is.
	If isPlayer is False, then num indicates what level of enemy it is.
#END
	Method New(isPlayer:bool, num:Int)
		Print "Tank New called"
		If isPlayer = True Then
			Print "++ For Player"
			Self.gob = eng.CreateImage(tankPlayerImage[num - 1], 0.0, 0.0)
			Self.gob.GetImage.SetHandle(Self.gob.GetImage.Width() / 2, Self.gob.GetImage.Height() / 2) ' Setting handle to center of image. Works pretty well for treaded vehicles.
			Self.gob.SetScale(0.75)
			Self.ammo = 0 'Always the cannon.
			Self.rof = 175
			Self.hitPoints = 1 'One hit and you're dead.
			Self.topSpeed = 20
			Self.accel = 0.6
			Self.topTurn = 3
			Self.towedItem = Null
			Self.gob.SetColGroup(GRPPLAYER) 'note: We set the collision group to also be able to identify the object from above (in a superclass situation) #TODO figure out how to do this right
			Self.gob.SetColWith(GRPENEMY, True)
			Self.gob.tag = num 'We use this seemingly unused number field to store the information like player number, or enemy level
			Self.gob.SetLayer(layGame)
			Self.gob.SetMaxSpeed(Self.topSpeed)
		Else
			'IF NUM>maxenemytypessetup SET IT BACK TO maxenemytypessetup FOR NOW ##FIXME
			Print "++ For Enemy"
			If num > 4 Then num = 4
			Select num
				Case 0
					Self.ammo = -1 '-1 means no weapon
					Self.hitPoints = 1
					Self.topSpeed = 12
					Self.accel = 0.3
					Self.topTurn = 1.5
					Self.towedItem = Null
					Self.gob = eng.CreateImage(tankEnemyImage[0], 0.0, 0.0)
					Self.gob.SetScale(0.5)
					Self.gob.GetImage.SetHandle(Self.gob.GetImage.Width() / 2, Self.gob.GetImage.Height() / 2) ' Setting handle to center of image. Works pretty well for treaded vehicles.
					Self.gob.SetColGroup(GRPENEMY) 'We set the collision group to also be able to identify the object from above (in a superclass situation)
					Self.gob.SetColWith(GRPBOOTY, True)
					Self.gob.SetColWith(GRPPLAYER, True)
					Self.gob.SetLayer(layGame)
					Self.gob.SetMaxSpeed(Self.topSpeed)
				Case 1
					Self.ammo = -1 '-1 means no weapon
					Self.hitPoints = 1
					Self.topSpeed = 12
					Self.accel = 0.4
					Self.topTurn = 1.9
					Self.towedItem = Null
					Self.gob = eng.CreateImage(tankEnemyImage[1], 0.0, 0.0)
					Self.gob.SetScale(0.40)
					Self.gob.GetImage.SetHandle(Self.gob.GetImage.Width() / 2, Self.gob.GetImage.Height() / 2) ' Setting handle to center of image. Works pretty well for treaded vehicles.
					Self.gob.SetColGroup(GRPENEMY) 'We set the collision group to also be able to identify the object from above (in a superclass situation)
					Self.gob.SetColWith(GRPBOOTY, True)
					Self.gob.SetColWith(GRPPLAYER, True)
					Self.gob.SetLayer(layGame)
					Self.gob.SetMaxSpeed(Self.topSpeed)

				Case 2
					Self.ammo = -1 '-1 means no weapon
					Self.hitPoints = 1
					Self.topSpeed = 20
					Self.accel = 0.7
					Self.topTurn = 3
					Self.towedItem = Null
					Self.gob = eng.CreateImage(tankEnemyImage[2], 0.0, 0.0)
					Self.gob.SetScale(0.35)
					Self.gob.GetImage.SetHandle(Self.gob.GetImage.Width() / 2, Self.gob.GetImage.Height() / 2) ' Setting handle to center of image. Works pretty well for treaded vehicles.
					Self.gob.SetColGroup(GRPENEMY) 'We set the collision group to also be able to identify the object from above (in a superclass situation)
					Self.gob.SetColWith(GRPBOOTY, True)
					Self.gob.SetColWith(GRPPLAYER, True)
					Self.gob.SetLayer(layGame)
					Self.gob.SetMaxSpeed(Self.topSpeed)

				Case 3
					Self.ammo = -1 '-1 means no weapon
					Self.hitPoints = 4
					Self.topSpeed = 4
					Self.accel = 0.1
					Self.topTurn = 1
					Self.towedItem = Null
					Self.gob = eng.CreateImage(tankEnemyImage[3], 0.0, 0.0)
					Self.gob.SetScale(1)
					Self.gob.GetImage.SetHandle(Self.gob.GetImage.Width() / 2, Self.gob.GetImage.Height() / 2) ' Setting handle to center of image. Works pretty well for treaded vehicles.
					Self.gob.SetColGroup(GRPENEMY) 'We set the collision group to also be able to identify the object from above (in a superclass situation)
					Self.gob.SetColWith(GRPBOOTY, True)
					Self.gob.SetColWith(GRPPLAYER, True)
					Self.gob.SetLayer(layGame)
					Self.gob.SetMaxSpeed(Self.topSpeed)

				Case 4
					Self.ammo = -1 '-1 means no weapon
					Self.hitPoints = 1
					Self.topSpeed = 11
					Self.accel = 0.2
					Self.topTurn = 5
					Self.towedItem = Null
					Self.gob = eng.CreateImage(tankEnemyImage[2], 0.0, 0.0) 
					Self.gob.SetScale(0.35)
					Self.gob.GetImage.SetHandle(Self.gob.GetImage.Width() / 2, Self.gob.GetImage.Height() / 2) ' Setting handle to center of image. Works pretty well for treaded vehicles.
					Self.gob.SetColGroup(GRPENEMY) 'We set the collision group to also be able to identify the object from above (in a superclass situation)
					Self.gob.SetColWith(GRPBOOTY, True)
					Self.gob.SetColWith(GRPPLAYER, True)
					Self.gob.SetLayer(layGame)
					Self.gob.SetMaxSpeed(Self.topSpeed)
				Case 5
				Case 6
				Case 7
				Case 8
				Case 9
				Case 10
				Case 11
				Case 12
				Case 13
				Case 14
				Case 15
				Default
			End Select
			Local startSide:Int = Rand(1, 5)
			Select startSide
				Case 1 'Off the top
					Self.gob.SetPos(Rnd(-100, fieldWidth + 100), -100)
				Case 2 'Off the right
					Self.gob.SetPos(fieldWidth + 100, Rnd(-100, fieldHeight + 100))
				Case 3 'Off the bottom
					Self.gob.SetPos(Rnd(-100, fieldWidth + 100), fieldHeight + 100)
				Case 4 'Off the left
					Self.gob.SetPos(-100, Rnd(-100, fieldHeight + 100))
			End Select
		End If
		
	End Method

	'Summary: Apply acceleration rules to this tank. Generally, increase speed by acceleration factor
	Method Accel:Void()
		Self.gob.AddSpeed( (Self.accel * eng.GetTimeScale()))

	End Method

	'Summary: Apply deceleration rules to this tank. Generally, decrease speed by double the acceleration factor
	Method Decel:Void()
'		If Self.gob.speed >= 0 Then
			Self.gob.AddSpeed(- (Self.accel * eng.GetTimeScale()))
'		Else If Self.gob.speed < 0 Then

'			Self.gob.AddSpeed(Self.accel * 2) 'Use the acceleration for now.
'		End If
	End Method

	'Summary: Apply turning rules to this tank. Generally, add to the angle by the factor of maximum turn ability.
	Method TurnRight:Void()
		Local factoredTurn:Float
		'topTurn is the turning ability at top speed. Turning improves as speed decreases. At speed 0, turning is three times topTurn
		factoredTurn = ( ( ( (1 - (Self.gob.GetSpeed() / Self.topSpeed)) * DYNZEROSPEEDTURNFACTOR) + 1) * Self.topTurn) * eng.GetTimeScale()
		'If Self.gob.collGroup = GRPPLAYER Then Print "Factored Turn = " + factoredTurn
		If Self.gob.GetSpeed() < 0 Then
			Print "Player tank speed in reverse: " + Self.gob.GetSpeed()
		End If
		Self.gob.SetAngle(factoredTurn, True)
		Self.gob.SetSpeed(Self.gob.GetSpeed(), Self.gob.GetAngle())
	End Method

	'Summary: Apply turning rules to this tank. Generally, subtract from the angle by the factor of maximum turn ability.
	Method TurnLeft:Void()
		Local factoredTurn:Float
		'topTurn is the turning ability at top speed. Turning improves as speed decreases. At speed 0, turning is three times topTurn
		factoredTurn = ( ( ( (1 - (Self.gob.GetSpeed() / Self.topSpeed)) * DYNZEROSPEEDTURNFACTOR) + 1) * Self.topTurn) * eng.GetTimeScale()
		'Print "Factored Turn = " + factoredTurn
		Self.gob.SetAngle(-factoredTurn, True)
		Self.gob.SetSpeed(Self.gob.GetSpeed(), Self.gob.GetAngle())
	End Method

	'Summary: Applies turning rules without knowing which direction it needs to turn-- attempts to turn toward the given heading, within the rules.
	Method TurnToward:Void(heading:Float)
		Local currAngle:Float = Self.gob.GetAngle()
		Local diff:Float = heading - currAngle
		If diff > 360 Then diff -= 360
		If diff < 0 Then diff += 360
'		Print "currAngle: " + currAngle
'		Print "heading: " + heading
'		Print "diff: " + diff

		If diff >= 180.0 Then
			Self.TurnLeft()
'			Print "Turned Left."
		ElseIf diff < 180.0 Then
			Self.TurnRight()
'			Print "Turned Right."
		End If
	
'		Local currAngle:Float = Self.gob.GetAngle() +360.0
'		Local diff:Float = currAngle - (heading + 360.0)
'#IF CONFIG="debug"
'		Print "TurnToward: " + heading + " from angle of " + currAngle + " with diff of " + diff
'#ENDIF
'		If Abs(diff) < 0.5 Then
'			'Don't do anything?
'			Print "On Course"
'		Else If Abs(diff) >= 180.0 Then
'			Self.TurnRight()
'			Print "Turned Right"
'		Else If Abs(diff) < 180.0 Then
'			Self.TurnLeft()
'			Print "Turned Left"
'		End If
	End Method

	'Summary: Applies turning rules without caring which direction to turn in-- attempts to turn completely away from the given heading. (Useful for pickups with visual towing)
	Method TurnAwayFrom:Void(heading:Float)
		Local currAngle:Float = Self.gob.GetAngle() +360
		Local diff:Float = ( (heading-180) + 360) - currAngle
		'If diff > 360 Then diff -= 360
		'If diff < 0 Then diff += 360
'		Print "Turn Away From "
'		Print "currAngle: " + currAngle
'		Print "heading: " + heading
'		Print "diff: " + diff

		If diff >= (180.0 + 360.0) Then
			Self.TurnLeft()
'			Print "Turned Left to turn away."
		ElseIf diff < (180.0 + 360.0) Then
			Self.TurnRight()
'			Print "Turned Right to turn away."
		End If		
	End Method

	'Summary: Fires the tank's primary weapon.
	Method Fire1:Void()
		Local tank:ftObject = Self.gob
		Local barreltip:Float[] = tank.GetVector(20, tank.angle)
		If eng.GetTime() < (Self.lastFired + Self.rof) Then Return 'Do not fire if we fired more recently than our ROF.
		Self.lastFired = eng.GetTime()
		Select ammo
			Case -1 'No ammo type. Don't fire anything.
			Case 0 'Le canon!
				Local shot:ftObject = eng.CreateImage(shotImage[0], barreltip[0], barreltip[1])
				shot.SetAngle(tank.angle)
				shot.SetMaxSpeed(50.0)
				shot.SetSpeed(tank.GetSpeed() +35)
				shot.SetScale(0.5)
				shot.SetLayer(layGame)
				eng.CreateObjTimer(shot, TMROBJECTREMOVE, 1500)
				If tank.GetColGroup() = GRPPLAYER Then
					shot.SetColGroup(GRPSHOTPLAYER)
					shot.SetColWith(GRPENEMY, True)
				Else If tank.GetColGroup() = GRPENEMY Then
					shot.SetColGroup(GRPSHOTENEMY)
					shot.SetColWith(GRPPLAYER, True)
				End If
				shot.SetRadius(2)
				shot.tag = ammo
				PlaySound shotSound[0]
			Case 1 'A frickin' la-zurr..
		End Select

	End Method

	'Summary: Picks up an object from the ground (usually booty) and fixes it to the tank for carrying off.
	Method PickUp:Void(booty:Booty)
		Self.towedItem = booty
		booty.gob.SetParent = Self.gob
		Booty.RemoveFromLoose(booty)
	End Method

	'Summary: Drops an object to the ground (usually booty).
	Method Drop:Void()
		Print "Tank.Drop called."
		If Self.towedItem <> Null Then
			Print " ++ And towed object wasn't null"
			Local droppedBooty:Booty = Self.towedItem
			droppedBooty.gob.SetParent(Null)
			Self.towedItem = Null
			Booty.AddToLoose(droppedBooty)
		End If

	End Method
		
	'Summmary: method to kill off tank, unhook any towed booty
	Method Die:Void()
		Self.Drop()
		If Self.gob.GetColGroup = GRPPLAYER Then
			Self.gob.SetVisible(False) 'We just hide the tank, rather than getting rid of it.
			
		Else
			Self.Finalize()
		End If
		PlaySound explosionSound[0]
		Print "Tank.Die called."
		'##FIXME: Draw an explosion here
	End Method
	
	'Summary: Method to remove a tank from play, but without giving the player(s) credit.
	Method Escape:Void()
		If Self.towedItem <> Null Then
			Self.towedItem.Score()
		End If
		Self.Finalize()
		Print "Tank.Escape called."
		'Score points or something!
	End Method
	
	'Summary: Method to finalize the tank completely so it can be GC'd. Called in any circumstance.
	Method Finalize:Void()
		Print "Tank.Finalize called."
		If Self.gob <> Null Then
			Print "++Removing Tank.gob"
			Self.gob.Remove()
			Self.gob.SetDataObj(Null)
			Self.gob = Null
		End If
		Self.towedItem = Null
	End Method
End Class