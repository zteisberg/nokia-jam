Battery = Class{__includes = GameObject}

function Battery:init(x,y,active,globalPositioning)
    GameObject.init(self,x,y,active,globalPositioning)
    self.source = textures['ButtonCycles']
    self.cycle = cycles['BatteryPower']
    self.pos = {x=x, y=y}
    self.charge = 15 * 30
end

function Battery:update()
    GameObject.update(self)
end

function Battery:render()
    battery_charge = 6 - math.ceil(self.charge / (6*15))
    if self.charge <= 15 and self.charge > 0 then
        lightSources['flashlight'].visible = currentFrameCycle % 3 == 0
    end
    love.graphics.draw(
        self.source, self.cycle[battery_charge],
        self.pos.x, self.pos.y, 0, 1, 1, 0, 0
    )
end