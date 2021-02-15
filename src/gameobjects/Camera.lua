Camera = Class{__includes = GameObject}

function Camera:init(x,y,speed, xMargin, yMargin)
    GameObject.init(self, x, y)
    self.speed = speed * (ZOOM_LEVEL/2 + 0.5)
    self.margin = {x=xMargin, y=yMargin}
    self.center = true
end

function Camera:update()

    local relativePos = {
        x = (player.pos.x - self.pos.x - self.margin.x) / (VIRTUAL_WIDTH - self.margin.x * 2),
        y = ((player.pos.y - self.pos.y - self.margin.y) / (VIRTUAL_HEIGHT - self.margin.y * 2) - 1) * 2
    }

    if toggleMouse then
        relativePos.x = relativePos.x + love.mouse.getX()/love.graphics.getWidth() - (player.direction + 1)/2
        relativePos.y = relativePos.y + love.mouse.getY()/love.graphics.getHeight()
    end

    local d = {
        x = self.speed * (relativePos.x + (player.direction - 1) * .5),
        y = self.speed * (relativePos.y - player.angle / VIRTUAL_HEIGHT * 30)
    }

    if self.center then
        d.x = d.x - self.speed/2 * player.direction
        if math.abs(1 - relativePos.x * 2) < 0.075 then self.center = false end
    end

    if player.state == 'walking' or toggleMouse or self.center then
        self.pos.x = math.floor(self.pos.x + d.x + 0.5)
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