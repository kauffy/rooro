Strict

#DEBUGAI=False

#rem
	Script:		RipOff.monkey
	Description:	RipOff of RipOff (working title) based on Hartlef's base script for fantomEngine 
	Author: 		Kauffy
#end
#REM
'Summary: ##TODO:
		See Notes.txt file in this project
#END
Import kauffygrounds
Import roConst
Import roTank
Import roBooty
Import roPlayer
Import roEnemy
Import roWave

'***************************************
Class game Extends App
	Field isSuspended:Bool = False
	Field p:Player[] = New Player[4]
	Field wave:Wave
	'------------------------------------------
	
	Method OnCreate:Int()
		Local enemy:Enemy
	
#IF CONFIG="debug"
		Print "game.OnCreate entered."
#ENDIF
		SetUpdateRate(60)
		
		eng = New engine
		Seed = Millisecs() 'eng.clock.GetTime()
		SetDeviceWindow(1680, 1024, 0)
		eng.SetCanvasSize(1680, 1024)
		fieldWidth = eng.GetCanvasWidth()
		fieldHeight = eng.GetCanvasHeight()

		fieldCenterLeftEdge = (fieldWidth / fieldCenterFactor) * (Floor(fieldCenterFactor / 2.0))
		fieldCenterRightEdge = (fieldWidth / fieldCenterFactor) * (Round(fieldCenterFactor / 2.0))
		fieldCenterTopEdge = (fieldHeight / fieldCenterFactor) * (Floor(fieldCenterFactor / 2.0))
		fieldCenterBottomEdge = (fieldHeight / fieldCenterFactor) * (Round(fieldCenterFactor / 2.0))


		CreateLayers()
		eng.SetDefaultLayer(layGame)
		LoadTankImages()
		LoadBootyImages()
		LoadShotImages()
		LoadShotSounds()
		LoadExplosionSounds()

		'Create player 1
		p[0] = New Player(1) 'The number passed must be 1 to 4. This is 1-base index.

		'wave = New Wave(-95) 'Stress Test
		'wave = New Wave(0) 'Base game
		wave = New Wave(-98) 'Slow-ass sample
		
#IF CONFIG="debug"
'		Print "New Player(1) created and assigned to p[0]."
#ENDIF
		
		layGame.SetActive(True)
		layGame.SetVisible(True)
#IF CONFIG="debug"
'		Print "layGame .SetActive and .SetVisible both set to True."
#ENDIF

		gm = GMPLAY
		Return 0
	End
	
	'Summary: Creates new layers
	Method CreateLayers:Void()
		layBackground = eng.CreateLayer()
		layGame = eng.CreateLayer()
		layUI = eng.CreateLayer()
		layMenu = eng.CreateLayer()
	End Method
	'Summary: Populates tankPlayerImage and tankEnemyImage arrays with sprites from files
	Method LoadTankImages:Void()
#IF CONFIG="debug"
		Print "LoadTankImages entered."
#ENDIF

		tankPlayerImage = New Image[4]
		tankEnemyImage = New Image[4] 'This is a changing value-- right now, there are only four enemy images.

		For Local p:Int = 0 Until tankPlayerImage.Length()
			Select p
				Case 0
					tankPlayerImage[p] = LoadImage("tankP1.png")
				Case 1
					tankPlayerImage[p] = LoadImage("tankP2.png")
				Case 2
					tankPlayerImage[p] = LoadImage("tankP3.png")
				Case 3
					tankPlayerImage[p] = LoadImage("tankP4.png")
			End Select
			If tankPlayerImage[p] = Null Then
				Print "tankPlayerImage " + p + " failed to load."
			End If
		End For
		For Local e:Int = 0 Until tankEnemyImage.Length()
			Select e
				Case 0
					tankEnemyImage[e] = LoadImage("tankEyellow.png")
				Case 1
					tankEnemyImage[e] = LoadImage("tankEgreen.png")
				Case 2
					tankEnemyImage[e] = LoadImage("tankEblue.png")
				Case 3
					tankEnemyImage[e] = LoadImage("tankEred.png")
			End Select
			If tankEnemyImage[e] = Null Then
				Print "tankEnemyImage " + e + " failed to load."
			End If
		End For
	End Method
	'Summary: Populates bootyImage array with sprites from files
	Method LoadBootyImages:Void()
