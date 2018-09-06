
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

local button = require("classes.button")
local loadsaveModule = require("classes.loadsave")
--======================================================================--
--== Initialization / Constructor
--======================================================================--
function sceneManager:__init(group, sceneName, options)
	self.group = group -- the group where the sceneManager should be inserted into	
	self.sceneName = sceneName

	self.minOctave = 2
	self.maxOctave = 7
	self.attempts = 0
	self.correctAnswers = 0
	self.questionActive = false
	self.randomNumber = math.random(12*(self.minOctave-2)+1, 12*(self.maxOctave-2))
	self.randomIntervalNumber = math.random(1,16)
	self.audioFileType = "mp3"
	self.time = 0 
	self:drawScene()
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

local settingsTable

function sceneManager:drawScene()
	self:checkAnswer()
	self:loadSettings()
	self:deconstructor()
	self:drawTimer()
	if self.sceneName == "note" then
		self.noteAttempts = 0
		self.correctNoteAnswers = 0
		self:createNoteScene()
	elseif self.sceneName == "interval" then
		self.intervalAttempts = 0
		self.correctIntervalAnswers = 0
		self:createIntervalScene()
	elseif self.sceneName == "scale" then
		self.scaleAttempts = 0
		self.correctScaleAnswers = 0
		self:createScaleScene()
	elseif self.sceneName == "chord" then
		self.chordAttempts = 0
		self.correctChordAnswers = 0 
		self:createChordScene()
	end
end
function sceneManager:drawTimer()
	self.timer = timer.performWithDelay (1000, function()
		self.time = self.time + 1
			self:drawTimer()
			--print(time)
		end)
	local options = {
		parent=self.group,
		text=self.time.."s",
		x=display.contentWidth-120,
		y=340,
		fontSize=60,
		font=native.systemFontBold,
		--align = "left"
	}
	if self.drawTime then
		self.drawTime.text = self.time.."s"
	else
		self.drawTime=display.newText(options)
	end
end

function sceneManager:loadSettings()
	settingsTable = loadsaveModule.loadTable("settings.asdfgh")
	--print("loading json")
	--loadsaveModule.print_r(settingsTable)
	self.minOctave = settingsTable.minimumOctave
	self.maxOctave = settingsTable.maximumOctave
	self.referenceC = settingsTable.referenceC
	self.practiceNoteOctave = settingsTable.practiceNoteOctave
	self.pitchCleansing = settingsTable.pitchCleansing

	self.totalNoteAttempts = settingsTable.totalNoteAttempts
    self.totalIntervalAttempts = settingsTable.totalIntervalAttempts
    self.totalScaleAttempts = settingsTable.totalChordAttempts 
    self.totalChordAttempts = settingsTable.totalScaleAttempts 
    
    self.totalCorrectNoteAttempts = settingsTable.totalCorrectNoteAttempts
    self.totalCorrectIntervalAttempts = settingsTable.totalCorrectIntervalAttempts
    self.totalCorrectChordAttempts = settingsTable.totalCorrectChordAttempts
    self.totalCorrectScaleAttempts = settingsTable.totalCorrectScaleAttempts
	
	self.totalAttempts = settingsTable.totalAttempts
end

