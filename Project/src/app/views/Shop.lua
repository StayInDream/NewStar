--
-- Author: LLLLL
-- Date: 2016-12-21 09:39:59
--
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local Shop = class("Shop",function()
	return display.newLayer()
end)

local shopTypes = {{50.00, 500}, {30.00, 200}, {15.00, 80}, {10.00, 50}, {5.00,15}, {2.00,5} , {1.00,2} }

--商店类型
Shop.SHOPTYPE = {
	ShopType_1 = 1, --主商店
	ShopType_2 = 2, --活动
}
local num = 0
function Shop:ctor()
	self:setVisible(false)

    self.sp_mask = display.newSprite( GAME_IMAGE.sp_mask)
    :align(display.CENTER, display.cx , display.cy)
    :addTo(self) 
    :setScale(20)
    :setOpacity(0)
    self.sp_bg01 = display.newScale9Sprite( GAME_IMAGE.huodong_diban_2, display.left - 250 , display.cy + 50, cc.size(400, 600) )
    :addTo(self) 
   
    local sp_bg02 = display.newSprite( GAME_IMAGE.shangdian_biaotoutu )
    :align(self.sp_bg01, 200, 580)
    :addTo(self.sp_bg01)

    local sp_03 = display.newSprite( GAME_IMAGE.shangdian_wenzi )
    :align(self.sp_bg01, 200, 590)
    :addTo(self.sp_bg01)

    local closeButton = cc.ui.UIPushButton.new({normal = GAME_IMAGE.close_bg, pressed = GAME_IMAGE.close_bg})
    :align(self.sp_bg01, 390, 570)
    :addTo(self.sp_bg01)
    :onButtonClicked(function()
        audio.playSound(GAME_SOUND.pselect)
        self:CloseShop()
        end)

    local duanxinButton = cc.ui.UIPushButton.new({normal = GAME_IMAGE.duanxinzhifu_2, pressed = GAME_IMAGE.duanxinzhifu_2})
    :align(self.sp_bg01, 200, 510)
    :addTo(self.sp_bg01)
    :onButtonClicked(function()
        --audio.playSound(GAME_SOUND.pselect)
        print("duanxin fu")
        end)

    local sp_shopitemBG = display.newScale9Sprite( GAME_IMAGE.shop_item_bg_2 ,200 , 280, cc.size(350, 400))
    :addTo(self.sp_bg01)

    local sp_04 = display.newSprite( GAME_IMAGE.emailIcon_diamond)
    :align(self.sp_bg01, 280, 50)
    :setScale(0.4)
    :addTo(self.sp_bg01)

    local lbl_01 = cc.ui.UILabel.new({
        UILabelType = 2,
        text  =  "拥有:",
        size = 20,
        })
    :align(self.sp_bg01, 210, 50)
    :addTo(self.sp_bg01)

    local diaNum = 0
    -- if GameData ~= nil and GameData.DIAMOND ~= nil then
    --     diaNum = GameData.DIAMOND
    -- end

     local lbl_02 = cc.ui.UILabel.new({
        UILabelType = 1,
        text  =  diaNum,
        font  = GAME_FONT,
        })
    :setScale(0.4)
    :align(self.sp_bg01, 300, 50)
    :addTo(self.sp_bg01)

    --滚动
    local ListView  = cc.ui.UIListView.new({
            viewRect  = cc.rect(0,0,350,390),
            direction = cc.ui.UIListView.DIRECTION_VERTICAL,
            items_ = {},

        })
        :addTo(self.sp_bg01)
        :align(self.sp_bg01, 25, 86)
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
                self:Pay({ num = shopTypes[i][1]})
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

function Shop:Show(ShopType)
	-- body
	self:setVisible(true)
	self.sp_mask:fadeTo(1, 255)
    
	if ShopType then

		if ShopType == Shop.SHOPTYPE.ShopType_1 then
				self:ShowMain()
				self.shoptype = ShopType
			elseif ShopType ==  Shop.SHOPTYPE.ShopType_2 then
				--todo
				self:ShowType_1_View()
				self.shoptype = ShopType
		end

		return
	end
	self:ShowMain()
	
end

function Shop:ShowMain()
	-- body
	scheduler.performWithDelayGlobal(function()
	        transition.moveTo(self.sp_bg01, {
            x = display.cx ,
            y = display.cy + 50,
            time = 0.5,
            easing = "backOut",
            })
            end , 0.1)
end

