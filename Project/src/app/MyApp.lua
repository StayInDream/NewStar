
require("config")
require("cocos.init")
require("framework.init")
GameState=require("framework.cc.utils.GameState")
GameData  = nil
GAME_FONT = nil


local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
     self.objects_ = {}
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.Director:getInstance():setContentScaleFactor(480 / CONFIG_SCREEN_WIDTH)

    display.addSpriteFrames(GAME_TEXTURE_DATA_FILENAME, GAME_TEXTURE_IMAGE_FILENAME)

     -- preload all sounds
    for k, v in pairs(GAME_SOUND) do
        if k ~= "classicbg" and k ~= "advbg" then
            audio.preloadSound(v)
         else
            audio.preloadMusic(v)
        end
    end

    GameState.init(function(param)
        local returnValue = nil
        if param.errorCode then
            print("error code" .. param.errorCode)
        else
            --crypto
            if param.name == "save" then
                local str = json.encode(param.values)
                str = crypto.encryptXXTEA(str,"lp")--使用XXT加密算法
                returnValue = {data = str}
            elseif param.name == "load" then
                local str = crypto.decryptXXTEA(param.values.data,"lp")
                returnValue = json.decode(str)
            end
        end
        return returnValue    
    end,"data.txt","lp") --保存到writablePath下data.txt文件中，加密口令"abcd"

    GameData = GameState.load() or {}
    if GameData == nil then --第一次运行游戏
        GameData = GameState.load()
    end

    GAME_FONT = "fonts/" .. GAME_FONT_
    
    -- 动画缓存
    -- display.addSpriteFrames("lqfRoleWalk.plist","lqfRoleWalk.png")
 
    -- local sprite = display.newSprite("#lqfDownStop.png")
    -- sprite:align(display.CENTER,display.cx,display.cy)
    -- sprite:addTo(self)
    -- sprite:setScale(2)
     
    -- local frames = display.newFrames("lqfDownWalk%d.png",1,2)
    -- local animation = display.newAnimation(frames,0.5/2)
    -- display.setAnimationCache("lqfDownWalk",animation)
    -- sprite:playAnimationForever(display.getAnimationCache("lqfDownWalk"))

    self:enterMenuScene()
end

function MyApp:enterMenuScene()
    self:InitGameStageData()
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
    self:InitGameStageData()
    -- 创建一个新场景
    local nextScene = require("app.scenes.GameScene").new()
    -- 包装过渡效果
    local transition = display.wrapSceneWithTransition(nextScene, "slideInR", 0.5)
    -- 切换到新场景
    display.replaceScene(transition)
end

function MyApp:ContinueGame()
    local nextScene = require("app.scenes.GameScene").new()
    -- 包装过渡效果
    local transition = display.wrapSceneWithTransition(nextScene, "slideInR", 0.5)
    -- 切换到新场景
    display.replaceScene(transition)
end

function MyApp:TeQuanButtonClick()
    
    --self:enterScene("GameScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MyApp:InitGameStageData()
    GameData.CURLEVEL    = 1
    GameData.CURSCORE    = 0
    GameData.TARGETSCORE = 10000
    GameData.HEIGHTSCORE = 0
    GameData.MAP         = {}
    GameData.GAMESTATE   = 0

    GameState.save(GameData)

    
end

return MyApp
