LightSource = Class{}

function LightSource:init(x,y,radius,falloff,angle,arc)
    self.x = x
    self.y = y
    self.radius = radius        -- radius of light source
    self.falloff = falloff      -- measured in percent of radius
    self.angle = angle or 0 -- angle offset of the start of the lightsource
    self.arc = arc or (math.pi * 2) -- width of the light source arc in radians
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

function areClockwise(v1_x, v1_y, v2_x, v2_y)
    return -v1_x*v2_y + v1_y*v2_x > 0
end

function isInsideSector(point_x, point_y, start_x, start_y, end_x, end_y)
    -- check if point is clockwise from the left side vector of the circle segment
    -- and counterclockwise from the right segment
    return (not areClockwise(start_x, start_y, point_x, point_y)) and areClockwise(end_x, end_y, point_x, point_y)
end

-- There are seven different dithering styles. The table of falloff values
-- determines at what % of the radius to transition to the next one 
function LightSource:calcPoints()

    self.points = {}
    local radius = math.floor( self.radius)
    local start_x = radius * math.cos(self.angle) * -1
    local end_x = radius * math.cos(self.angle + self.arc) * -1
    local start_y = (radius * math.sin(self.angle))
    local end_y = (radius * math.sin(self.angle + self.arc))
    local thresholds = {}
    for i = 1, #self.falloff do
        thresholds[i] = ( radius * self.falloff[i] )^2
    end
    
    -- loop through x and y values using (0,0) as origin
    local y = -radius
    while y < radius do
        y = y + 1

        -- Time saving: calculate chord length to reduce number of iterations
        local chord = math.floor(math.sqrt(radius^2-y^2)+0.5)
        local x = -chord
        x = x - (4-x%4) + 1 -- Standardize starting position of x-values
        while x < chord do
            local distSqr = x^2 + y^2
            x = x + 1
            if self.arc <= math.pi and not isInsideSector(x, y, start_x, start_y, end_x, end_y) then goto continue end
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