function Shop:ShowType_1_View()
    -- body
    if self.layer_buyView then
    	scheduler.performWithDelayGlobal(function( )
        	-- body
        	transition.moveTo(self.layer_buyView, {
            x = display.cx ,
            y = display.cy ,
            time = 0.5,
            easing = "backOut",
            })

        end, 0.1)
    	return
    end
    self.layer_buyView = display.newLayer()
    :align(display.CENTER, display.right + display.width, display.cy)
    :addTo(self, 5)

     local sp_02  = display.newSprite(GAME_IMAGE.hotsale_bg)
     :align(display.CENTER, display.cx, display.cy)
     :addTo(self.layer_buyView) 

     local sp_03  = display.newSprite(GAME_IMAGE.buydiamand_wenzi)
     :align(display.CENTER, sp_02:getPositionX(), sp_02:getPositionY() + 165)
     :addTo(self.layer_buyView)

     local sp_04  = display.newSprite(GAME_IMAGE.zengbig_unicom)
     :align(display.CENTER, sp_02:getPositionX() - 70, sp_02:getPositionY())
     :addTo(self.layer_buyView) 

     local sequenceAction = transition.sequence({
            cc.ScaleTo:create(0.5, 1.1, 1.1, 1), 
            cc.ScaleTo:create(0.5, 0.9, 0.9, 1), 
            })

      transition.execute(sp_04, cc.RepeatForever:create( sequenceAction ))

    local sp_05  = display.newSprite(GAME_IMAGE.emailIcon_diamond)
     :align(display.CENTER, sp_02:getPositionX()+ 30 , sp_02:getPositionY() + 40)
     :addTo(self.layer_buyView) 
     :setScale(0.6)

     local lbl_1 = cc.ui.UILabel.new({
        UILabelType = 1,
        text        = "300个",
        font        = GAME_FONT,
        })
        :setScale(0.5)
        :align(display.CENTER,  sp_05:getPositionX() + 70 , sp_05:getPositionY() )
        :addTo(self.layer_buyView)
        :setColor(cc.c3b(255, 0, 255))

    local sp_06  = display.newSprite(GAME_IMAGE.emailIcon_diamond)
     :align(display.CENTER, sp_02:getPositionX()+ 45 , sp_02:getPositionY() - 20)
     :addTo(self.layer_buyView) 
     :setScale(0.4)

     local lbl_2 = cc.ui.UILabel.new({
        UILabelType = 1,
        text        = "200个",
        font        = GAME_FONT,
        })
        :setScale(0.5)
        :align(display.CENTER,  sp_06:getPositionX() + 55 , sp_06:getPositionY() )
        :addTo(self.layer_buyView)
        :setColor(cc.c3b(255, 0, 255))

    local btn_buy = cc.ui.UIPushButton.new({normal =  GAME_IMAGE.anniu, pressed =  GAME_IMAGE.anniu1})   --购买
        :align(display.CENTER, sp_02:getPositionX(), sp_02:getPositionY() - 130)
        :onButtonClicked(function()
            audio.playSound(GAME_SOUND.pselect)
           self:Pay({num = 30 ,})
        end)
        :addTo(self.layer_buyView)

    local btn_close = cc.ui.UIPushButton.new({normal =  GAME_IMAGE.close_bg, pressed =  GAME_IMAGE.close_bg})  
        :align(display.CENTER, sp_02:getPositionX() + 150 , sp_02:getPositionY() + 170)
        :onButtonClicked(function()
            audio.playSound(GAME_SOUND.pselect)
            self:CloseShop()
        end)
        :addTo(self.layer_buyView)   

    local sp_07  = display.newSprite(GAME_IMAGE.onsale_btn_buy)
     :align(display.CENTER, btn_buy:getPositionX() , btn_buy:getPositionY())
     :addTo(self.layer_buyView) 

     local lbl_3 = cc.ui.UILabel.new({
        UILabelType = 2,
        text        = "点击按钮您将通过短信支付30元。",
        size        = 30
        })
        :setScale(0.5)
        :align(display.CENTER,  btn_buy:getPositionX() , btn_buy:getPositionY() - 40)
        :addTo(self.layer_buyView)

        scheduler.performWithDelayGlobal(function( )
        	-- body
        	transition.moveTo(self.layer_buyView, {
            x = display.cx ,
            y = display.cy ,
            time = 0.5,
            easing = "backOut",
            })

        end, 0.1)
end

function Shop:CloseShop( )
	-- body
	if self.shoptype == Shop.SHOPTYPE.ShopType_1 then

		scheduler.performWithDelayGlobal(function()
            -- body
            transition.moveTo(self.sp_bg01, {
                x = display.cx - 700,
                y = display.cy + 50,
                time = 0.5,
                easing = "backIn",
                onComplete = function()
                   self:setVisible(false)
                end,
                })
        end, 0.1)

		elseif self.shoptype == Shop.SHOPTYPE.ShopType_2 then
			--todo
			scheduler.performWithDelayGlobal(function( )
        	transition.moveTo(self.layer_buyView, {
            x = display.right + display.width ,
            y = display.cy ,
            time = 0.5,
            easing = "backIn",
            onComplete = function()
                self:setVisible(false)
            end,
            })

        end, 0.1)
	end
end

function Shop:Pay( arges )
    -- body
    num = arges.num
    ShopType = arges.shoptype
    print("pay " .. num .. "元")
end

return Shop