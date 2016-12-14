local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local BubbleButton = import("..views.BubbleButton")


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

HSCORETAG = 100
LEVELTAG = 101
CSCORETAG = 102
CURLEVEL   = 1
TARGETSCORE = 1000
CURSCORE = 100
SCALE = 1.5
UNNEEDCLEAR = 0
NEEDCLEAR = 1
CLEAROVER = 2
MOVEDELAY = 1.5

local STAR_WIDTH = 48   
local STAR_HEIGHT = 48
local ROW = 10
local COL = 10
local LEFT_STAR = 20    --剩余星星小于该数给予奖励
local STARGAIN  = 5      --星星得分基数

local MOVESPEED = 4     --星星的移动速度

local  mHandle = nil

local node_title  = nil --标头 显示分数道具等
local layer_stars = nil --星星逻辑层

local lbl_stage     = nil --关卡
local lbl_target    = nil --目标分数
local lbl_curscore  = nil --得分
local lbl_diamond   = nil --钻石数量
local lbl_prop1     = nil --道具1
local lbl_prop2     = nil --道具2
local lbl_prop3     = nil --道具3

local sp_tongguan = nil
local lbl_show = nil
local bool_ishaveShow_sp_tongguan = false
local bool_isusingBoom = false

function MatrixStar:ctor()
    self.Hscore = 0
    self.Level = 1
    self.Goal = STARTSCORE
    self.Cscore = 0
    self.STAR = {}
    self.SELECT_STAR = {}  --保存颜色相同的星星
    self.clearNeed = UNNEEDCLEAR  -- 是否需要清除剩余的星星
    --self:setLabel(self.Hscore,self.Level,self.Goal,self.Cscore)  
	self:initMatrix()  
    self:initTitles()  
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
       return self:onTouch(event, event.x, event.y) 
    end, false)

      --添加背景粒子特效
   local particle = cc.ParticleSystemQuad:create("gameBack.plist")
    self:addChild(particle,-2)

end  

