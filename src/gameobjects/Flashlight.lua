Flashlight = Class{__includes = LightSource}

function Flashlight:init(angle, distance)
    LightSource.init(self, -1000, -1000, distance, .5)
    LightSource.setAngle(self, angle, -angle/2)
end

function Flashlight:update()
    LightSource.setRotation(self, math.pi/2*(1 - player.direction) - self.angle/2 + player.angle * player.direction)
    self.pos = {
        x = player.pos.x + player:getFlashlightX() * player.direction - (player.direction-1)/2,
        y = player.pos.y - player:getFlashlightY()
    }
end

function Flashlight:render()
    LightSource.render(self)
end

function Flashlight:calcVectors()
    LightSource.calcVectors(self)
end