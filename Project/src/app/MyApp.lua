
require("config")
require("cocos.init")
require("framework.init")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
     self.objects_ = {}
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    display.addSpriteFrames(GAME_TEXTURE_DATA_FILENAME, GAME_TEXTURE_IMAGE_FILENAME)

     -- preload all sounds
    for k, v in pairs(GAME_SOUND) do
        audio.preloadSound(v)
    end
    self:enterMenuScene()
end

function MyApp:enterMenuScene()
    self:enterScene("MenuScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MyApp:ShowSetting()
  --  self:enterScene("SetGameScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MyApp:ShowShop()
    --self:enterScene("SetGameScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MyApp:ShowEmail()
    --self:enterScene("SetGameScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MyApp:ShowRank()
    --self:enterScene("SetGameScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MyApp:ShowCDKEY()
    --self:enterScene("SetGameScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MyApp:StartNewGame()
    -- 创建一个新场景
    local nextScene = require("app.scenes.GameScene").new()
    -- 包装过渡效果
    local transition = display.wrapSceneWithTransition(nextScene, "slideInR", 0.5)
    -- 切换到新场景
    display.replaceScene(transition)
end

function MyApp:ContinueGame()
    --self:enterScene("GameScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

return MyApp
