local BubbleButton = import("..views.BubbleButton")
local CCLabelChange = import("..views.CCLabelChange")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local Shop = import("..views.Shop")
local WarningWin = import("..views.WarningWin")

local MenuScene = class("MenuScene", function()
    return display.newScene("MenuScene")
end)

local activityTypes = {  }

function MenuScene:ctor()
     -- local sp_mark = display.newScale9Sprite(GAME_IMAGE.sp_mask ,display.cx, display.cy, cc.size(display.widthInPixels, display.heightInPixels) )
     -- :addTo(self)

    self.bg = display.newSprite(GAME_IMAGE.Bg_Stage)
    self.bg:setPosition(display.cx, display.cy )
	self:addChild(self.bg)

    self.Shop = Shop.new()
    :addTo(self,100)

    self.WarningWin = WarningWin.new()
    :addTo(self,150)

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
        :align(display.CENTER, display.cx  +10, display.bottom + 50 )
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
    local editBox2 = cc.ui.UIInput.new({
        image =GAME_IMAGE.CDKEY_btn,
        size = cc.size(63, 73),
        x = display.cx +170,
        y = display.bottom + 50 ,
        listener = function(event, editbox)
            if event == "began" then
               -- self:onEditBoxBegan(editbox)
            elseif event == "ended" then
                --self:onEditBoxEnded(editbox)
                local _trimed = string.trim(editbox:getText())
                --判断兑换码是否匹配
                self.WarningWin:ShowWaringInfo({ })

                editbox:setText("")
            elseif event == "return" then
             --   self:onEditBoxReturn(editbox)
            elseif event == "changed" then
               -- self:onEditBoxChanged(editbox)
            else
             --   printf("EditBox event %s", tostring(event))
            end
        end
    })
    editBox2:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
    layer_menu:addChild(editBox2)

    -- self.CDKEYButton = BubbleButton.new({
    --         image = GAME_IMAGE.CDKEY_btn,
    --         sound = GAME_SOUND.pselect,
    --         prepare = function()
    --             if GameData.SOUND == 1 then
    --             audio.playSound(GAME_SOUND.pselect)
    --             end
    --             self.CDKEYButton:setButtonEnabled(false)
    --         end,
    --         listener = function()
    --             self:ShowCDKEY()
    --         end,
    --     })
    --     :align(display.CENTER, display.cx + 170, display.bottom + 50 )
    --     :addTo(layer_menu) 

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
            self.Shop:Show( Shop.SHOPTYPE.ShopType_4)
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

    --活动
    self.ActivityButton =  cc.ui.UIPushButton.new({normal =  GAME_IMAGE.emailIcon_activity, pressed =   GAME_IMAGE.emailIcon_activity})
        :align(display.CENTER, display.left + 50, display.cy )
        :onButtonClicked(function()
            if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
            end
            self:EnterActivity()
        end)
        :addTo(layer_menu)

       -- 添加背景粒子特效
    local particle = cc.ParticleSystemQuad:create(GAME_PARTICE.Particle_TileDebris)
    :align(display.CENTER, display.cx, display.cy)
    layer_menu:addChild(particle,1)  

   

end

function MenuScene:onKeypad( event )
    -- body
    if device.platform == "android" then
        if event.key == "back" then
            device.showAlert("提示", "确定退出游戏么？", {"确定", "取消"}, function (event)
                if event.buttonIndex == 1 then
                        cc.Director:getInstance():endToLua()  
                       -- game.exit()
                    else  
                        device.cancelAlert()  --取消对话框 
                end
            end )
        end
    end
end

