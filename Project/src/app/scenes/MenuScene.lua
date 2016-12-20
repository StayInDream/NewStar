local BubbleButton = import("..views.BubbleButton")
local CCLabelChange = import("..views.CCLabelChange")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local MenuScene = class("MenuScene", function()
    return display.newScene("MenuScene")
end)

local shopTypes = {{50.00, 500}, {30.00, 200}, {15.00, 80}, {10.00, 50}, {5.00,15}, {2.00,5} , {1.00,2} }
function MenuScene:ctor()
    self.bg = display.newSprite(GAME_IMAGE.Bg_Stage)
    self.bg:setPosition(display.cx, display.cy )
	self:addChild(self.bg)
	
    local layer_logging = display.newLayer() --loading 层
    self:addChild(layer_logging,1)
    local layer_menu = display.newLayer() --菜单按钮层
    self:addChild(layer_menu,1)
    layer_menu:setVisible(false)

        local  sp_jsy = display.newSprite(GAME_IMAGE.jsy)
            :align(cc.ui.TEXT_ALIGN_CENTER, display.cx , display.cy )
            :addTo(layer_logging)

        local  sp_jiazai = display.newSprite(GAME_IMAGE.jiazai)
            :align(cc.ui.TEXT_ALIGN_CENTER, display.cx + 15, display.bottom + 30)
            :addTo(layer_logging)

        scheduler.performWithDelayGlobal(function ()
                layer_logging:setVisible(false)
                layer_menu:setVisible(true)
            end, 0.1)



