Flashlight = Class{__includes = LightSource}

function Flashlight:init(angle)
    LightSource.init(self, -1000, -1000, 200, {.5,.55,.6,.65,.7,.75})
    LightSource.setAngle(self, angle, -angle/2)
end

function Flashlight:update()
    LightSource.setRotation(self, math.pi/2*(1 - player.direction) - self.angle/2 + player.angle * player.direction)
    self.pos = {
        x = player.pos.x + 11 * player.direction,
        y = player.pos.y - 8 - player.heightOffset[player.animation:getFrame()]
    }
end

function Flashlight:render()
    LightSource.render(self)
end

function Flashlight:calcVectors()
    LightSource.calcVectors(self)
end