#IF CONFIG="debug"
		Print "LoadBootyImages entered."
#ENDIF
		bootyImage = New Image[1]
		bootyImage[0] = LoadImage("booty.png")
		bootyImage[0].SetHandle(bootyImage[0].Width() / 2, bootyImage[0].Height() / 2)
	End Method
	'Summary: Populates shotImage array with sprites from files
	Method LoadShotImages:Void()
#IF CONFIG="debug"
		Print "LoadShotImages entered."
#ENDIF
		shotImage = New Image[1]
		shotImage[0] = LoadImage("shotP1.png")
		shotImage[0].SetHandle(shotImage[0].Width() / 2, shotImage[0].Height() / 2)
	End Method
	'Summary: Populates shotSound array with audio from files.
	Method LoadShotSounds:Void()
		shotSound = New Sound[1]
		shotSound[0] = LoadSound("shotp1.wav") 'Sound effects on GLFW have to be .wav
		If shotSound[0] = Null Then Error("shotSound wasn't loaded right for some dumb reason.")
	End Method
	'Summary: Populates explosionSound array with audio from files.
	Method LoadExplosionSounds:Void()
		explosionSound = New Sound[1]
		explosionSound[0] = LoadSound("explosion.wav") 'Sound effects on GLFW have to be .wav
		'note: TODO: Add in code for sound effects for other devices.
		If shotSound[0] = Null Then Error("explosionSound wasn't loaded right for some dumb reason.")
	End Method
	'Summary: Spawns bootycount booty around the center field.
	Method ScatterBooty:Void(bootycount:Int)
		Local booty:Booty
		For Local i:Int = 0 Until bootycount
			booty = New Booty(0) 'We don't save the booty, because the class handles it for us.
			booty.gob.SetAngle(Rnd(360.0))
		End For
	End Method
	'------------------------------------------
	Method OnUpdate:Int()
		Local d:Float = Float(eng.CalcDeltaTime())/60.0
		If isSuspended = False Then
			If cntLastGobs <> layGame.objList.Count() Then
				Print "Game Layer Object List Count: " + layGame.objList.Count()
				cntLastGobs = layGame.objList.Count()
			End If
			If KeyHit(KEY_P) Then
				If eng.GetTimeScale() = 0 Then
					eng.SetTimeScale(1.0)
				Else
					eng.SetTimeScale(0)
				EndIf
			EndIf
			If KeyHit(KEY_COMMA) Then eng.SetTimeScale(0.5)
			If KeyHit(KEY_PERIOD) Then eng.SetTimeScale(1.0)
			If KeyHit(KEY_SLASH) Then eng.SetTimeScale(1.5)
			
			Select gm
				Case GMPLAY
					eng.Update(Float(d))
					eng.CollisionCheck(layGame)
					g.wave.Update()
				Case GMMENU
				Case GMTITLE
				Case GMWAVEBREAK
					'If KeyHit(KEY_SPACE) Then
					gm = GMPLAY
					Print "WAVE BREAK!!!!!!"
			End Select
		End If
		Return 0
	End
	'------------------------------------------
	Method OnRender:Int()
		Cls
		'DrawImage(tankPlayerImage[0], DeviceWidth() / 2, DeviceHeight() / 2)
#IF CONFIG="debug"
'		'Draw a box around the center field, for debug and testing purposes
'		SetColor(128, 128, 128)
'		DrawRectOutline(fieldCenterLeftEdge, fieldCenterTopEdge, fieldWidth / fieldCenterFactor, fieldHeight / fieldCenterFactor)
'		'Draw a box around the target booty, so we know where the AI is heading.
'
		For Local i:Int = 0 Until Enemy.enemyListAll.Count()
			Local enemy:Enemy
			'Draw a line from the enemy tank to its node, then to its target
			For enemy = EachIn Enemy.enemyListAll
				SetColor(128, 0, 0)
				DrawLine(enemy.tank.gob.GetPosX(), enemy.tank.gob.GetPosY(), enemy.node.GetPosX(), enemy.node.GetPosY())
				'Draw a line from the enemy tank's node to its target.
				SetColor(128, 64, 0)
				If enemy.target <> Null Then DrawLine(enemy.node.GetPosX(), enemy.node.GetPosY(), enemy.target.GetPosX(), enemy.target.GetPosY())
				SetColor(255, 255, 255)
			End For
		End For
