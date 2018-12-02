Strict
#REM
	Summary:
	A generic class set for managing a list of assets. This is a fundamental structure for asset management.
	That is, this class maintains a list of assets (whatever they may be). When a new one is requested, this
	class will check to see if it has a disused (retired) asset in its list and recycle it, otherwise, it will
	transparently request a new one.
	
	The list members are of the Asset type which contains both a reference to the asset in question and some flags and other data about the asset's membership in the list.

#END

Import kauffygrounds

'Summary: Class to manage asset lists/object pools. This is the list itself.
Class AssetList<classType>
	Private
		Field _assets:Asset<classType>[]
		
		'Summary: Method to instantiate a new AssetList of size preInitSize elements (initially)
		Method New(preInitSize:Int)
			_assets = New Asset<classType>[preInitSize]
			
			'Should go through an allocate all of the assets at once, then mark each as retired (empty)
			For Local alCursor:Int = 0 Until _assets.Length()
				_assets[alCursor] = New Asset<classType>
				_assets[alCursor].retired = True
			End For
			Return
		End Method

	Public
		'Summary: Method to issue a new element in the AssetList
		Method Issue:Asset<classType>()
			'Initial implementation-- just crawl the list and look for .retired = True
			For Local alCursor:Int = 0 Until _assets.Length()
				If _assets[alCursor].retired = True Then
					_assets[alCursor].Clear()
					Return _assets[alCursor]
				End If
			End For
			Print "AssetList.Issue did not find a retired asset to give."
			Return Null
		End Method
		
		'Summary: Method to read an element from the underlying array by index (for iterating the list 'n stuff)
		Method GetAssetByIndex:Asset<classType>(index:Int)
			Return _assets[index]
		End Method
		
		'Summary: Method to wipe out an AssetList for garbage collection. This is unlikely to be done, I think.
		Method Finalize:Void()
			Self.Clear()
			Return
		End Method
		
		'Summary: Method to add a new Asset to the list.
		Method Add:Void(newAsset:classType)
			Return
		End Method
		
		'Summary: Method to return the size of the AssetList as though it were an array.
		Method Length:Int()
			Return _assets.Length()
		End Method
		
	Private
		'Summary: Method to empty out all of the assets in an AssetList.
		Method Clear:Void()
			For Local assetCursor:Asset<classType> = EachIn Self._assets
				assetCursor.Clear()
			End For
			Return
		End Method
		
End Class

'Summary: Class for the assets in an asset list itself-- this is the object stored, plus some flags or other data.
Class Asset<classType>
	Private
		Field content:classType 'Summary: Reference to an object that the owning asset list is about.
		Field retired:Bool 'Summary: Flag to determine whether this asset entry can be re-used or not.
		
	Public
		Method New()
			Self.content = Null
			Self.retired = True
			Return
		End Method
		
		Method Retire:Void()
			Self.retired = True
			Return
		End Method
		
		Method Clear:Void()
			Self.content = Null
			Self.Retire()
		End Method
		
		Method GetContent:classType()
			Return Self.content
		End Method
		
		Method SetContent:Void(newContent:classType)
			Self.content = newContent
			Self.retired = False
		End Method
End Class