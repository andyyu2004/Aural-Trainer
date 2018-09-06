
-- =============================================================

--======================================================================--
--== sceneManager Class factory
--======================================================================--
local settingsManager = class() -- define sceneManager as a class (notice the capitals)
settingsManager.__name = "settingsManager" -- give the class a name
--======================================================================--
--== Require dependant classes
--======================================================================--
local pt = require("classes.printTable") 
local widget = require ("widget")
-- Constants
local fullw = display.contentWidth
local fullh = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local yRelativePlacement = 0

local button = require("classes.button")
local loadsaveModule = require("classes.loadsave")
--======================================================================--
--== Initialization / Constructor
--======================================================================--
function settingsManager:__init(group, options)
	self.group = group
	
    self:createSettingsTable()

	end

--======================================================================--
--== Code / Methods
--======================================================================--
local settingsTable

function settingsManager:createSettingsTable()
    settingsTable = loadsaveModule.loadTable("settings.asdfgh")
    --loadsaveModule.print_r(settingsTable)    
    self.minimumOctave = settingsTable.minimumOctave
    self.maximumOctave = settingsTable.maximumOctave
    self.referenceC =   settingsTable.referenceC
    self.notePracticeOctave = settingsTable.practiceNoteOctave
    self.pitchCleansing = settingsTable.pitchCleansing
    self.timer = settingsTable.timerEnabled
    --print(self, self.minimumOctave, self.maximumOctave, self.referenceC)
    self:createSettings()
end

function settingsManager:drawArrowButton(rotation,x,y,setting)
	-- Function to handle button events
    local function handleButtonEvent( event )
        if ( "ended" == event.phase ) then
            if setting == "self.minimumOctave" then
                if rotation == 90 and self.minimumOctave < 5 and self.minimumOctave < (self.maximumOctave-1) then
                    self.minimumOctave = self.minimumOctave + 1
                    self.lowestOctaveDisplay.text = "Lowest Note Octave:           "..self.minimumOctave
                elseif rotation == 270 and self.minimumOctave > 2 then
                    self.minimumOctave = self.minimumOctave - 1
                    self.lowestOctaveDisplay.text = "Lowest Note Octave:           "..self.minimumOctave
                end    
                --print(self.minimumOctave)
            elseif setting == "self.maximumOctave" then
                if rotation == 90 and self.maximumOctave < 6 then
                    self.maximumOctave = self.maximumOctave + 1
                    self.highestOctaveDisplay.text = "Highest Note Octave:           "..self.maximumOctave
                elseif rotation == 270 and self.maximumOctave > 3 and (self.maximumOctave - 1) > self.minimumOctave then
                    self.maximumOctave = self.maximumOctave - 1
                    self.highestOctaveDisplay.text = "Highest Note Octave:           "..self.maximumOctave
                end    
            elseif setting == "practiceOctave" then
                 if rotation == 90 and self.notePracticeOctave < 5 then
                    self.notePracticeOctave = self.notePracticeOctave + 1
                    self.practiceOctave.text = "Learning Note Octave:           "..self.notePracticeOctave
                elseif rotation == 270 and self.notePracticeOctave > 2 then
                    self.notePracticeOctave = self.notePracticeOctave - 1
                    self.practiceOctave.text = "Learning Note Octave:           "..self.notePracticeOctave
                end    
            end
        end
    end
    self.button = widget.newButton(
        {
            width = 80,
            height = 80,
            defaultFile = "images/arrow.png",
            --overFile = "buttonOver.png",
            --label = "button",
            onEvent = handleButtonEvent
        }
    )
     
    -- Center the button
    self.button.x = x
    self.button.y = y
    --self.button = display.newImageRect(self.control, self.image, 27, 27 )
    self.button.rotation = rotation
    self.group:insert(self.button)
    --Change the button's label text
    --button1:setLabel( "2-Image" )
end