--标头显示
function MatrixStar:initTitles() 
    -- body
    node_title = display.newNode()
    self:addChild(node_title)

    lbl_stage = cc.ui.UILabel.new({
        UILabelType = 2,
        text  =  "第 "..CURLEVEL.." 关",
        font = GAME_FONT,
        size = 25,
        })
    :align(cc.ui.TEXT_VALIGN_CENTER, display.left + 60, display.top - 30)
    :addTo(node_title)

    lbl_target = cc.ui.UILabel.new({
        UILabelType = 2,
        text  =  "目标 " .. TARGETSCORE,
        font = GAME_FONT,
        size = 27,
        })
    :align(cc.ui.TEXT_ALIGNMENT_LEFT, display.left + 165, display.top - 30)
    :addTo(node_title)


    lbl_curscore = cc.ui.UILabel.new({
        UILabelType = 2,
        text = CURSCORE,
        font = GAME_FONT,
        size = 27,
        })
    :align(cc.ui.TEXT_ALIGNMENT_LEFT, display.left + 240, display.top - 90)
    :addTo(node_title)

   local sp_dangqianfenshu = display.newSprite(GAME_IMAGE.dangqianfenshu ,lbl_curscore:getPositionX() - 40, lbl_curscore:getPositionY()  )
       :setScale(0.5)  
       :addTo(node_title)

    -- 宝石按钮
    self.AddDiamondButton =  cc.ui.UIPushButton.new({normal =  GAME_IMAGE.coin_bar, pressed =  GAME_IMAGE.coin_bar})
        :align(display.CENTER,  display.left + 70, display.top - 90)
        :onButtonClicked(function()
            audio.playSound(GAME_SOUND.pselect)
           -- app:enterMenuScene()
        end)
        :setScale(0.8)
        :addTo(node_title)
    local sp_jiahao = display.newSprite(GAME_IMAGE.jiahao, display.left + 42,  display.top - 95) 
        :addTo(node_title) 
        :setScale(0.9)  

    lbl_diamond = cc.ui.UILabel.new({
        UILabelType = 2,
        text  =  "10000",
        font = GAME_FONT,
        size = 18,
    })
    :align(cc.ui.TEXT_VALIGN_CENTER, display.left + 80, display.top - 87)
    :addTo(node_title)


    lbl_show = cc.ui.UILabel.new({
        UILabelType = 2,
        text  =  "  ",
        font = GAME_FONT,
        size = 20,
        color = cc.c3b(255,140,0),
    })
    :align(cc.ui.TEXT_VALIGN_CENTER, display.cx - 400, display.cy)
    :addTo(node_title)

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
    transition.execute(lbl_show, sequenceAction1 ,{  
        delay = 0,  
        easing = "sineInOut",  
        onComplete = function()  
        node_title:removeChild(sp_tongguanbg)
        end, 
    })



    sp_tongguan = display.newSprite(GAME_IMAGE.stage_clear, display.cx, display.cy)
    :addTo(node_title,3)
    sp_tongguan:setScale(0)


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
        :align(display.top,  display.right - 50, display.top - 30)
        :setScale(0.8)
        :addTo(node_title)
    local sp_coinbar01 = display.newSprite(GAME_IMAGE.coin_bar, self.Prop1Btn:getPositionX() - 5, self.Prop1Btn:getPositionY() - 36) 
        :addTo(node_title) 
        :setScale(0.6)  

    lbl_prop1 = cc.ui.UILabel.new({
        UILabelType = 2,
        text  =  "1000",
        font = GAME_FONT,
        size =  18,
    })
    :align(cc.ui.TEXT_VALIGN_CENTER,self.Prop1Btn:getPositionX(), self.Prop1Btn:getPositionY() - 34)
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
        :align(display.top,  display.right - 50, display.top - 100)
        :setScale(0.8)
        :addTo(node_title)
    local sp_coinbar02 = display.newSprite(GAME_IMAGE.coin_bar, self.Prop2Btn:getPositionX() - 5, self.Prop2Btn:getPositionY() - 36) 
        :addTo(node_title) 
        :setScale(0.6)  

    lbl_prop2 = cc.ui.UILabel.new({
        UILabelType = 2,
        text  =  "100",
        font = GAME_FONT,
        size = 18,
    })
    :align(cc.ui.TEXT_VALIGN_CENTER,self.Prop2Btn:getPositionX(), self.Prop2Btn:getPositionY() - 34)
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
        :align(display.top,  display.right - 50, display.top - 170)
        :setScale(0.8)
        :addTo(node_title)
    local sp_coinbar03 = display.newSprite(GAME_IMAGE.coin_bar, self.Prop3Btn:getPositionX() - 5, self.Prop3Btn:getPositionY() - 36) 
        :addTo(node_title) 
        :setScale(0.6)  

    lbl_prop3 = cc.ui.UILabel.new({
        UILabelType = 2,
        text  =  "1000",
        font = GAME_FONT,
        size = 18,
    })
    :align(cc.ui.TEXT_VALIGN_CENTER,self.Prop3Btn:getPositionX(), self.Prop3Btn:getPositionY() - 34)
    :addTo(node_title)

    node_title:fadeIn(15)
end

-- 道具 1 点击事件
function MatrixStar:Prop1_onclick()
    audio.playSound(GAME_SOUND.Props_Rainbow)
    self:setTouchEnabled(true)
    self.Prop1Btn:setButtonEnabled(false)
    self.Prop2Btn:setButtonEnabled(false)
    self.Prop3Btn:setButtonEnabled(false)

    self:ResetStar()  
end

-- 道具 2 点击事件
function MatrixStar:Prop2_onclick()
    audio.playSound(GAME_SOUND.pselect)
    bool_isusingBoom = true
    self:setTouchEnabled(true)
    self.Prop1Btn:setButtonEnabled(false)
    self.Prop2Btn:setButtonEnabled(false)
    self.Prop3Btn:setButtonEnabled(false)
end

