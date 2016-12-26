local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local BubbleButton = import("..views.BubbleButton")
local Shop = import("..views.Shop")
local CCLabelChange = import("..views.CCLabelChange")

local MatrixStar = class("MatrixStar",function()
	return display.newLayer()
end)

local STAR_RES_LIST = {"#1000.png","#1001.png",
"#1002.png","#1003.png","#1004.png"}

--被选中时的星星图
local STAR_RES_LIST_SELECT = {"#bg_1000.png","#bg_1001.png",
"#bg_1002.png","#bg_1003.png","#bg_1004.png"}

-- 
local LBL_LIST = {"image/praise5.png","praise8.png",
"praise10.png","praise12.png","praise18.png","praise25.png"}

local STAR_PARTICLE = {GAME_PARTICE.pop_star1000_particle,GAME_PARTICE.pop_star1001_particle,
GAME_PARTICE.pop_star1002_particle,GAME_PARTICE.pop_star1003_particle,GAME_PARTICE.pop_star1004_particle}

local HEIGHTSCORE  = 0   --最高分
local CURLEVEL     = 1     --当前关卡
local TARGETSCORE  = 1000  --通关分数
local CURSCORE     = 0   --当前得分
local SCALE        = 1.5   
local UNNEEDCLEAR  = 0
local NEEDCLEAR    = 1
local CLEAROVER    = 2
local MOVEDELAY    = 1.5
local BOOL_ISCONTINUE = 0  --读档开始， 值为1是读档
local DIAMOND         = 15  --拥有钻石的数量
local MAP = {}
local GAMESTATE    = 0 --游戏状态， 0->开始布局新的星星， 1 ->存档 ， 2->游戏失败 ,3 -> 游戏准备好，按钮可以点击
local SOUND = 1  --游戏声音， 1是on ， 0 是off


local STAR_WIDTH  = 48 
local STAR_HEIGHT = 48  
local ROW = 10
local COL = 10
local LEFT_STAR = 15    --剩余星星小于该数给予奖励
local STARGAIN  = 5      --星星得分基数

local MOVESPEED = 4     --星星的移动速度
local mHandle   = nil

local node_title     = nil --标头 显示分数道具等
local layer_stars    = nil --星星逻辑层
local node_prop3Btns = nil  --使用刷子时，弹出的按钮窗 
local node_paseview  = nil  --暂停界面
local node_faileView = nil  --失败界面

local lbl_stage       = nil --关卡
local lbl_target      = nil --目标分数
local lbl_heightScore = nil  --最高分
local lbl_curscore    = nil --得分
local lbl_diamond     = nil --钻石数量
local lbl_prop1       = nil --道具1
local lbl_prop2       = nil --道具2
local lbl_prop3       = nil --道具3
local lbl_showStage   = nil --开始前的报幕lbl 

local sp_tongguan                 = nil
local lbl_show                    = nil
local bool_ishaveShow_sp_tongguan = false
local bool_isusingBoom            = false  --true正在使用炸弹
local bool_isusingPaint           = false  --true正在使用刷子
local bool_isfirst                = true   --true表示 刚开始游戏 或 复活进入
local bool_isgaming               = false

local comboNum = 1

function MatrixStar:ctor()
    self:LoadGameData()
    self.Hscore      = HEIGHTSCORE
    self.Level       = CURLEVEL
    self.Cscore      = CURSCORE
    self.STAR        = {}
    self.SELECT_STAR = {}  --保存颜色相同的星星
    self.clearNeed   = UNNEEDCLEAR  -- 是否需要清除剩余的星星
    self:initTitles()  
    self:ShowPauseView()
    SOUND = GameData.SOUND
    bool_isfirst     = true
    self.Shop = Shop.new()
    :addTo(self,100)
    if GAMESTATE == 2 then 
            self:ShowFail()
        else
            self:Show()
    end
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
       return self:onTouch(event, event.x, event.y) 
    end, false)

    self:addNodeEventListener(cc.KEYPAD_EVENT,function(event)
       return self:onKeypad(event) 
    end, false)
    self:setKeypadEnabled(true)
end  

function MatrixStar:Show() 
    -- body
        bool_isfirst = false
        self.clearNeed = UNNEEDCLEAR
        lbl_showStage:setString( "   ".."第 " ..CURLEVEL .." 关" .. "\n\n 目标 " .. TARGETSCORE)
        scheduler.performWithDelayGlobal( function ( )
            -- body
             transition.moveTo(lbl_showStage, {x = display.cx , y = display.cy, time = 0.5} )
        end ,0.8)  
        scheduler.performWithDelayGlobal( function ( )
            -- body
            if GameData.SOUND == 1 then
            audio.playSound(GAME_SOUND.pstar)
            end
        end ,1.1)  
        scheduler.performWithDelayGlobal( function ( )
            -- body
            transition.moveTo(lbl_showStage, {x = display.cx - 400, y = display.cy, time = 0.5} )
        end ,2.3)  
        scheduler.performWithDelayGlobal( function ( )
            -- body
            lbl_showStage:setPosition( display.cx + 400, display.cy)
            self:initMatrix()  
            self:setLabel( HEIGHTSCORE, CURLEVEL ,TARGETSCORE, CURSCORE)
            sp_tongguan:setScale(0)
        end ,2.8)  
end

function MatrixStar:LoadGameData( )
    -- body
    if GameData.HEIGHTSCORE ~= nil then
        HEIGHTSCORE = GameData.HEIGHTSCORE
    end

    if GameData.CURLEVEL ~= nil then
        CURLEVEL = GameData.CURLEVEL
    end

    if GameData.CURSCORE ~= nil then
        CURSCORE = GameData.CURSCORE
    end

    if GameData.TARGETSCORE ~= nil then
        TARGETSCORE = GameData.TARGETSCORE
    end

    if GameData.DIAMOND  ~= nil then
        DIAMOND = GameData.DIAMOND
    end

    if GameData.MAP ~= nil then
        MAP = GameData.MAP
    end

    if GameData.GAMESTATE ~= nil then
        GAMESTATE = GameData.GAMESTATE
    end

    if GameData.SOUND ~= nil then
        SOUND = GameData.SOUND
    end

end

function MatrixStar:SaveGameData( )
    -- body
    bool_ishaveShow_sp_tongguan = false
    GameData.HEIGHTSCORE = HEIGHTSCORE
    GameData.TARGETSCORE = TARGETSCORE
    GameData.CURLEVEL    = CURLEVEL
    GameData.CURSCORE    = CURSCORE
    GameData.DIAMOND     = DIAMOND
    GameData.MAP         = MAP
    GameData.GAMESTATE   = GAMESTATE
    GameData.SOUND       = SOUND
    GameState.save(GameData)

end

function MatrixStar:GetMap(  )
    -- body
    MAP = {}
    for i = 1, ROW do
        for j = 1, COL do
            if self.STAR[i] ~={} and self.STAR[i][j] ~= nil and self.STAR[i][j][1] ~= nil then
                table.insert(MAP, {self.STAR[i][j][2] , i , j})
            end
        end
    end
end

