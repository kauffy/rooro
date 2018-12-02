Import roTank

'Summary: Represents an enemy "player", containing its in-game object and objective, etc.
Class Enemy
	Global enemyListAll:List<Enemy> = New List<Enemy>
	
	Field tank:Tank 'Summary: Contains the tank object for this Enemy.
	Field targType:Int 'Summary: Contains the type of objective this enemy has currently. 1=Get Booty, 2=Escape, 3=Kill a Player
	Field targIndex:Int 'Summary: Combined with targType, contains a parameter. If targType=1, e.g., then this contains Index of the booty object in the booty array. This method is deprecated.
	Field target:ftObject 'Summary: An ftObject containing the target we're after. This simplifies some things. This is the new method.
	Field node:ftObject 'Summary: For pathfinding, where is the destination I am heading for?
	Field nodeAge:Int 'Summary: Timestamp of when the node was created. Aged nodes are probably ineffective nodes. If a node gets too stale, we want to re-node.
	Field moveMode:Int 'Summary: For sub-behavior withing pathfinding. 0 is normal, fast as I can moving toward node/target. 1 is something else.

	'Summary: Adds an Enemy object into the current enemy list.
	Function AddToAll:Int(newEnemy:Enemy)
		'If enemyListAll.Contains(newEnemy) = False Then
		enemyListAll.AddLast(newEnemy)
		Return 0		
	End Function

	'Summary: Removes an Enemy object from the current enemy list.
	Function RemoveFromAll:Int(remEnemy:Enemy)
		'If enemyListAll.Contains(remEnemy) = True Then
		enemyListAll.Remove(remEnemy)
#IF CONFIG="debug"
		Print "Enemy.RemoveFromAll entered."
		Print "There are " + enemyListAll.Count() + " enemies total."
#ENDIF
		Return 0
	End Function

	'Summary: Declare a new enemy "player" with skill of level (an int from 0 to, like 10). Currently, level is also used to determine the type of tank.
	Method New(level:Int)
		'Declare a new tank
		'Set an objective.
		Print "Enemy.New called."
		Self.tank = New Tank(False, level)
		Self.targType = TRGGETBOOTY '##FIXME: Don't set the objective this way
		Self.target = Null
		Self.tank.gob.dataObj = Self
		Self.node = eng.CreateCircle(5, 0.0, 0.0)
		Self.node.SetColor(10, 255, 10)
		Self.node.SetVisible(False) 'If you want nodes visible for AI path debugging purposes, set this to True.
		Self.moveMode = MMNORMAL
		Enemy.AddToAll(Self)
	End Method

	'Summary: Performs update functions. This is where the individual enemy AI gets called to do its thing.
	Method Update:Void()
		If Self.tank = Null Then
			Print "Enemy.Update got called with an Enemy with a nulled Tank."
			Return
		End If
		Select Self.targType
			Case TRGGETBOOTY
				Self.moveMode = MMNORMAL
			Case TRGPICKUP
				Self.moveMode = MMPICKUP
			Case TRGESCAPE
				Self.moveMode = MMNORMAL
'#Region "Border Rules"
				Local pos:Float[] = Self.tank.gob.GetPos()
				Local escaped:Bool = False
		
				If pos[0] < 0 - FIELDBORDERWIDTH Then
					Print "Enemy escaped off left side."
					escaped = True
				End If
				If pos[0] > fieldWidth + FIELDBORDERWIDTH Then
					Print "Enemy escaped off right side."
					escaped = True
				End If
				If pos[1] < 0 - FIELDBORDERWIDTH Then
					Print "Enemy escaped off top side."
					escaped = True
				End If
				If pos[1] > fieldHeight + FIELDBORDERWIDTH Then
					Print "Enemy escaped off bottom side."
					escaped = True
				End If
				If escaped = True
						Self.Escape()
				End If
