--local MatrixStar = import("..ui.MatrixStar", currentModuleName)

local GameScene = class("GameScene", function()
    return display.newScene("GameScene")
end)

function GameScene:ctor()
    local bg = display.newSprite(GAME_IMAGE.front,display.cx,display.cy)
    self:addChild(bg)
    
    self.Matrix = require("app.scenes.MatrixStar").new()
    self:addChild(self.Matrix)
    local x = 1
    self:scheduleUpdate(function() 
               -- self:update() 
               end,0)
end

function GameScene:update()
--    self:updateScore()
    self.Matrix:updateStar()
    if self.Matrix.clearNeed == CLEAROVER then 
        if self.Matrix.Cscore >= self.Matrix.Goal then 
            self:goNextLevel()
        else 
            self:goGameOver()
        end
    end
end

function GameScene:goGameOver()
    self.Matrix.clearNeed = UNNEEDCLEAR
    local GameOverUI = display.newSprite("GameOver.jpg")
    GameOverUI:setPosition(display.cx,display.top)
    self:addChild(GameOverUI)
    GameOverUI:runAction(transition.sequence({transition.moveTo(GameOverUI,
        {time = MOVEDELAY, x = display.cx, y = display.cy}),
        CCCallFunc:create(function()
        local item ={}
        item[1]= ui.newImageMenuItem({image = "menu_top.png", imageSelected = "menu_top.png",
        listener = function()  
        game.enterGameScene() end ,  x = display.cx, y = display.cy})
        local menu = ui.newMenu(item)
        self:addChild(menu)
        self:removeChild(GameOverUI)
    end)}))
end

function GameScene:goNextLevel()
    self.Matrix.clearNeed = UNNEEDCLEAR
    print(1,2)
    local PassGameUI = display.newSprite("Pass.jpg")
    PassGameUI:setPosition(display.cx,display.top)
    self:addChild(PassGameUI)
    PassGameUI:runAction(transition.sequence({transition.moveTo(PassGameUI,
        {time = MOVEDELAY, x = display.cx, y = display.cy}),
        CCCallFunc:create(function()
        self.Matrix.Level = self.Matrix.Level + 1
        self.Matrix.Goal = STARTSCORE + STARTSCORE * (self.Matrix.Level * 2 -1)
        local HscoreUI = self.Matrix:getChildByTag(HSCORETAG)
        HscoreUI:setString(string.format("HighestScore: %s", tostring(self.Matrix.Hscore)))
        local CscoreUI = self.Matrix:getChildByTag(CSCORETAG)
        CscoreUI:setString(string.format("CurrentScore: %s", tostring(self.Matrix.Cscore)))
        local LevelUI = self.Matrix:getChildByTag(LEVELTAG)
        LevelUI:setString(string.format("Level %s" .."  ".."GoalScore %s", 
        tostring(self.Matrix.Level),tostring(self.Matrix.Goal)))
        self:removeChild(PassGameUI)
        self.Matrix:initMatrix()
    end)}))
end


function GameScene:onEnter()
end

function GameScene:onExit()
    print(" GameScene ==> onExit")
     self:removeAllChildren()
end

return GameScene