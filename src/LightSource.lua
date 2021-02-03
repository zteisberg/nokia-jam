LightSource = Class{}

function LightSource:init(x,y,radius,falloff)
    self.x = x
    self.y = y
    self.radius = radius        -- radius of light source
    self.falloff = falloff      -- measured in percent of radius
    for i = #falloff + 1, 7 do  -- unfilled falloff values default to 100%
        falloff[i] = 1
    end
    self.animate = false
    self.points = {}
    self:calcPoints()
end

function LightSource:update(dt)
    if self.animate then 
        if self.animatePhase then
            if self.radius <= self.animateEnd then
                self.radius = self.radius + self.animateStep
            else self.animatePhase = false end
        else
            if self.radius >= self.animateStart then
                self.radius = self.radius - self.animateStep
            else self.animatePhase = true end
        end
        self:calcPoints()
    end
        
end

function LightSource:render(dt)
    love.graphics.setColor(COLOR_LIGHT)
    love.graphics.points(self.points)
end

function LightSource:enableAnimation(startSize,endSize,step)
    self.animate = true
    self.animateStep = step or 0.25
    self.animateStart = startSize or radius
    self.animateEnd = endSize or radius + 20
    self.animatePhase = true
end

function LightSource:disableAnimation()
    self.animate = false
end

function LightSource:calcPoints()

    self.points = {}
    local radius = math.floor( self.radius)
    local thresholds = {}
    for i = 1, #self.falloff do
        thresholds[i] = ( radius * self.falloff[i] )^2
    end
    
    local y = -radius
    while y < radius do
        y = y + 1
        local chord = math.floor(math.sqrt(radius^2-y^2)+0.5)
        local x = -chord
        x = x - (4-x%4) + 1
        while x < chord do
            local distSqr = x^2 + y^2
            x = x + 1
            if distSqr > thresholds[7] then
                if y%4 > 0 then goto continue end
                x = x + 3
            elseif distSqr > thresholds[6] then
                if y%3 > 0 then goto continue end
                x = x + 2
            elseif distSqr > thresholds[5] then
                if y%2 > 0 then goto continue end
                x = x + 1
            elseif distSqr > thresholds[1] then
                if y%2 + x%2 == 0 then 
                    x = x+1 
                end
                if (distSqr >= thresholds[2]) and (x+y)%4 == 0 then
                    x = x+1
                elseif (distSqr >= thresholds[3]) and (x+y)%2 == 0 then
                    x = x+1
                    if (distSqr >= thresholds[4]) and x%2 ~= y%2 then
                        x = x + 2
                    end
                end
            end
            self.points[#self.points+1] = {self.x+x-globalX, self.y+y-globalY, 215/255, 240/255, 232/255}
            ::continue::
        end
    end
end