--进入活动列表
function MenuScene:EnterActivity()
    -- body
     self.btn_mask = cc.ui.UIPushButton.new({normal =  GAME_IMAGE.sp_mask, pressed =  GAME_IMAGE.sp_mask})
            :align(display.CENTER, display.cx , display.cy)
            :addTo(self,1) 
            :setScale(20)
            :setOpacity(0)
         self.btn_mask:fadeTo(1, 255)
    if self.layer_activity == nil then
        self.layer_activity = display.newLayer()
        :align(display.CENTER, display.left - display.width, display.cy)
        :addTo(self ,2)

        local sp_bg01 = display.newScale9Sprite( GAME_IMAGE.huodong_diban_2, display.cx , display.cy , cc.size(400, 600) )
        :addTo(self.layer_activity) 

        local sp_bg02 = display.newSprite( GAME_IMAGE.title_silk_22  )
        :align( display.CENTER, sp_bg01:getPositionX() , sp_bg01:getPositionY()+300)
        :addTo(self.layer_activity)

        local sp_bg03 = display.newScale9Sprite( GAME_IMAGE.btnFrame , sp_bg01:getContentSize().width / 2 , sp_bg01:getContentSize().height / 2 - 35 , cc.size(370, 480)  )
        :addTo(sp_bg01)

        local sp_title= display.newSprite( GAME_IMAGE.huodongzhongxin  )
        :align( display.CENTER, sp_bg02:getPositionX() , sp_bg02:getPositionY() + 20)
        :addTo(self.layer_activity)

        local sp_noactivity= display.newSprite( GAME_IMAGE.no_activity  )
        :align( display.CENTER, sp_bg01:getPositionX() , sp_bg01:getPositionY())
        :addTo(self.layer_activity)
        :setVisible(false)

         --任务菜单按钮
        --日常任务

        local btn_dayActivity=  cc.ui.UIPushButton.new({normal =  GAME_IMAGE.anniu, pressed =  GAME_IMAGE.anniu1 , disabled = GAME_IMAGE.anniu1 }, {scale9 = true})
            :align(display.CENTER, sp_bg01:getPositionX() - 100, sp_bg01:getPositionY() + 225 )
            :setButtonSize(110, 65)
          --  :setButtonEnabled(false)
            :setButtonLabel("normal", cc.ui.UILabel.new({
                UILabelType = 2,
                text = "悬赏任务",
                size = 22,
                color = cc.c3b(0, 0, 0)
            }))-- 设置各个状态的按钮显示文字
             :setButtonLabel("disabled", cc.ui.UILabel.new({
                UILabelType = 2,
                text = "悬赏任务",
                size = 22,
                color = cc.c3b(0, 255, 0)
            }))-- 设置各个状态的按钮显示文字
            :onButtonClicked(function()
                if GameData.SOUND == 1 then
                    audio.playSound(GAME_SOUND.pselect)
                end
               
            end)
            :addTo(self.layer_activity)

            local btn_dayActivity=  cc.ui.UIPushButton.new({normal =  GAME_IMAGE.close_bg, pressed =  GAME_IMAGE.close_bg  })
                :align(display.CENTER,sp_bg02:getContentSize().width,sp_bg02:getContentSize().height /2  )
                :addTo(sp_bg02)
                :onButtonClicked(function()
                    transition.moveTo( self.layer_activity, {
                        x = display.left - display.width,
                        y = display.cy, 
                        time = 0.5,
                        easing = "backIn" ,
                        onComplete = function ()
                            -- body
                            self:removeChild( self.btn_mask)
                             self.btn_mask = nil 
                        end,
                        })
                    end)

        if activityTypes~= nil and type(activityTypes) == "table" and #activityTypes > 0 then 

            local ListView  = cc.ui.UIListView.new({
                    viewRect  = cc.rect(0,0,370,472),
                    direction = cc.ui.UIListView.DIRECTION_VERTICAL,
                    items_ = {},
                   -- bg     = GAME_IMAGE.btnFrame,
                   -- bgScale9  = true,

                })
                :addTo(sp_bg01)
                :align(display.CENTER, 15 , 28)
                :setBounceable(true) 
                -- 注册滚动事件 通过event.name区分
                ListView:onScroll( function(event)
                    -- TODO: sth
                end)


            for i=1,#activityTypes  do
                local content = display.newScale9Sprite( GAME_IMAGE.shop_item_bg_1 ,0 , 0, cc.size(350, 60))
                
                local btn_get = cc.ui.UIPushButton.new({normal = GAME_IMAGE.anniu, pressed = GAME_IMAGE.anniu1 ,disabled = GAME_IMAGE.anniu1} )
                :align(display.CENTER, 300, 30)
                :addTo(content)
                :setScaleX(0.4)
                :setScaleY(0.6)
                :setButtonEnabled(false)
                :setButtonLabel("disabled", cc.ui.UILabel.new({
                UILabelType = 2,
                text = "未 达 成",
                size = 30,
                color = cc.c3b(0, 255, 0)
                }))-- 设置各个状态的按钮显示文字
                :setButtonLabel("normal", cc.ui.UILabel.new({
                UILabelType = 2,
                text = "领 取",
                size = 30,
                color = cc.c3b(0, 0, 0)
            }))-- 设置各个状态的按钮显示文字
                :onButtonClicked(function()
                     if GameData.SOUND == 1 then audio.playSound(GAME_SOUND.pselect) end

                    end)

                local  sp_contentMask = display.newScale9Sprite(GAME_IMAGE.sp_mask , 125, 33, cc.size(240, 45))
                --:addTo(content)

                --任务描述
                local lbl_task = cc.ui.UILabel.new({
                    UILabelType = 2,
                    text  =  "消灭星星的总数达到1000个,奖励钻石100枚。",
                    size = 18,
                    valign = cc.ui.TEXT_ALIGNMENT_CENTER,
                    dimensions = cc.size(210, 50),
                    color = cc.c3b(255, 0, 255)               
                    })
                    :align(display.CENTER, 120, 30 )
                    :addTo(content)

                --任务进度
                -- local lbl_taskPross = cc.ui.UILabel.new({
                --     UILabelType = 2,
                --     text  =  " 100/1000",
                --     size = 15,
                --     valign = cc.ui.TEXT_ALIGN_CENTER,
                --     dimensions = cc.size(100, 60)
                --     })
                --     :align(display.CENTER, 260, 30 )
                --     :addTo(content)    

            local listItem = ListView:newItem(content)
                listItem:setItemSize(350, 60)  
                ListView:addItem(listItem)
            end
            ListView:reload() 
           
            else
                sp_noactivity:setVisible(true)

        end
    end

    

    scheduler.performWithDelayGlobal(function( )
        -- body
        transition.moveTo(self.layer_activity, {
        x = display.cx ,
        y = display.cy ,
        time = 0.5,
        easing = "backOut",
        })
    end, 0.1)
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
                self:ExitGame()
                layer_setting:removeAllChildren()
                self:removeChild(layer_setting)
            end,0.5)
            self.sp_btnbg:moveTo(0.3, display.left  - 50 , display.bottom + 250)
           
        end)
        self.sp_btnbg:moveTo(0.3, display.left + 25 , display.bottom + 250)