function sceneManager:checkAnswer()
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
	
	self.checkAnswer = function(event)
		self.totalAttempts = self.totalAttempts + 1
		print(self.totalAttempts)
		if event.category == "note" then
			--print(event.answer)
			local answer = convertNoteToNumber(event.answer, noteArray)
			self.totalNoteAttempts = self.totalNoteAttempts + 1
			--print (answer)
			if answer % 12 == self.answer then
				for i = 1,12 do
					self.noteButton[i]:setButtonStatus(1,1,1,true)
					self.noteButton[answer]:setButtonStatus(0,1,0, true)
				end
				--Play random notes to cleanse relative pitch
				local playCleansingNoise = function()
					if self.pitchCleansing == "True" then
						local randomNumber = math.random(1,60)
						audio.play(noteAudioReferenceTable[randomNumber])
					end
				end
				timer.performWithDelay( 120, playCleansingNoise, 13 )
				print("You got it right")
				self.totalCorrectNoteAttempts = self.totalCorrectNoteAttempts + 1
				self.correctNoteAnswers = self.correctNoteAnswers + 1
				self.questionActive = false
				self.handlePlayNoteEvent({phase = "ended"})
				self.noteAttempts = self.noteAttempts + 1
				self:drawNoteAttemptsCounter()
				return true
			else
				--pt.print_r(self.noteButton)
				self.noteButton[answer]:setButtonStatus(1,0,0, false)
				print("Try again")
				self.noteAttempts = self.noteAttempts + 1
				self:drawNoteAttemptsCounter()
				--return false
			end
		elseif event.category == "interval" then
			self.totalIntervalAttempts = self.totalIntervalAttempts + 1
			--print(event.answer)
			local answer = convertNoteToNumber(event.answer, intervalArray)
			--print ("Note converted to answer = " .. answer)
			if answer == self.answer then
				for i = 1,16 do
					if self.intervalButton[i] then
						self.intervalButton[i]:setButtonStatus(1,1,1,true)
						self.intervalButton[answer]:setButtonStatus(0,1,0, true)
					end
				end
				print("You got it right")
				self.totalCorrectIntervalAttempts = self.totalCorrectIntervalAttempts + 1
				self.correctIntervalAnswers = self.correctIntervalAnswers + 1
				self.questionActive = false
				self.handlePlayIntervalEvent({phase = "ended"})
				self.intervalAttempts = self.intervalAttempts + 1
				self:drawIntervalAttemptsCounter()
				return true
			else
				--pt.print_r(self.noteButton)
				self.intervalButton[answer]:setButtonStatus(1,0,0, false)
				print("Try again")
				self.intervalAttempts = self.intervalAttempts + 1
				self:drawIntervalAttemptsCounter()
				--return false
			end
		elseif event.category == "scale" then
			self.totalScaleAttempts = self.totalScaleAttempts + 1
			local answer = convertNoteToNumber(event.answer, scaleArray)
			if answer == self.answer then
				for i = 1,10 do
					if self.scaleButton[i] then
						self.scaleButton[i]:setButtonStatus(1,1,1,true)
						self.scaleButton[answer]:setButtonStatus(0,1,0, true)
					end
				end
				print("You got it right")
				self.correctScaleAnswers = self.correctScaleAnswers + 1
				self.totalCorrectScaleAttempts = self.totalCorrectScaleAttempts + 1
				self.questionActive = false
				self.handlePlayScaleEvent({phase = "ended"})
				self.scaleAttempts = self.scaleAttempts + 1
				self:drawScaleAttemptsCounter()
				return true
			else
				--pt.print_r(self.noteButton)
				self.scaleButton[answer]:setButtonStatus(1,0,0, false)
				print("Try again")
				self.scaleAttempts = self.scaleAttempts + 1
				self:drawScaleAttemptsCounter()
				--return false
			end
		elseif event.category == "chord" then
			self.totalChordAttempts = self.totalChordAttempts + 1
			local answer = convertNoteToNumber(event.answer, chordArray)
			if answer == self.answer then
				for i = 1,16 do
					if self.chordButton[i] then
						self.chordButton[i]:setButtonStatus(1,1,1,true)
						self.chordButton[answer]:setButtonStatus(0,1,0, true)
					end
				end
				print("You got it right")
				self.totalCorrectChordAttempts = self.totalCorrectChordAttempts + 1
				self.correctChordAnswers = self.correctChordAnswers + 1
				self.questionActive = false
				self.handlePlayChordEvent({phase = "ended"})
				self.chordAttempts = self.chordAttempts + 1
				self:drawChordAttemptsCounter()
				return true
			else
				--pt.print_r(self.noteButton)
				self.chordButton[answer]:setButtonStatus(1,0,0, false)
				print("Try again")
				self.chordAttempts = self.chordAttempts + 1
				self:drawChordAttemptsCounter()
				--return false
			end
		end
	end
	Runtime:addEventListener("recieveAnswer", self.checkAnswer)
