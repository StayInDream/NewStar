local BubbleButton = import("..views.BubbleButton")
local CCLabelChange = import("..views.CCLabelChange")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local Shop = import("..views.Shop")

local MenuScene = class("MenuScene", function()
    return display.newScene("MenuScene")
end)

local shopTypes = {{50.00, 500}, {30.00, 200}, {15.00, 80}, {10.00, 50}, {5.00,15}, {2.00,5} , {1.00,2} }
function MenuScene:ctor()
    self.bg = display.newSprite(GAME_IMAGE.Bg_Stage)
    self.bg:setPosition(display.cx, display.cy )
	self:addChild(self.bg)

    self.Shop = Shop.new()
    :addTo(self,100)

    local layer_logging = display.newLayer() --loading 层
    self:addChild(layer_logging,1)
    local layer_menu = display.newLayer() --菜单按钮层
    self:addChild(layer_menu,1)
    layer_menu:setVisible(false)

        local  sp_jsy = display.newSprite(GAME_IMAGE.jsy)
            :align(display.CENTER, display.cx , display.cy )
            :addTo(layer_logging)

        local  sp_jiazai = display.newSprite(GAME_IMAGE.jiazai)
            :align(display.CENTER, display.cx + 15, display.bottom + 30)
            :addTo(layer_logging)

        scheduler.performWithDelayGlobal(function ()
                layer_logging:setVisible(false)
                layer_menu:setVisible(true)
            end, 0.1)



