Camera = Class{__includes = GameObject}

function Camera:init(x,y,speed, xMargin, yMargin)
    GameObject.init(self, x, y)
    self.speed = speed
    self.margin = {x=xMargin, y=yMargin}
    self.center = true
end

function Camera:update()

    local relativePos = {
        x = (player.pos.x - self.pos.x - self.margin.x) / (VIRTUAL_WIDTH - self.margin.x * 2),
        y = ((player.pos.y - self.pos.y - self.margin.y) / (VIRTUAL_HEIGHT - self.margin.y * 2) - 1) * 2
    }

    local d = {
        x = self.speed * (relativePos.x + (player.direction - 1) * .5),
        y = self.speed * (relativePos.y - player.angle / math.pi * 2)
    }

    if player.walking then
        self.pos.x = math.floor(self.pos.x + d.x + 0.5)
        player.pos.x = player.pos.x + player.direction

    elseif self.center then
        self.pos.x = math.floor(self.pos.x + d.x/2 + 0.5)
        if math.abs(d.x) <= 6 then self.center = false end
    end
    
    self.pos.y = math.floor(self.pos.y + d.y)
end


-- local relativePos = ((self.pos.y - CAMERA_MARGIN.y) / (VIRTUAL_HEIGHT - CAMERA_MARGIN.y * 2) - 1) * 2
-- local dy = math.ceil(CAMERA_SPEED * (relativePos - self.angle/math.pi*2))
-- self.pos.y = self.pos.y - dy
-- camera.y = camera.y - dy

function Camera:render()
    --do nothing
end