function settingsManager:drawBooleanButton(x,y,setting)
    local booleanButton = {}
    local handleButtonEvent = function( event )
        if ( "ended" == event.phase ) then
            if setting == "referenceNote" then
                if self.referenceC == "True" then
                    self.referenceC = "False"
                elseif self.referenceC == "False" then
                    self.referenceC = "True" 
                end
                booleanButton[setting]:setLabel(self.referenceC)
            elseif setting == "Pitch Cleansing Noises" then 
                if self.pitchCleansing == "True" then
                    self.pitchCleansing = "False"    
                elseif self.pitchCleansing == "False" then
                    self.pitchCleansing = "True" 
                end
                booleanButton[setting]:setLabel(self.pitchCleansing)
            elseif setting == "Timer" then
                if self.timer == "True" then
                    self.timer = "False"
                elseif self.timer == "False" then
                    self.timer = "True"
                end
                booleanButton[setting]:setLabel(self.timer)
            end
        --print(self.referenceC)

        end
    end
    booleanButton[setting] = widget.newButton(
        {
            label = "",
            onEvent = handleButtonEvent,
            shape = "rectangle",
            width = 200,
            height = 52,
            cornerRadius = 5,
            fillColor = { default={1}, over = {0.3} },
            font = native.systemFontBold, 
            --strokeColor = { default={255}, over={255} },
            --strokeWidth = 100,
            labelColor = { default = { 0, 0, 0 }, over = { 163, 25, 12} },
        }
    )
    if setting == "referenceNote" then
        booleanButton["referenceNote"]:setLabel(self.referenceC)
    elseif setting == "Pitch Cleansing Noises" then
        booleanButton["Pitch Cleansing Noises"]:setLabel(self.pitchCleansing)
    elseif setting == "Timer" then
        booleanButton["Timer"]:setLabel(self.timer)
    end
    booleanButton[setting].x = x
    booleanButton[setting].y = y
    self.group:insert(booleanButton[setting])
    booleanButton[setting]._view._label.size = 55
    --pt.print_r(booleanButton)
end

function settingsManager:createSettings()
    self.lowestOctaveDisplay = display.newText( self.group, "Lowest Note Octave:           "..self.minimumOctave, 850, 500 + yRelativePlacement, native.systemFontBold, 52 )
    self.lowestOctaveDisplay.anchorX = 1
    self.highestOctaveDisplay = display.newText( self.group, "Highest Note Octave:           "..self.maximumOctave, 850, 580 + yRelativePlacement, native.systemFontBold, 52 )
    self.highestOctaveDisplay.anchorX = 1
    self.referenceNoteDisplay = display.newText( self.group, "Reference Note:", 660, 740 + yRelativePlacement, native.systemFontBold, 52 )
    self.referenceNoteDisplay.anchorX = 1
    self.practiceOctave = display.newText( self.group, "Learning Note Octave:           "..self.notePracticeOctave, 850, 660 + yRelativePlacement, native.systemFontBold, 52 )
    self.practiceOctave.anchorX = 1
    self.pitchCleansingDisplay = display.newText( self.group, "Pitch Cleansing Noise:", 660, 815 + yRelativePlacement, native.systemFontBold, 50 )
    self.pitchCleansingDisplay.anchorX = 1
    self.pitchCleansingDisplay = display.newText( self.group, "Timer Enabled:", 660, 890 + yRelativePlacement, native.systemFontBold, 52 )
    self.pitchCleansingDisplay.anchorX = 1

    self:drawArrowButton(90, 925, 500, "self.minimumOctave")
    self:drawArrowButton(270, 740, 500, "self.minimumOctave")
    self:drawArrowButton(90, 925, 580, "self.maximumOctave")
    self:drawArrowButton(270, 740, 580, "self.maximumOctave")
    self:drawBooleanButton(820, 742, "referenceNote")
    self:drawArrowButton(90, 925, 665, "practiceOctave")
    self:drawArrowButton(270, 740, 655, "practiceOctave")
    self:drawBooleanButton(820, 815, "Pitch Cleansing Noises")
    self:drawBooleanButton(820, 890, "Timer")
end

function settingsManager:loadSaveSettings(operation)
    --print(self, self.minimumOctave, self.maximumOctave, self.referenceC)
    --local settingsTable = {}
    settingsTable.minimumOctave = self.minimumOctave
    settingsTable.maximumOctave = self.maximumOctave
    settingsTable.referenceC = self.referenceC
    settingsTable.practiceNoteOctave = self.notePracticeOctave
    settingsTable.pitchCleansing = self.pitchCleansing
    settingsTable.timerEnabled = self.timer
    if operation == "save" then 
        loadsaveModule.saveTable(settingsTable, "settings.asdfgh")
        --loadsaveModule.print_r(settingsTable)
        print("saving settings")
        loadsaveModule.print_r(settingsTable)
    end
end

--======================================================================--
--== Return factory
--======================================================================--
return settingsManager
