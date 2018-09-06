-- =============================================================
-- noteScene.lua
-- Creates the game enviroment
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()
local widget 		= require( "widget" )

----------------------------------------------------------------------
--							Requires								--
----------------------------------------------------------------------
local sceneManager	= require ("classes.practiceSceneManager")
local pt = require("classes.printTable")
----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Constants
local fullw = display.contentWidth
local fullh = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view
	
	local background = display.newRect(centerX, centerY, fullw*1.2, fullh)
	background:setFillColor(0.08)
	sceneGroup:insert(background)

	local options = 
	{
		parent = sceneGroup,
		text = "Note",     
		x = centerX,
		y = 150,
		font = native.systemFontBold,   
		fontSize = 120,
		align = "center"  -- Alignment parameter
	}
 
	local title = display.newText( options )
	title:setFillColor(1,1,1)
	

	-- call the the main game class and pass over the options table
	local sceneManager = sceneManager:new(sceneGroup, "note", options)

	local function handleSettingsEvent( event )
		if ( "ended" == event.phase ) then
		local options = 
		{
			effect = "fade",
			time = 500
		}
		composer.gotoScene( "scenes.practiceScene", options )
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
	local prevScene = composer.getSceneName( "previous" )
	if prevScene then
		composer.removeScene( prevScene ) 
	end
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
	local sceneGroup = self.view
	Runtime:removeEventListener("setOptions", self.setOptions)
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