'#EndRegion				

			Case TRGKILL
				Self.moveMode = MMNORMAL
		End Select
		If Self.tank <> Null Then Self.Nav() 'Only call Nav if we didn't Escape() above.
	End Method

	'Summary: Performs navigation update -- am I on track? If not, steer.	
	Method Nav:Void()
		'Local targPoint:ftObject
		Local rayAngle:Float = 0.0
		Local coords:Vector2D = New Vector2D
		Local newAngle:Float = 0.0
		Local window:Float = 0.0
		Select Self.targType
			Case TRGGETBOOTY
				If Self.target = Null OR Booty.bootyListLoose.Contains(Booty(Self.target.GetDataObj())) = False Then
					Local tmpNewTarget:Booty
					tmpNewTarget = Booty.GimmeRandom
					If tmpNewTarget <> Null Then
						Self.target = tmpNewTarget.gob
					Else
						Self.target = Null
						Self.targType = TRGESCAPE
						Self.targIndex = -1
						Self.target = eng.CreateCircle(5, fieldWidth + 50, fieldHeight + 50) 'Quick and dirty-- create an ftObject off-screen in the lower-right. ##FIXME: This is creating one EVERY TIME CODE RUNS PAST HERE!

					End If
				End If
				If Self.target = Null Then Print "Enemy.Nav: TRGGETBOOTY target is still null after code called to set it."

			Case TRGESCAPE
'				If Self.target = Null Then
'				End If
				If Self.targIndex = -1 Then 'If targIndex is flagged this way, this means our Escape location is set to something we don't want it set to.
					Self.targIndex = 0 'Turn that off, so we only do that one time
					Self.target = eng.CreateCircle(5, fieldWidth + 50, fieldHeight + 50) 'Quick and dirty-- create an ftObject off-screen in the lower-right. ##FIXME: This is creating one EVERY TIME CODE RUNS PAST HERE!
					'Find the closest border.
					'Set the target to be 100 units past the border along the most direct axis
					If Self.tank.gob.GetPosX() > (fieldWidth / 2) Then 'We are closer to the right than the left
						Self.target.SetPosX(fieldWidth + 100)
					Else
						Self.target.SetPosX(-100)
					End If
					If Self.tank.gob.GetPosY() > (fieldHeight / 2) Then 'We are closer to the bottom than the top
						Self.target.SetPosY(fieldHeight + 100)
					Else
						Self.target.SetPosY(-100)
					End If
				End If
				If Self.tank.towedItem = Null Then 'I am not towing anything. I'm just in ESCAPE mode because I think there's no more work to do (as in, all the booty is spoken for).
					If Booty.CountLoose > 0 Then 'If a booty is suddenly available again, I want to go after it.
						Self.target.Remove() 'Since we were in Escape mode, we have a Circle ftObject out there we are targeting. Since we're switching modes, we want to remove that target.
						Self.target = Null
						Self.targType = TRGGETBOOTY
						Return 'We jump out of code here, because we don't want to do the rest of the call in this Objective mode.
					End If
				End If
			Case TRGPICKUP
				If Self.target = Null Then
					Print "Target is somehow Null with TRGPICKUP mode set!"
				End If
			Case TRGKILL
			
		End Select
		Local targDistance:Float = Self.tank.gob.GetTargetDist(Self.target)
		Local nodeDistance:Float = Self.tank.gob.GetTargetDist(Self.node)

		Select Self.moveMode
			Case MMNORMAL ' This is for navigating toward and/or updating nodes to reach the target location.
				If targDistance > AIMINDISTANCEFORPATHING Then
					rayAngle = Self.tank.gob.GetTargetAngle(Self.node)