end

function sceneManager:drawPercentage(correctAttempts, totalAttempts)
	--print(correctAttempts, totalAttempts)
	if totalAttempts == 0 or correctAttempts == 0 then 
		self.percentageText = "0%"
	else 
		self.percentageText = math.round(correctAttempts/totalAttempts*100) .. "%"
	end
	local options = {
		parent=self.group,
		text=self.percentageText,
		x=display.contentWidth-120,
		y=250,
		fontSize=60,
		font=native.systemFontBold,
		--align = "left"
	}
	if self.drawPercentageDisplay then
		self.drawPercentageDisplay.text = math.round(correctAttempts/totalAttempts*100) .. "%"
	else
		self.drawPercentageDisplay=display.newText(options)
	end
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
	for n = (self.minOctave - 2)*12+1, (self.maxOctave-2)*12 do
		local notes = noteFileNameArray[n].."."..self.audioFileType
		--print (notes)
		noteAudioReferenceTable[n] = audio.loadSound("sounds/piano/"..self.audioFileType.. "/notes/"..notes)
	end

	self.handlePlayNoteEvent = function ( event )
	    if ( "ended" == event.phase ) then
	    	if self.questionActive == false then
		        self.randomNumber = math.random(12*(self.minOctave-2)+1, 12*(self.maxOctave-2))
		        local randomNote = noteFileNameArray[self.randomNumber]
		        local randomOctave = math.random(self.minOctave, self.maxOctave) -- may not be necessary
		        local scientificNotation = randomNote..randomOctave					-- //
		        --print(scientificNotation)
		        --local notesTable = {}
		        --notesTable[self.randomNoteNumber] = audio.loadSound("sounds/"..scientificNotation..".mp3")
		        --print(randomNumber)
		    end
			audio.play(noteAudioReferenceTable[self.randomNumber])
		    self.questionActive = true
		    self.answer = (self.randomNumber) % 12 
		    if self.anwer == 0 then
		    	self.answer = 12
		    end
		    print ("The Correct Answer Is "..self.answer)
		    --self.randomNoteNumber = self.randomNoteNumber + 1		   
	    end
	end
	--if not playButton then
    local playButton = widget.newButton(
        {
            width = 270,
	        height = 180,
	        defaultFile = "images/whiteSpeaker.png",
	        --overFile = "buttonOver.png",
	        onEvent = self.handlePlayNoteEvent
        }
    )	
    playButton.x = 160
    playButton.y = 400
    playButton:setFillColor(1,1,1)
    self.group:insert(playButton)

	--end    
	if self.referenceC == "True" then
	    local playReferenceSound = function (event)
	    	if ( "ended" == event.phase ) then
	    	 	audio.play(noteAudioReferenceTable[25])
	    	end
		end
	    --if not playReference then
		    local playReference = widget.newButton(
		        {
		            width = 270,
			        height = 180,
			        defaultFile = "images/whiteSpeaker.png",
			        --overFile = "buttonOver.png",
			        onEvent = playReferenceSound,
			        label = "C4",
			        labelColor = { default = { 0, 0, 0 } },
			        font = native.systemFontBold
		        }
		    )	
		    playReference.x = fullw - 200
		    playReference.y = 400
		    playReference._view._label.size = 65
		    playReference._view._label.x = 95
		    --playReference._view._labelColor = {0}
		    self.group:insert(playReference)
	end
	  self.handlePlayNoteEvent({phase = "ended"})
	--end
	self.drawNoteAttemptsCounter = function()
		self:drawPercentage(self.correctNoteAnswers, self.noteAttempts)
		local options = {
			parent=self.group,
			text=self.correctNoteAnswers.."/"..self.noteAttempts,
			x=display.contentWidth-120,
			y=150,
			fontSize=75,
			font=native.systemFontBold,
			--align = "left"
		}
		if self.noteAttemptsCounter then
			self.noteAttemptsCounter.text = self.correctNoteAnswers.."/"..self.noteAttempts
		else
			self.noteAttemptsCounter=display.newText(options)
		end
	end
	self:drawNoteAttemptsCounter()