--标头显示
function MatrixStar:initTitles() 
    -- body
    node_title = display.newNode()
    self:addChild(node_title , 2)

    lbl_stage = cc.ui.UILabel.new({
        UILabelType = 1,
        text  =  "第 "..CURLEVEL.." 关",
        font = GAME_FONT,
        size = 25,
        })
    :align(cc.ui.TEXT_VALIGN_CENTER, display.left + 60, display.top - 30)
    :setColor(cc.c3b(124, 252, 0))
    :setScale(0.5)
    :addTo(node_title)

    lbl_target = cc.ui.UILabel.new({
        UILabelType = 1,
        text  =  "目标 " .. TARGETSCORE,
        font = GAME_FONT,
        size = 27,
        })
    :align(cc.ui.TEXT_ALIGNMENT_LEFT, display.left + 165, display.top - 70)
    :setColor(cc.c3b(0, 255, 255))
     :setScale(0.5)
    :addTo(node_title)

    lbl_heightScore = cc.ui.UILabel.new({
        UILabelType = 1,
        text  =  "最高 " .. HEIGHTSCORE,
        font = GAME_FONT,
        size = 27,
        })
    :align(cc.ui.TEXT_ALIGNMENT_LEFT, display.left + 165, display.top - 30)
    :setColor(cc.c3b(255, 140, 0))
     :setScale(0.5)
    :addTo(node_title)


    lbl_curscore = cc.ui.UILabel.new({
        UILabelType = 1,
        text = CURSCORE,
        font = GAME_FONT,
        size = 20,
        })
    :align(cc.ui.TEXT_ALIGNMENT_LEFT, display.left + 240, display.top - 105)
     :setScale(0.5)
    :addTo(node_title)

   local sp_dangqianfenshu = display.newSprite(GAME_IMAGE.dangqianfenshu ,lbl_curscore:getPositionX() - 40, lbl_curscore:getPositionY()  )
       :setScale(0.5)  
       :addTo(node_title)

    -- 宝石按钮
    self.AddDiamondButton =  cc.ui.UIPushButton.new({normal =  GAME_IMAGE.coin_bar, pressed =  GAME_IMAGE.coin_bar})
        :align(display.CENTER,  display.left + 70, display.top - 90)
        :onButtonClicked(function()
            if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
            end
            self.Shop:Show(Shop.SHOPTYPE.ShopType_2)
        end)
        :setScale(0.8)
        :addTo(node_title)
    local sp_jiahao = display.newSprite(GAME_IMAGE.jiahao, display.left + 42,  display.top - 95) 
        :addTo(node_title) 
        :setScale(0.9)  

    lbl_diamond = cc.ui.UILabel.new({
        UILabelType = 1,
        text = DIAMOND,
        font = GAME_FONT,
        size = 18,
    })
    :align(cc.ui.TEXT_VALIGN_CENTER, display.left + 80, display.top - 87)
     :setScale(0.5)
    :addTo(node_title)


    lbl_show = cc.ui.UILabel.new({
        UILabelType = 1,
        text  =  "  ",
        font = GAME_FONT,
        size = 20,
       -- color = cc.c3b(255,140,0),
    })
    :align(cc.ui.TEXT_VALIGN_CENTER, display.cx , display.cy + 200)
    :setColor(cc.c3b(255,140,0))
     :setScale(0.5)
    :addTo(node_title)

    sp_tongguan = display.newSprite(GAME_IMAGE.stage_clear, display.cx, display.cy)
    :addTo(node_title)
    sp_tongguan:setScale(0)

    lbl_showStage = cc.ui.UILabel.new({
        UILabelType = 1,
        text  =  "  ",
        font = GAME_FONT,
        size = 40,
        color = cc.c3b(0,255,255),
    })
    :align(cc.ui.TEXT_VALIGN_CENTER, display.cx + 400, display.cy )
     :setScale(0.8)
    :addTo(node_title)


    --道具 1 重新布局
    self.Prop1Btn =  BubbleButton.new({
            image = GAME_IMAGE.Props_Rainbow,
            sound = GAME_SOUND.Props_Rainbow,
            prepare = function()
                self.Prop1Btn:setButtonEnabled(false)
            end,
            listener = function()
                self:Prop1_onclick()
            end,
        })
        :align(display.CENTER,  display.right - 50, display.top - 30)
        :setScale(0.8)
        :addTo(node_title)
    local sp_coinbar01 = display.newSprite(GAME_IMAGE.coin_bar, self.Prop1Btn:getPositionX() - 5, self.Prop1Btn:getPositionY() - 36) 
        :addTo(node_title) 
        :setScale(0.6)  

    lbl_prop1 = cc.ui.UILabel.new({
        UILabelType = 1,
        text  = 5,
        font = GAME_FONT,
        size =  18,
    })
    :align(cc.ui.TEXT_VALIGN_CENTER,self.Prop1Btn:getPositionX(), self.Prop1Btn:getPositionY() - 34)
     :setScale(0.4)
    :addTo(node_title)

    --道具 2
    self.Prop2Btn =  BubbleButton.new({
            image = GAME_IMAGE.Props_Bomb,
            sound = GAME_SOUND.Props_Paint,
            prepare = function()
                self.Prop2Btn:setButtonEnabled(false)
            end,
            listener = function()
                self:Prop2_onclick()
            end,
        })
        :align(display.CENTER,  display.right - 50, display.top - 100)
        :setScale(0.8)
        :addTo(node_title)
    local sp_coinbar02 = display.newSprite(GAME_IMAGE.coin_bar, self.Prop2Btn:getPositionX() - 5, self.Prop2Btn:getPositionY() - 36) 
        :addTo(node_title) 
        :setScale(0.6)  

    lbl_prop2 = cc.ui.UILabel.new({
        UILabelType = 1,
        text  = 5,
        font = GAME_FONT,
        size = 18,
    })
    :align(cc.ui.TEXT_VALIGN_CENTER,self.Prop2Btn:getPositionX(), self.Prop2Btn:getPositionY() - 34)
     :setScale(0.4)
    :addTo(node_title)

    --道具 3
    self.Prop3Btn =  BubbleButton.new({
            image = GAME_IMAGE.Props_Paint,
            sound = GAME_SOUND.Props_Paint,
            prepare = function()
                self.Prop3Btn:setButtonEnabled(false)
            end,
            listener = function()
                self:Prop3_onclick()
            end,
        })
        :align(display.CENTER,  display.right - 50, display.top - 170)
        :setScale(0.8)
        :addTo(node_title)

        --暂停
    self.PauseBtn = BubbleButton.new({
            image = GAME_IMAGE.pause,
            sound = GAME_SOUND.pselect,
            prepare = function()
                self.PauseBtn:setButtonEnabled(false)
            end,
            listener = function()
                if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
            end
                self:PauseBtn_onclick()
            end,
        })
        :align(display.CENTER,  display.left + 50, display.top - 170)
        :setScale(1)
        :addTo(node_title)

    local sp_coinbar03 = display.newSprite(GAME_IMAGE.coin_bar, self.Prop3Btn:getPositionX() - 5, self.Prop3Btn:getPositionY() - 36) 
        :addTo(node_title) 
        :setScale(0.6)  

    lbl_prop3 = cc.ui.UILabel.new({
        UILabelType = 1,
        text  =  5,
        font = GAME_FONT,
        size = 18,
    })
    :align(cc.ui.TEXT_VALIGN_CENTER,self.Prop3Btn:getPositionX(), self.Prop3Btn:getPositionY() - 34)
     :setScale(0.4)
    :addTo(node_title)

    node_title:fadeIn(15)

    node_prop3Btns  = display.newNode()  --使用刷子时的按钮节点
    node_title:addChild(node_prop3Btns)
    self.sp_btnbg  = display.newScale9Sprite(GAME_IMAGE.btnFrame , self.Prop3Btn:getPositionX() - 160 , self.Prop3Btn:getPositionY() + 10  ,cc.size(210,50) )
    :setOpacity(150)
    :addTo(node_prop3Btns)

    local offetx = -48*0.4 - 58
    self.prop3Btns = {}
    for i=1,#STAR_RES_LIST do
        local btn =  cc.ui.UIPushButton.new({normal =  STAR_RES_LIST[i], pressed =  STAR_RES_LIST[i]})
        :align( display.CENTER,self.sp_btnbg:getPositionX() + offetx , self.sp_btnbg:getPositionY())
        :onButtonClicked( function()
            if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
            end
            self:prop3BtnsCliclDelegete(i)
        end )
        :setScale(0.4)
        :addTo(node_prop3Btns)
        offetx = offetx + 48*0.4 + 20
        table.insert(self.prop3Btns, {btn , btn:getPositionX(), btn:getPositionY()})
        btn:setPosition(self.sp_btnbg:getPositionX() + 80 , self.sp_btnbg:getPositionY())
    end
    node_prop3Btns:setVisible(false)
end

--显示暂停界面
function MatrixStar:ShowPauseView()
    -- body
    if node_paseview == nil then 
        node_paseview = display.newNode()
        :setPosition(display.left,display.top  + 20)
        self:addChild(node_paseview , 3)

    node_paseview:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
    end, false)
    node_paseview:setTouchEnabled(true)



    local sp_bg = display.newSprite(GAME_IMAGE.front)
    :align(display.CENTER, display.cx, display.cy)
    :addTo(node_paseview)

    local lbl_rule = cc.ui.UILabel.new({
        UILabelType = 1 ,
        text  =  "基本规则:\n\n -选中并消除相连的方块\n\n - 消除的相连方块越多,分数越高\n\n - 剩余方块少于15,有额外奖励\n\n",
        font = GAME_FONT ,
        })
    :align(cc.ui.TEXT_ALIGNMENT_LEFT, display.left + 20, display.top -130)
   -- :setColor(cc.c3b(124, 252, 0))
    :setScale(0.5)
    :addTo(node_paseview)

    local sp_01 = display.newSprite(GAME_IMAGE.connected)
    :align(display.CENTER, display.left +  120, display.cy + 50)
    :addTo(node_paseview)
    local lbl_rule = cc.ui.UILabel.new({
        UILabelType = 1 ,
        text  =  "相连",
        font = GAME_FONT ,
        })
    :align(cc.ui.TEXT_VALIGN_CENTER, sp_01:getPositionX(), sp_01:getPositionY() - 100)
   -- :setColor(cc.c3b(124, 252, 0))
    :setScale(0.5)
    :addTo(node_paseview)

    local sp_02 = display.newSprite(GAME_IMAGE.connected_not)
    :align(display.CENTER, display.right - 120, display.cy + 50)
    :addTo(node_paseview)
    local lbl_rule = cc.ui.UILabel.new({
        UILabelType = 1 ,
        text  =  "不相连",
        font = GAME_FONT ,
        })
    :align(cc.ui.TEXT_VALIGN_CENTER, sp_02:getPositionX(), sp_02:getPositionY() - 100)
   -- :setColor(cc.c3b(124, 252, 0))
    :setScale(0.5)
    :addTo(node_paseview)

    local lbl_rule02 = cc.ui.UILabel.new({
        UILabelType = 1 ,
        text  =  "道具:\n\n        - 炸掉3x3方块 - 5个钻石\n\n        - 自选方块颜色 -5个钻石\n\n        - 更新所有方块位置 - 5个钻石",
        font = GAME_FONT ,
        })
    :align(cc.ui.TEXT_ALIGNMENT_LEFT, display.left + 20, display.bottom + 220)
   -- :setColor(cc.c3b(124, 252, 0))
    :setScale(0.5)
    :addTo(node_paseview)

    local sp_prop01 = display.newSprite(GAME_IMAGE.Props_Bomb)
    :align(display.CENTER, display.left + 50, display.bottom + 250)
    :setScale(0.6)
    :addTo(node_paseview)

    local sp_prop02 = display.newSprite(GAME_IMAGE.Props_Paint)
    :align(display.CENTER, display.left + 50, display.bottom + 190)
    :setScale(0.6)
    :addTo(node_paseview)

    local sp_prop03 = display.newSprite(GAME_IMAGE.Props_Rainbow)
    :align(display.CENTER, display.left + 50, display.bottom + 130)
    :setScale(0.6)
    :addTo(node_paseview)


    -- 退出按钮
        self.HomeButton = BubbleButton.new({
            image = GAME_IMAGE.Button_Home,
            sound = GAME_SOUND.pselect,
            prepare = function()
                if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
                end
                self.HomeButton:setButtonEnabled(false)
            end,
            listener = function()
                self:HomeBtn_onClick()
            end,
        })
        :align(display.CENTER, display.left + 90, display.bottom + 50)
        :setScale(0.6)
        :addTo(node_paseview)

         -- 继续按钮
        self.ContinueButton = BubbleButton.new({
            image = GAME_IMAGE.Button_Continue,
            sound = GAME_SOUND.pselect,
            prepare = function()
                if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
                end
                self.ContinueButton:setButtonEnabled(false)
            end,
            listener = function()
                self:ContinueButton_onClick()
            end,
        })
        :align(display.CENTER, display.left + 240, display.bottom + 50)
        :setScale(0.4)
        :addTo(node_paseview)

        -- 设置静音按钮
        local sp_ = GAME_IMAGE.Button_SoundOn
        if GameData.SOUND == 0 then
            sp_ = GAME_IMAGE.Button_SoundOff
        end

        self.SetVolumeButton = BubbleButton.new({
            image = sp_,
            sound = GAME_SOUND.pselect,
            prepare = function()
                if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
                end
                self.SetVolumeButton:setButtonEnabled(false)
            end,
            listener = function()
                self:SetVolume_onClick()
            end,
        })
        :setButtonImage(cc.ui.UIPushButton.NORMAL, sp_ ,true)
        :align(display.CENTER, display.left + 390, display.bottom + 50)
        :setScale(0.6)
        :addTo(node_paseview)
    end
