Strict
#REM
	Summary:
	A collection of classes and functions for working with 2D space.
#END

Import kauffygrounds

Class Vector2Di
	Field x:Int
	Field y:Int
	
	Method New(newX:Int, newY:Int)
		Self.x = newX
		Self.y = newY
	End Method

End Class

Class Vector2Dray
	Field r:Float
	Field angle:Float
	
	Method New(newR:Float = 0.0, newAng:Float = 0.0)
		Self.r = newR
		Self.angle = newAng
	End Method
End Class

Function Distance:Float(point1:Vector2D, point2:Vector2D)
	Local dx:Float = point1.x - point2.x
	Local dy:Float = point1.y - point2.y
	Return Sqrt( (dx * dx) + (dy * dy))
End Function

Function Distance:Float(point1x:Float, point1y:Float, point2x:Float, point2y:Float)
	Local dx:Float = point1x - point2x
	Local dy:Float = point1y - point2y
	Return Sqrt( (dx * dx) + (dy * dy))
End Function

Function MidPoint:Vector2D(point1:Vector2D, point2:Vector2D)
	Local midpoint:Vector2D = New Vector2D
	midpoint.x = (point1.x + point2.x) / 2
	midpoint.y = (point1.y + point1.y) / 2
	Return midpoint
End Function

Function MidPoint:Vector2D(point1x:Float, point1y:Float, point2x:Float, point2y:Float)
	Local midpoint:Vector2D = New Vector2D
	midpoint.x = (point1.x + point2.x) / 2
	midpoint.y = (point1.y + point1.y) / 2
	Return midpoint
End Function

Function GetBearing:Vector2Dray(targX:Float, targY:Float)
	Local ray:Vector2Dray = New Vector2Dray
	ray.r = Sqrt( (targX * targX) + (targY * targY))
	ray.angle = ATan2(targX, targY)'+90.0 '##FIX ME Add 90 degrees for some reason? 
	If ray.angle < 0 Then ray.angle = 360 + ray.angle
	Return ray
End Function

Function GetCoords:Vector2D(ray:Vector2Dray)
	Local coords:Vector2D = New Vector2D
	coords.x = ray.r * Sin(ray.angle)
	'If coords.x < 0.001 Then coords.x = 0.0 'Does not work-- screws up negative angles. Duh.
	coords.y = ray.r * - (Cos(ray.angle))
	'If coords.y < 0.001 Then coords.y = 0.0 'Does not work-- screws up negative angles. Duh.
	Return coords
End Function

Function GetCoords:Vector2D(rayMagnitude:Float, rayAngle:Float)
	Local coords:Vector2D = New Vector2D
'#IF CONFIG="debug"
'	Print "Coords called with: r:" + rayMagnitude + ", a:" + rayAngle
'#ENDIF
	coords.x = rayMagnitude * Sin(rayAngle)
	'If coords.x < 0.001 Then coords.x = 0.0 'Does not work-- screws up negative angles. Duh.
	coords.y = rayMagnitude * - (Cos(rayAngle))
	'If coords.y < 0.001 Then coords.y = 0.0 'Does not work-- screws up negative angles. Duh.

'#IF CONFIG="debug"
'	Print "Coords returning: " + coords.x + "," + coords.y
'#ENDIF
	Return coords
End Function