--[[菜单层设置  ---start ]]

	self.coin_bar  = display.newSprite(GAME_IMAGE.coin_bar, display.cx - self.bg:getContentSize().width / 2 + 100,display.cy + self.bg:getContentSize().height / 2  - 30)
    layer_menu:addChild(self.coin_bar)
    local lbl_coin = cc.ui.UILabel.new({
        UILabelType = 1,
        text  =  "0",
        font = GAME_FONT,
      --  size = 10,
       
    })
        :align(cc.ui.TEXT_ALIGN_CENTER, display.cx - self.bg:getContentSize().width / 2 + 115, display.cy + self.bg:getContentSize().height / 2 - 25)
        :addTo(layer_menu)
        :setScale(0.5)

	self.jinbi_tiao  = display.newSprite(GAME_IMAGE.jinbi_tiao, display.cx - self.bg:getContentSize().width / 2 + 270,display.cy + self.bg:getContentSize().height / 2 - 30)
    layer_menu:addChild(self.jinbi_tiao)
    local lbl_jinbi = cc.ui.UILabel.new({
        UILabelType = 1,
        text  =  "1234578",
        font = GAME_FONT,
        size = 20
    })
        :align(cc.ui.TEXT_ALIGN_CENTER,  display.cx - self.bg:getContentSize().width / 2 + 285, display.cy + self.bg:getContentSize().height / 2 - 25)
        :addTo(layer_menu)
         :setScale(0.5)

    -- logo
    self.logo  = display.newSprite(GAME_IMAGE.logo_xin_1)
    self.logo:setPosition(display.cx, display.cy + self.logo:getContentSize().height  + 100)
    layer_menu:addChild(self.logo)
	transition.moveTo( self.logo, {time = 0.7, y = display.cy +  self.logo:getContentSize().height , easing = "BOUNCEOUT"})

    -- add buttons 

	-- 设置
    self.GameSetButton = BubbleButton.new({
            image = GAME_IMAGE.menu_btn,
            sound = GAME_SOUND.pselect,
            prepare = function()
                audio.playSound(GAME_SOUND.pselect)
                self.GameSetButton:setButtonEnabled(false)
            end,
            listener = function()
                self:ShowSettingView()
            end,
        })
        :align(display.BOTTOM, display.cx - self.bg:getContentSize().width / 2 + 70, display.cy -  self.bg:getContentSize().height / 2 + 50)
        :addTo(layer_menu)

	-- 邮件
    self.EmailButton = BubbleButton.new({
            image = GAME_IMAGE.btn_email,
            sound = GAME_SOUND.pselect,
            prepare = function()
                audio.playSound(GAME_SOUND.pselect)
                self.EmailButton:setButtonEnabled(false)
            end,
            listener = function()
                self:ShowEmail()
            end,
        })
        :align(display.BOTTOM, display.cx - self.bg:getContentSize().width / 2 + 160, display.cy -  self.bg:getContentSize().height / 2 + 50)
        :addTo(layer_menu)

	--商城
    self.ShopButton = BubbleButton.new({
            image = GAME_IMAGE.Button_Shop,
            sound = GAME_SOUND.pselect,
            prepare = function()
                audio.playSound(GAME_SOUND.pselect)
                self.ShopButton:setButtonEnabled(false)
            end,
            listener = function()
                self:ShowShop()
            end,
        })
        :align(display.BOTTOM, display.cx - self.bg:getContentSize().width / 2 + 250, display.cy -  self.bg:getContentSize().height / 2 + 50)
        :addTo(layer_menu) 

	--排行榜
    self.RankButton = BubbleButton.new({
            image = GAME_IMAGE.paihangbang,
            sound = GAME_SOUND.pselect,
            prepare = function()
                audio.playSound(GAME_SOUND.pselect)
                self.RankButton:setButtonEnabled(false)
            end,
            listener = function()
                self:ShowRank()
            end,
        })
        :align(display.BOTTOM, display.cx - self.bg:getContentSize().width / 2+ 340, display.cy -  self.bg:getContentSize().height / 2 + 50)
        :addTo(layer_menu) 

	--兑换码
    self.CDKEYButton = BubbleButton.new({
            image = GAME_IMAGE.CDKEY_btn,
            sound = GAME_SOUND.pselect,
            prepare = function()
                audio.playSound(GAME_SOUND.pselect)
                self.CDKEYButton:setButtonEnabled(false)
            end,
            listener = function()
                self:ShowCDKEY()
            end,
        })
        :align(display.BOTTOM, display.cx - self.bg:getContentSize().width / 2 + 430, display.cy -  self.bg:getContentSize().height / 2 + 50)
        :addTo(layer_menu) 

    --新游戏
    self.NewGameButton = BubbleButton.new({
            image = GAME_IMAGE.popstar_start,
            sound = GAME_SOUND.pselect,
            prepare = function()
                audio.playSound(GAME_SOUND.pselect)
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
                audio.playSound(GAME_SOUND.pselect)
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
        :align(display.CENTER,  display.cx + self.bg:getContentSize().width / 2 - 100 , display.cy +  self.bg:getContentSize().height / 2 - 350)
        :onButtonClicked(function()
            audio.playSound(GAME_SOUND.pselect)
           -- app:enterMenuScene()
        end)
        :addTo(layer_menu)
    local sequenceAction = transition.sequence({
            cc.ScaleTo:create(0.5, 1.2, 1.2, 1), 
            cc.ScaleTo:create(0.5, 1, 1, 1), 
            })

      transition.execute(self.TeQuanButton, cc.RepeatForever:create( sequenceAction ))

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
            self.sp_btnbg:moveTo(0.3, display.left  - 50 , display.bottom + 150)
            end)
    btn_mask:fadeTo(0.5, 255)

    self.sp_btnbg = display.newSprite(GAME_IMAGE.for_bg)
        :align(display.CENTER, display.left  - 50 , display.bottom + 150)
        :addTo(layer_setting)

        local sp_ = GAME_IMAGE.Button_SoundOn
        if GameData.SOUND == 0 then
            sp_ = GAME_IMAGE.Button_SoundOff
        end

    self.soundButton = cc.ui.UIPushButton.new({normal = sp_, pressed = sp_})
        :addTo(self.sp_btnbg) 
        :align(self.sp_btnbg, 25, 150)
        :setScale(0.45)
        :onButtonClicked(function()
                audio.playSound(GAME_SOUND.pselect)
                if GameData.SOUND == 0 then
                        GameData.SOUND = 1
                        self.soundButton:setButtonImage( cc.ui.UIPushButton.NORMAL, GAME_IMAGE.Button_SoundOn ,true)
                        self.soundButton:setButtonImage( cc.ui.UIPushButton.PRESSED,GAME_IMAGE.Button_SoundOn ,true)
                    else
                        GameData.SOUND = 0
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
                self.sp_btnbg:moveTo(0.3, display.left  - 50 , display.bottom + 150)
                end,0.3)
        end)

    local setingButton = cc.ui.UIPushButton.new({normal = GAME_IMAGE.set_about, pressed = GAME_IMAGE.set_about})
        :addTo(self.sp_btnbg) 
        :align(self.sp_btnbg, 25, 95)
        :setScale(0.8)
        :onButtonClicked(function()
            audio.playSound(GAME_SOUND.pselect)
            scheduler.performWithDelayGlobal(function()
                -- body
                self:removeChild(layer_setting)
            end,0.5)
            self.sp_btnbg:moveTo(0.3, display.left  - 50 , display.bottom + 150)
        end)

    local exitButton = cc.ui.UIPushButton.new({normal = GAME_IMAGE.set_back, pressed = GAME_IMAGE.set_back})
        :addTo(self.sp_btnbg) 
        :align(self.sp_btnbg, 25, 40)
        :setScale(0.8)
        :onButtonClicked(function()
            audio.playSound(GAME_SOUND.pselect)
            scheduler.performWithDelayGlobal(function()
                -- body
                self:removeChild(layer_setting)
                self:ExitGame()
            end,0.5)
            self.sp_btnbg:moveTo(0.3, display.left  - 50 , display.bottom + 150)
           
        end)
        self.sp_btnbg:moveTo(0.3, display.left + 22 , display.bottom + 150)