--[[菜单层设置  ---start ]]

	self.coin_bar  = display.newSprite(GAME_IMAGE.coin_bar)
    :align(display.CENTER, display.left + 110, display.top - 30)
    layer_menu:addChild(self.coin_bar)

    local lbl_coin = cc.ui.UILabel.new({
        UILabelType = 1,
        text  = GameData.DIAMOND,
        font = GAME_FONT,
      --  size = 10,
       
    })
        :align(display.CENTER, display.left + 125, display.top - 25)
        :addTo(layer_menu)
        :setScale(0.5)


	self.jinbi_tiao  = display.newSprite(GAME_IMAGE.jinbi_tiao)
    :setVisible(false)
    :align(display.CENTER, display.left + 150, display.top - 50)
    layer_menu:addChild(self.jinbi_tiao)
    local lbl_jinbi = cc.ui.UILabel.new({
        UILabelType = 1,
        text  =  "1234578",
        font = GAME_FONT,
        size = 20
    })
        :align(display.CENTER, display.left + 150, display.top - 50)
        :addTo(layer_menu)
        :setScale(0.5)
        :setVisible(false)

    -- logo
    self.logo  = display.newSprite(GAME_IMAGE.logo_xin_1)
    :align(display.CENTER, display.cx, display.top + 200)
    layer_menu:addChild(self.logo)
	transition.moveTo( self.logo, {time = 0.7, y = display.cy +250 , easing = "BOUNCEOUT"})

    -- add buttons 

	-- 设置
    self.GameSetButton = BubbleButton.new({
            image = GAME_IMAGE.menu_btn,
            sound = GAME_SOUND.pselect,
            prepare = function()
                if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
                end
                self.GameSetButton:setButtonEnabled(false)
            end,
            listener = function()
                self:ShowSettingView()
            end,
        })
        :align(display.CENTER, display.cx - 160, display.bottom + 50 )
        :addTo(layer_menu)

	-- 邮件
    self.EmailButton = BubbleButton.new({
            image = GAME_IMAGE.btn_email,
            sound = GAME_SOUND.pselect,
            prepare = function()
                if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
                end
                self.EmailButton:setButtonEnabled(false)
            end,
            listener = function()
                self:ShowEmail()
            end,
        })
        :align(display.CENTER, display.cx - 70, display.bottom + 50 )
        :addTo(layer_menu)

	--商城
    self.ShopButton = BubbleButton.new({
            image = GAME_IMAGE.Button_Shop,
            sound = GAME_SOUND.pselect,
            prepare = function()
                if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
                end
                self.ShopButton:setButtonEnabled(false)
            end,
            listener = function()
                self.Shop:Show(Shop.SHOPTYPE.ShopType_1)
            end,
        })
        :align(display.CENTER, display.cx , display.bottom + 50 )
        :addTo(layer_menu) 

	--排行榜
    self.RankButton = BubbleButton.new({
            image = GAME_IMAGE.paihangbang,
            sound = GAME_SOUND.pselect,
            prepare = function()
               if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
                end
                self.RankButton:setButtonEnabled(false)
            end,
            listener = function()
                self:ShowRank()
            end,
        })
        :align(display.CENTER, display.cx + 90, display.bottom + 50 )
        :addTo(layer_menu) 

	--兑换码
    self.CDKEYButton = BubbleButton.new({
            image = GAME_IMAGE.CDKEY_btn,
            sound = GAME_SOUND.pselect,
            prepare = function()
                if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
                end
                self.CDKEYButton:setButtonEnabled(false)
            end,
            listener = function()
                self:ShowCDKEY()
            end,
        })
        :align(display.CENTER, display.cx + 170, display.bottom + 50 )
        :addTo(layer_menu) 

    --新游戏
    self.NewGameButton = BubbleButton.new({
            image = GAME_IMAGE.popstar_start,
            sound = GAME_SOUND.pselect,
            prepare = function()
                if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
                end
                self.NewGameButton:setButtonEnabled(false)
            end,
            listener = function()

                app:StartNewGame()

            end,
        })
        :align(display.CENTER, display.cx , display.cy +  self.bg:getContentSize().height / 2 - 450)
        :addTo(layer_menu) 

    --继续游戏
    self.ContinueGameButton = BubbleButton.new({
            image = GAME_IMAGE.popstar_continue,
            sound = GAME_SOUND.pselect,
            prepare = function()
                self.ContinueGameButton:setButtonEnabled(false)
            end,
            listener = function()
                if GameData.GAMESTATE ~= nil and (GameData.GAMESTATE == 1 or GameData.GAMESTATE == 2) then
                if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
                end
                app:ContinueGame()
                end
            end,
        })
        :align(display.CENTER, display.cx , display.cy +  self.bg:getContentSize().height / 2 - 550)
        :addTo(layer_menu) 

    self.sp_continue  = display.newSprite(GAME_IMAGE.sp_continue)
    self.sp_continue:setPosition(display.cx - 100, display.cy  - 110)
    layer_menu:addChild(self.sp_continue)
    self.sp_continue:setOpacity(0)
   
    local sequenceAction1 = transition.sequence({
            cc.FadeTo:create(1, 125), 
            cc.FadeTo:create(1, 255), 
            })

    if GameData.GAMESTATE == 1 then --有存档
        self.sp_continue:setOpacity(255)
      --  transition.execute(self.sp_continue, cc.RepeatForever:creacte( sequenceAction1 ))
        elseif GameData.GAMESTATE == 2 then --未通关 复活后继续游戏
            --todo
            self.sp_continue:setOpacity(255)
            self.sp_continue:setTexture(GAME_IMAGE.sp_relife)
    end

    -- 特权礼包
    self.TeQuanButton =  cc.ui.UIPushButton.new({normal =  "image/trqunrukou.png", pressed =  "image/trqunrukou.png"})
        :align(display.CENTER,  display.cx + self.bg:getContentSize().width / 2 - 80 , display.cy +  self.bg:getContentSize().height / 2 - 350)
        :onButtonClicked(function()
            if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
            end
           -- app:enterMenuScene()
        end)
        :addTo(layer_menu)
    local sequenceAction = transition.sequence({
            cc.ScaleTo:create(0.3, 1.2, 1.2, 1), 
            cc.ScaleTo:create(0.5, 1, 1, 1), 
            })

      transition.execute(self.TeQuanButton, cc.RepeatForever:create( sequenceAction ))

       -- 大礼包
    self.gift_btn =  cc.ui.UIPushButton.new({normal =  GAME_IMAGE.gift_btn, pressed =  GAME_IMAGE.gift_btn})
        :align(display.CENTER,  display.cx + self.bg:getContentSize().width / 2 - 80 , display.cy +  self.bg:getContentSize().height / 2 - 470)
        :onButtonClicked(function()
            if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
            end
            self.Shop:Show( Shop.SHOPTYPE.ShopType_3)
        end)
        :addTo(layer_menu)
    local sequenceAction1 = transition.sequence({
            cc.ScaleTo:create(0.5, 1.2, 1.2, 1), 
            cc.ScaleTo:create(0.5, 1, 1, 1), 
            })

      transition.execute(self.gift_btn, cc.RepeatForever:create( sequenceAction1 ))

    --  
    -- local label = display.newTTFLabel({
    --     text = "0",
    --     font = "arial",
    --     size = 64})

    --       label:setPosition(display.cx - 100, display.cy)
    --     :addChild(label)
    --      local action = CCLabelChange:create(label, 60, 1, 100)
  
    --      action:playAction()     

       -- 添加背景粒子特效
    local particle = cc.ParticleSystemQuad:create(GAME_PARTICE.Particle_TileDebris)
    :align(display.CENTER, display.cx, display.cy)
    layer_menu:addChild(particle,1)  

    -- self:addNodeEventListener(cc.KEYPAD_EVENT,function(event)
    --    return self:onKeypad(event) 
    -- end, false)
    -- self:setKeypadEnabled(true)