end

function MenuScene:ShowEmail()
    self.WarningWin:ShowWaringInfo({dec = "暂未开启,敬请期待..."})
end

function MenuScene:ShowRank()
    self.WarningWin:ShowWaringInfo({dec = "暂未开启,敬请期待..."})
end

function MenuScene:ShowCDKEY()
    --self:enterScene("SetGameScene", nil, "fade", 0.6, display.COLOR_WHITE)
     -- GameData.CDKEY =  device.showInputBox("请输入您的兑换码", "", "")
end

function MenuScene:ExitGame(event)
    -- -- body
    -- print("退出游戏")
    if device.platform == "android" then
        device.showAlert("提示", "确定退出游戏么？", {"确定", "取消"}, function (event)
            if event.buttonIndex == 1 then
                    cc.Director:getInstance():endToLua()  
                   -- game.exit()
                else  
                    device.cancelAlert()  --取消对话框 
            end 
        end)
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
                   -- audio.rewindMusic()
            end
    end

    self.touchLayer = display.newLayer()
        self.touchLayer:addNodeEventListener(cc.KEYPAD_EVENT, function(event)
            if event.key == "back" then  
                device.showAlert("提示", "确定退出游戏么？", {"确定", "取消"}, function (event)
                    if event.buttonIndex == 1 then
                            cc.Director:getInstance():endToLua()  
                           -- game.exit()
                        else  
                            device.cancelAlert()  --取消对话框 
                    end 
                end)
            end
        end)
        self.touchLayer:setKeypadEnabled(true)
        self:addChild(self.touchLayer,-10)
end

function MenuScene:onExit()
    print("MenuScene ==>onExit ")
    self:removeAllChildren()
end

return MenuScene
