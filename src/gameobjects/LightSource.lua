LightSource = Class{__includes = GameObject}

local INTENSITY_MAP = {}

function LightSource:Load()
    for i = 0,8 do INTENSITY_MAP[i] = {} end
    for x = 0,7 do
        for i = 0,8 do INTENSITY_MAP[i][x] = {} end
        for y = 0,7 do
            INTENSITY_MAP[0][x][y] = true
            INTENSITY_MAP[1][x][y] = (y-x)%4 > 0 or (y+x)%4 > 0
            INTENSITY_MAP[2][x][y] = x%2 + y%2 > 0
            INTENSITY_MAP[3][x][y] = (x+y-2)%4 > 0 and (x-y)%4>0
            INTENSITY_MAP[4][x][y] = (x+y+1)%2 == 0
            INTENSITY_MAP[5][x][y] = (y+x+1)%4 == 0 or (y-x-1)%4==0
            INTENSITY_MAP[6][x][y] = (x+1)%2 + y%2 == 0
            INTENSITY_MAP[7][x][y] = (y-x-1)%4 == 0 and (y+x+1)%4 == 0
            INTENSITY_MAP[8][x][y] = (y-x-1)%8 == 0 and (y+x+1)%8 == 0
        end
    end
end
            

function LightSource:init(x, y, radius, falloff)
    GameObject.init(self, x or 0, y or 0)
    self.visible = true
    self.radius = radius             -- radius of light source
    self:setFalloff(falloff)         -- measured in percent of radius           
    self.rotation = 0                -- angle offset of the start of the lightsource
    self.angle = math.pi * 2         -- width of the light source arc in radians
end

function LightSource:update(dt)
    if self.animate then
        self:adjustRadius( self.animateStep * self.animateDirection )
        if     self.radius <= self.animateStart then self.animateDirection = 1
        elseif self.radius >= self.animateEnd   then self.animateDirection = -1 end
    end
end

function LightSource:render()
    if self.visible then
        local radius = math.floor(self.radius + 0.5)
        local points = {}
        local transition = {}
        for i = 1, #self.falloff do
            transition[i-1] = ( radius * self.falloff[i] )^2
        end

        for y = -radius, radius do
            local chord = math.floor(math.sqrt(radius^2 - y^2) + 0.5)
            for x = -chord, chord do
                if self.angle > math.pi or isInsideSector(x, y, self.angleVec1.x, self.angleVec1.y, self.angleVec2.x, self.angleVec2.y) then
                    local dist2 = x^2 + y^2
                    for i = 0, #INTENSITY_MAP do
                        if dist2 <= transition[i] then 
                            if INTENSITY_MAP[i][(x+self.pos.x)%8][(y+self.pos.y)%8] then
                                points[#points + 1] = x+self.pos.x-camera.pos.x
                                points[#points + 1] = y+self.pos.y-camera.pos.y end
                            break
                        end
                    end
                end
            end
        end
        love.graphics.points(points)
    end

end

function LightSource:shadows(osbstruction)
    love.graphics.polygon('fill',osbstruction:shadow(self.pos))
end

function LightSource:setAngle(angle, rotation)
    self.rotation = rotation or -angle/2
    self.angle = angle
    self.calcVectors(self)
end

function LightSource:setRotation(rotation)
    self.rotation = rotation
    self.calcVectors(self)
end

function LightSource:setFalloff(falloff)
    if type(falloff) == 'table' then self.falloff = falloff
    else self.falloff = {falloff} end

    if #self.falloff == 1 and self.falloff[1] < 1 then
        local step = (1 - self.falloff[1]) / #INTENSITY_MAP
        for i = 2, #INTENSITY_MAP + 1 do
            self.falloff[i] = self.falloff[i-1] + step end
    
    elseif #self.falloff == 2 and falloff[2] < 1 - falloff[1] then
        local step = falloff[2]
        for i = 2, #INTENSITY_MAP + 1 do
            self.falloff[i] = self.falloff[i-1] + step end
    
    else
        for i = #self.falloff + 1, #INTENSITY_MAP + 1 do  -- unfilled falloff values default to 100%
            self.falloff[i] = 1 end
    end
end

function LightSource:adjustRadius(amount)
    self.radius = self.radius + amount
end

function LightSource:setAnimation(startSize,endSize,step)
    self.animate = true
    self.animateStep = step or 1
    self.animateStart = startSize or self.radius
    self.animateEnd = endSize or self.radius * 1.1
    self.animateDirection = 1
    if self.radius < startSize then
        self.radius = startSize
    elseif self.radius > endSize then
        self.radius = self.endSize
        self.animateDirection = -1
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