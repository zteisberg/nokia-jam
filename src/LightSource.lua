LightSource = Class{__includes = GameObject}

function LightSource:init(x, y, radius, falloff)
    GameObject.init(self, x or 0, y or 0)
    self.visible = true
    self.radius = radius             -- radius of light source
    self.falloff = falloff           -- measured in percent of radius
    self.rotation = 0                -- angle offset of the start of the lightsource
    self.angle = math.pi * 2         -- width of the light source arc in radians
    for i = #self.falloff + 1, 6 do  -- unfilled falloff values default to 100%
        self.falloff[i] = 1
    end
    self.frames = {self.calcPoints(self)}
    self.frame = 1
    self.frameTotal = 1
    self.frameToAnimate = 0
end

function LightSource:update(dt)
    if self.frameToAnimate > 0 and self.frameToAnimate < self.frameTotal then
        ::recheck::
        if self.animateFlag then
            if self.radius <= self.animateEnd then
                self.radius = self.radius + self.animateStep
                self.frames[#self.frames + 1] = self.calcPoints(self)
            else
                self.animateFlag = false
                goto recheck
            end
        else
            if self.radius >= self.animateStart then
                self.radius = self.radius - self.animateStep
                self.frames[#self.frames + 1] = self.calcPoints(self)
            else
                self.animateFlag = true
                goto recheck
            end
        end
        self.frameToAnimate = self.frameToAnimate + 1
    end


    if self.animate == 1 then
        if self.radius <= self.animateEnd then
            self.radius = self.radius + self.animateStep
            self.frames[#self.frames + 1] = self.calcPoints(self)
        end
    elseif self.animate == 2 then
        if self.radius >= self.animateStart then
            self.radius = self.radius - self.animateStep
            self.frames[#self.frames + 1] = self.calcPoints(self)
        else self.animate = 3 end
    end
    
    self.frame = self.frame % #self.frames + 1 
end

function LightSource:render()
    if self.visible then
        local translation = {}
        for i, point in pairs(self.frames[self.frame]) do
            if self.angle > math.pi or isInsideSector(point[1], point[2], self.angleVec1.x, self.angleVec1.y, self.angleVec2.x, self.angleVec2.y) then
                translation[#translation+1] = {
                    point[1] + self.pos.x - (self.relative and camera.pos.x or 0),
                    point[2] + self.pos.y - (self.relative and camera.pos.y or 0),
                }
            end
        end
        love.graphics.points(translation)
    end
end

function LightSource:shadows(osbstruction)
    love.graphics.polygon('fill',osbstruction:shadow(self.pos))
end

function LightSource:setTransform(x, y, angle, rotation)
    self.pos.x = x
    self.pos.y = y
    self.angle = angle
    self.rotation = rotation
end

function LightSource:setAngle(angle, rotation)
    self.rotation = rotation
    self.angle = angle
    self.calcVectors(self)
end

function LightSource:setRotation(rotation)
    self.rotation = rotation
    self.calcVectors(self)
end

function LightSource:setRadius(radius)
    self.radius = radius
    self.frames = {self.calcPoints(self)}
end

function LightSource:changeRadius(dr)
    self.radius = self.radius + dr
    if self.radius ~= math.floor( self.radius + 0.5) then
        self.frames = {self.calcPoints(self)}
    end
end

function LightSource:setAnimation(startSize,endSize,step)
    self.animateStep = step or 1
    self.animateStart = startSize or self.radius
    self.animateEnd = endSize or self.radius * 1.1
    self.animateFlag = true
    self.frameToAnimate = 1
    self.frameTotal = math.ceil((endSize - startSize) / self.animateStep)*2
    if self.radius < startSize then
        self.radius = startSize
        self.frames = {self.calcPoints(self)}
        self.animatePhase = true
    elseif self.radius > endSize then
        self.radius = self.endSize
        self.frames = {self.calcPoints(self)}
        self.animatePhase = false
    end
end

function areClockwise(v1_x, v1_y, v2_x, v2_y)
    return -v1_x*v2_y + v1_y*v2_x > 0
end

function isInsideSector(point_x, point_y, start_x, start_y, end_x, end_y)
    -- check if point is clockwise from the left side vector of the circle segment
    -- and counterclockwise from the right segment
    return (not areClockwise(start_x, start_y, point_x, point_y)) and areClockwise(end_x, end_y, point_x, point_y)
end

function LightSource:calcVectors()
    self.angleVec1 = {
        x = -100 * math.cos(self.rotation),
        y =  100 * math.sin(self.rotation),
    } 
    self.angleVec2 = { 
        x = -100 * math.cos(self.rotation+self.angle),
        y =  100 * math.sin(self.rotation+self.angle),
    }
end

-- There are seven different dithering styles. The table of falloff values
-- determines at what % of the radius to transition to the next one 
function LightSource:calcPoints()
    local points = {}
    local radius = math.floor( self.radius + 0.5)
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
        local x = -chord - (2-chord%2) + 1
        while x < chord do
            local distSqr = x^2 + y^2
            x = x + 1
            if distSqr > thresholds[6] then
                if y%4 > 0 then goto continue end
                x = x + 3
            elseif distSqr > thresholds[5] then
                if y%2 > 0 then goto continue end
                x = x + 1
            elseif distSqr > thresholds[1] then
                if y%2 + x%2 == 0 then 
                    x = x+1 
                end
                if (distSqr >= thresholds[3]) and (x+y)%2 == 0 then
                    x = x+1
                    if (distSqr >= thresholds[4]) and x%2 ~= y%2 then
                        x = x + 2
                    end
                elseif (distSqr >= thresholds[2]) and (x+y)%4 == 0 then
                    x = x+1
                end
            end
            points[#points+1] = {
                x,-- + self.pos.x - (self.relative and camera.pos.x or 0),
                y,-- + self.pos.y - (self.relative and camera.pos.y or 0),
            }
            ::continue::
        end
    end
    return points
end