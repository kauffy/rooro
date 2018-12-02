Strict
#REM
	Summary:
	A collection of classes and functions for working with time and timescales.
	
	For example, when game time is not analogous to real-time (you want to use time units other than millisecs, or you want to stop time advancing when you pause)
	or you want to be able to alter time scale (switch to fast-forward or slow-mo).
#END

Import kauffygrounds
#REM
	Summary:
	A class for an alternative clock. This allows in-game events to be keyed to a clock you can control.
	You would create the clock in OnCreate() and then anyplace else you would use Millisecs() you use clock.GetTime().
	NOTE: This works best for a KGClock that is also keyed to Millisecs-- unless all other functions you will be using are also scaled to use whatever unit you intend.
	
	Optionally:
	1) You can start the clock at a time other than 0, for example, if you wanted to use the clock to count alternate real-world time, you could start the clock at any given serial date in
		history-- check whatever serial-to-date function you are using for what settings to use.
	2) You can set the base scale of the clock to a different unit-- if you want it to count alternate-world "minutes", you could set the basescale to 60000. Then this alternate clock would
		count only one "minute" per 60,000 millisecs.
	3) You can set the clock to start paused or not. If you start it paused, it will remain at 0 (or whatever you set the time to start at) until UnPause is called.
#END
Class KGClock
	Private
		Field time:Int 'Summary: Value of the clock currently. #NOTE: Contemplating turning this into a float.
		Field baseScale:Float 'Summary: Ratio of Millisecs to this clock's unit. A value of 1000 here means 1 unit on this clock passes per second.
		Field playScale:Float 'Summary: Ratio of passage of time to 'normal' as defined above.
		Field lastPlayScale:Float 'Summary: Last playscale prior to a pause, because pause is playscale 0.
		Field lastUpdated:Int 'Summary: Time in Millisecs the kgClock was last updated.
		Field lastPaused:Int 'Summary: Time in Millisecs the kgClock was paused.
		Field isPaused:Bool 'Summary: Is kgClock time paused from advancing?
		
	Public
#REM
		'Summary:
		Creates a new clock starting with the value newtime, at the given base scale, and either paused or counting immediately. The value given is in whatever units you want this clock to represent.
		You can create multiple clocks in multiple base scales-- and as long as you pause and adjust them together consistently, they will remain relatively correct to each-other.
		For example, you could create one clock that is in Millisecs and starts at 0 and key all your graphics to that, so it pauses along with the game.
		And then create a second clock, in seconds, that starts off with the date-serial value of January 1, 1939.
		As long as both clocks are updated together, both clocks are paused at the same time, and both clocks have their scales updated together, you will have a clock to tell you
		millisecond flow AND a clock to tell you the flow of history that is compatible with normal serial-to-date functions.			

#END		
		Method New(newTime:Int = 0, newScale:Int = 1, startPaused:Bool = False) 'Default to a fresh clock, and default to millisecs.
			Self.time = newTime
			Self.baseScale = newScale
			Self.playScale = 1.0
			Self.lastPlayScale = Self.playScale
			If startPaused = True Then
				Self.lastPaused = Millisecs()
				Self.isPaused = True
				Self.playScale = 0.0
			Else
				Self.isPaused = False
			End If
			Self.lastUpdated = Millisecs()
		End Method
		'Summary: Updates the given clock. Should be called as frequently as makes sense for your application, but typically, throw a call in OnUpdate().
		Method Update:Void()
			If Self.isPaused = True Then Return
			Self.time = Self.time + ( ( (Millisecs() -Self.lastUpdated) / Self.baseScale) * Self.playScale)
			Self.lastUpdated = Millisecs()
			Return
		End Method
		'Summary: Returns the time value stored in the given clock. This is analogous to Millisecs().
		Method GetTime:Int()
			Return time
		End Method
		'Summary: Stops the advancement of time on this clock.
		Method Pause:Void()
			If Self.isPaused = True Then Return
			Self.Update() 'One last call to Update to make sure we captured everything.
			Self.isPaused = True
			Self.lastPlayScale = Self.playScale 'Preserve the last playscale we were using, so we can return to it after a pause.
			Self.playScale = 0.0
		End Method
		'Summary: Resumes the advancement of time on this clock.
		Method Unpause:Void()
			If Self.isPaused = False Then Return
			Self.lastUpdated = Millisecs()
			Self.isPaused = False
			Self.playScale = Self.lastPlayScale
		End Method
		'Summary: Convenience function to flip the state of Pause on this clock.
		Method TogglePause:Void()
			If Self.isPaused = True Then
				Self.Unpause()
			Else
				Self.Pause()
			End If
		End Method
		'Summary: Returns whether the clock is paused or not.
		Method IsPaused:Bool()
			Return Self.isPaused
		End Method
		'Summary: Property of what the playscale is. For example, if the playscale is 2.0, then time advances twice as fast on this clock as the Millisecs() clock does.
		Method PlayScale:Void(newPlayScale:Float) Property
			If newPlayScale = 0 Or Self.isPaused = True Then Return
			Self.playScale = newPlayScale
		End Method
		'Summary: Propert to read the current playscale.
		Method PlayScale:Float() Property
			Return Self.playScale
		End Method
End Class