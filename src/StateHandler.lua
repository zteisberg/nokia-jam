StateHandler = Class{}

function StateHandler:init(gameStates)
    self.empty = {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end
    }
    self.state = self.empty
    self.stateName = ''
    self.stateGetFunction = {}
    self.stateStored = {}
    self.isPersistent = {}
end

function StateHandler:update()
    self.state:update()
end

function StateHandler:render()
    self.state:render()
end

function StateHandler:addState(name, getter, isPersistent)
    self.stateName = name
    self.stateGetFunction[name] = getter
    self.isPersistent[name] = isPersistent or false
end

function StateHandler:setState(name, parameters)
    if self.isPersistent[self.stateName] then 
        self.stateStored[self.stateName] = state 
    end
    self.state:exit()
    if self.isPersistent[name] and self.stateStored[self] then
         self.state = self.stateStored[name]
    else self.state = self.stateGetFunction[name]() end
    self.state:enter()
end

function StateHandler:resetState()
    self.state = self.stateGetFunction[self.stateName]()
end