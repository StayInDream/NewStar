
require("config")
require("cocos.init")
require("framework.init")
GameState=require("framework.cc.utils.GameState")

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
        if k ~= "Bgm_01" and k ~= "advbg" then
            audio.preloadSound(v)
         else
            audio.preloadMusic(v)
        end
    end

     GameState.init(function(param)
        local returnValue = nil

         if  param.name=="load" then
             --文件出错了 重新加载
            if param.errorCode then
               -- CCLuaLog("error")
               local data = cc.FileUtils:getInstance():getStringFromFile("Data/playerData.json")
               print(data)
               local playerJson = json.decode(data)
               GameState.save(playerJson)
               returnValue=json.decode(str)
            else
                local str =param.values.data
                --local str=crypto.decryptXXTEA(str, "abcd")
                returnValue=json.decode(str)
                print("load Data")
            end


        elseif param.name=="save" then
                local str=json.encode(param.values)
                --str=crypto.encryptXXTEA(str, "abcd")
                returnValue={data=str}
                print("save Data")

        end

        return returnValue
    end, "playerData.dat","super")

    self.playerJson = GameState.load()
    if self.playerJson == nil then --第一次运行游戏
         self.playerJson=GameState.load()
    end
    
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

function MyApp:TeQuanButtonClick()
    
    --self:enterScene("GameScene", nil, "fade", 0.6, display.COLOR_WHITE)
    
    
end

return MyApp
