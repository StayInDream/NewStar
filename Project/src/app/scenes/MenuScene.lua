local BubbleButton = import("..views.BubbleButton")

local MenuScene = class("MenuScene", function()
    return display.newScene("MenuScene")
end)

function MenuScene:ctor()
    self.bg = display.newSprite(GAME_IMAGE.Bg_Stage)
    self.bg:setPosition(display.cx, display.cy )
	self:addChild(self.bg)

	
	self.coin_bar  = display.newSprite(GAME_IMAGE.coin_bar, display.cx - self.bg:getContentSize().width / 2 + 100,display.cy + self.bg:getContentSize().height / 2  - 30)
    self:addChild(self.coin_bar)
     local lbl_coin = cc.ui.UILabel.new({
        UILabelType = 2,
        text  =  "0",
        size = 20
    })
        :align(cc.ui.TEXT_ALIGN_CENTER, display.cx - self.bg:getContentSize().width / 2 + 115, display.cy + self.bg:getContentSize().height / 2 - 25)
        :addTo(self)

	self.jinbi_tiao  = display.newSprite(GAME_IMAGE.jinbi_tiao, display.cx - self.bg:getContentSize().width / 2 + 270,display.cy + self.bg:getContentSize().height / 2 - 30)
    self:addChild(self.jinbi_tiao)
    local lbl_jinbi = cc.ui.UILabel.new({
        UILabelType = 2,
        text  =  "1234578",
        size = 20
    })
        :align(cc.ui.TEXT_ALIGN_CENTER,  display.cx - self.bg:getContentSize().width / 2 + 285, display.cy + self.bg:getContentSize().height / 2 - 25)
        :addTo(self)


    --self:addChild(label)

    self.logo  = display.newSprite(GAME_IMAGE.logo_xin_1)
    self.logo:setPosition(display.cx, display.cy + self.logo:getContentSize().height  + 100)
    self:addChild(self.logo)
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
                app:ShowSetting()
            end,
        })
        :align(display.BOTTOM, display.cx - self.bg:getContentSize().width / 2 + 70, display.cy -  self.bg:getContentSize().height / 2 + 50)
        :addTo(self)

	-- 邮件
    self.EmailButton = BubbleButton.new({
            image = GAME_IMAGE.btn_email,
            sound = GAME_SOUND.pselect,
            prepare = function()
                audio.playSound(GAME_SOUND.pselect)
                self.EmailButton:setButtonEnabled(false)
            end,
            listener = function()
                app:ShowEmail()
            end,
        })
        :align(display.BOTTOM, display.cx - self.bg:getContentSize().width / 2 + 160, display.cy -  self.bg:getContentSize().height / 2 + 50)
        :addTo(self)

	--商城
    self.ShopButton = BubbleButton.new({
            image = GAME_IMAGE.Button_Shop,
            sound = GAME_SOUND.pselect,
            prepare = function()
                audio.playSound(GAME_SOUND.pselect)
                self.ShopButton:setButtonEnabled(false)
            end,
            listener = function()
                app:ShowShop()
            end,
        })
        :align(display.BOTTOM, display.cx - self.bg:getContentSize().width / 2 + 250, display.cy -  self.bg:getContentSize().height / 2 + 50)
        :addTo(self) 

	--排行榜
    self.RankButton = BubbleButton.new({
            image = GAME_IMAGE.paihangbang,
            sound = GAME_SOUND.pselect,
            prepare = function()
                audio.playSound(GAME_SOUND.pselect)
                self.RankButton:setButtonEnabled(false)
            end,
            listener = function()
                app:ShowRank()
            end,
        })
        :align(display.BOTTOM, display.cx - self.bg:getContentSize().width / 2+ 340, display.cy -  self.bg:getContentSize().height / 2 + 50)
        :addTo(self) 

	--兑换码
    self.CDKEYButton = BubbleButton.new({
            image = GAME_IMAGE.CDKEY_btn,
            sound = GAME_SOUND.pselect,
            prepare = function()
                audio.playSound(GAME_SOUND.pselect)
                self.CDKEYButton:setButtonEnabled(false)
            end,
            listener = function()
                app:ShowCDKEY()
            end,
        })
        :align(display.BOTTOM, display.cx - self.bg:getContentSize().width / 2 + 430, display.cy -  self.bg:getContentSize().height / 2 + 50)
        :addTo(self) 

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
        :align(display.CENTER, display.cx , display.cy +  self.bg:getContentSize().height / 2 - 400)
        :addTo(self) 

    --继续游戏
    self.ContinueGameButton = BubbleButton.new({
            image = GAME_IMAGE.popstar_continue,
            sound = GAME_SOUND.pselect,
            prepare = function()
                audio.playSound(GAME_SOUND.pselect)
                self.ContinueGameButton:setButtonEnabled(false)
            end,
            listener = function()
                app:ContinueGame()
            end,
        })
        :align(display.CENTER, display.cx , display.cy +  self.bg:getContentSize().height / 2 - 500)
        :addTo(self) 

end

function MenuScene:onEnter()
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
end

return MenuScene
