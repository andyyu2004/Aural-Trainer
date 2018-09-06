
-- =============================================================
-- mainMenu.lua
-- =============================================================

----------------------------------------------------------------------
--							Requires								--
----------------------------------------------------------------------
local composer 		= require( "composer" )
local scene    		= composer.newScene()
local widget 		= require( "widget" )
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Constants
local fullw = display.contentWidth
local fullh = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local yRelativePlacement = 150
local textSize = 85
----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view
	
	local background = display.newRect(centerX, centerY, fullw*1.2, fullh)
	background:setFillColor(0.08)
	sceneGroup:insert(background)
	-- Write title on the screen
	local options = 
	{
		parent = sceneGroup,
		text = "Learning",     
		x = centerX,
		y = 25 + yRelativePlacement,
		font = native.systemFontBold,   
		fontSize = 120,
		align = "center"  -- Alignment parameter
	}
 
	local title = display.newText( options )
	title:setFillColor(1,1,1)
	
	-- Note Button
	local function handleButtonEvent( event )
	if ( "ended" == event.phase ) then
		local options = 
		{
			effect = "fade",
			time = 500
		}
		composer.gotoScene( "scenes.noteScenePractice", options )
		end
	end

	local changeSceneButton = widget.newButton(
		{
			label = "Note",
			onEvent = handleButtonEvent,
			-- Properties for a rounded rectangle button
			shape = "roundedRect",
			width = 650,
			height = 150,
			cornerRadius = 30,
			fillColor = { default={1,1,1,0}, over={0.3} },
			font = native.systemFontBold, 
			--strokeColor = { default={255}, over={255} },
			--strokeWidth = 100,
			labelColor = { default = { 1}, over = { 0.1} },
		}
	)
	sceneGroup:insert(changeSceneButton)
	-- Center the button
	changeSceneButton._view._label.size = textSize
	changeSceneButton.x = centerX
	changeSceneButton.y = 250 + yRelativePlacement

	-- Interval 
	local function handleButtonEvent( event )
		if ( "ended" == event.phase ) then
		local options = 
		{
			effect = "fade",
			time = 500
		}
		composer.gotoScene( "scenes.intervalScenePractice", options )
		end
	end

	local changeSceneButton = widget.newButton(
		{
			label = "Interval",
			onEvent = handleButtonEvent,
			font = native.systemFontBold, 
			-- Properties for a rounded rectangle button
			shape = "roundedRect",
			width = 650,
			height = 150,
			cornerRadius = 30,
			fillColor = { default={1,1,1,0}, over={0.3} },
			--strokeColor = { default={255}, over={255} },
			--strokeWidth = 100,
			labelColor = { default = { 1 }, over = { 0.1} },
		}
	)
	sceneGroup:insert(changeSceneButton)
	-- Center the button
	changeSceneButton._view._label.size = textSize
	changeSceneButton.x = centerX
	changeSceneButton.y = 500 + yRelativePlacement

	-- Chord
	local function handleButtonEvent( event )
		if ( "ended" == event.phase ) then
		local options = 
		{
			effect = "fade",
			time = 500
		}
		composer.gotoScene( "scenes.chordScenePractice", options )
		end
	end

	local changeSceneButton = widget.newButton(
		{
			label = "Chord",
			onEvent = handleButtonEvent,
			font = native.systemFontBold, 
			-- Properties for a rounded rectangle button
			shape = "roundedRect",
			width = 650,
			height = 150,
			cornerRadius = 30,
			fillColor = { default={1,1,1,0}, over={0.3} },
			--strokeColor = { default={255}, over={255} },
			--strokeWidth = 100,
			labelColor = { default = { 1 }, over = { 0.1 } },
		}
	)
	sceneGroup:insert(changeSceneButton)
	changeSceneButton.alpha = 1
	-- Center the button
	changeSceneButton._view._label.size = textSize
	changeSceneButton.x = centerX
	changeSceneButton.y = 750 + yRelativePlacement	

	-- Scales
	local function handleButtonEvent( event )
		if ( "ended" == event.phase ) then
		local options = 
		{
			effect = "fade",
			time = 500
		}
		composer.gotoScene( "scenes.scaleScenePractice", options )
		end
	end

	local changeSceneButton = widget.newButton(
		{
			label = "Scale",
			onEvent = handleButtonEvent,
			font = native.systemFontBold, 
			-- Properties for a rounded rectangle button
			shape = "roundedRect",
			width = 650,
			height = 150,
			cornerRadius = 30,
			fillColor = { default={1,1,1,0}, over={0.3} },
			--strokeColor = { default={255}, over={255} },
			--strokeWidth = 100,
			labelColor = { default = { 1 }, over = { 0.1 } },
		}
	)
	sceneGroup:insert(changeSceneButton)
	-- Center the button
	changeSceneButton._view._label.size = textSize
	changeSceneButton.x = centerX
	changeSceneButton.y = 1000 + yRelativePlacement	
	
	-- Practice Mode
	local function handleButtonEvent( event )
		if ( "ended" == event.phase ) then
		local options = 
		{
			effect = "fade",
			time = 500
		}
		composer.gotoScene( "scenes.menuScene", options )
		end
	end

	local changeSceneButton = widget.newButton(
		{
			label = "Listening",
			onEvent = handleButtonEvent,
			font = native.systemFontBold, 
			-- Properties for a rounded rectangle button
			shape = "roundedRect",
			width = 650,
			height = 150,
			cornerRadius = 30,
			fillColor = { default={1,1,1,0}, over={0.3} },
			--strokeColor = { default={255}, over={255} },
			--strokeWidth = 100,
			labelColor = { default = { 1 }, over = { 0.1 } },
		}
	)
	sceneGroup:insert(changeSceneButton)
	-- Center the button
	changeSceneButton._view._label.size = textSize
	changeSceneButton.x = centerX
	changeSceneButton.y = 1250 + yRelativePlacement	
	-- Settings
	local function handleSettingsEvent( event )
		if ( "ended" == event.phase ) then
		local options = 
		{
			effect = "fade",
			time = 500
		}
		composer.gotoScene( "scenes.settingsScene", options )
		end
	end

	local settingsButton = widget.newButton(
		{
			onEvent = handleSettingsEvent,
			defaultFile = "images/settingsIcon2.png",
			width  = 350,
			height = 350,

		}
	)
	sceneGroup:insert(settingsButton)
	settingsButton.x = fullw - 250
	settingsButton.y = 1525 + yRelativePlacement	

	-- Information
	local function handleSettingsEvent( event )
		if ( "ended" == event.phase ) then
		local options = 
		{
			effect = "fade",
			time = 500
		}
		composer.gotoScene( "scenes.informationScene", options )
		end
	end

	local settingsButton = widget.newButton(
		{
			onEvent = handleSettingsEvent,
			defaultFile = "images/informationIcon.png",
			width  = 350,
			height = 350,

		}
	)
	sceneGroup:insert(settingsButton)
	settingsButton.x = 250
	settingsButton.y = 1525 + yRelativePlacement	

	local systemFonts = native.getFontNames()
	 
	-- Set the string to query for (part of the font name to locate)
	local searchString = "pt"
	 
	-- Display each font in the Terminal/console
	for i, fontName in ipairs( systemFonts ) do
	 
	    local j, k = string.find( string.lower(fontName), string.lower(searchString) )
	 
	    if ( j ~= nil ) then
	        print( "Font Name = " .. tostring( fontName ) )
	    end
	end
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didEnter( event )
	local sceneGroup = self.view
	
	-- remove the previous scene,  so that when it is reloaded it starts fresh
	local prevScene = composer.getSceneName( "previous" )
	if prevScene then
		composer.removeScene( prevScene ) 
		print("removing ", prevScene)
	end
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
	local sceneGroup = self.view
	Runtime:removeEventListener("options", self.setOptions)
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExit( event )
	local sceneGroup = self.view

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
function scene:show( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willEnter( event )
	elseif( willDid == "did" ) then
		self:didEnter( event )
	end
end
function scene:hide( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willExit( event )
	elseif( willDid == "did" ) then
		self:didExit( event )
	end
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------
return scene
