Interactable = Class{__includes = GameObject}

local animations = {}

function Interactable:Load()
    animations['button'] = Animation(textures['ButtonCycles'], cycles['ButtonIndicator'], 1, 7, 7)
    animations['up-arrow'] = Animation(textures['ButtonCycles'], cycles['UpArrowIndicator'], 0.25, 9, 9)
    animations['right-arrow'] = Animation(textures['ButtonCycles'], cycles['SideArrowIndicator'], 0.25, 9, 9)
    animations['down-arrow'] = animations['up-arrow']
    animations['left-arrow'] = animations['right-arrow']
end

function Interactable:init(x, y, icon, activationRadius, activationKey, activationFunction, activationParameters, resetTimeInFrames)
    GameObject.init(self, x, y)
    if icon then
        self.animation = animations[icon]
        if     icon == 'down-arrow' then self.flip = -1
        elseif icon == 'left-arrow' then self.direction = -1 end
    end
    self.inRange = false
    self.isActive = true
    self.activationKey = activationKey or nil
    self.activationRadius = activationRadius or 50
    self.activationRadius = self.activationRadius^2
    self.activationFunction = activationFunction
    self.activationParameters = activationParameters
    self.resetTime = resetTimeInFrames or -1
    self.resetTimer = 0
end

function Interactable:update()
    GameObject.update(self)
    self.resetTimer = self.resetTimer + 1
    if self.isActive and dist2(player.pos, self.pos) < self.activationRadius then
        if input.keysPressed[self.activationKey] then
            if self.activationFunction then self.activationFunction(self, self.activationParameters) end
            self.isActive = false
            self.resetTimer = 0
        end
        self.inRange = true
    else self.inRange = false end
    if self.resetTimer == self.resetTime then
        self.isActive = true
    end
end

function Interactable:render()
    if self.inRange then
        GameObject.render(self)
    end
end