end

function MatrixStar:ShowFaile( ... )
    -- body
end

function MatrixStar:HomeBtn_onClick( )
    -- body
    node_paseview = nil 
    GAMESTATE     = 1
    CURLEVEL      = self.Level
    CURSCORE      = self.Cscore
    HEIGHTSCORE   = self.Hscore
    if self.CCLabelChangeaction then
        self.CCLabelChangeaction:selfKill()
    end
    self:removeAllChildren()
    self:GetMap()
    self:SaveGameData()
     -- 创建一个新场景
    local nextScene = require("app.scenes.MenuScene").new()
    -- 包装过渡效果
    local transition = display.wrapSceneWithTransition(nextScene, "splitRows", 0.5)
    -- 切换到新场景
    display.replaceScene(transition)
end

function MatrixStar:ContinueButton_onClick( )
    -- body
     transition.moveTo(node_paseview, {time = 0.5 , x = display.left , y = display.top + 10 ,easing = "EXPONENTIALIN"})
end

function MatrixStar:SetVolume_onClick( )
    -- body
    if SOUND == 0 then --原本是静音
            SOUND = 1
            GameData.SOUND = 1 
            GameState.save(GameData)
            if isHadPlayMusic == false then
                    audio.playMusic(GAME_SOUND.classicbg)
                    isHadPlayMusic = true
                else
                    audio.rewindMusic()
            end
            audio.setSoundsVolume(0)
            self.SetVolumeButton:setButtonImage(cc.ui.UIPushButton.NORMAL, GAME_IMAGE.Button_SoundOn ,true)
            self.SetVolumeButton:setButtonImage(cc.ui.UIPushButton.PRESSED, GAME_IMAGE.Button_SoundOn ,true)
        else
            SOUND = 0
            GameData.SOUND = 0 
            GameState.save(GameData)
            audio.pauseMusic()
            audio.setSoundsVolume(1)
            self.SetVolumeButton:setButtonImage(cc.ui.UIPushButton.NORMAL, GAME_IMAGE.Button_SoundOff ,true)
            self.SetVolumeButton:setButtonImage(cc.ui.UIPushButton.PRESSED, GAME_IMAGE.Button_SoundOff ,true)
    end
end

-- 道具 1 点击事件
function MatrixStar:Prop1_onclick()
    if GAMESTATE ~= 3 then
        return
    end
    if  SOUND == 1 then
    end
    if GameData.SOUND == 1 then
    audio.playSound(GAME_SOUND.Props_Rainbow)
    end
    if DIAMOND >= 5 then
        self:setTouchEnabled(true)
        self.Prop1Btn:setButtonEnabled(false)
        self.Prop2Btn:setButtonEnabled(false)
        self.Prop3Btn:setButtonEnabled(false)
        self:ResetStar() 
        DIAMOND = DIAMOND - 5 
        GameData.DIAMOND     = DIAMOND
        GameState.save(GameData)
        lbl_diamond:setString(DIAMOND)
    else
        self.Shop:Show(Shop.SHOPTYPE.ShopType_2)
    end 
end

-- 道具 2 点击事件
function MatrixStar:Prop2_onclick()
    if GAMESTATE ~= 3 then
        return
    end
    if GameData.SOUND == 1 then
        audio.playSound(GAME_SOUND.pselect)
    end
    if DIAMOND >= 5 then
        bool_isusingBoom  = true
        self:setTouchEnabled(true)
        self.Prop1Btn:setButtonEnabled(false)
        self.Prop2Btn:setButtonEnabled(false)

        if self.Prop3Btn_sequenceAction ~= nil then
            transition.stopTarget(self.Prop3Btn)
            self.Prop3Btn_sequenceAction = nil
        end

        local sequenceAction = transition.sequence({
                cc.ScaleTo:create(0.5, 0.8, 0.8, 1), 
                cc.ScaleTo:create(0.5, 1, 1, 1), 
                })
        self.Prop2Btn_sequenceAction = transition.execute(self.Prop2Btn, cc.RepeatForever:create( sequenceAction ))
        DIAMOND = DIAMOND - 5
        GameData.DIAMOND     = DIAMOND
        GameState.save(GameData)
        lbl_diamond:setString(DIAMOND)
    else
         self.Shop:Show(Shop.SHOPTYPE.ShopType_2)

    end
end

-- 道具 3 点击事件
function MatrixStar:Prop3_onclick()
    if GAMESTATE ~= 3 then
        return
    end
    if GameData.SOUND == 1 then
    audio.playSound(GAME_SOUND.Props_Paint)
    end
    if DIAMOND >=5 then
        bool_isusingPaint = true
        self:setTouchEnabled(true)
        self.Prop1Btn:setButtonEnabled(false)
        self.Prop3Btn:setButtonEnabled(false)
        if self.Prop2Btn_sequenceAction ~= nil then
            transition.stopTarget(self.Prop2Btn)
            self.Prop2Btn_sequenceAction = nil
        end
        local sequenceAction = transition.sequence({
                cc.ScaleTo:create(0.5, 0.8, 0.8, 1), 
                cc.ScaleTo:create(0.5, 1, 1, 1), 
                })

       self.Prop3Btn_sequenceAction = transition.execute(self.Prop3Btn, cc.RepeatForever:create( sequenceAction ))

       lbl_show:setString(" ")
        node_prop3Btns:setVisible(true)
        for i=1,#self.prop3Btns do
            if self.prop3Btns[i][1] ~= nil then
                transition.moveTo( self.prop3Btns[i][1], {time = 0.3,x = self.prop3Btns[i][2] , easing = "BOUNCEOUT"})
            end
        end
        DIAMOND = DIAMOND - 5
        GameData.DIAMOND     = DIAMOND
        GameState.save(GameData)

        lbl_diamond:setString(DIAMOND)
    else
         self.Shop:Show(Shop.SHOPTYPE.ShopType_2)

    end
end

--暂停按钮
function MatrixStar:PauseBtn_onclick( )
    -- body
    local sp_mark = display.newScale9Sprite(GAME_IMAGE.sp_mask ,display.cx, display.cy, cc.size(display.widthInPixels, display.heightInPixels) )
    :addTo(node_paseview,-1)
    transition.moveTo(node_paseview, {time = 0.5 , x = display.left , y = display.bottom ,easing = "EXPONENTIALOUT"})
end

-- 选择颜色
function MatrixStar:prop3BtnsCliclDelegete(index)
    local sequenceAction = transition.sequence({
            cc.ScaleTo:create(0.5, 0.3, 0.3, 0.3), 
            cc.ScaleTo:create(0.5, 0.4, 0.4, 0.4), 
           -- cc.RotateBy:create(0.5, 360),
            })
    for i=1,#self.prop3Btns do
        if self.prop3Btns[i][1] ~= self.prop3Btns[index][1] then
        transition.stopTarget(self.prop3Btns[i][1])
        self.prop3Btns[i][1]:setScale(0.4)
        self.prop3Btns[i][1]:setRotation(0)
        end 
    end
       transition.execute(self.prop3Btns[index][1], cc.RepeatForever:create( sequenceAction ))
       self.selectColor =  index
end

