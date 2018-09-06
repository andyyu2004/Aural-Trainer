--======================================================================--
--== Button Class factory
--======================================================================--
local button = class()
button.__name = "button"

--======================================================================--
--== Require dependant classes
--======================================================================--
local widget = require ("widget")
local pt = require("classes.printTable") 
local loadSaveModule = require("classes.loadsave")
--======================================================================--
--== Initialization / Constructor
--======================================================================--
function button:__init(group, xloc, yloc, width, height, note, category, buttonNumber)
    -- Constructor for class
        -- Parameters:
        --  group - the group where the game should be inserted into
        self.group = group
        self.xloc = xloc
        self.yloc = yloc
        self.width = width or 480
        self.height = height or 130
        self.id = note
        self.category = category
        self.buttonNumber = buttonNumber
        self:drawButton()
        self:deconstructor()
end

--======================================================================--
--== Code / Methods
--======================================================================--
function button:drawButton()
    self.handleButtonEvent = function( event )
        if ( "ended" == event.phase ) then
            --[[if self.settingsTable == nil then
                settingsTable = loadSaveModule.loadTable("settings.asdfgh")
                totalAttempts = settingsTable.totalAttempts
                print(FUCKSDFDS)
            end
            self.totalAttempts = self.totalAttempts + 1
            print(self.totalAttempts)]]
            --pt.print_r(settingsTable)
            --print ("button self.id = "..self.id)
            local event = { name = "recieveAnswer", category = self.category, answer = self.id }
            Runtime:dispatchEvent(event)
        end
    end
    self.button = widget.newButton(
        {
            label = self.id,
            onEvent = self.handleButtonEvent,
            shape = "roundedRect",
            width = self.width,
            height = self.height,
            cornerRadius = 13,
            fillColor = { default={1}, over = {0.3} },
            font = native.systemFontBold, 
            --strokeColor = { default={255}, over={255} },
            --strokeWidth = 100,
            labelColor = { default = { 0, 0, 0 }, over = { 163, 25, 12} },
        }
    )
    self.group:insert(self.button)
    -- Center the button
    if self.category == "note" then
        self.button._view._label.size = 65
        self.button._view._fontType = native.systemFontBold
    elseif self.category == "interval" then
        self.button._view._label.size = 55
    elseif self.category == "chord" then
        self.button._view._label.size = 50
    elseif self.category == scale then 
        self.button._view._label.size = 60
    else
        self.button._view._label.size = 60
    end
    self.button.x = self.xloc
    self.button.y = self.yloc
end
function button:setButtonStatus(r,g,b,status)
    --self.button._view._fillColor = { default={0.1}, over = {1,0,0} }
    self.button:setFillColor(r,g,b)
        if status == true and r == 0 then
            self.button:setFillColor(0,1,0)
            timer.performWithDelay(700, function()
                self.button:setFillColor(1,1,1)
            end)
        end
    self.button:setEnabled(status)
    --self.button._view._label.size = 150
    --print("removeButon function")
    --display.remove(self.button)
    --self.button = nil
end

function button:deconstructor() 
    self.button.finalize = function() 
        --print("kill buttons")
        self.button = nil
        self = nil
    end
    self.button:addEventListener("finalize")
end
--======================================================================--
--== Return factory
--======================================================================--
return button