-- 道具 3 点击事件
function MatrixStar:Prop3_onclick()
    audio.playSound(GAME_SOUND.Props_Paint)
    self:setTouchEnabl(true)
    self.Prop1Btn:setBttonEnabled(false)
    self.Prop2Btn:setButtonEnabled(false)
    self.Prop3Btn:setButtonEnabled(false)

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
                self:setTouchEnabled(true) 
                self.Prop1Btn:setButtonEnabled(true)
                self.Prop2Btn:setButtonEnabled(true)
                self.Prop3Btn:setButtonEnabled(true)
            end
        end,  
        })  
        offettime = offettime + 0.01
        transition.execute(self.STAR[travel_2[2]][travel_2[3]][1], sequence2, {  
        delay = offettime ,  
        easing = "InOut",  
        onComplete = function()  
            if #leftStars <= 0 then
                self:setTouchEnabled(true) 
                self.Prop1Btn:setButtonEnabled(true)
                self.Prop2Btn:setButtonEnabled(true)
                self.Prop3Btn:setButtonEnabled(true)
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
    for y = j - 1, j + 1 do
        for x = i - 1, i + 1 do
            if x <= ROW and x > 0 and y  <= COL and y > 0 and self.STAR[x][y][1] ~= nil then 
            table.insert(self.SELECT_STAR, {self.STAR[x][y][1], x, y})
            end
        end
    end
    
   -- bool_isusingBoom = false
    local offetX = 0
    if j >= 10  then
        offetX = -(STAR_WIDTH*2)
        elseif j <= 1  then
            offetX = STAR_WIDTH*2
    end

    local sp_boom = display.newSprite(GAME_IMAGE.Props_Bomb ,self.STAR[i][j][1]:getPositionX() + offetX, self.STAR[i][j][1]:getPositionY() + 100)
        :setScale(3)
        :addTo(node_title)

        transition.moveTo(sp_boom , {x = self.STAR[i][j][1]:getPositionX(), y = self.STAR[i][j][1]:getPositionY(), time = 1.2})
        
       -- transition.fadeTo(sp_boom , {opacity = 255, time = 0.3})
       --transition.fadeTo(sp_boom , {opacity = 128, time = 0.3})
        --transition.fadeTo(sp_boom , {opacity = 255, time = 0.3})
        transition.scaleTo(sp_boom, {
            scaleX     = 1,
            scaleY     = 1,
            time       = 1.2,
            onComplete = function ( )
                node_title:removeChild(sp_boom)
                audio.playSound(GAME_SOUND.Props_Bomb)
                self:ShowAnimLabel(true , i , j)
                while #self.SELECT_STAR > 0 do
                    self:deleteOneStar()
                end
                self:setTouchEnabled(true) 
                self.Prop1Btn:setButtonEnabled(true)
                self.Prop2Btn:setButtonEnabled(true)
                self.Prop3Btn:setButtonEnabled(true)
                end, 
        })
   
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
     
    for row = 1, ROW do
        local y = (row-1) * STAR_HEIGHT + STAR_HEIGHT/2 + 72
        self.STAR[row] = {}
        for col = 1, COL do
            self.STAR[row][col] = {}
            local x = (col-1) * STAR_WIDTH + STAR_WIDTH/2
            local i = math.random(1,#STAR_RES_LIST)
            local star = display.newSprite(STAR_RES_LIST[i])
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

            local sequence = transition.sequence({
            cc.ScaleTo:create(0.3, 0.5),
            }) 

            transition.execute(star, sequence, {  
            delay = 0.5,  
            easing = "InOut",  
            onComplete = function()  
                if row == ROW  and col == COL then
                   self:setTouchEnabled(true) 
                   else
                   self:setTouchEnabled(false) 
                end
            end,  
            })  
        end
    end
end

function MatrixStar:setLabel(isreadyTostart,Hscore,Level,TargetScore,Cscore)
   if isreadyTostart == true then

    else
        --todo
   end
end

function MatrixStar:onTouch(eventType, x, y)  
    if eventType.name == "began" then 
        i = math.floor((y-72) / STAR_HEIGHT) + 1
        j = math.floor(x / STAR_WIDTH) + 1
        if i < 1 or i > ROW or j < 1 or j > COL or self.clearNeed ~= UNNEEDCLEAR then
            return 
        end 

        self.SELECT_STAR = {}   --将选中的星星清空
        self:setTouchEnabled(false)

        if bool_isusingBoom == true then
            self:UseBoom(i,j)
            return
        end

        if self:getSelectStar() == false then 
            return
        end
        -- 星星排序 从左往右 从上往下
        if #self.SELECT_STAR > 1 then
            self:ShowAnimLabel(false , i , j)
        end

        audio.playSound(GAME_SOUND.ppop )

        local  function deleteOneStar_( dt )
            self:deleteOneStar()
        end 
        
        mHandle = scheduler.scheduleGlobal(deleteOneStar_, 0.1)
        self:ShowAnim(#self.SELECT_STAR)
    end
end

function MatrixStar:deleteOneStar()
        -- body
        local deleteStar = {}
        deleteStar = table.remove(self.SELECT_STAR)
        if deleteStar ~= nil and #deleteStar ~= 0 then
        self:setTouchEnabled(false)
        local row , col = deleteStar[2], deleteStar[3]
       
        local particle = cc.ParticleSystemQuad:create(STAR_PARTICLE[self.STAR[row][col][2]])
                particle:setPosition(self.STAR[row][col][1]:getPosition())
                particle:setAutoRemoveOnFinish(true)
                self:addChild(particle,1)  
        self:removeChild(self.STAR[row][col][1]) 

        self.STAR[row][col][1] = nil 
        self.STAR[row][col] = {}
        end

        if #self.SELECT_STAR <=0 then
            self:UpdateMatrix()
            self.Prop2Btn:setButtonEnabled(true)

        if self:isEnd() == true then 
            
             self.clearNeed = NEEDCLEAR
        end

        if mHandle ~= nil then
            scheduler.unscheduleGlobal(mHandle)
            mHandle = nil
        end
        self:updateStar()
        self:setTouchEnabled(true)
        end
end

function MatrixStar:ShowAnimLabel(isusingBoom ,i,j)
    if (isusingBoom == false and  #self.SELECT_STAR > 1 ) or  (isusingBoom == true and  #self.SELECT_STAR > 0 ) then
            local deleteStarnum = #self.SELECT_STAR
            if isusingBoom == true then
                STARGAIN = 10
            end
            local getscorse = string.format("%s", tostring(#self.SELECT_STAR * #self.SELECT_STAR * STARGAIN))
            lbl_show:setString("消除"..deleteStarnum .."个:"..getscorse.."分")
            local posx , posy  = self.STAR[i][j][1]:getPositionX() , self.STAR[i][j][1]:getPositionY() + 50
            local lbl_      = cc.ui.UILabel.new({
                UILabelType = 2,
                text        = getscorse,
                font        = GAME_FONT,
                size        = 40,
                })
                :align(cc.ui.TEXT_VALIGN_CENTER, posx, posy)
                :addTo(self,1)

            local sequenceAction = transition.sequence({
            cc.FadeTo:create(0.1, 255 ),
            cc.ScaleTo:create(0.1, 3, 3, 1), 
            cc.ScaleTo:create(0.5, 1, 1, 1), 
            cc.MoveTo:create(0.5, cc.p(lbl_curscore:getPositionX() , lbl_curscore:getPositionY() - 10 )),
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
       local sp_praise1 = display.newSprite(GAME_IMAGE.praise1) 
        :align(display.CENTER, display.cx, display.cy)
        :addTo(node_title) 
        transition.execute(sp_praise1, sequenceAction, {
            delay = 0,
            easing = "sineInOut",  
            onComplete = function()  
                node_title:removeChild(sp_praise1)
            end, 
            })

        audio.playSound(GAME_SOUND.word_1, false)

        elseif num < 9 then --酷毙了
            local sp_praise2 = display.newSprite(GAME_IMAGE.praise2) 
            :align(display.CENTER, display.cx, display.cy)
            :addTo(node_title) 
            transition.execute(sp_praise2, sequenceAction, {
                delay = 0,
                easing = "sineInOut",  
                onComplete = function()  
                    node_title:removeChild(sp_praise2)
                end, 
                })
            audio.playSound(GAME_SOUND.word_1, false)
            elseif num < 12 then --霸气侧漏
                local sp_praise2 = display.newSprite(GAME_IMAGE.praise3) 
                :align(display.CENTER, display.cx, display.cy)
                :addTo(node_title) 
                transition.execute(sp_praise2, sequenceAction, {
                    delay = 0,
                    easing = "sineInOut",  
                    onComplete = function()  
                        node_title:removeChild(sp_praise2)
                    end, 
                    })
                audio.playSound(GAME_SOUND.word_2, false)
                elseif num > 11 then --棒棒
                    local praises = {GAME_IMAGE.praise4, GAME_IMAGE.praise5, GAME_IMAGE.praise6}
                    local sp_praise2 = display.newSprite(praises[math.random(1,3)]) 
                    :align(display.CENTER, display.cx, display.cy)
                    :addTo(node_title) 
                    transition.execute(sp_praise2, sequenceAction, {
                        delay = 0,
                        easing = "sineInOut",  
                        onComplete = function()  
                            node_title:removeChild(sp_praise2)
                        end, 
                        })
                    audio.playSound(GAME_SOUND.word_2, false)
                   
    end
end

function MatrixStar:updateScore(select)
    self.Cscore = self.Cscore + select * select * STARGAIN
    lbl_curscore:setString(string.format("%s", tostring(self.Cscore)))
    if self.Cscore >= TARGETSCORE then
            lbl_curscore:setTextColor(cc.c3b(255, 255 , 0))

            if bool_ishaveShow_sp_tongguan == false then

                audio.playSound(GAME_SOUND.ptarget)
                local sp_tongguanbg = display.newSprite(GAME_IMAGE.stage_clear_bg, display.cx, display.cy)
                    :addTo(node_title,2)
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
            lbl_curscore:setTextColor(cc.c3b(0, 255, 127))
    end
end

function MatrixStar:getSelectStar()
    local travel = {}  --当作一个队列使用，用于选出周围与触摸星星颜色相同的星星
    if self.STAR[i][j][1] == nil then
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
        local frame = display.newSprite(STAR_RES_LIST_SELECT[self.STAR[i][j][2]]) 
        self.STAR[i][j][1]:setTexture(frame:getTexture())

        self.STAR[i][j][3] = nil 
        self.SELECT_STAR = {}
        return false
        -- else
        --     for i=1,#self.SELECT_STAR  do
        --         --替换成选中的精灵图样
        --         local  color = self.STAR[self.SELECT_STAR[i][2]][self.SELECT_STAR[i][3]][2] --颜色
        --         local slectSprite =  display.newSprite(STAR_RES_LIST_SELECT[color])         --选中的图样
        --         self.STAR[self.SELECT_STAR[i][2]][self.SELECT_STAR[i][3]][1]:setTexture(slectSprite:getTexture())  --把原来的精灵更换图片
        --     end
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
    self:setTouchEnabled(false)
    self.Prop1Btn:setButtonEnabled(false)
    self.Prop2Btn:setButtonEnabled(false)
    self.Prop3Btn:setButtonEnabled(false)

    local str = "剩余星星: " .. #deleteStars
    local num = self:getStarNum()
                if num < LEFT_STAR then
                    local left = LEFT_STAR - num 
                    self.Cscore = self.Cscore + left * left * STARGAIN
                    str = "剩余星星: " .. num .."\n" .. "获得奖励: " .. left * left * STARGAIN .."分"
                end

    local lbl_  = cc.ui.UILabel.new({
            UILabelType = 2,
            text        = str ,
            font        = GAME_FONT,
            size        = 40,
            })
            :align(cc.ui.TEXT_VALIGN_CENTER, display.right + 200, display.cy)
            :addTo(self,3)

        local sequenceAction = transition.sequence({
        cc.MoveTo:create(0.3, cc.p(display.cx , display.cy)),
        cc.FadeTo:create(10,  0 ),
        })

        transition.execute(lbl_, sequenceAction ,{  
            delay = 0,  
            easing = "sineInOut",  
            onComplete = function()  
                self:setTouchEnabled(true)
                self:removeChild(lbl_)
            end, 
        })

   local function oneByone(dt)
        local deleteNextStar = {}
        deleteNextStar = table.remove(deleteStars)
        if deleteNextStar ~= nil and #deleteNextStar ~= 0 then
            
            local row , col = deleteNextStar[2], deleteNextStar[3]
            audio.playSound(GAME_SOUND.ppop)
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
                self:setTouchEnabled(true)
        end
    end
     mHandle = scheduler.scheduleGlobal(oneByone, 0.1)
end

function MatrixStar:updatePos(posX,posY,i,j)
    transition.execute(self.STAR[i][j][1], cc.MoveTo:create(0.1, cc.p(self.STAR[i][j][4] , self.STAR[i][j][5] )), {  
    delay = 0.1,  
    easing = "bounceInOut",  
    onComplete = function()  
        if self.STAR[i][j][1]:getPositionY() < self.STAR[i][j][5]  then
                     self.STAR[i][j][1]:setPositionY(self.STAR[i][j][5])
        end

        if self.STAR[i][j][1]:getPositionX() < self.STAR[i][j][4]  then
             self.STAR[i][j][1]:setPositionX(self.STAR[i][j][4])
        end 
    end,  
    })  
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
--                    print("test"..tostring(begin_i))
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

-- function MatrixStar:deleteStarsOneByone(  )

--     for num = 1, #self.SELECT_STAR do 
--         local row , col = self.SELECT_STAR[num][2], self.SELECT_STAR[num][3]
--         audio.playSound(GAME_SOUND.ppop)
--         local particle = cc.ParticleSystemQuad:create(STAR_PARTICLE[self.STAR[row][col][2]])
--                 particle:setPosition(self.SELECT_STAR[num][1]:getPosition())
--                 particle:setAutoRemoveOnFinish(true)
--                 self:addChild(particle,1)  

--         self:removeChild(self.STAR[row][col][1]) 
--         self.STAR[row][col][1] = nil 
--     end
--     scheduler.performWithDelayGlobal(self:deleteOneStar(), 0.3)  
-- end



return MatrixStar