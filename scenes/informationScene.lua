----------------------------------------------------------------------
--							Requires								--
----------------------------------------------------------------------
local composer 		= require( "composer" )
local scene    		= composer.newScene()
local widget 		= require( "widget" )
local pt 			= require ("classes.printTable")
local loadSaveM 	= require ("classes.loadsave")
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Constants
local fullw = display.contentWidth
local fullh = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local yRelativePlacement = 150
local settingsTable
----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------

function scene:create( event )
	local sceneGroup = self.view
	settingsTable = loadSaveM.loadTable("settings.asdfgh")
	local tCIA = settingsTable.totalCorrectIntervalAttempts
	local tCNA = settingsTable.totalCorrectNoteAttempts
	local tCSA = settingsTable.totalCorrectScaleAttempts
	local tCCA = settingsTable.totalCorrectChordAttempts

	local tNA = settingsTable.totalNoteAttempts 
	local tIA = settingsTable.totalIntervalAttempts 
	local tSA = settingsTable.totalScaleAttempts 
	local tCA = settingsTable.totalChordAttempts 

	local totalAttempts = settingsTable.totalAttempts

	local noteAccuracy = 0 
	if tNA ~= 0 then
		noteAccuracy = math.round((tCNA/tNA*100))
	end
	local intervalAccuracy = 0 
	if tIA ~= 0 then
		intervalAccuracy = math.round((tCIA/tIA*100))
	end
	local chordAccuracy = 0 
	if tCA ~= 0 then
		chordAccuracy = math.round((tCCA/tCA*100))
	end
	local scaleAccuracy = 0
	if tSA ~= 0 then
		scaleAccuracy = math.round((tCSA/tSA*100))
	end
	local totalAccuracy = 0
	if (tCIA + tCNA + tCSA + tCCA) ~= 0 then
		totalAccuracy = math.round(((tCIA + tCNA + tCSA + tCCA)/totalAttempts*100))
	end
	local background = display.newRect(centerX, centerY, fullw*1.2, fullh)
	background:setFillColor(0.08)
	sceneGroup:insert(background)
	
	-- Write title on the screen
	local options = 
	{
		parent = sceneGroup,
		text = "Information",     
		x = centerX+125,
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

	local options = {
		parent = sceneGroup,
		text = 
		"This is the information scene \nHave funa asd as\nasskjashdfaksjfdh sk\a\a\a",
		x = centerX,
		y = centerY,
		font = native.systemFont,
		fontSize = 80,
		align = "left"
	}
	--local informationText = display.newText(options)

	local statisticsTextOptions = {
		parent = sceneGroup,
		text = "",
		x = centerX,
		y = centerY,
		width = 800,
		font = native.systemFont,
		fontSize = 50,
		align = "left"
	}
	local statisticsText = display.newText(statisticsTextOptions)
	statisticsText.text = "Note Accuracy = "..noteAccuracy.."%\nInterval Accuracy = ".. intervalAccuracy.."%\nChord Accuracy = ".. chordAccuracy.."%\nScale Accuracy = ".. scaleAccuracy .."%\nOverall Accuracy = "..totalAccuracy.."%"

local statisticsTextOptions2 = {
		parent = sceneGroup,
		text = "",
		x = centerX,
		y = 1300,
		width = 800,
		font = native.systemFont,
		fontSize = 50,
		align = "left"
	}
	local statisticsText2 = display.newText(statisticsTextOptions2)
	statisticsText2.text = "Total Note Attempts = "..tNA.."\nTotal Interval Attempts = ".. tIA.."\nTotal Chord Attempts = ".. tCA.."\nTotal Scale Attempts = ".. tSA .."\nTotal Attempts = "..totalAttempts..""

local instructionTextOptions = {
		parent = sceneGroup,
		text = "Use the Listening Page to test yourself, and use the learning page to learn the sounds",
		x = centerX,
		y = 500,
		width = 800,
		font = native.systemFont,
		fontSize = 50,
		align = "left"
	}
	local instructionText = display.newText(instructionTextOptions)
	
	-- Reset Button
	local function resetSettings( event )
		if ( "ended" == event.phase ) then

			local defaultTable =  {}
	        print("fick")
	        defaultTable.minimumOctave = 2
	        defaultTable.maximumOctave = 6
	        defaultTable.referenceC = "False"
	        defaultTable.pitchCleansing = "True"
	        defaultTable.practiceNoteOctave = 4
	        defaultTable.timerEnabled = "True"
	        
	        defaultTable.totalAttempts = 0
	        
	        defaultTable.totalNoteAttempts = 0
	        defaultTable.totalIntervalAttempts = 0
	        defaultTable.totalChordAttempts = 0
	        defaultTable.totalScaleAttempts = 0

	        defaultTable.totalCorrectNoteAttempts = 0
	        defaultTable.totalCorrectIntervalAttempts = 0
	        defaultTable.totalCorrectChordAttempts = 0
	        defaultTable.totalCorrectScaleAttempts = 0
	        --print("settingsdontExist")
	        loadSaveM.saveTable(defaultTable, "settings.asdfgh")
	        
		end
	end

	local resetButton = widget.newButton(
		{
			label = "Reset",
			onEvent = resetSettings,
			-- Properties for a rounded rectangle button
			shape = "roundedRect",
			width = 750,
			height = 150,
			cornerRadius = 15,
			fillColor = { default={1}, over={1,0,0} },
			font = native.systemFontBold, 
			--strokeColor = { default={255}, over={255} },
			--strokeWidth = 100,
			labelColor = { default = { 0, 0, 0 }, over = { 163, 25, 12} },
		}
	)
	sceneGroup:insert(resetButton)
	-- Center the button
	resetButton._view._label.size = 50
	resetButton.x = centerX
	resetButton.y = fullh - 250
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