--星星重排
function MatrixStar:ResetStar( )
    -- body
    local markStars = {}  --保存重排后的星星
    local leftStars = {}  --保存重排前的星星
    for i = 1, ROW do
        for j = 1, COL do
            if self.STAR[i][j][1] ~= nil then
                table.insert(leftStars, {self.STAR[i][j], i , j })
            end
        end
    end

    if #leftStars < 2 then
        return
    end
    self:setTouchEnabled(false)


    if  #leftStars % 2 > 0 then --剩余数量为奇数
        table.insert(markStars, table.remove(leftStars, math.random(1,#leftStars)))
    end

    local offettime = 0.01

    while #leftStars > 0 do
        --todo
        local  travel_1 = table.remove(leftStars, math.random(1,#leftStars))
        local  travel_2 = table.remove(leftStars, math.random(1,#leftStars))
       -- print( "a ==> ".. self.STAR[travel_1[2]][travel_1[3]][2] .. "  x ==> " .. self.STAR[travel_1[2]][travel_1[3]][4] .." y==> " .. self.STAR[travel_1[2]][travel_1[3]][5])
       -- print( "a ==> ".. self.STAR[travel_2[2]][travel_2[3]][2] .. "  x ==> " .. self.STAR[travel_2[2]][travel_2[3]][4] .." y==> " .. self.STAR[travel_2[2]][travel_2[3]][5])

        local posx,posy   =  self.STAR[travel_1[2]][travel_1[3]][1]:getPosition()  
        local posx2,posy2 =  self.STAR[travel_2[2]][travel_2[3]][1]:getPosition()  

    -- 移动动作
       -- local moveAction1= cc.MoveTo:create(0.5,cc.p(posx2,posy2))
       -- local moveAction2= cc.MoveTo:create(0.5,cc.p(posx,posy))

        offettime = offettime + 0.01

        local sequence1 = transition.sequence({
        cc.ScaleTo:create(0.1, 0.6),
        cc.MoveTo:create(0.5,cc.p(posx2 ,posy2)),
        cc.ScaleTo:create(0.01, 0.5),
        })

        local sequence2 = transition.sequence({
        cc.ScaleTo:create(0.1, 0.6),
        cc.MoveTo:create(0.5,cc.p(posx ,posy )),
        cc.ScaleTo:create(0.01, 0.5),
        })

        transition.execute(self.STAR[travel_1[2]][travel_1[3]][1], sequence1, {  
        delay = offettime,  
        easing = "InOut",  
        onComplete = function()  
            if #leftStars <= 0 then
                self:SetBtnsState(true) 
            end
        end,  
        })  
        offettime = offettime + 0.01
        transition.execute(self.STAR[travel_2[2]][travel_2[3]][1], sequence2, {  
        delay = offettime ,  
        easing = "InOut",  
        onComplete = function()  
            if #leftStars <= 0 then
                self:SetBtnsState(true)
            end
        end,  
        })  

        local value = self.STAR[travel_1[2]][travel_1[3]]
        local x1 , y1 = value[4], value[5]
        local x2 , y2 = self.STAR[travel_2[2]][travel_2[3]][4], self.STAR[travel_2[2]][travel_2[3]][5] --
        local sp , index = value[1], value[2]
        self.STAR[travel_1[2]][travel_1[3]] = self.STAR[travel_2[2]][travel_2[3]]
        self.STAR[travel_2[2]][travel_2[3]] =  value
        self.STAR[travel_1[2]][travel_1[3]][4] = x2
        self.STAR[travel_1[2]][travel_1[3]][5] = y2
        self.STAR[travel_2[2]][travel_2[3]][4] = x1
        self.STAR[travel_2[2]][travel_2[3]][5] = y1

       -- print( "b ==> ".. self.STAR[travel_1[2]][travel_1[3]][2] .. "  x ==> " .. self.STAR[travel_1[2]][travel_1[3]][4] .." y==> " .. self.STAR[travel_1[2]][travel_1[3]][5])
        --print( "b ==> ".. self.STAR[travel_2[2]][travel_2[3]][2] .. "  x ==> " .. self.STAR[travel_2[2]][travel_2[3]][4] .." y==> " .. self.STAR[travel_2[2]][travel_2[3]][5])

    end
     for i = 1, ROW do
        for j = 1, COL do
            if self.STAR[i][j][1] ~= nil then
                local y = (i-1) * STAR_HEIGHT + STAR_HEIGHT/2 + 72
                local x = (j-1) * STAR_WIDTH + STAR_WIDTH/2
                self.STAR[i][j][4] = x
                self.STAR[i][j][5] = y
            end
        end
    end
end

--使用炸弹
function MatrixStar:UseBoom(i,j) 
    -- body
    if self.STAR[i][j][1] == nil then
        return
    end 
    GAMESTATE = 0 
    for y = j - 1, j + 1 do
        for x = i - 1, i + 1 do
            if x <= ROW and x > 0 and y  <= COL and y > 0 and self.STAR[x][y][1] ~= nil then 
            table.insert(self.SELECT_STAR, {self.STAR[x][y][1], x, y})
            end
        end
    end
    
    for i=1,#self.SELECT_STAR do
         --替换成选中的精灵图样
        local color = self.STAR[self.SELECT_STAR[i][2]][self.SELECT_STAR[i][3]][2] --颜色
        local frameNo = display.newSpriteFrame(string.sub(STAR_RES_LIST_SELECT[color], 2))
        self.STAR[self.SELECT_STAR[i][2]][self.SELECT_STAR[i][3]][1]:setSpriteFrame(frameNo)  --把原来的精灵更换图片
    end
   
    bool_isusingBoom = false
    local offetX = 0
    if j >= 10  then
        offetX = -(STAR_WIDTH*2)
        elseif j <= 1  then
            offetX = STAR_WIDTH*2
    end

    local sp_boom = display.newSprite(GAME_IMAGE.Props_Bomb ,self.STAR[i][j][1]:getPositionX() + offetX, self.STAR[i][j][1]:getPositionY() + 100)
        :setScale(3)
        :addTo(node_title)

        transition.moveTo(sp_boom , {x = self.STAR[i][j][1]:getPositionX(), y = self.STAR[i][j][1]:getPositionY(), time = 1})
        
       -- transition.fadeTo(sp_boom , {opacity = 255, time = 0.3})
       --transition.fadeTo(sp_boom , {opacity = 128, time = 0.3})
        --transition.fadeTo(sp_boom , {opacity = 255, time = 0.3})
        transition.scaleTo(sp_boom, {
            scaleX     = 1,
            scaleY     = 1,
            time       = 1,
            onComplete = function ( )
                node_title:removeChild(sp_boom)
                if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.Props_Bomb)
                end
                self:ShowAnimLabel(true , i , j)
                while #self.SELECT_STAR > 0 do
                    self:deleteOneStar()
                end
                if self.Prop2Btn_sequenceAction ~= nil then
                    transition.stopTarget(self.Prop2Btn)
                    self.Prop2Btn_sequenceAction = nil
                end
                GAMESTATE = 3 
            end, 
        })
end

--使用刷子
function MatrixStar:UsePaint(i, j )
    -- body
    if self.STAR[i][j][1] == nil then
        return
    end 

    if self.selectColor == nil then
        if GameData.SOUND ==1 then
        audio.playSound(GAME_SOUND.Eff_Warning)
        end
        local lbl_ = cc.ui.UILabel.new({
            UILabelType = 2,
            text  =  "请先选择要转换的颜色！",
            size = 35,
            color = cc.c3b(0, 255, 255)
        })
        :align(cc.ui.TEXT_VALIGN_CENTER, display.cx, display.cy)
        :addTo(node_title)
        :setOpacity(0)
        :setScale(3)
        transition.fadeIn(lbl_, {time = 0.3 })
        transition.scaleTo(lbl_, {scale = 1, time = 0.5})

        local sequence = transition.sequence({
            cc.FadeTo:create(0.5, 0), 
            }) 

        transition.execute(lbl_, sequence, {  
        delay = 1,  
        easing = "InOut",  
        onComplete = function()  
        node_title:removeChild(lbl_)
        end,  
        }) 
        for i=1,#self.prop3Btns do
            local sequence2 = transition.sequence({
            cc.ScaleTo:create(0.3, 0.5, 0.5, 0.5), 
            cc.ScaleTo:create(0.3, 0.4, 0.4, 0.4), 
            }) 

            transition.execute(self.prop3Btns[i][1], sequence2, {  
            delay = 0.15 * i ,  
            easing = "InOut",  
            onComplete = function()  
            end,  
            }) 
        end

       
        else
            self:SetBtnsState(false)
            local prop = self.prop3Btns[self.selectColor][1]
            transition.stopTarget(prop)
            prop:setScale(0.4)
            prop:setRotation(0)
            transition.scaleTo(self.STAR[i][j][1],{scale = 0.01, time = 0.8} )

            local sequenceAction = transition.sequence({
            cc.ScaleTo:create(0.3, 0.8, 0.8, 1), 
            cc.MoveTo:create(0.5, cc.p( self.STAR[i][j][1]:getPositionX(), self.STAR[i][j][1]:getPositionY())),
            cc.ScaleTo:create(0.1, 0.4, 0.4, 1), 
            cc.ScaleTo:create(0.1, 0.5, 0.5, 1), 
            })
           local _sequenceAction = transition.execute(prop, sequenceAction ,{  
            delay = 0,  
            easing = "sineOut",  
            onComplete = function()  
                transition.stopTarget(self.STAR[i][j][1])
                self.STAR[i][j][1]:setScale(0.5)
                local frameNo = display.newSpriteFrame(string.sub(STAR_RES_LIST[self.selectColor], 2))
                self.STAR[i][j][1]:setSpriteFrame(frameNo)
                self.STAR[i][j][2] = self.selectColor
                self.STAR[i][j][3] = nil
                bool_isusingPaint  = false
                node_prop3Btns:setVisible(false)
                self.selectColor = nil

                for i=1,#self.prop3Btns do
                    if self.prop3Btns[i][1] ~= nil then
                        transition.stopTarget(self.prop3Btns[i][1])
                        self.prop3Btns[i][1]:setScale(0.4)
                        self.prop3Btns[i][1]:setPosition(self.sp_btnbg:getPositionX() + 80 , self.sp_btnbg:getPositionY())
                    end
                end

                if self.Prop3Btn_sequenceAction ~= nil then
                    transition.stopTarget(self.Prop3Btn)
                    self.Prop3Btn_sequenceAction = nil
                end
                self:SetBtnsState(true)
            end,  })

    end
end

function MatrixStar:initMatrix()  
    --[[self.STAR[i][j]是一个表，其中i表示星星矩阵的行，j表示列，它包含6个元素
        self.STAR[i][j][1]表示星星精灵
        self.STAR[i][j][2]表示该精灵的样色 
        self.STAR[i][j][3]表示该精灵是否被选中
        self.STAR[i][j][4]表示该精灵的坐标x
        self.STAR[i][j][5]表示该精灵的坐标y
        self.STAR[i][j][6]表示该精灵所在行
        self.STAR[i][j][7]表示该精灵所在的列

        ]]
    math.randomseed(os.time())   
    self.nums = 0
    local starSequenceindex =math.random(1, 4)
    local delay = 0
    local markx = 0
    self:SetBtnsState(false) 

    if  GAMESTATE == 0 or #MAP <= 0 or GAMESTATE == 2 then
        for row = 1, ROW do
            local y = (row-1) * STAR_HEIGHT + STAR_HEIGHT/2 + 72 
            self.STAR[row] = {}
            for col = 1, COL do
                self.STAR[row][col] = {}
                local x = (col-1) * STAR_WIDTH + STAR_WIDTH/2
                local i = math.random(1, #STAR_RES_LIST)
                local star = display.newSprite(STAR_RES_LIST[i])
                if starSequenceindex == 2 then 
                star:setScale(0)
                star:setPosition(x,y)
                elseif starSequenceindex == 1 then
                    --todo
                    star:setScale(0.5)
                    star:setPosition(x,y + display.height)
                    delay = row * col * 0.005
                elseif starSequenceindex == 3 then
                        --todo
                        star:setScale(0.5)
                        if row%2 == 1 and col%2 ==1 then
                                star:setPosition(x - display.width,y)
                                 delay = row * 0.05
                            elseif row%2 == 0 and col%2 ==1  then
                                star:setPosition(x + display.width,y)
                                delay = row * 0.05
                            elseif  col%2 == 0 then
                                delay = col * 0.05
                                if col == 2 or col == 6 or col == 10 then
                                    star:setPosition(x ,y + display.height)
                                else
                                    star:setPosition(x ,y - display.height)
                                end
                        end
                elseif starSequenceindex == 4 then
                        --todo
                        star:setScale(0.5)
                        if col == tow then
                            markx = x
                        end
                        -- delay = row * 0.05
                        if col < row then
                            star:setPosition(x, self.STAR[col][col][5])
                            else
                                --todo
                            star:setPosition(markx, y) 
                        end

                end

                self.STAR[row][col][1] = star
                self.STAR[row][col][2] = i
                self.STAR[row][col][3] = false
                self.STAR[row][col][4] = x
                self.STAR[row][col][5] = y
                self.STAR[row][col][6] = row
                self.STAR[row][col][7] = col
                self:addChild(star)

                local sequence = transition.sequence({
                    cc.MoveTo:create(0.3, cc.p(x, y))
                    }) 

                local sequence02 = transition.sequence({
                    cc.ScaleTo:create(math.random(0.3, 0.5),0.5),
                    }) 
                local starSequence  = {sequence,sequence02 ,sequence ,sequence}

            
                transition.execute(star, starSequence[starSequenceindex], {  
                delay = delay,  
                easing = "sineOut",  
                onComplete = function()  
                    self.nums = self.nums + 1
                    if self.nums >= self:getStarNum() then
                       self:SetBtnsState(true) 
                       GAMESTATE = 3
                    end
                end,  
                })  
             end
        end

    else  --读档
        print("读档")
        local map = MAP
         for row = 1, ROW do
            local y = (row-1) * STAR_HEIGHT + STAR_HEIGHT/2 + 72
            self.STAR[row] = {}
            for col = 1, COL do
                self.STAR[row][col] = {}
                local x = (col-1) * STAR_WIDTH + STAR_WIDTH/2
                local i = 1
                local star = nil
                for index = 1,#map do
                    if map[index][2] == row and map[index][3] == col then
                        i = map[index][1]
                        star = display.newSprite(STAR_RES_LIST[i])
                        star:setScale(0)
                        self.STAR[row][col][1] = star
                        self.STAR[row][col][2] = i
                        self.STAR[row][col][3] = false
                        star:setPosition(x,y)
                        self.STAR[row][col][4] = x
                        self.STAR[row][col][5] = y
                        self.STAR[row][col][6] = row
                        self.STAR[row][col][7] = col
                        self:addChild(star)
                    end
                end
                
                
                if star ~= nil then
                    --用来计数，一播放完动作的星星完全播放完后设置为可 touch状态
                    local sequence = transition.sequence({
                    cc.ScaleTo:create(math.random(0.3, 0.5), 0.5),
                    }) 

                    transition.execute(star, sequence, {  
                    delay = 0,  
                    easing = "exponentialOut",  
                    onComplete = function()  
                        self.nums = self.nums + 1
                        if self.nums >= #MAP then
                           self:SetBtnsState(true) 
                           GAMESTATE = 3
                        end
                    end,  
                    })  
                end
            end
        end

    end
end

   --  lbl显示内容
function MatrixStar:setLabel(Hscore,Level,TargetScore,Cscore)
   lbl_heightScore:setString("最高 " .. Hscore)
   lbl_stage:setString("第 "..Level.." 关")
   lbl_target:setString( "目标 " .. TargetScore)
   lbl_curscore:setString(string.format("%s", tostring(Cscore)))
   self.Level  = Level
   self.Hscore = Hscore
   self.Cscore = Cscore

end

    -- 下一关
function MatrixStar:nextStage( )
    -- body
    
    GAMESTATE = 0
    CURLEVEL = CURLEVEL + 1
    TARGETSCORE = TARGETSCORE + 500 * (CURLEVEL)
    CURSCORE = self.Cscore 
    self.Hscore      = HEIGHTSCORE
    self.Level       = CURLEVEL
    self.STAR        = {}
    self.SELECT_STAR = {} 
    bool_ishaveShow_sp_tongguan = false
    lbl_curscore:setColor(cc.c3b(255, 255, 255))
     if self.CCLabelChangeaction then
        self.CCLabelChangeaction:selfKill()
        self.CCLabelChangeaction = nil 
    end
    self:Show()
end

function MatrixStar:onKeypad( event )
    -- body
        print(event.key)
    if event.key == "back" then
        self:ShowPauseView()
        elseif event.key == "menu" then  --菜单键
            print("menu keypad onclick")               
    end
end

function MatrixStar:onTouch(eventType, x, y)  
  --  print(eventType.name .. " ==> "..self.clearNeed)
    if GAMESTATE ~= 3 then  --游戏还没准备好
        return
    end
    if eventType.name == "began" then 
        i = math.floor((y-72) / STAR_HEIGHT) + 1
        j = math.floor(x / STAR_WIDTH) + 1
        if i < 1 or i > ROW or j < 1 or j > COL or self.clearNeed ~= UNNEEDCLEAR or self.STAR[i][j][1] == nil then
            return 
        end 

        self.SELECT_STAR = {}   --将选中的星星清空

        if bool_isusingBoom == true then
            self:UseBoom(i,j)
            return
        end

        if bool_isusingPaint == true then
            self:UsePaint(i, j)
            return
        end

        if self:getSelectStar() == false then 
            return
        end
        self:setTouchEnabled(false)
        -- 星星排序 从左往右 从上往下
        if #self.SELECT_STAR > 1 then
            self:ShowAnimLabel(false , i , j)
        end

        if self.ComboHandler == nil and #self.SELECT_STAR > 1 then
            self.ComboHandler = scheduler.performWithDelayGlobal(function( )
                -- body
                if comboNum > 2 then 
                    local sp_combo = display.newSprite(GAME_IMAGE.Sign_ComboX)
                    :addTo(self)
                    :align(display.CENTER, display.cx -50, display.cy - 50)
                    :setScale(2)

                    local sp_combo00 = display.newSprite("image/Number_480x065.png" )
                    :addTo(sp_combo)
                    :setTextureRect(cc.rect(comboNum*48,0,40,65))
                    :align(display.CENTER, sp_combo:getContentSize().width + 30, 30)
                    :setScale(1)

                    local sequence = transition.sequence({
                        cc.ScaleTo:create(0.2, 1),
                        cc.MoveTo:create(0.5,cc.p(display.cx - 50, display.cy + 50)),
                        cc.FadeTo:create(0.2, 125),
                        cc.FadeTo:create(0.2, 255),
                        cc.FadeTo:create(0.2, 125),
                        cc.FadeTo:create(0.2, 255),
                        cc.FadeTo:create(0.2, 0),
                        })

                        transition.execute(sp_combo, sequence, {  
                        delay = 0,  
                        easing = "InOut",  
                        onComplete = function()  
                           self:removeChild(sp_combo)
                           sp_combo = nil 
                        end,  
                        })  

                    -- sp_combo:scaleTo(0.2, 1.5)
                    -- sp_combo:scaleTo(0.2, 1)
                    -- sp_combo:moveTo(0.5, display.cx -50, display.cy)

                end
                self.ComboHandler = nil 
                comboNum = 1
            end, 2)
            else
            comboNum = comboNum + 1
        end


        local  function deleteOneStar_( dt )
            if GameData.SOUND == 1 then
            audio.playSound(GAME_SOUND.ppop )
            end
            self:deleteOneStar()
        end 
        
        mHandle = scheduler.scheduleGlobal(deleteOneStar_, 0.05)
        self:ShowAnim(#self.SELECT_STAR)
    end
end

function MatrixStar:deleteOneStar()
        -- body
        local deleteStar = {}
        deleteStar = table.remove(self.SELECT_STAR)
        if deleteStar ~= nil and #deleteStar ~= 0 then
            local row , col = deleteStar[2], deleteStar[3]

            local particle = cc.ParticleSystemQuad:create(STAR_PARTICLE[self.STAR[row][col][2]])
                    particle:setPosition(self.STAR[row][col][1]:getPosition())
                    particle:setAutoRemoveOnFinish(true)
                    self:addChild(particle,1)  

            self:removeChild(self.STAR[row][col][1]) 

            self.STAR[row][col][1] = nil 
           -- self.STAR[row][col] = {}
        end

        if #self.SELECT_STAR <=0 then
            self:UpdateMatrix()
            if self:isEnd() == true then 
                self.clearNeed = NEEDCLEAR
            end

            if mHandle ~= nil then
                scheduler.unscheduleGlobal(mHandle)
                mHandle = nil
            end
            self:updateStar()
            self:SetBtnsState(true)
        end
end

function MatrixStar:ShowAnimLabel(isusingBoom ,i,j)
    if self.STAR[i][j][1] == nil then
        return
    end
    if (isusingBoom == false and  #self.SELECT_STAR > 1 ) or  (isusingBoom == true and  #self.SELECT_STAR > 0 ) then
            local deleteStarnum = #self.SELECT_STAR
            if isusingBoom == true then
                STARGAIN = 10
            end
            local getscorse = string.format("%s", tostring(#self.SELECT_STAR * #self.SELECT_STAR * STARGAIN))
            lbl_show:setString("消除"..deleteStarnum .."个:"..getscorse.."分")
            local posx , posy  = self.STAR[i][j][1]:getPositionX() , self.STAR[i][j][1]:getPositionY() + 50
            local lbl_      = cc.ui.UILabel.new({
                UILabelType = 1,
                text        = getscorse,
                font        = GAME_FONT,
                size        = 40,
                })
                :setScale(0.5)
                :align(cc.ui.TEXT_VALIGN_CENTER, posx, posy)
                :addTo(self,3)

            local sequenceAction = transition.sequence({
            cc.FadeTo:create(0.1, 255 ),
            cc.ScaleTo:create(0.1, 3, 3, 1), 
            cc.ScaleTo:create(0.5, 1, 1, 1), 
            cc.MoveTo:create(0.5, cc.p(lbl_curscore:getPositionX() , lbl_curscore:getPositionY() )),
            cc.FadeTo:create(0.3,  0 ),
            })

            transition.execute(lbl_, sequenceAction ,{  
                delay = 0,  
                easing = "sineInOut",  
                onComplete = function()  
                    self:removeChild(lbl_)
                    self:updateScore( deleteStarnum )
                    STARGAIN = 5
                end, 
            })
        end
end

--称赞
function MatrixStar:ShowAnim(num )
    -- body
    if num <= 4 then
        return
    end
    local sequenceAction = transition.sequence({
        cc.MoveTo:create(0.2, cc.p(display.cx, display.cy + 100)),
        cc.ScaleTo:create(0.5, 0.5, 0.5, 1), 
        cc.FadeTo:create(0.2, 125), 
        cc.FadeTo:create(0.2, 255),
        cc.FadeTo:create(0.2, 125), 
        cc.FadeTo:create(0.2, 255),
        cc.FadeTo:create(0.2,  0 ),
        })
    if num > 4 and num < 7 then --32个赞
        local praises = {GAME_IMAGE.praise1, GAME_IMAGE.praise00, GAME_IMAGE.praise0 }
        local sp_praise1 = display.newSprite(praises[math.random(1, #praises) ])
        :align(display.CENTER, display.cx, display.cy)
        :addTo(node_title) 
        transition.execute(sp_praise1, sequenceAction, {
            delay = 0,
            easing = "sineInOut",  
            onComplete = function()  
                node_title:removeChild(sp_praise1)
            end, 
            })

        if GameData.SOUND == 1 then
        audio.playSound(GAME_SOUND.word_1)
        end

        elseif num < 9 then --酷毙了
            local praises = {GAME_IMAGE.praise2,  GAME_IMAGE.praise3 }
            local sp_praise2 = display.newSprite(praises[math.random(1,#praises)]) 
            :align(display.CENTER, display.cx, display.cy)
            :addTo(node_title) 
            transition.execute(sp_praise2, sequenceAction, {
                delay = 0,
                easing = "sineInOut",  
                onComplete = function()  
                    node_title:removeChild(sp_praise2)
                end, 
                })
            if GameData.SOUND == 1 then
            audio.playSound(GAME_SOUND.word_1)
            end
            elseif num < 12 then --霸气侧漏
                local praises = {GAME_IMAGE.praise4, GAME_IMAGE.praise5 }
                local sp_praise2 = display.newSprite(praises[math.random(1,#praises)]) 
                :align(display.CENTER, display.cx, display.cy)
                :addTo(node_title) 
                transition.execute(sp_praise2, sequenceAction, {
                    delay = 0,
                    easing = "sineInOut",  
                    onComplete = function()  
                        node_title:removeChild(sp_praise2)
                    end, 
                    })
                if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.word_2)
                end
                elseif num > 11 then --棒棒
                    local praises = { GAME_IMAGE.praise6, GAME_IMAGE.praise7 }
                    local sp_praise2 = display.newSprite(praises[math.random(1,#praises)]) 
                    :align(display.CENTER, display.cx, display.cy)
                    :addTo(node_title) 
                    transition.execute(sp_praise2, sequenceAction, {
                        delay = 0,
                        easing = "sineInOut",  
                        onComplete = function()  
                            node_title:removeChild(sp_praise2)
                        end, 
                        })
                    if GameData.SOUND == 1 then audio.playSound(GAME_SOUND.word_2) end
                   
    end
end

function MatrixStar:updateScore(select)
    local lastScore = self.Cscore
    self.Cscore = self.Cscore + select * select * STARGAIN
   -- lbl_curscore:setString(string.format("%s", tostring(self.Cscore)))

   if self.CCLabelChangeaction ~= nill then
        self.CCLabelChangeaction:init(lbl_curscore,  { duration = 0.1, fromNum = lastScore , toNum = self.Cscore , changerate = 5,callback = function()
            end})
    else
        self.CCLabelChangeaction = CCLabelChange:create(lbl_curscore,  { duration = 0.1, fromNum = lastScore , toNum = self.Cscore , changerate = 5,callback = function()
            end})
        :addTo(self)
   end
   
    self.CCLabelChangeaction:playAction()


    if  self.Cscore >= HEIGHTSCORE then
        self.Hscore = self.Cscore

        lbl_heightScore:setString( "最高 " .. string.format("%s", tostring(self.Cscore)))
    end

    if self.Cscore >= TARGETSCORE then
            lbl_curscore:setColor(cc.c3b(255, 255 , 0))

            if bool_ishaveShow_sp_tongguan == false then

                if GameData.SOUND == 1 then audio.playSound(GAME_SOUND.ptarget) end
                local sp_tongguanbg = display.newSprite(GAME_IMAGE.stage_clear_bg, display.cx, display.cy)
                    :addTo(node_title,-2)
                local sequenceAction1 = transition.sequence({
                cc.FadeTo:create(0.1, 255 ),
                cc.RotateBy:create(0.1, 180),
                cc.ScaleTo:create(0.5, 1, 1, 1), 
                cc.FadeTo:create(0.15, 125 ),
                cc.FadeTo:create(0.15, 255 ),
                cc.FadeTo:create(0.15, 125 ),
                cc.FadeTo:create(0.15, 255 ),
                cc.FadeTo:create(0.15, 125 ),
                cc.FadeTo:create(0.15, 0 ),
                })
                transition.execute(sp_tongguanbg, sequenceAction1 ,{  
                    delay = 0,  
                    easing = "sineInOut",  
                    onComplete = function()  
                    node_title:removeChild(sp_tongguanbg)
                    end, 
                })

                sp_tongguan:setPosition(display.cx, display.cy)


                local sequenceAction = transition.sequence({
                cc.FadeTo:create(0.1, 255 ),
                cc.ScaleTo:create(1.5, 1, 1, 1), 
                cc.MoveTo:create(0.5, cc.p(lbl_curscore:getPositionX() , lbl_curscore:getPositionY() - 50 )),
                cc.ScaleTo:create(0.1, 0.3, 0.3, 1),
                })

                transition.execute(sp_tongguan, sequenceAction ,{  
                    delay = 0,  
                    easing = "sineInOut",  
                    onComplete = function()  
                    node_title:removeChild(sp_tongguanbg)
                    end, 
                })
                bool_ishaveShow_sp_tongguan = true
                end
        else
            lbl_curscore:setColor(cc.c3b(0, 255, 127))

    end
end

function MatrixStar:getSelectStar()
    local travel = {}  --当作一个队列使用，用于选出周围与触摸星星颜色相同的星星
    if  self.STAR[i][j][1] == nil  then
        return
    end 
    
        table.insert(travel, {self.STAR[i][j][1], i, j})
        while #travel ~= 0 do
            if i + 1 <= ROW and self.STAR[i][j][3] ~= true and 
                self.STAR[i][j][2] == self.STAR[i + 1][j][2] then
                table.insert(travel, {self.STAR[i+1][j][1],i+1,j})
            end

            if i-1 >= 1 and self.STAR[i][j][3] ~= true and
                self.STAR[i][j][2] ==self.STAR[i-1][j][2] then
                table.insert(travel, {self.STAR[i-1][j][1],i-1,j})
            end

            if j+1 <= COL and self.STAR[i][j][3] ~= true and
                self.STAR[i][j][2] ==self.STAR[i][j+1][2] then
                table.insert(travel, {self.STAR[i][j+1][1],i,j+1}) 
            end

            if j-1 >= 1 and self.STAR[i][j][3] ~= true and
                self.STAR[i][j][2] ==self.STAR[i][j-1][2] then
                table.insert(travel, {self.STAR[i][j-1][1],i,j-1})
            end
            
            if self.STAR[i][j][3] ~= true then
               self.STAR[i][j][3] = true
               table.insert(self.SELECT_STAR,{self.STAR[i][j][1],i,j})
            end
            
            table.remove(travel,1)  --table没有类似双向队列的功能直接删除第一个元素
            if #travel ~= 0 then 
                i, j = travel[1][2], travel[1][3] --取出表的第一个元素
            end  
        end

    if #self.SELECT_STAR <= 1   then
        -- local frame = display.newSprite(STAR_RES_LIST_SELECT[self.STAR[i][j][2]]) 
        -- self.STAR[i][j][1]:setTexture(frame:getTexture())

        self.STAR[i][j][3] = nil 
        self.SELECT_STAR = {}
        return false
    else
        for i=1,#self.SELECT_STAR  do
            local color = self.STAR[self.SELECT_STAR[i][2]][self.SELECT_STAR[i][3]][2] --颜色
            local frameNo = display.newSpriteFrame(string.sub(STAR_RES_LIST_SELECT[color], 2))
            if frameNo ~= nil and self.STAR[self.SELECT_STAR[i][2]][self.SELECT_STAR[i][3]][1]~= nil then
                self.STAR[self.SELECT_STAR[i][2]][self.SELECT_STAR[i][3]][1]:setSpriteFrame(frameNo)  --把原来的精灵更换图片
            else
                print("ERROR ==>  请确定是否存在"..string.sub(STAR_RES_LIST_SELECT[color], 2).." 的图片")
            end
        end
    end 
    return true
end

function MatrixStar:updateStar()
    for i = 1, ROW do
        for j = 1, COL do
            if self.STAR[i][j][1] ~= nil then 
                local posX, posY = self.STAR[i][j][1]:getPosition()
                self:updatePos(posX,posY ,i,j)
            end
        end
    end

    if self.clearNeed == NEEDCLEAR then 
        self:ClearLeftStarOneByOne()
    end
end

function MatrixStar:ClearLeftStarOneByOne()
    local deleteStars = {}
    for i = 1, ROW do
        for j = 1, COL do
            if self.STAR[i][j][1] ~= nil then
               table.insert(deleteStars, {self.STAR[i][j][1] , i, j})
            end
        end
    end
    self:SetBtnsState(false)

    local num = self:getStarNum()
    local str = "剩余星星 " .. num .."\n\n奖励"
    local getscore = 0

    if num < LEFT_STAR then
        local left = LEFT_STAR - num 
        getscore = left * left * STARGAIN
        
    else

    end

    lbl_  = cc.ui.UILabel.new({
            UILabelType = 1,
            text        = str ,
            font        = GAME_FONT,
            size        = 30,
            })
            :align(cc.ui.TEXT_VALIGN_CENTER, display.right + 200, display.cy)
            :setScale(0.5)
            :addTo(self,3)

    lbl_02  = cc.ui.UILabel.new({
            UILabelType = 1,
            text        = getscore ,
            font        = GAME_FONT,
            size        = 30,
            })
            :align(cc.ui.TEXT_ALIGNMENT_LEFT, display.right + 200, display.cy - 50)
            :setScale(0.5)
            :addTo(self,3)
    -- local sp_diamond  = display.newSprite(GAME_IMAGE.emailIcon_diamond)
    --  :align(display.CENTER, display.left + 100, display.cy - 70)
    --  :addTo(self) 
    --  :setScale(0.4)   

    -- lbl_03  = cc.ui.UILabel.new({
    --     UILabelType = 1,
    --     text        = "+2" ,
    --     font        = GAME_FONT,
    --     size        = 30,
    --     })
    --     :align(cc.ui.TEXT_ALIGNMENT_LEFT,display.right + 100, display.cy - 70)
    --     :setScale(0.5)
    --     :addTo(self,3)

    transition.moveTo(lbl_, {x = display.cx , y = display.cy , time = 0.3 })
    transition.moveTo(lbl_02, {x = display.cx + 40 , y = display.cy - 25 , time = 0.5 })
   -- transition.moveTo(sp_diamond, {x = display.cx -10 , y = display.cy - 70 , time = 0.3 })
  --  transition.moveTo(lbl_03, {x = display.cx + 25 , y = display.cy - 70 , time = 0.5 })

  local  sequenceAction = transition.sequence({
            cc.ScaleTo:create(0.1, 2, 2, 1), 
            
            cc.ScaleTo:create(0.5, 0.5, 0.5, 1), 
            cc.MoveTo:create(0.5, cc.p(lbl_curscore:getPositionX() , lbl_curscore:getPositionY() )),
            cc.FadeTo:create(0.3,  0 ),
        })

   local sequenceAction1 = transition.sequence({
            cc.ScaleTo:create(0.1, 2, 2, 1), 
            cc.ScaleTo:create(0.5, 0.5, 0.5, 1), 
            cc.MoveTo:create(0.5, cc.p(lbl_diamond:getPositionX() , lbl_diamond:getPositionY() )),
            cc.FadeTo:create(0.3,  0 ),
        })

    transition.execute(lbl_02 , sequenceAction , {
        delay = num * 0.05 + 1.5 ,  
                easing = "sineInOut",  
                onComplete = function()  
                    self:removeChild(lbl_)
                    self:removeChild(lbl_02)
                  --  self:removeChild(sp_diamond)
                    --self:removeChild(lbl_03)
                    self.Cscore =  self.Cscore + getscore
                  --  DIAMOND = DIAMOND + 2 
                   -- GameData.DIAMOND = DIAMOND
                   -- GameState.save(GameData)
                    lbl_curscore:setString(string.format("%s", tostring(self.Cscore)))
                    if self.Cscore > HEIGHTSCORE then 
                        HEIGHTSCORE = self.Cscore
                        lbl_heightScore:setString("最高 " .. HEIGHTSCORE)
                    end
                    lbl_diamond:setString(string.format("%s", tostring(DIAMOND)))
                    local x = self.Cscore - TARGETSCORE
                    if  x >= 0 or bool_ishaveShow_sp_tongguan == true then --已经通关了
                        scheduler.performWithDelayGlobal(function()
                            local sequenceAction03 = transition.sequence({
                                cc.MoveTo:create(0.2, cc.p(display.cx, display.cy)),
                                cc.ScaleTo:create(0.5, 0.8, 0.8, 1), 
                                cc.FadeTo:create(0.2, 125), 
                                cc.FadeTo:create(0.2, 255),
                                cc.FadeTo:create(0.2, 125), 
                                cc.FadeTo:create(0.2, 255),
                               -- cc.ScaleTo:create(0.5,  0 ),
                                })

                            local sequenceAction04 = transition.sequence({
                                cc.MoveTo:create(0.5,cc.p(display.cx, display.cy)),
                               -- cc.ScaleTo:create(0.5, 0.8, 0.8, 1), 
                                -- cc.FadeTo:create(0.2, 125), 
                                -- cc.FadeTo:create(0.2, 255),
                                -- cc.FadeTo:create(0.2, 125), 
                                -- cc.FadeTo:create(0.2, 255),
                                cc.FadeTo:create(1, 255 ),
                                cc.MoveTo:create(0.5,cc.p(display.left - 400, display.cy)),
                                })
                            local textSp = {GAME_IMAGE.Text_StageEnd, GAME_IMAGE.Text_StageEnd02 , "小星星:\n     其实我一点都不小...！" , "小星星:\n     你来做我们的爷爷(奶奶)吧"}
                            local index = math.random(1,2)

                            local Text_StageEnd = nil

                            if index > 2 then
                                Text_StageEnd = cc.ui.UILabel.new({
                                    UILabelType = 2,
                                    text        = textSp[index] ,
                                    size        = 28,
                                    })
                                    :align(display.CENTER, display.right + 400 , display.cy)
                                    :addTo(self,4)
                                    sequenceAction03 = sequenceAction04
                                else
                                Text_StageEnd  = display.newSprite(textSp[index])
                                     :align(display.CENTER, display.cx , display.cy)
                                     :addTo(self, 4) 
                                     :setScale(0)
                            end

                            -- body
                            transition.execute(Text_StageEnd , sequenceAction03 ,{
                                delay = 0 ,  
                                easing = "sineInOut",  
                                onComplete = function()  
                                scheduler.performWithDelayGlobal(function()
                                    self:removeChild(Text_StageEnd)
                                    self:nextStage()

                                    end, 1)
                                end,
                                })

                        end, 0.1)
                    else  --失败
                        self:ShowFail()
                    end
                end, 
        })

      transition.execute(lbl_02, sequenceAction ,{  
                delay = num * 0.05 + 1.5 ,  
                easing = "sineInOut",  
                onComplete = function()  
                    -- self:removeChild(lbl_)
                    -- self:removeChild(lbl_02)
                    -- self:removeChild(sp_diamond)
                    -- self:removeChild(lbl_03)
                    -- self.Cscore =  self.Cscore + getscore
                    -- lbl_curscore:setString(string.format("%s", tostring(self.Cscore)))
                    -- local x = self.Cscore - TARGETSCORE
                    -- if  x >= 0 or bool_ishaveShow_sp_tongguan == true then --已经通关了
                    --     self:nextStage()
                    -- else  --失败
                    --     self:ShowFail()
                    -- end
                end, 
                })
     scheduler.performWithDelayGlobal( function ( )
            -- body
             if GameData.SOUND == 1 then audio.playSound(GAME_SOUND.NextGameRound) end
        end ,num * 0.05 + 1.5)  


   local function oneByone(dt)
        local deleteNextStar = {}
        deleteNextStar = table.remove(deleteStars)
        if deleteNextStar ~= nil and #deleteNextStar ~= 0 then
            local row , col = deleteNextStar[2], deleteNextStar[3]
             if GameData.SOUND == 1 then audio.playSound(GAME_SOUND.ppop) end
            local particle = cc.ParticleSystemQuad:create(STAR_PARTICLE[self.STAR[row][col][2]])
                    particle:setPosition(self.STAR[row][col][1]:getPosition())
                    particle:setAutoRemoveOnFinish(true)
                    self:addChild(particle,1)  
                self:removeChild(self.STAR[row][col][1]) 
                self.STAR[row][col][1] = nil 
                self.STAR[row][col] = {}
            else
                scheduler.unscheduleGlobal(mHandle)
                mHandle = nil
                self.clearNeed = CLEAROVER
        end
    end
    scheduler.performWithDelayGlobal(function ( )
        -- body
        mHandle = scheduler.scheduleGlobal(oneByone, 0.05)
        
    end, 1)
end

function MatrixStar:ShowResult( )
    -- body
    local layer_result = display.newColorLayer(cc.c4b(0, 0, 0, 255))
    :align(display.CENTER, display.left, display.bottom)
    :addTo(self, 5)

    local bg00  = display.newSprite(GAME_IMAGE.result_bg1)
     :addTo(layer_result) 
     :setPosition(display.cx, display.cy)
     :setScale(10)
     local bg01  = display.newSprite(GAME_IMAGE.bg_sunburst1)
     :addTo(layer_result) 
     :setPosition(display.cx, display.cy)
     :setScale(2)

    local sequenceAction = transition.sequence({
            cc.RotateBy:create(4, 90),
            cc.RotateBy:create(4, 90),
            cc.RotateBy:create(4, 90),
            cc.RotateBy:create(4, 90),
            })

    transition.execute(bg01, cc.RepeatForever:create( sequenceAction ))

     local sp_logo  = display.newSprite(GAME_IMAGE.logo_pic)
     :addTo(layer_result) 
     :setPosition(display.left + 140, display.top - 100)

    local sp_diamond  = display.newSprite(GAME_IMAGE.emailIcon_diamond)
     :addTo(layer_result) 
     :setPosition(display.right - 50, display.top - 40)
     :setScale(0.4)

     local lbl_diamond = cc.ui.UILabel.new({
            UILabelType = 1,
            text        = GameData.DIAMOND ,
            font        = GAME_FONT,
            })
            :setScale(0.5)
            :align(cc.ui.TEXT_ALIGNMENT_CENTER, sp_diamond:getPositionX() - 60, sp_diamond:getPositionY())
            :addTo(layer_result)

    local lbl_level = cc.ui.UILabel.new({
        UILabelType = 1,
        text        = "经典过关 - 第 " .. self.Level .." 关",
        font        = GAME_FONT,
        })
        :setScale(0.5)
        :align(cc.ui.TEXT_ALIGNMENT_CENTER, sp_logo:getPositionX() - 80, sp_logo:getPositionY() - 100)
        :addTo(layer_result)

    local lbl_score = cc.ui.UILabel.new({
        UILabelType = 1,
        text        = self.Cscore,
        font        = GAME_FONT,
        })
        :setScale(1)
        :align(display.CENTER, display.cx , display.cy)
        :addTo(layer_result)

    local exitButton =  cc.ui.UIPushButton.new({normal =  GAME_IMAGE.exit, pressed =  GAME_IMAGE.exit})
        :align(display.CENTER,  display.cx - 100, display.bottom + 200)
        :onButtonClicked(function()
            if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
            end
            if self.CCLabelChangeaction then
                self.CCLabelChangeaction:selfKill()
            end
            node_paseview  = nil 
            node_faileView = nil 
            GAMESTATE      = 2 
            CURLEVEL       = self.Level
            self:GetMap()
            self:SaveGameData()
            self:removeAllChildren()
            -- 创建一个新场景
            local nextScene = require("app.scenes.MenuScene").new()
            -- 包装过渡效果
            local transition = display.wrapSceneWithTransition(nextScene, "flipAngular", 0.5)
            -- 切换到新场景
            display.replaceScene(transition)
        end)
        :setScale(0.8)
        :addTo(layer_result)

    local retryButton =  cc.ui.UIPushButton.new({normal =  GAME_IMAGE.retry, pressed =  GAME_IMAGE.retry})
        :align(display.CENTER,  display.cx + 100, display.bottom + 200)
        :onButtonClicked(function()
            if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
            end
            self:removeChild(layer_result)
            self.Cscore = CURSCORE
            layer_result = nil 
            GAMESTATE = 0
            self:Show()
        end)
        :setScale(0.8)
        :addTo(layer_result)    
end

 --显示失败界面--
function MatrixStar:ShowFail( )
   -- body
   if node_faileView == nil then
    node_faileView = display.newLayer()
    :align(display.CENTER, display.cx, display.top)
    :addTo(self, 4)

    local bg  = display.newSprite(GAME_IMAGE.sp_mask)
     :addTo(node_faileView) 
     :setScale(20)

    local sp_00  = display.newSprite(GAME_IMAGE.jixutongguan_juese)
     :align(display.CENTER, display.left + 120, display.bottom)
     :addTo(node_faileView) 
     :setScale(1)

     local sp_01  = display.newSprite(GAME_IMAGE.jixutongguan)
     :align(display.CENTER, display.cx, display.bottom + 200)
     :addTo(node_faileView) 
     :setScale(1)

    local closeButton =  cc.ui.UIPushButton.new({normal =  GAME_IMAGE.close_bg, pressed =  GAME_IMAGE.close_bg})
        :align(display.CENTER,  display.cx + 140, display.bottom + 300)
        :addTo(node_faileView)
        :onButtonClicked(function()
            if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
            end
            if bool_isfirst == true then
                self:removeAllChildren()
                -- 创建一个新场景
                local nextScene = require("app.scenes.MenuScene").new()
                -- 包装过渡效果
                local transition = display.wrapSceneWithTransition(nextScene, "pageTurn", 0.5)
                -- 切换到新场景
                display.replaceScene(transition)
                else
                    self:removeChild(node_faileView)
                    self:ShowResult()
                end
            node_faileView = nil
            node_paseview  = nil 
        end)

    local comntinueButton =  cc.ui.UIPushButton.new({normal =  GAME_IMAGE.tongguananniu_btn, pressed =  GAME_IMAGE.tongguananniu_btn})
        :align(display.CENTER,  display.cx + 110, display.bottom -25)
        :onButtonClicked(function()
            if GameData.SOUND == 1 then
                audio.playSound(GAME_SOUND.pselect)
            end
            if GameData.DIAMOND >= 5 then
                    self:removeChild(node_faileView)
                    GAMESTATE = 0
                    self:Show()
                    node_faileView = nil 
                else
                    self.Shop:Show(Shop.SHOPTYPE.ShopType_2)
            end
        end)
        :addTo(node_faileView)    
     local sp_03  = display.newSprite(GAME_IMAGE.tongguananniu_wenzi)
     :align(display.CENTER, display.cx + 110, display.bottom -20)
     :addTo(comntinueButton) 
     :setScale(1)   
    local lbl_cost = cc.ui.UILabel.new({
        UILabelType = 2,
        text        = "挑战一次需要5个钻石" ,
        size       = 30
        })
        :align(cc.ui.TEXT_ALIGNMENT_LEFT, sp_03:getPositionX()- 90, sp_03:getPositionY() - 60)
        :setScale(0.6)
        :setColor(cc.c3b(255, 0, 255))
        :addTo(node_faileView) 

    -- local lbl_timer = cc.ui.UILabel.new({
    --     UILabelType = 1,
    --     text        = "10" ,
    --     font        = GAME_FONT,
    --     })
    --     :align(cc.ui.TEXT_ALIGNMENT_LEFT, sp_03:getPositionX() + 75, sp_03:getPositionY())
    --     :setScale(0.6)
    --     :addTo(node_faileView)

    -- self.CCLabelChangeaction = CCLabelChange:create(lbl_timer,  { duration = 1, fromNum = 10, toNum = 0 , callback = function()
    --     -- body
    --     node_faileView:removeChild(self.CCLabelChangeaction)
    --     self:ShowResult()  
    -- end})
    -- :addTo(node_faileView)
    -- self.CCLabelChangeaction:playAction()
    end

end

function MatrixStar:updatePos(posX,posY,i,j)
    scheduler.performWithDelayGlobal(function()
            -- body
            transition.moveTo(self.STAR[i][j][1], {
                x = self.STAR[i][j][4],
                y = self.STAR[i][j][5],
                time = 0.3,
                easing = "backIn",
                onComplete = function()
                   if self.STAR[i][j][1] ~= nil and self.STAR[i][j][1]:getPositionY() < self.STAR[i][j][5]  then
                        self.STAR[i][j][1]:setPositionY(self.STAR[i][j][5])
                    end

                    if self.STAR[i][j][1] ~= nil and self.STAR[i][j][1]:getPositionX() < self.STAR[i][j][4]  then
                         self.STAR[i][j][1]:setPositionX(self.STAR[i][j][4])
                    end 
                end,
                })
        end, 0.1)
end

function MatrixStar:isEnd()
    for i = 1, ROW do
        for j = 1, COL do
            local color = self.STAR[i][j][2]
            if self.STAR[i][j][1] ~= nil then
                if i+1<=ROW and self.STAR[i+1][j][1] ~= nil and color == self.STAR[i+1][j][2] then
                    return false
                end
                if i-1>=1 and self.STAR[i-1][j][1] ~= nil and color == self.STAR[i-1][j][2] then
                    return false
                end
                if j-1>=1 and self.STAR[i][j-1][1] ~= nil and color == self.STAR[i][j-1][2] then
                    return false
                end
                if j+1<=COL and self.STAR[i][j+1][1] ~= nil and color == self.STAR[i][j+1][2] then
                    return false
                end
            end
        end
    end
    return true
end

function MatrixStar:UpdateMatrix()
    for i = 1, ROW do
        for j = 1,COL do
            if self.STAR[i][j][1] == nil then 
                local up = i
                local dis = 0
                while self.STAR[up][j][1] == nil do
                    dis = dis + 1
                    up = up + 1
                    if(up>ROW) then
                        break
                    end
                end

                for begin_i = i + dis, ROW do
 --               print("test"..tostring(begin_i))
                    if self.STAR[begin_i][j][1]~=nil then 
                        self.STAR[begin_i-dis][j][1]=self.STAR[begin_i][j][1]
                        self.STAR[begin_i-dis][j][2]=self.STAR[begin_i][j][2]
                        self.STAR[begin_i-dis][j][3]=self.STAR[begin_i][j][3]
                        local x = (j-1)*STAR_WIDTH + STAR_WIDTH/2  
                        local y = (begin_i-dis-1)*STAR_HEIGHT + STAR_HEIGHT/2 + 72
                        self.STAR[begin_i-dis][j][4] =x
                        self.STAR[begin_i-dis][j][5] =y
                        self.STAR[begin_i][j][1] = nil
                        self.STAR[begin_i][j][2] = nil
                        self.STAR[begin_i][j][3] = nil
                        self.STAR[begin_i][j][4] = nil
                        self.STAR[begin_i][j][5] = nil
                    end
                end
            end
        end
    end

    for j = 1, COL do
        if self.STAR[1][j][1] == nil then
            local des = 0 
            local right = j
            while self.STAR[1][right][1] == nil do
                des = des + 1
                right = right + 1
                if right>COL then
                    break
                end
            end
            for begin_i = ROW, 1,-1 do
                for begin_j = j + des, COL do 
                    if self.STAR[begin_i][begin_j][1] ~= nil then
                        self.STAR[begin_i][begin_j-des][1]=self.STAR[begin_i][begin_j][1]
                        self.STAR[begin_i][begin_j-des][2]=self.STAR[begin_i][begin_j][2]
                        self.STAR[begin_i][begin_j-des][3]=self.STAR[begin_i][begin_j][3]
                        local x = (begin_j-des-1)*STAR_WIDTH + STAR_WIDTH/2  
                        local y = (begin_i-1)*STAR_HEIGHT + STAR_HEIGHT/2 + 72
                        self.STAR[begin_i][begin_j-des][4] = x
                        self.STAR[begin_i][begin_j-des][5] = y
                        self.STAR[begin_i][begin_j][1] = nil
                        self.STAR[begin_i][begin_j][2] = nil
                        self.STAR[begin_i][begin_j][3] = nil
                        self.STAR[begin_i][begin_j][4] = nil
                        self.STAR[begin_i][begin_j][5] = nil
                    end
                end
            end
        end
    end
end

function MatrixStar:getStarNum()
    local num = 0
    for i = 1, ROW do
        for j = 1, COL do
            if self.STAR[i][j][1] ~= nil then
                num = num + 1
            end
        end
    end
    return num  
end

function MatrixStar:SetBtnsState( enabled)
    self.Prop1Btn:setButtonEnabled(enabled)
    self.Prop2Btn:setButtonEnabled(enabled)
    self.Prop3Btn:setButtonEnabled(enabled)
    self:setTouchEnabled(enabled)
end

function MatrixStar:onExit(  )
    -- body
    print("MatrixStar ==> onExit")
end



return MatrixStar