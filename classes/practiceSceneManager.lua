
-- =============================================================

--======================================================================--
--== sceneManager Class factory
--======================================================================--
local sceneManager = class() -- define sceneManager as a class (notice the capitals)
sceneManager.__name = "sceneManager" -- give the class a name
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
local loadsaveModule = require("classes.loadsave")
local button = require("classes.button")
--maybe make the quiz question the octave once clicked on the note

--======================================================================--
--== Initialization / Constructor
--======================================================================--
function sceneManager:__init(group, sceneName, options)
	self.group = group -- the group where the sceneManager should be inserted into	
	self.sceneName = sceneName

	self.minOctave = options.minOctave or 2
	self.maxOctave = 7
	self.randomNumber = math.random(12*(self.minOctave-2)+1, 12*(self.maxOctave-2))
	self.randomIntervalNumber = math.random(1,16)
	self.audioFileType = "mp3"
	self:loadSettings()

	end

--======================================================================--
--== Code / Methods
--======================================================================--
local noteArray = {"C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb","G", "G#/Ab", "A", "A#/Bb", "B" }
--local noteFileNameArray = {"C", "Csharp", "D", "Dsharp", "E", "F", "Fsharp","G", "Gsharp", "A", "Asharp", "B"}
local noteFileNameArray = {"C2", "Csharp2", "D2", "Dsharp2", "E2", "F2", "Fsharp2","G2", "Gsharp2", "A2", "Asharp2", "B2",
						   "C3", "Csharp3", "D3", "Dsharp3", "E3", "F3", "Fsharp3","G3", "Gsharp3", "A3", "Asharp3", "B3",
						   "C4", "Csharp4", "D4", "Dsharp4", "E4", "F4", "Fsharp4","G4", "Gsharp4", "A4", "Asharp4", "B4",
						   "C5", "Csharp5", "D5", "Dsharp5", "E5", "F5", "Fsharp5","G5", "Gsharp5", "A5", "Asharp5", "B5", 
						   "C6", "Csharp6", "D6", "Dsharp6", "E6", "F6", "Fsharp6","G6", "Gsharp6", "A6", "Asharp6", "B6"}
--local noteFileNameOctaveArray
local noteAudioReferenceTable = {}
--pt.print_r(noteAudioReferenceTable)
--pt.print_r(noteFileNameArray)

local intervalArray ={nil,"Unison", "Minor 2nd", "Major 2nd", "Minor 3rd", "Major 3rd", nil, "Perfect 4th", "Tritone", "Perfect 5th", "Minor 6th", "Major 6th", "Minor 7th", "Major 7th", nil, "Octave"}
local intervalAudioReferenceTable = {}

local scaleArray = {"Major", "Melodic Minor", "Harmonic Minor", "Dorian", "Phrygian", "Lydian", "Mixolydian", "Aeolian", "Locrian", "Whole Tone"}
local scaleAudioReferenceTable = {}

local chordArray = {"Major Triad", "Minor Triad", "Augmented Triad", "Diminished Triad", "Diminished Major 7th", "Dominant 7th", "Dominant 7b5", "Diminished 7th", "Major 7th", "Minor 7th", "Minor Major 7th", "Half Diminished 7th", "Augmented 7th", "Augmented Major 7th", "Suspended 2nd", "Suspended 4th"}
local chordAudioReferenceTable = {}

function sceneManager:loadSettings()
	local settingsTable = loadsaveModule.loadTable("settings.asdfgh")
	--print("loading json")
	--loadsaveModule.print_r(settingsTable)
	self.minOctave = settingsTable.minimumOctave
	self.maxOctave = settingsTable.maximumOctave
	self.referenceC = settingsTable.referenceC
	self.practiceNoteOctave = settingsTable.practiceNoteOctave
	self:drawScene()
end

function sceneManager:drawScene()
	self:playNote()
	self:deconstructor()
	if self.sceneName == "note" then
		self:createNoteScene()
	elseif self.sceneName == "interval" then
		self:createIntervalScene()
	elseif self.sceneName == "scale" then
		self:createScaleScene()
	elseif self.sceneName == "chord" then
		self:createChordScene()
	end

end
function sceneManager:playNote()
	local function convertNoteToNumber(noteName,arrayName)
		for k, v in pairs(arrayName) do
	    	if noteName == v then
	    		--print(k)
	      		return k
	    	end
		end
		print("error in searching array")
		return false
	end
	
	self.playNote = function (event)
		--print (event.category, event.answer)
		local arrayName = event.category .. "Array"
		--print(arrayName)
		if event.category == "note" then
			local n = convertNoteToNumber(event.answer, noteArray) + 12*(self.practiceNoteOctave-2)
			audio.play(noteAudioReferenceTable[n])
			print(n)
		elseif event.category == "interval" then
			local n = convertNoteToNumber(event.answer, intervalArray)
			audio.play(intervalAudioReferenceTable[n])	
		elseif event.category == "chord" then
			local n = convertNoteToNumber(event.answer, chordArray)
			audio.play(chordAudioReferenceTable[n])
		elseif event.category == "scale" then
			local n = convertNoteToNumber(event.answer, scaleArray)
			audio.play(scaleAudioReferenceTable[n], {channel = 1})
		end
	end
	Runtime:addEventListener("recieveAnswer", self.playNote)
end	

