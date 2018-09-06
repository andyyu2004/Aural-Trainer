-- =============================================================
-- Written by Craig Briggs.  Feel free to modify and reuse in anyway.
--
-- mainMenu.lua
-- Main menu the user will be presented with
-- =============================================================

----------------------------------------------------------------------
--							Requires								--
----------------------------------------------------------------------
local composer 		= require( "composer" )
local scene    		= composer.newScene()
local widget 		= require( "widget" )
local settingsManagerM 	= require("classes.settingsManager")
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Constants
local fullw = display.contentWidth
local fullh = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local yRelativePlacement = 150
local settingsManager
----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view
	
	local background = display.newRect(centerX, centerY, fullw*1.2, fullh)
	background:setFillColor(0.08)
	sceneGroup:insert(background)

	settingsManager = settingsManagerM:new(sceneGroup, options)
	
	-- Write title on the screen
	local options = 
	{
		parent = sceneGroup,
		text = "Settings",     
		x = centerX+50,
		y = 50 + yRelativePlacement,
		font = native.systemFontBold,   
		fontSize = 100,
		align = "center"  -- Alignment parameter
	}
 
	local title = display.newText( options )
	title:setFillColor(1,1,1)
	
	local function handleSettingsEvent( event )
		if ( "ended" == event.phase ) then
		--settingsManager:loadSaveSettings("save")
		local options = 
		{
			effect = "fade",
			time = 500
		}
		composer.gotoScene( composer.getSceneName( "previous" ), options )
		end
	end
	local menuButton = widget.newButton(
		{
			onEvent = handleSettingsEvent,
			defaultFile = "images/menuIcon.png",
			width  = 300,
			height = 140,

		}
	)
	sceneGroup:insert(menuButton)
	menuButton.x = fullw/6
	menuButton.y = 150		

	local instructionTextOptions = {
		parent = sceneGroup,
		text = "The note octave settings controls the lowest and highest octave the app will play in the listening note mode\nThe learning note octave controls the octave of the learning note mode\nOctaves are in scientific pitch notation " ,
		x = centerX,
		y = centerY + 300,
		width = 800,
		font = native.systemFont,
		fontSize = 48,
		align = "left"
	}
	local instructionText = display.newText(instructionTextOptions)
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
		composer.removeScene( prevScene, true ) 
	end
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
	local sceneGroup = self.view
	--settingsManager:loadSaveSettings(settingsManager, "save")
	settingsManager:loadSaveSettings("save")
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