end
function MenuScene:ShowShop()
    local layer_shop = display.newLayer()
    :addTo(self ,1)

    local sp_mask = display.newSprite( GAME_IMAGE.sp_mask)
    :align(display.CENTER, display.cx , display.cy)
    :addTo(layer_shop) 
    :setScale(20)

    local sp_mask = display.newSprite( GAME_IMAGE.sp_mask)
    :align(display.CENTER, display.cx , display.cy)
    :addTo(layer_shop) 
    :setScale(20)
    :setOpacity(0)
    sp_mask:fadeTo(1, 255)

    local sp_bg01 = display.newScale9Sprite( GAME_IMAGE.huodong_diban_2, display.left - 250 , display.cy + 50, cc.size(400, 600) )
    :addTo(layer_shop) 
    scheduler.performWithDelayGlobal(function()
         transition.moveTo(sp_bg01, {
            x = display.cx ,
            y = display.cy + 50,
            time = 0.5,
            easing = "backOut",
            })
            end , 0.1)

    local sp_bg02 = display.newSprite( GAME_IMAGE.shangdian_biaotoutu )
    :align(sp_bg01, 200, 580)
    :addTo(sp_bg01)

    local sp_03 = display.newSprite( GAME_IMAGE.shangdian_wenzi )
    :align(sp_bg01, 200, 590)
    :addTo(sp_bg01)

    local closeButton = cc.ui.UIPushButton.new({normal = GAME_IMAGE.close_bg, pressed = GAME_IMAGE.close_bg})
    :align(sp_bg01, 390, 570)
    :addTo(sp_bg01)
    :onButtonClicked(function()
        audio.playSound(GAME_SOUND.pselect)
        scheduler.performWithDelayGlobal(function()
            -- body
            transition.moveTo(sp_bg01, {
                x = display.cx - 700,
                y = display.cy + 50,
                time = 0.5,
                easing = "backIn",
                onComplete = function()
                   self:removeChild(layer_shop)
                end,
                })
        end, 0.1)

        end)

    local duanxinButton = cc.ui.UIPushButton.new({normal = GAME_IMAGE.duanxinzhifu_2, pressed = GAME_IMAGE.duanxinzhifu_2})
    :align(sp_bg01, 200, 510)
    :addTo(sp_bg01)
    :onButtonClicked(function()
        --audio.playSound(GAME_SOUND.pselect)
        print("duanxin fu")
        end)

    local sp_shopitemBG = display.newScale9Sprite( GAME_IMAGE.shop_item_bg_2 ,200 , 280, cc.size(350, 400))
    :addTo(sp_bg01)

    local sp_04 = display.newSprite( GAME_IMAGE.emailIcon_diamond)
    :align(sp_bg01, 280, 50)
    :setScale(0.4)
    :addTo(sp_bg01)

    local lbl_01 = cc.ui.UILabel.new({
        UILabelType = 2,
        text  =  "拥有:",
        size = 20,
        })
    :align(sp_bg01, 210, 50)
    :addTo(sp_bg01)

    local diaNum = GameData.DIAMOND
    if diaNum == nil then
        diaNum = 0
    end

     local lbl_02 = cc.ui.UILabel.new({
        UILabelType = 1,
        text  =  diaNum,
        font  = GAME_FONT,
        })
    :setScale(0.4)
    :align(sp_bg01, 300, 50)
    :addTo(sp_bg01)

    --滚动
    local ListView  = cc.ui.UIListView.new({
            viewRect  = cc.rect(0,0,350,390),
            direction = cc.ui.UIListView.DIRECTION_VERTICAL,
            items_ = {},

        })
        :addTo(sp_bg01)
        :align(sp_bg01, 25, 86)
        :setBounceable(true) 
        -- 注册滚动事件 通过event.name区分
        ListView:onScroll( function(event)
            -- TODO: sth
        end)

        for i=1, #shopTypes do
            local content = display.newScale9Sprite( GAME_IMAGE.shop_item_bg_1 ,0 , 0, cc.size(330, 60))
            local sp_dia = display.newSprite( GAME_IMAGE.emailIcon_diamond)
            :align(content, 30, 35)
            :addTo(content)
            :setScale(0.4)

            local sp_zengbig_unicom = display.newSprite( GAME_IMAGE.zengbig_unicom)
            :align(content, 150, 35)
            :addTo(content)
            :setScale(0.3)

            local lbl_001 = cc.ui.UILabel.new({
                UILabelType = 1,
                text  =  shopTypes[i][1] * 10 .. "个",
                font = GAME_FONT,
                --size = 40
                })
            :align(content, 65, 35)
            :setScale(0.4)
            :addTo(content)

             local lbl_002 = cc.ui.UILabel.new({
                UILabelType = 1,
                text  =  shopTypes[i][2] .. "个",
                font = GAME_FONT,
                --size = 40
                })
            :align(content, 180, 35)
            :setScale(0.4)
            :addTo(content)

            local buyButton = cc.ui.UIPushButton.new({normal = GAME_IMAGE.anniu, pressed = GAME_IMAGE.anniu1})
            :align(content, 280, 30)
            :addTo(content)
            :setScaleX(0.5)
            :setScaleY(0.6)
            :onButtonClicked(function()
                print("buy something")
                end)

            local lbl_003 = cc.ui.UILabel.new({
                UILabelType = 2,
                text  = "￥" .. math.floor(shopTypes[i][1]) .."" .. ".00",
                size  = 40 ,
                })
            :align(content, 245, 30)
            :setScale(0.5)
            :setTextColor(cc.c3b(0, 0, 0))
            :addTo(content)
            
            local listItem = ListView:newItem(content)
            listItem:setItemSize(330, 60)  
            ListView:addItem(listItem)
        end
        ListView:reload() 


end

function MenuScene:ShowEmail()
    --self:enterScene("SetGameScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MenuScene:ShowRank()
    --self:enterScene("SetGameScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MenuScene:ShowCDKEY()
    --self:enterScene("SetGameScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MenuScene:ExitGame()
    -- body
    print("退出游戏")
end

function MenuScene:onEnter()
   -- audio.playMusic(GAME_SOUND.classicbg)
    -- if GameData.SoundOff == 0 or  GameData.SoundOff == nil then 
    --     audio.playMusic(GAME_SOUND.classicbg)
    --     else
    --     audio.stopMusic(false)  
    -- end
    if device.platform ~= "android" then return end
	    -- avoid unmeant back
	    self:performWithDelay(function()
	        -- keypad layer, for android
	        local layer = display.newLayer()
	        layer:addKeypadEventListener(function(event)
	            if event == "back" then game.exit() end
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
