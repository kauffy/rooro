Import RipOff

'#Region "Constants and Globals"
Const GMTITLE:Int = 0 'Summary: Game Mode: Title Screen
Const GMPLAY:Int = 1 'Summary: Game Mode: Play
Const GMMENU:Int = 2 'Summary: Game Mode: Menu
Const GMWAVEBREAK:Int = 3 'Summary Game Mode: Wave Break (in-between waves)

Const GRPPLAYER:Int = 1 'Summary: Collision group for player tanks
Const GRPENEMY:Int = 2 'Summary: Collision group for enemy tanks
Const GRPBOOTY:Int = 3 'Summary: Collision group tor booty objects
Const GRPSHOTPLAYER:Int = 4 'Summary: Collision group for shots fired by players
Const GRPSHOTENEMY:Int = 5 'Summary: Collision group for shots fired by enemies
Const GRPFX:Int = 6 'Summary: Collision group for visual effects that just look pretty and don't collide with anything
Const GRPESCAPE:Int = 7 'Summary: Collision group for escape zones. Enemies and booty collide with these to score points.

Const TRGGETBOOTY:Int = 1 'Summary: Target Type: Booty
Const TRGESCAPE:Int = 2 'Summary: Target Type: Get the Hell Out of Here!
Const TRGKILL:Int = 3 'Summary: Target Type: I'mma killa somebody!
Const TRGPICKUP:Int = 4 'Summary: Target Type: Don't do any navigating. We have collided with a booty, now we want to hitch it.

Const MMNORMAL:Int = 1 'Summary: Move mode normal. Drive toward nav/target as fast as I can.
Const MMPICKUP:Int = 2 'Summary: Move mode pickup. For future use. Intended to allow an enemy to sit idle while spinning to hitch a pickup.

Const TMROBJECTREMOVE:Int = 2 'Summary: Defines a value for the type of timer used with SetObjectTimer in ftEngine. This is a timer to remove an object at the end, to decay temporaries.
Const TMROBJECTACTIVATE:Int = 3 'Summary: This timer will activate the object at the end of its time.

Const FIELDBORDERWIDTH:Int = 10 'Summary: How much of a margin to set around the border for player tank to collide with?

Const AINODEDISTANCEFACTOR:Float = 3.0 'Summary: At what distance to set the node between me and the target? (2 is half way, 3 would be a third of the way).
Const AIWINDOWMAX:Float = 135.0 'Summary: What is the maximum angle width for the window of random angles. This window is the cone of possible angles for nodes with the intended angle at the center.
Const AIMINDISTANCEFORPATHING:Float = 30 'Summary: What is the minimum distance at which we stop generating new nodes and just go at the target?
Const DYNZEROSPEEDTURNFACTOR:Float = 1.7 'Summary: How much greater is turning ability at zero speed as opposed to at max speed?


Global eng:engine

Global g:RipOff.game 'Summary: The global variable for the game class instance.

Global fieldWidth:Float 'Summary: The total width of the playfield.
Global fieldHeight:Float 'Summary: The total height of the playfield.
Global fieldCenterFactor:Int = 5 ' Summary: The factor by which to divide field and height to determine center field and player starts. MUST BE AN ODD NUMBER!

Global fieldCenterLeftEdge:Float = (fieldWidth / fieldCenterFactor) * (Floor(fieldCenterFactor / 2.0))
Global fieldCenterRightEdge:Float = (fieldWidth / fieldCenterFactor) * (Round(fieldCenterFactor / 2.0))
Global fieldCenterTopEdge:Float = (fieldHeight / fieldCenterFactor) * (Floor(fieldCenterFactor / 2.0))
Global fieldCenterBottomEdge:Float = (fieldHeight / fieldCenterFactor) * (Round(fieldCenterFactor / 2.0))

Global tankPlayerImage:Image[] 'Summary: An array to hold images for players 1-4
Global tankEnemyImage:Image[] 'Summary: An array to hold images for enemy tanks, (e.g., level 1, level 2, level 3, level 4)
Global bootyImage:Image[] 'Summary: An array to hold images for booty (or other power-ups, etc.)
Global shotImage:Image[] 'Summary: An array to hold images for shots

Global shotSound:Sound[] 'Summary: An array to hold sound effects for shots
Global explosionSound:Sound[] 'Summary: An array to hold sound effects for 'splosions
Global gm:Int = GMPLAY 'Summary: Game mode. 0 = Title/GameOver/Attract, 1 = Play, 2 = Menu/Pause

Global layBackground:ftLayer 'Summary: Layer for background (if we choose to have one in the future).
Global layGame:ftLayer 'Summary: Layer for game elements.
Global layUI:ftLayer 'Summary: Layer for the user interface.
Global layMenu:ftLayer 'Summary: Layer for the menu (distinct from the user interface).

Global waveNum:Int 'Summary: What is the current wave of the game?
Global cntBooty:Int 'Summary: What is the count of total booty still left in-play (not carried, not already stolen). When this hits zero, game ends, player loss.
Global cntEnemy:Int 'Summary: What is the total number of active enemies right now-- when this hits zero, wave ends, player victory.

Global cntLastGobs:Int 'Summary: Debug variable to count how many ftObjects there are and to only print the count if it changes.
'#EndRegion