#ENDIF

		eng.Render()
		Return 0
	End
	'------------------------------------------
	Method OnResume:Int()
		isSuspended = False
		SetUpdateRate(60)
		Return 0
	End
	'------------------------------------------
	Method OnSuspend:Int()
		isSuspended = True
		SetUpdateRate(5)
		Return 0
	End
End	

'***************************************
Class engine Extends ftEngine
	'------------------------------------------
	Method OnObjectCollision:Int(obj:ftObject, obj2:ftObject)
'#IF CONFIG="debug"
'	Print obj.GetColGroup() + " collides with " + obj2.GetColGroup()
'#ENDIF
'		If (obj.GetColGroup() = GRPENEMY And obj2.GetColGroup() = GRPPLAYER) OR (obj.GetColGroup() = GRPPLAYER And obj2.GetColGroup() = GRPENEMY) Then
'			Local enemy:Enemy
'			Local player:Player
'			'Collision between tanks-- player and enemy.
'			If obj.GetColGroup() = GRPENEMY Then 'Depending upon who hit whom, we assign the objects to the things we really want to know about.
'				enemy = Enemy(obj.GetDataObj())
'				player = Player(obj2.GetDataObj())
'			Else If obj.GetColGroup() = GRPPLAYER Then
'				enemy = Enemy(obj2.GetDataObj())
'				player = Player(obj.GetDataObj())
'			End If
'			enemy.Die()
'			player.tank.Die()
'		End If
		If obj.GetColGroup() = GRPSHOTPLAYER And obj2.GetColGroup() = GRPENEMY Then
			'IF A PLAYER SHOT COLLIDES WITH AN ENEMY TANK
			'obj2.Remove()
			Enemy(obj2.GetDataObj()).Die()
			obj.Remove()
		End If
		If obj.GetColGroup() = GRPENEMY And obj2.GetColGroup() = GRPBOOTY Then
			'IF AN ENEMY TANK ACTUALLY COLLIDES WITH BOOTY!
			If Booty.bootyListLoose.Contains(Booty(obj2.GetDataObj())) = True Then 'Make sure THIS booty is not spoken for.
				Local enemy:Enemy = Enemy(obj.GetDataObj())
				If enemy.targType = TRGGETBOOTY Then
					'Regardless of which booty we intended to pick up, when we hit one, that's the one we want. Amiright, fellas?!
					enemy.targType = TRGPICKUP 'Calls off the dogs
					Booty.RemoveFromLoose(Booty(obj2.GetDataObj())) 'Pull it from the list of booty that is available for pickup.
					enemy.tank.towedItem = Booty(obj2.GetDataObj())
					enemy.target = obj2
				Else
					'We do not want to do anything if we collide with booty-- we're up to something else right now.
				End If
			End If
		End If
		Return 0
	End
	'------------------------------------------
	Method OnObjectTimer:Int(timerId:Int, obj:ftObject)
		Select timerId
			Case TMROBJECTREMOVE
				obj.Remove()
		End Select
		Return 0
	End	
	'------------------------------------------
	Method OnObjectTouch:Int(obj:ftObject, touchId:Int)
		Return 0
	End
	'------------------------------------------
	Method OnObjectTransition:Int(transId:Int, obj:ftObject)
		Return 0
	End
	'------------------------------------------
	Method OnObjectUpdate:Int(obj:ftObject)

		Select obj.collGroup
			Case GRPPLAYER 'This is a player object
				g.p[ (obj.tag - 1)].Update()
			Case GRPENEMY 'This is an enemy
				If obj.deleted = True Then
					Print "An ftObject has called an ObjectUpdate on an Enemy with its deleted flag set to True."
				Else
					Local enemy:Enemy = Enemy(obj.GetDataObj())
					enemy.Update()
				End If
			Case GRPBOOTY 'This is a booty!
				If obj.deleted = True Then
					Print "An ftObject has called an ObjectUpdate on an Booty with its deleted flag set to True."
				Else
					Local booty:Booty = Booty(obj.GetDataObj())
					booty.Update()
				End If
		End Select
		Return 0
	End Method
	'------------------------------------------
	Method OnLayerUpdate:Int(layer:ftLayer)
		Return 0
	End Method
End

'***************************************
Function Main:Int()
	g = New game
	Return 0
End