end

function sceneManager:createIntervalScene()
	self.intervalButton = {}
	for x = 1, 2 do 	-- xy  = 1, 2, 3, 4, 5, 6, 2, 4, 6, 8, 10, 12
		for y = 1, 8 do -- x+y = 2, 3, 4, 5, 6, 7, 3, 4, 5, 6, 7,  8
			if x == 1 then
				if intervalArray[2*y-1] then
					self.intervalButton[2*y-1] = button:new(self.group, x*fullw/4, y*fullh/11+290, nil, nil, intervalArray[2*y-1], "interval", 2*y-1) 
				end
			elseif x == 2 then
				if intervalArray[2*y] then
					self.intervalButton[2*y] = button:new(self.group, fullw - fullw/4, y*fullh/11+290, nil, nil, intervalArray[2*y], "interval", 2*y) 
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
	self.handlePlayIntervalEvent = function (event)
	    if ( "ended" == event.phase ) then
	    	if self.questionActive == false then
	    		self.randomIntervalNumber = math.random(1,16)
		        self.checkRandomNumber = function()
		        	if self.randomIntervalNumber == 1 or self.randomIntervalNumber == 7 or self.randomIntervalNumber == 15 or self.randomIntervalNumber == nil then
		        		self.randomIntervalNumber = math.random(1,16)
		        		self.checkRandomNumber()
		        		--print(self.randomNumber)
		        	end
		        end
		        self.checkRandomNumber()
		        --local randomOctave = math.random(self.minOctave, self.maxOctave) -- may not be necessary
		        --local scientificNotation = randomNote..randomOctave					-- //
		        --print(scientificNotation)
		        --local notesTable = {}
		        --notesTable[self.randomNoteNumber] = audio.loadSound("sounds/"..scientificNotation..".mp3")
		        --print(randomNumber)
		    end
			audio.play(intervalAudioReferenceTable[self.randomIntervalNumber])
			--audio.play(intervalAudioReferenceTable[2])
		    self.questionActive = true
		    self.answer = self.randomIntervalNumber
		    print ("The Correct Answer Is "..self.answer)
		    --self.randomNoteNumber = self.randomNoteNumber + 1		   
	    end
	end
	 local playButton = widget.newButton(
	        {
	            width = 270,
		        height = 180,
		        defaultFile = "images/whiteSpeaker.png",
		        --overFile = "buttonOver.png",
		        onEvent = self.handlePlayIntervalEvent
	        }
	    )	
	    playButton.x = 200
	    playButton.y = 400
	    playButton:setFillColor(1,1,1)
	    self.group:insert(playButton)	
	self.handlePlayIntervalEvent({phase="ended"})  
	self.drawIntervalAttemptsCounter = function()
		self:drawPercentage(self.correctIntervalAnswers, self.intervalAttempts)
		local options = {
			parent=self.group,
			text=self.correctIntervalAnswers.."/"..self.intervalAttempts,
			x=display.contentWidth-120,
			y=150,
			fontSize=75,
			font=native.systemFontBold,
			--align = "left"
		}
		if self.intervalAttemptsCounter then
			self.intervalAttemptsCounter.text = self.correctIntervalAnswers.."/"..self.intervalAttempts
		else
			self.intervalAttemptsCounter=display.newText(options)
		end
	end	
	self:drawIntervalAttemptsCounter()	  
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
	self.handlePlayChordEvent = function (event)
	    if ( "ended" == event.phase ) then
	    	if self.questionActive == false then
	    		self.randomChordNumber = math.random(1,16)
		    end
			audio.play(chordAudioReferenceTable[self.randomChordNumber])
			--audio.play(chordAudioReferenceTable[2])
			print("FFs")
		    self.questionActive = true
		    self.answer = self.randomChordNumber
		    print ("The Correct Answer Is "..self.answer)
		    --self.randomNoteNumber = self.randomNoteNumber + 1		   
	    end
	end
	 local playButton = widget.newButton(
        {
            width = 270,
	        height = 180,
	        defaultFile = "images/whiteSpeaker.png",
	        --overFile = "buttonOver.png",
	        onEvent = self.handlePlayChordEvent 
	    }
    )	
    playButton.x = 160
    playButton.y = 360
    playButton:setFillColor(1,1,1)
    self.group:insert(playButton)	
	self.handlePlayChordEvent({phase="ended"})  
	
	self.drawChordAttemptsCounter = function()
		self:drawPercentage(self.correctChordAnswers, self.chordAttempts)
		local options = {
			parent=self.group,
			text=self.correctChordAnswers.."/"..self.chordAttempts,
			x=display.contentWidth-120,
			y=150,
			fontSize=75,
			font=native.systemFontBold,
			--align = "left"
		}
		if self.chordAttemptsCounter then
			self.chordAttemptsCounter.text = self.correctChordAnswers.."/"..self.chordAttempts
		else
			self.chordAttemptsCounter=display.newText(options)
		end
	end	
	self:drawChordAttemptsCounter()	 
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
		self.handlePlayScaleEvent = function (event)
	    if ( "ended" == event.phase ) then
	    	if self.questionActive == false then
	    		self.randomScaleNumber = math.random(1,10)
		    end
		    if audio.isChannelPlaying(1) == false then
				local options = {channel = 1}		    	
				audio.play(scaleAudioReferenceTable[self.randomScaleNumber], options)
				--audio.play(intervalAudioReferenceTable[2])
			end
		    self.questionActive = true
		    self.answer = self.randomScaleNumber
		    print ("The Correct Answer Is "..self.answer)
		    --self.randomNoteNumber = self.randomNoteNumber + 1		   
	    end
	end
	local playButton = widget.newButton(
	    {
	        width = 270,
		    height = 180,
		    defaultFile = "images/whiteSpeaker.png",
		    --overFile = "buttonOver.png",
		    onEvent = self.handlePlayScaleEvent
	    }
	    )	
	    playButton.x = 160
	    playButton.y = 400
	    playButton:setFillColor(1,1,1)
	    self.group:insert(playButton)	
	self.handlePlayScaleEvent({phase="ended"})   
	
	self.drawScaleAttemptsCounter = function()
	self:drawPercentage(self.correctScaleAnswers, self.scaleAttempts)
		local options = {
			parent=self.group,
			text=self.correctScaleAnswers.."/"..self.scaleAttempts,
			x=display.contentWidth-120,
			y=150,
			fontSize=75,
			font=native.systemFontBold,
			--align = "left"
		}
		if self.scaleAttemptsCounter then
			self.scaleAttemptsCounter.text = self.correctScaleAnswers.."/"..self.scaleAttempts
		else
			self.scaleAttemptsCounter=display.newText(options)
		end
	end	
	self:drawScaleAttemptsCounter()	  
end

function sceneManager:deconstructor() 
	self.group.finalize = function() 
		settingsTable.totalAttempts = self.totalAttempts
		settingsTable.totalNoteAttempts = self.totalNoteAttempts
		settingsTable.totalIntervalAttempts = self.totalIntervalAttempts
		settingsTable.totalChordAttempts = self.totalChordAttempts
		settingsTable.totalScaleAttempts = self.totalScaleAttempts

		settingsTable.totalCorrectNoteAttempts = self.totalCorrectNoteAttempts
		settingsTable.totalCorrectIntervalAttempts = self.totalCorrectIntervalAttempts
    	settingsTable.totalCorrectChordAttempts = self.totalCorrectChordAttempts
    	settingsTable.totalCorrectScaleAttempts = self.totalCorrectScaleAttempts
		
		pt.print_r(settingsTable)
		loadsaveModule.saveTable(settingsTable, "settings.asdfgh")

		Runtime:removeEventListener("recieveAnswer", self.checkAnswer)
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
		print "finalise scene"
		timer.cancel(self.timer)
		self.group = nil
	end
	self.group:addEventListener("finalize")
end
--======================================================================--
--== Return factory
--======================================================================--
return sceneManager
