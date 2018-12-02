Strict
#REM
	This is a file for testing each of the features of kauffygrounds.
#END

Import kauffygrounds

Class TestBed Extends App
	Method New()
		TestAssetList
	End Method
End Class

Function Main:Int()
	Local tb:TestBed = New TestBed
	Return 0
End Function

Function TestAssetList:Int()
	Local startTime:Int = Millisecs()
	Local al:AssetList<Widget>
	Local aw:Asset<Widget>
	Local w:Widget
	al = New AssetList<Widget>(1000)
	Print "Filling AssetList.."
	For Local alCursor:Int = 0 Until al.Length()
		aw = al.Issue()
		w = New Widget()
		w.A = alCursor
		w.B = "Item #" + String(alCursor + 1)
		w.C = Rnd(0, 1)
		aw.SetContent(w)
	End For
	Print "AssetList filled.."
	Print "Elapsed: " + ( (Millisecs() -startTime) / 1000.0) + " seconds."
	Print "Wiping out AssetList.."
	al.Finalize()
	Print "Filling AssetList.."
	For Local alCursor:Int = 0 Until al.Length()
		aw = al.Issue()
		w=New Widget()
		w.A = alCursor
		w.B = "Item #" + String(alCursor + 1)
		w.C = Rnd(0, 1)
		aw.SetContent(w)
	End For
	Print "Elapsed: " + ( (Millisecs() -startTime) / 1000.0) + " seconds."
	Print "Dumping contents."
	For Local alCursor:Int = 0 Until al.Length()
		w = al.GetAssetByIndex(alCursor).GetContent()
		Print "Widget #: " + w.A + " String: " + w.B + " Float: " + w.C
	End For
	Return 0
	
End Function

Class Widget
	Field A:Int
	Field B:String
	Field C:Float
	
	
End Class