Import kauffygrounds
Import RipOff

'Summary: Class to control the enemy gameflow-- each wave can be coded distinctly.
Class Wave
	Global currentWave:Int 'Summary: Global variable to hold the count of the current wave.
	Global maxWave:Int = 6'Summary: Global to hold the highest available wave.

	Field Desc:String

	Function Advance()
		If currentWave >= 0 Then
			currentWave = currentWave + 1
			If currentWave > maxWave Then Error "You appear to have survived all the waves."
		End If
		Print "Wave.Advance " + currentWave
		Local wave:Wave = New Wave(currentWave)
		If currentWave < - 50 Then
			currentWave = 0 - (100 + currentWave)
		End If
	End Function
	'Summary: Creates a new Wave of level <wave>.
	Method New(wave:Int)
		Print "*********************************"
		Print "Wave.New: " + wave + " called."
		Print "*********************************"
		Local enemy:Enemy
		'Depending upon the wave, execute the setup code for the start of the wave
		'The setup code instantiates the enemies.
'		Print "wave.New entered. wave=" + wave
		currentWave = wave
		Select wave
			Case -99 'Drop a lot of booty for debugging
				g.ScatterBooty(40)

			Case -98 'Drop only a little booty for debugging then 4 slow enemies
				g.ScatterBooty(5)

			Case -97 'Drop only micro booty for debugging
				g.ScatterBooty(3)

			Case -96 'Drop a bunch of booty for fly/carcass mode. Should be 20 booty and 20 enemies, so each wave/round is identical. Easy to spot object count leaks.
				g.ScatterBooty(20)

			Case -95 'Drop a shit-ton of booty for stress-test mode
				g.ScatterBooty(80)
				
			Case -94 'Drop just a few booty to see if the memory leak is on the booty side or the tank side
				g.ScatterBooty(4)
				
			Case -6 'Debug mode (find memory leak mode)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)
				enemy = New Enemy(4)

			Case -5 'Debug mode (stress test mode)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)

			Case -4 'Debug mode (flies picking off a carcass mode)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				
			Case -3 'Debug mode
				enemy = New Enemy(0)

			Case -2 'Debug mode.
				enemy = New Enemy(3)
				enemy = New Enemy(3)
				enemy = New Enemy(3)
				enemy = New Enemy(3)

			Case -1 'Debug mode.
				enemy = New Enemy(0) 'The number passed is 0-based. Levels start at zero for enemies, okay?!
				enemy = New Enemy(0)
				enemy = New Enemy(0)
				enemy = New Enemy(0)
				enemy = New Enemy(1)
				enemy = New Enemy(1)
				enemy = New Enemy(1)
				enemy = New Enemy(1)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)
'				enemy = New Enemy(3)
'				enemy = New Enemy(3)
'				enemy = New Enemy(3)
'				enemy = New Enemy(3)

			Case 0 'Very first start of the game
				g.ScatterBooty(8)
				enemy = New Enemy(0) 'The number passed is 0-based. Levels start at zero for enemies, okay?!
				enemy = New Enemy(0)
				enemy = New Enemy(0)

			Case 1
				enemy = New Enemy(0) 'The number passed is 0-based. Levels start at zero for enemies, okay?!
				enemy = New Enemy(0)
				enemy = New Enemy(0)
	
			Case 2
				enemy = New Enemy(0) 'The number passed is 0-based. Levels start at zero for enemies, okay?!
				enemy = New Enemy(0)
				enemy = New Enemy(1)
				
			Case 3
				enemy = New Enemy(0) 'The number passed is 0-based. Levels start at zero for enemies, okay?!
				enemy = New Enemy(1)
				enemy = New Enemy(1)
				enemy = New Enemy(0)

			Case 4
				enemy = New Enemy(1) 'The number passed is 0-based. Levels start at zero for enemies, okay?!
				enemy = New Enemy(1)
				enemy = New Enemy(1)
				enemy = New Enemy(1)

			Case 5
				enemy = New Enemy(1) 'The number passed is 0-based. Levels start at zero for enemies, okay?!
				enemy = New Enemy(1)
				enemy = New Enemy(1)
				enemy = New Enemy(2)

			Case 6
				enemy = New Enemy(2) 'The number passed is 0-based. Levels start at zero for enemies, okay?!
				enemy = New Enemy(2)
				enemy = New Enemy(2)
				enemy = New Enemy(2)

		End Select
	End Method
	
	Method Update()
		'Count the booty. Count the enemies.
		'If enemies is 0 wave over, time for a new wave.
		'If booty is 0 game over, time for you to do something else.
		If Enemy.enemyListAll.Count() < 1 Then
			Print "enemyListAll.Count <1. Clearing list."
			Enemy.enemyListAll.Clear
			Print "enemyListAll.Count after clearing list:" + Enemy.enemyListAll.Count()
			Select currentWave
				Case currentWave < 0'Debug case-- launch more enemies!
					currentWave = currentWave
					Wave.Advance()
				Default
					Wave.Advance()
			End Select
			gm = GMWAVEBREAK

		End If
		If Booty.CountAll() < 1 Then
			For Local booty:Booty = EachIn Booty.bootyListAll
				booty.Finalize()
			End For
			Booty.bootyListAll.Clear
			Booty.bootyListLoose.Clear
			If currentWave < 0 And currentWave > - 50 Then
				currentWave = - (100 - Abs(currentWave)) 'Have to do this to put it back into its complementary booty scatter stage
			Else
				Error("You appear to have lost the game!")
			End If
			For Local enemy:Enemy = EachIn Enemy.enemyListAll
				enemy.Finalize()
			End For
			Wave.Advance()
		End If
	End Method
	Method Finalize()
		'Wave End.
		'Remove targets.
	End Method
End Class