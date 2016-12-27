--
-- Author: LLLLL
-- Date: 2016-12-27 15:01:49
--
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

--提示窗口
local WarningWin = class("WarningWin",function()
	return display.newLayer()
end)

function WarningWin:ctor()
	self:setVisible(false)
	self.sp_mask = display.newSprite( GAME_IMAGE.sp_mask)
	    :align(display.CENTER, display.cx , display.cy)
	    :addTo(self) 
	    :setScale(20)
	    :setOpacity(255)
	self.btn_mask = cc.ui.UIPushButton.new({normal = GAME_IMAGE.sp_mask, pressed = GAME_IMAGE.sp_mask ,disabled = GAME_IMAGE.sp_mask})
	:align(display.CENTER, display.cx , display.cy)
	:setButtonSize(display.widthInPixels, display.heightInPixels)
	:onButtonClicked(function()
                self:setVisible(false)
            end)
	:addTo(self) 

    self.sp_bg01 = display.newScale9Sprite( GAME_IMAGE.btnFrame, display.cx , display.cy, cc.size(300, 200) )
	    :addTo(self)
	    :setTouchEnabled(true)

	self.lbl_title = cc.ui.UILabel.new({
		UILabelType = 2,
		text = "提 示 信 息",
		size = 20,
		color = cc.c3b(0, 255, 0),   
		})
	    :align(display.CENTER,  self.sp_bg01:getContentSize().width /2, self.sp_bg01:getContentSize().height -20)
        :addTo(self.sp_bg01)

	local shape3 = display.newLine({{10,  self.sp_bg01:getContentSize().height -35}, {290, self.sp_bg01:getContentSize().height -35}},
	    {borderColor = cc.c4f(1.0, 0.0, 0.0, 1.0),
	    borderWidth = 2})
	:addTo(self.sp_bg01)

    self.lbl_dec= cc.ui.UILabel.new({
		UILabelType = 2,
		text = "这是是消息的内容详情，这是是消息的内容详情，这是是消息的内容详情，这是是消息的内容详情，这是是消息的内容详情，这是是消息的内容详情，这是是消息的内容详情，这是是消息的内容详情，",
		size = 15,
		valign = cc.ui.TEXT_ALIGN_CENTER,
		dimensions = cc.size(260, 150),
		color = cc.c3b(0, 255, 255) ,   
		})
	    :align(display.CENTER,  self.sp_bg01:getContentSize().width /2 , self.sp_bg01:getContentSize().height/2 - 15)
	    :addTo(self.sp_bg01)

    local lbl_ = cc.ui.UILabel.new({
		UILabelType = 2,
		text = "3秒后此窗口自动消失...",
		size = 15,
		})
	    :align(display.BOTTOM,  self.sp_bg01:getContentSize().width /2,  -20)
        :addTo(self.sp_bg01)

end

function WarningWin:ShowWaringInfo( params)
	-- body
	if params then
		self:setVisible(true)
		scheduler.performWithDelayGlobal(function ()
			-- body
			self:setVisible(false)
		end, 3)

		local lbl_title = params.title or "提 示 信 息"
		local lbl_dec = "无提示内容"
		if not params.dec then
			print("[ERROR] 调用WarningWin:ShowWaringInfo(params)参数错误，无提示信息描述 --如：dec = xxxxxx " )
		else
			 lbl_dec = params.dec 
		end

		self.lbl_title:setString(lbl_title)
		self.lbl_dec:setString(lbl_dec)
	end
end

return WarningWin