function sceneManager:createNoteScene()
	--print("createNoteScene")
	self.noteButton = {}
	for x = 1, 2 do 	-- xy  = 1, 2, 3, 4, 5, 6, 2, 4, 6, 8, 10, 12
		for y = 1, 6 do -- x+y = 2, 3, 4, 5, 6, 7, 3, 4, 5, 6, 7,  8
			if x == 1 then
				--if not self.noteButton[2*y-1] then
					self.noteButton[2*y-1] = button:new(self.group, x*fullw/4, y*fullh/9+400, nil, nil, noteArray[2*y-1], "note", 2*y-1) 
				--end
			elseif x == 2 then
				--if not self.noteButton[2*y] then
					self.noteButton[2*y] = button:new(self.group, fullw - fullw/4, y*fullh/9+400, nil, nil, noteArray[2*y], "note", 2*y) 
				--end
			end
		end
	end
	for n = (self.practiceNoteOctave-2)*12+1, (self.practiceNoteOctave - 1)*12 do
		local notes = noteFileNameArray[n].."."..self.audioFileType
		--print (notes,n)
		noteAudioReferenceTable[n] = audio.loadSound("sounds/piano/"..self.audioFileType.. "/notes/"..notes)
	end
	--pt.print_r(self.noteButton)
end

function sceneManager:createIntervalScene()
	self.intervalButton = {}
	for x = 1, 2 do 	-- xy  = 1, 2, 3, 4, 5, 6, 2, 4, 6, 8, 10, 12
		for y = 1, 8 do -- x+y = 2, 3, 4, 5, 6, 7, 3, 4, 5, 6, 7,  8
			if x == 1 then
				if intervalArray[2*y-1] then
					self.intervalButton[2*y-1] = button:new(self.group, x*fullw/4, y*fullh/11+250, nil, nil, intervalArray[2*y-1], "interval", 2*y-1) 
				end
			elseif x == 2 then
				if intervalArray[2*y] then
					self.intervalButton[2*y] = button:new(self.group, fullw - fullw/4, y*fullh/11+250, nil, nil, intervalArray[2*y], "interval", 2*y) 
				end
			end
		end
	end
	for n = 1, 16 do
		if intervalArray[n] then
			local intervals = intervalArray[n].."."..self.audioFileType
			--print (intervals)
			intervalAudioReferenceTable[n] = audio.loadSound("sounds/piano/"..self.audioFileType.."/intervals/"..intervals)
		end
	end
end

function sceneManager:createChordScene()
	self.chordButton = {}
	for x = 1, 2 do 	-- xy  = 1, 2, 3, 4, 5, 6, 2, 4, 6, 8, 10, 12
		for y = 1, 8 do -- x+y = 2, 3, 4, 5, 6, 7, 3, 4, 5, 6, 7,  8
			if x == 1 then
				self.chordButton[2*y-1] = button:new(self.group, x*fullw/4, y*fullh/12+400, nil, nil, chordArray[2*y-1], "chord", 2*y-1) 
			elseif x == 2 then
				self.chordButton[2*y] = button:new(self.group, fullw - fullw/4, y*fullh/12+400, nil, nil, chordArray[2*y], "chord", 2*y) 
			end
		end
	end
	for n = 1,16 do
		local chords = chordArray[n].."."..self.audioFileType
		chordAudioReferenceTable[n] = audio.loadSound("sounds/piano/"..self.audioFileType.. "/chords/"..chords)
	end
end

function sceneManager:createScaleScene()
	self.scaleButton = {}
	for x = 1, 2 do 	-- xy  = 1, 2, 3, 4, 5, 6, 2, 4, 6, 8, 10, 12
		for y = 1, 5 do -- x+y = 2, 3, 4, 5, 6, 7, 3, 4, 5, 6, 7,  8
			if x == 1 then
				--if not self.noteButton[2*y-1] then
					self.scaleButton[2*y-1] = button:new(self.group, x*fullw/4, y*fullh/9+400, nil, nil, scaleArray[2*y-1], "scale", 2*y-1) 
				--end
			elseif x == 2 then
				--if not self.noteButton[2*y] then
					self.scaleButton[2*y] = button:new(self.group, fullw - fullw/4, y*fullh/9+400, nil, nil, scaleArray[2*y], "scale", 2*y) 
				--end
			end
		end
	end
	for n = 1,10 do
		local scales = scaleArray[n].."."..self.audioFileType
		scaleAudioReferenceTable[n] = audio.loadSound("sounds/piano/"..self.audioFileType.. "/scales/"..scales)
	end
end

function sceneManager:deconstructor() 
	self.group.finalize = function() 
		pt.print_r(self)
		Runtime:removeEventListener("recieveAnswer", self.playNote)
		if self.sceneName == "note" then
			for n = (self.minOctave - 2)*12+1, (self.maxOctave-2)*12 do
				audio.dispose(noteAudioReferenceTable[n])
			end
		elseif self.sceneName == "interval" then	
			for n = 1,16 do
				audio.dispose(intervalAudioReferenceTable[n])
			end
		elseif self.sceneName == "scales" then
			for n = 1, 10 do
				audio.dispose(scaleAudioReferenceTable[n])
			end
		elseif self.sceneName == "chords" then
			for n = 1,16 do
				audio.dispose(chordAudioReferenceTable[n])
			end
		end
		print "finalise practice scene"
		self.group = nil
	end
	self.group:addEventListener("finalize")
end
--======================================================================--
--== Return factory
--======================================================================--
return sceneManager