'					Print "rayAngle (Angle to Node): " + rayAngle
'					Print "nodeDistance: " + nodeDistance
'					Print "targetAngle (Angle to Target): " + Self.tank.gob.GetTargetAngle(targPoint)
'					Print "How far off: " + (rayAngle - Self.tank.gob.GetTargetAngle(targPoint))
					If (Abs(rayAngle - Self.tank.gob.GetTargetAngle(Self.target)) > 90) OR (nodeDistance <= 40) OR (Self.node.GetPosX() = 0) Or (eng.GetTime() -Self.nodeAge > 2000.0) Then
						'If the angle between myself and the target is way off, or the node is very close, or my node is unitialized, then I recalc my node.
						'But first, I want to check and see if my target is still on the menu. What if some other brother picked up my booty?
						window = (Min(targDistance, 100.0) * (AIWINDOWMAX / 100.0)) 'Generate a window related to distance to target, maxing out at 90 degrees for 100 dist and beyond
						newAngle = Rnd(0, window)
						coords = GetCoords(targDistance / AINODEDISTANCEFACTOR, Self.tank.gob.GetTargetAngle(Self.target) + (newAngle - (window / 2)))
'						Print "Repositioning Node"
						Self.node.SetPosX(Self.tank.gob.GetPosX() +coords.x)
						Self.node.SetPosY(Self.tank.gob.GetPosY() +coords.y)
						Self.nodeAge = eng.GetTime()
					End If
					If Self.targType = TRGGETBOOTY And eng.GetTime() -Self.nodeAge > 1200.0 Then Self.tank.Decel() 'Slow down if our node is aging.
				End If
				rayAngle = Self.tank.gob.GetTargetAngle(Self.node)
				Self.tank.TurnToward(rayAngle)
				Self.tank.Accel()
			Case MMPICKUP ' This is for not moving anywhere, but instead, rotating in place to hitch up to the booty.
				'We have collided with booty, now we want to stop, turn away from it, hitch to it, and leave.
				Self.tank.gob.SetSpeed(0)
				Self.tank.TurnAwayFrom(Self.tank.gob.GetTargetAngle(Self.target))
				'Print "Angle to target" + (Self.tank.gob.GetTargetAngle(Self.target) - Self.tank.gob.GetAngle())
				rayAngle = Self.tank.gob.GetTargetAngle(Self.target) - Self.tank.gob.GetAngle()
				If Abs(rayAngle) > (180.0 - Self.tank.topTurn - 3) And Abs(rayAngle) < (180.0 + Self.tank.topTurn + 3) Then 'The 3 in here is to add a little margin on either side.
					'Print "Successfully rotated to put the booty on notice!"
					'We put the booty behind us. Now let's pick it up!
					Self.tank.PickUp(Booty(Self.target.GetDataObj()))
					Self.targType = TRGESCAPE
					Self.targIndex = -1 'Means we haven't chosen an exit location yet. Used with the entry to this method to set it if unset.
					
				End If
		End Select
	End Method

	'Summary: Once the objective is set, I'mma pick a target..
	Method SetTarget:Int(type:Int = 0, index:Int = 0)
		
	End Method

	'Summary: If I'm killed, score points and remove me and my tank from the game.
	Method Die:Void()
		Print "Enemy.Die called."
		Self.tank.Die()
		Self.Finalize()
	End Method
	
	'Summary: If I've made it off the edge of the screen, remove me and my tank from the game, but don't give the player(s) the satisfaction of the points.
	Method Escape:Void()
		Print "Enemy.Escape called."
		Self.tank.Escape()
		Self.Finalize()
	End Method
	'Summary: Method to completely free up Enemy object and its resources so the memory can be GC'd.
	Method Finalize:Void()
		Print "Enemy.Finalize called."
		If Self.tank <> Null Then Self.tank.Finalize()
		Print "Enemy.node remove to be called."
		If Self.node <> Null Then Self.node.Remove()
		Print "Enemy.target remove to be called."
		If Self.targType = TRGESCAPE And Self.target <> Null Then Self.target.Remove() 'We only want to do this is the target is our fake target circle we created.
		Self.tank = Null
		Self.node = Null
		Self.target = Null
		Enemy.RemoveFromAll(Self)
	End Method
End Class

