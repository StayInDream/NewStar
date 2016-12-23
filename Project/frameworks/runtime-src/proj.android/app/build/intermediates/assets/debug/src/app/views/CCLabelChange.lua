--
-- Author: LLLLL
-- Date: 2016-12-09 19:30:53
--
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

CCLabelChange = class("CCLabelChange", function()
    local node = display.newNode()
    node:setNodeEventEnabled(true)
    return node
end)            
--index
local __index           = CCLabelChange
local _duration         = 1
local _fromNum          = 0
local _toNum            = 0
local _target           = nil
local _isPause          = false
local _changerate       = 1
local bool_ifKillself   = true
local timer             = 0
local bool_add          = true --true为自增
local _callback         = nil
local bool_isTarget     = false

local lbl_Willactions   = {}
local lbl_actions       = {}

 --target 要显示的数字变化的lbl
 --duration 周期
 --fromNum 开始值
 --toNum 目标值
function CCLabelChange:create(target, args)
    local ret = CCLabelChange.new()
    ret:init(target, args)
   -- target:getParent():addChild(self) --基于此执行
    return ret
end

function CCLabelChange:init(target, args)
    _target   = target
    _duration = args.duration
    _fromNum  = args.fromNum
    _toNum    = args.toNum
    _callback = args.callback or nil
    _changerate = args.changerate or 1
    bool_ifKillself = args.selfKill or true
    
    timer     = _fromNum
    bool_isTarget = false
    _isPause = false
    local x   = _toNum - _fromNum
    if x > 0 then
            bool_add = true 
        else
            bool_add = false
    end

    table.insert(lbl_Willactions, {_target = _target,_duration = _duration, _fromNum =_fromNum , _toNum = _toNum , _callback = _callback, _changerate = _changerate , bool_ifKillself = bool_ifKillself, timer = timer , bool_add =bool_add})
end

--两种情况下执行此方法 1、动作执行完毕 2、同类动作，旧动作在执行中，新动作需要执行，此时把旧动作移除
function CCLabelChange:selfKill()
    self:pauseAction()
    if self.handler ~= nil and bool_ifKillself == true then
        scheduler.unscheduleGlobal(self.handler)
   -- self:removeFromParentAndCleanup(true) --从父类移除
  
    _target._labelChange = nil --把引用删除
    _target = nil
    end --停止scheduler
end

function CCLabelChange:pauseAction()
    _isPause = true
end

function CCLabelChange:resumeAction()
    _isPause = false
end

--重新开始
function CCLabelChange:ReplayAction()
    _isPause      = false
    bool_isTarget = false
    timer         = _fromNum
end

function CCLabelChange:playAction()
    if #lbl_actions ==  0 then --执行新的动作指令
        local action = table.remove(lbl_Willactions , 1)
        _target   = action._target
        _duration = action._duration
        _fromNum  = action._fromNum
        _toNum    = action._toNum
        _callback = action._callback
        _changerate = action._changerate 
        bool_ifKillself = action.bool_ifKillself
        timer     = action.timer
        bool_add  = action.bool_add

        if self.waitHandle ~= nil then
            scheduler.unscheduleGlobal(self.waitHandle)
            self.waitHandle = nil
        end

        else
            --todo  --前一个动作还没结束
            if self.waitHandle == nil then
                    self.waitHandle = scheduler.scheduleGlobal( function( )
                        -- body
                    self:playAction() end, 0.5 )
                 
            end
            return
    end 

    local oldAction = _target._labelChange
    -- if oldAction then
    --     --旧动作存在
    --  oldAction:selfKill()
    -- end


    _target._labelChange = _target --引用变成自己
    local function int(x) 
        return x>=0 and math.floor(x) or math.ceil(x)
    end

    local function updateLabelNum(dt)
        if _isPause or bool_isTarget == true then
            return
        end

        if bool_add == true then
                timer = int(timer + _changerate) 
            else
                timer = int(timer - _changerate) 
        end

        if _target ~= nil then
            if bool_add == true then 
                if timer < _toNum then
                        _target:setString(math.abs( timer))
                    else
                        bool_isTarget = true
                        _target._labelChange = nil
                        _target:setString(math.abs( _toNum))
                        if _callback ~= nil then
                            _callback()
                        end
                        scheduler.unscheduleGlobal(table.remove(lbl_actions))
                end
            else
                if timer > _toNum then
                        _target:setString(math.abs( timer))
                    else
                        bool_isTarget = true
                        _target._labelChange = nil
                        _target:setString(math.abs( _toNum))
                        if _callback ~= nil then
                            _callback()
                        end
                        scheduler.unscheduleGlobal(table.remove(lbl_actions))
                        
                end
            end
                    
        end
    end
  self.handler =  scheduler.scheduleGlobal(updateLabelNum , _duration )
  table.insert(lbl_actions, self.handler )
end

function CCLabelChange:onEnter()
     print("CCLabelChange ==> onEnter")
end

function CCLabelChange:onExit()
    print("CCLabelChange ==> onExit")
    if self.handler ~= nil then
        scheduler.unscheduleGlobal(self.handler)
    end

    if self.waitHandle ~= nil then
        scheduler.unscheduleGlobal(self.waitHandle)
        self.waitHandle = nil
    end
    lbl_Willactions = {}
    lbl_actions     ={}

end

return CCLabelChange