end

function MenuScene:onKeypad( event )
    -- body
    if event.key == "back" then
        device.showAlert("提示", "确定退出游戏么？", {"确定", "取消"}, function (event)
            if event.buttonIndex == 1 then  
                    cc.Director:getInstance():endToLua()
                else  
                    device.cancelAlert()  --取消对话框 
            end  
            end)
        elseif event.key == "menu" then  --菜单键
            print("menu keypad onclick")               
    end        
end

function MenuScene:ShowSettingView()
    local layer_setting = display.newLayer()
    :addTo(self ,1)
    local btn_mask = cc.ui.UIPushButton.new({normal =  GAME_IMAGE.sp_mask, pressed =  GAME_IMAGE.sp_mask})
        :align(display.CENTER, display.cx , display.cy)
        :addTo(layer_setting) 
        :setScale(20)
        :setOpacity(0)
        :onButtonClicked(function()
            scheduler.performWithDelayGlobal(function()
                -- body
                self:removeChild(layer_setting)
            end,0.5)
            self.sp_btnbg:moveTo(0.3, display.left  - 50 , display.bottom + 250)
            end)
    btn_mask:fadeTo(0.5, 255)

    self.sp_btnbg = display.newScale9Sprite(GAME_IMAGE.for_bg, 0, 0, cc.size(70, 300))
        :align(display.CENTER, display.left  - 50 , display.bottom + 250)
        :addTo(layer_setting)

        local sp_ = GAME_IMAGE.Button_SoundOn
        if GameData.SOUND == 0 then
            sp_ = GAME_IMAGE.Button_SoundOff
        end

    self.soundButton = cc.ui.UIPushButton.new({normal = sp_, pressed = sp_})
        :addTo(self.sp_btnbg) 
        :align( display.CENTER ,35, 240)
        :setScale(0.55)
        :onButtonClicked(function()
            if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
            end
                if GameData.SOUND == 0 then
                        GameData.SOUND = 1
                        if isHadPlayMusic == false then
                                audio.playMusic(GAME_SOUND.classicbg)
                                isHadPlayMusic = true
                            else
                                audio.rewindMusic()
                        end
                        self.soundButton:setButtonImage( cc.ui.UIPushButton.NORMAL, GAME_IMAGE.Button_SoundOn ,true)
                        self.soundButton:setButtonImage( cc.ui.UIPushButton.PRESSED,GAME_IMAGE.Button_SoundOn ,true)
                    else
                        GameData.SOUND = 0
                        audio.pauseMusic()
                        self.soundButton:setButtonImage( cc.ui.UIPushButton.NORMAL, GAME_IMAGE.Button_SoundOff ,true)
                        self.soundButton:setButtonImage( cc.ui.UIPushButton.PRESSED,GAME_IMAGE.Button_SoundOff ,true)
                end
                GameState.save(GameData)
                scheduler.performWithDelayGlobal(function()
                -- body
                self:removeChild(layer_setting)
                end,0.6)
                scheduler.performWithDelayGlobal(function()
                -- body
                self.sp_btnbg:moveTo(0.3, display.left  - 50 , display.bottom + 250)
                end,0.3)
        end)

    local setingButton = cc.ui.UIPushButton.new({normal = GAME_IMAGE.set_about, pressed = GAME_IMAGE.set_about})
        :addTo(self.sp_btnbg) 
        :align( display.CENTER, 35, 150)
        :setScale(1)
        :onButtonClicked(function()
            if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
            end
            scheduler.performWithDelayGlobal(function()
                -- body
                self:removeChild(layer_setting)
            end,0.5)
            self.sp_btnbg:moveTo(0.3, display.left  - 50 , display.bottom + 250)
        end)

    local exitButton = cc.ui.UIPushButton.new({normal = GAME_IMAGE.set_back, pressed = GAME_IMAGE.set_back})
        :addTo(self.sp_btnbg) 
        :align( display.CENTER, 35, 60)
        :setScale(1)
        :onButtonClicked(function()
            if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
            end
            scheduler.performWithDelayGlobal(function()
                -- body
                self:removeChild(layer_setting)
                self:ExitGame()
            end,0.5)
            self.sp_btnbg:moveTo(0.3, display.left  - 50 , display.bottom + 250)
           
        end)
        self.sp_btnbg:moveTo(0.3, display.left + 25 , display.bottom + 250)
