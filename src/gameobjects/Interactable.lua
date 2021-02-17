Interactable = Class{__includes = GameObject}

local animations = {}

function Interactable:Load()
    animations['button'] = function() return Animation(textures['ButtonCycles'], cycles['ButtonIndicator'], 0.15, 7, 7) end
    animations['up-arrow'] = function() return Animation(textures['ButtonCycles'], cycles['UpArrowIndicator'], 0.25, 9, 9) end
    animations['right-arrow'] = function() return Animation(textures['ButtonCycles'], cycles['SideArrowIndicator'], 0.25, 9, 9) end
    animations['down-arrow'] = animations['up-arrow']
    animations['left-arrow'] = animations['right-arrow']
    animations['side-door-right'] = function() return Animation(textures['SideDoor'], cycles['SideDoor'], 0, 31, 45) end
    animations['side-door-left'] = animations['side-door-right']
end

function Interactable:init(x, y, graphic, activationRadius, activationKey, activationFunction, activationParameters, resetTimeInFrames)
    GameObject.init(self, x, y)
    if graphic then
        self.animation = animations[graphic]()
        if     graphic == 'down-arrow' then self.flip = -1
        elseif graphic == 'left-arrow' or graphic == 'side-door-left' then self.direction = -1 end
    end
    self.alwaysVisible = false
    self.inRange = false
    self.isActive = true
    self.activationKey = activationKey or nil
    self.activationRadius = activationRadius or 50
    self.activationRadius = self.activationRadius^2
    self.activationFunction = activationFunction
    self.activationParameters = activationParameters
    self.viewableRadius = self.activationRadius
    self.keyDownIsOkay = false
    self.resetTime = resetTimeInFrames or -1
    self.resetTimer = 0
end

function Interactable:update()
    GameObject.update(self)
    self.resetTimer = self.resetTimer + 1
    local distanceToPlayer = dist2(player.pos, self.pos)
    if self.isActive and distanceToPlayer < self.activationRadius then
        if input.keysPressed[self.activationKey]
        or (input.keysDown[self.activationKey] and self.keyDownIsOkay) then
            self.isActive = false
            if self.activationFunction then self:activationFunction(self.activationParameters) end
            self.resetTimer = 0
        end
    end
    if distanceToPlayer < self.viewableRadius then
        self.inRange = true
    else self.inRange = false end
    if self.resetTimer == self.resetTime then
        self.isActive = true
    end
end

function Interactable:render()
    if self.alwaysVisible or (self.isActive and self.inRange) then
        GameObject.render(self)
    end
end