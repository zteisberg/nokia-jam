Animation = Class{}

function Animation:init(source, cycle, speed, width, height, xOrigin, yOrigin)
    self.source = source
    self.cycle = cycle
    self.speed = speed
    self.frame = 1
    self.width = width
    self.height = height
    self.origin = {
        x = xOrigin or math.floor(self.width/2),
        y = yOrigin or math.floor(self.height/2)
    }
end

function Animation:update()
    self.frame = (self.frame + self.speed) % #self.cycle
end

function Animation:render(x, y, sx, sy)
    sx = sx or 1
    sy = sy or 1
    love.graphics.draw(
        self.source, self.cycle[math.floor(self.frame+1)],
        x, y, 0, sx, sy, self.origin.x, self.origin.y
    )
end