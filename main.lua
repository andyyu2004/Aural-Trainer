-- Main.lua 
-----------------------------------------------------------------------------------------
--Requires
-----------------------------------------------------------------------------------------
local composer 	= require "composer" 
require("classes.30logglobal")
loadsaveModule = require("classes.loadsave")
local settingsTable
-----------------------------------------------------------------------------------------
-- Main
-----------------------------------------------------------------------------------------
function createSettingsTable()
    settingsExist = loadsaveModule.fileExists("settings.asdfgh")
    if settingsExist == false then 
        settingsTable =  {}
        print("fick")
        settingsTable.minimumOctave = 2
        settingsTable.maximumOctave = 6
        settingsTable.referenceC = "False"
        settingsTable.pitchCleansing = "True"
        settingsTable.practiceNoteOctave = 4
        settingsTable.timerEnabled = "True"
        
        settingsTable.totalAttempts = 0
        
        settingsTable.totalNoteAttempts = 0
        settingsTable.totalIntervalAttempts = 0
        settingsTable.totalChordAttempts = 0
        settingsTable.totalScaleAttempts = 0

        settingsTable.totalCorrectNoteAttempts = 0
        settingsTable.totalCorrectIntervalAttempts = 0
        settingsTable.totalCorrectChordAttempts = 0
        settingsTable.totalCorrectScaleAttempts = 0
        --print("settingsdontExist")
        loadsaveModule.saveTable(settingsTable, "settings.asdfgh")
    end
end
createSettingsTable()
composer.isDebug = true
composer.gotoScene("scenes.menuScene")