end

function MenuScene:ShowEmail()
    --self:enterScene("SetGameScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MenuScene:ShowRank()
    --self:enterScene("SetGameScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MenuScene:ShowCDKEY()
    --self:enterScene("SetGameScene", nil, "fade", 0.6, display.COLOR_WHITE)
   GameData.CDKEY =  device.showInputBox("请输入您的兑换码", "", "")
   print(GameData.CDKEY)
end

function MenuScene:ExitGame()
    -- body
    print("退出游戏")
    if device.platform == "android" then
        self.touchLayer = display.newLayer()
        self.touchLayer:addNodeEventListener(cc.KEYPAD_EVENT, function(event)
            if event.key == "back" then  
                device.showAlert("提示", "确定退出游戏么？", {"确定", "取消"}, function (event)
                    if event.buttonIndex == 1 then  
                            cc.Director:getInstance():endToLua()
                        else  
                            device.cancelAlert()  --取消对话框 
                            self:removeChild(self.touchLayer)
                            self.touchLayer  = nil 
                    end 
                end)
            end
        end)
        self.touchLayer:setKeypadEnabled(true)
        self:addChild(self.touchLayer)
    end 
end

function MenuScene:onEnter()
    
   if GameData.SOUND == 0 then 
        audio.pauseMusic()
        else
            if isHadPlayMusic == false then
                    audio.playMusic(GAME_SOUND.classicbg)
                    isHadPlayMusic = true
                else
                    audio.rewindMusic()
            end
    end
    -- if GameData.SoundOff == 0 or  GameData.SoundOff == nil then 
    --     audio.playMusic(GAME_SOUND.classicbg)
    --     else
    --     audio.stopMusic(false)  
    -- end
    if device.platform ~= "android" then return end
	    self:performWithDelay(function()
	        -- keypad layer, for android
	        local layer = display.newLayer()
	        layer:addKeypadEventListener(function(event)
	            if event.key == "back" then
                     device.showAlert("提示", "确定退出游戏么？", {"确定", "取消"}, function (event)
                    if event.buttonIndex == 1 then  
                          --  cc.Director:getInstance():endToLua()
                          game.exit()
                        else  
                            device.cancelAlert()  --取消对话框 
                    end  
                    end)

                  end
	        end)
	        self:addChild(layer)

	        layer:setKeypadEnabled(true)
	    end, 0.5)
end

function MenuScene:onExit()
    print("MenuScene ==>onExit ")
    self:removeAllChildren()
end

return MenuScene
