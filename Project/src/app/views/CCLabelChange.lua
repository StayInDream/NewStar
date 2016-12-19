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
local timer             = 0
local bool_add          = true --true为自增
local _callback         = nil
local bool_isTarget     = false

 --target 要显示的数字变化的lbl
 --duration 周期
 --fromNum 开始值
 --toNum 目标值
function CCLabelChange:create(target, args)
    local ret = CCLabelChange.new()
    ret:init(target, args)
    return ret
end

function CCLabelChange:init(target, args)
    _target   = target
    _duration = args.duration
    _fromNum  = args.fromNum
    _toNum    = args.toNum
    _callback = args.callback
    
    timer     = _fromNum
    bool_isTarget = false
    _isPause = false
    local x   = _toNum - _fromNum
    if x > 0 then
            bool_add = true 
        else
            bool_add = false
    end

end

--两种情况下执行此方法 1、动作执行完毕 2、同类动作，旧动作在执行中，新动作需要执行，此时把旧动作移除
function CCLabelChange:selfKill()

    if self.handler ~= nil then
        scheduler.unscheduleGlobal(self.handler)
    self:removeFromParentAndCleanup(true) --从父类移除
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
    local oldAction = _target._labelChange

    if oldAction then
        --旧动作存在
     oldAction:selfKill()
    end

    _target._labelChange = _target --引用变成自己
    local function int(x) 
        return x>=0 and math.floor(x) or math.ceil(x)
    end

    local function updateLabelNum(dt)
        if _isPause or bool_isTarget == true then
            return
        end


        if bool_add == true then
                timer = int(timer + 1) 
            else
                timer = int(timer - 1) 
        end

        if _target ~= nil then
            if bool_add == true then 
                if timer < _toNum then
                        _target:setString(math.abs( timer))
                    else
                        bool_isTarget = true
                        _target:setString(math.abs( _toNum))
                        if _callback ~= nil then
                            _callback()
                        end
                end
            else
                if timer > _toNum then
                        _target:setString(math.abs( timer))
                    else
                        bool_isTarget = true
                        _target:setString(math.abs( _toNum))
                        if _callback ~= nil then
                            _callback()
                        end
                end
            end
                    
        end
    end
  self.handler =  scheduler.scheduleGlobal(updateLabelNum , _duration )
end

function CCLabelChange:onEnter()
     print("enter")
end

function CCLabelChange:onExit()
    print(onExit)
    if self.handler ~= nil then
        scheduler.unscheduleGlobal(self.handler)
    end
end

return CCLabelChange