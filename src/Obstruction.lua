Obstruction = Class{__includes = GameObject}

function Obstruction:init(x, y, width, height)
    GameObject.init(self, x, y)
    self.size = {x = width, y = height}
    self.rayTraceFunctionTable = {
        [1] = Obstruction.lightIsToUpperLeft,
        [2] = Obstruction.lightIsToUpperMid,
        [3] = Obstruction.lightIsToUpperRight,
        [4] = Obstruction.lightIsToCenterLeft,
        [5] = Obstruction.lightIsInsideShape,
        [6] = Obstruction.lightIsToCenterRight,
        [7] = Obstruction.lightIsToLowerLeft,
        [8] = Obstruction.lightIsToLowerMid,
        [9] = Obstruction.lightIsToLowerRight
    }
end

function Obstruction:render()
    if input.keysDown['up']    then self.pos.y = self.pos.y - 1 end
    if input.keysDown['down']  then self.pos.y = self.pos.y + 1 end
    if input.keysDown['left']  then self.pos.x = self.pos.x - 1 end
    if input.keysDown['right'] then self.pos.x = self.pos.x + 1 end
    love.graphics.rectangle('fill', self.pos.x-camera.pos.x, self.pos.y-camera.pos.y, self.size.x, self.size.y)
end


function Obstruction:shadow(lightSource)
    local xPos = 2
    local yPos = 1
    local v1 = {x=self.pos.x-camera.pos.x, y=self.pos.y-camera.pos.y}
    local v2 = {x=lightSource.x-camera.pos.x, y=lightSource.y-camera.pos.y}
    if     v2.x > v1.x + self.size.x then xPos = 3
    elseif v2.x < v1.x then xPos = 1 end
    if     v2.y > v1.y + self.size.y then yPos = 2
    elseif v2.y < v1.y then yPos = 0 end

    local func = self.rayTraceFunctionTable[xPos+yPos*3]

    return func(v1, v2, self.size)
end

function rayTraceToEdge(v1, v2)
    local result = {x=0, y=0}
    local dx, dy = v1.x - v2.x, v1.y - v2.y
    local m = dy/dx
    if dx * dy ~= 0 then
        if dx < 0 then result.x = 0
        else result.x = VIRTUAL_WIDTH end
        result.y = m * (result.x - v2.x) + v2.y
        if result.y < 0 or result.y > VIRTUAL_HEIGHT then
            if dy < 0 then result.y = 0
            else result.y = VIRTUAL_HEIGHT end
            result.x = (result.y - v2.y) / m + v2.x
        end
    elseif dx == 0 then
        result.x = v2.x
        if dy < 0 then result.y = 0
        else result.y = VIRTUAL_HEIGHT end
    else
        result.y = v2.y
        if dx < 0 then result.x = 0
        else result.x = VIRTUAL_WIDTH end
    end

    return result
end

function Obstruction.lightIsToUpperLeft(v1, v2, size)
    print('a')
    local raytrace1 = rayTraceToEdge({x = v1.x + size.x, y = v1.y}, v2)
    local raytrace2 = rayTraceToEdge({x = v1.x,          y = v1.y + size.y}, v2)
    return {
        v1.x,           v1.y,
        v1.x + size.x,  v1.y,
        raytrace1.x,    raytrace1.y,
        VIRTUAL_WIDTH,  VIRTUAL_HEIGHT,
        raytrace2.x,    raytrace2.y,
        v1.x,           v1.y + size.y
    }
end

function Obstruction.lightIsToUpperMid(v1,v2,size)
    print('b')
    local raytrace1 = rayTraceToEdge({x = v1.x,          y = v1.y + size.y}, v2)
    local raytrace2 = rayTraceToEdge({x = v1.x + size.x, y = v1.y + size.y}, v2)
    return {
        v1.x,           v1.y,
        v1.x + size.x,  v1.y,
        raytrace1.x,    raytrace1.y,
        VIRTUAL_WIDTH,  VIRTUAL_HEIGHT,
        0,              VIRTUAL_HEIGHT,
        raytrace2.x,    raytrace2.y
    }
end

function Obstruction.lightIsToUpperRight(v1,v2,size)
    print('c')
    local raytrace1 = rayTraceToEdge({x = v1.x + size.x, y = v1.y + size.y},  v2)
    local raytrace2 = rayTraceToEdge(v1, v2)
    return {
        v1.x,           v1.y,
        v1.x + size.x,  v1.y,
        v1.x + size.x,  v1.y + size.y,
        raytrace1.x,    raytrace1.y,
        0,              VIRTUAL_HEIGHT,
        raytrace2.x,    raytrace2.y
    }
end

function Obstruction.lightIsToCenterRight(v1,v2,size)
    print('d')
    local raytrace1 = rayTraceToEdge({x = v1.x,          y = v1.y},          v2)
    local raytrace2 = rayTraceToEdge({x = v1.x,          y = v1.y + size.y}, v2)
    return {
        0,              0,
        raytrace1.x,    raytrace1.y,
        v1.x + size.x,  v1.y,
        v1.x + size.x,  v1.y + size.y,
        raytrace2.x,    raytrace2.y,
        0,              VIRTUAL_HEIGHT
    }
end

function Obstruction.lightIsToLowerRight(v1,v2,size)
    print('e')
    local raytrace1 = rayTraceToEdge({x = v1.x + size.x, y = v1.y},          v2)
    local raytrace2 = rayTraceToEdge({x = v1.x,          y = v1.y + size.y}, v2)
    return {
        0,              0,
        raytrace1.x,    raytrace1.y,
        v1.x + size.x,  v1.y,
        v1.x + size.x,  v1.y + size.y,
        v1.x,           v1.y + size.y,
        raytrace2.x,    raytrace2.y
    }
end

function Obstruction.lightIsToLowerMid(v1,v2,size)
    print('f')
    local raytrace1 = rayTraceToEdge(v1, v2)
    local raytrace2 = rayTraceToEdge({x = v1.x,          y = v1.y + size.y}, v2)
    print(raytrace2.x, raytrace2.y)
    return {
        0,              0,
        VIRTUAL_WIDTH,  0,
        raytrace2.x,    raytrace2.y,
        v1.x + size.x,  v1.y + size.y,
        v1.x,           v1.y + size.y,
        raytrace1.x,    raytrace1.y
    }
end

function Obstruction.lightIsToLowerLeft(v1,v2,size)
    print('g')
    local raytrace1 = rayTraceToEdge(v1, v2)
    local raytrace2 = rayTraceToEdge({x = v1.x + size.x, y = v1.y + size.y}, v2)
    return {
        v1.x,           v1.y,
        raytrace1.x,    raytrace1.y,
        VIRTUAL_WIDTH,  0,
        raytrace2.x,    raytrace2.y,
        v1.x + size.x,  v1.y + size.y,
        v1.x,           v1.y + size.y
    }
end

function Obstruction.lightIsToCenterLeft(v1,v2,size)
    print('h')
    local raytrace1 = rayTraceToEdge({x = v1.x + size.x, y = v1.y}, v2)
    local raytrace2 = rayTraceToEdge({x = v1.x + size.x, y = v1.y + size.y}, v2)
    return {
        v1.x,           v1.y,
        raytrace1.x,    raytrace1.y,
        VIRTUAL_WIDTH,  0,
        VIRTUAL_WIDTH,  VIRTUAL_HEIGHT,
        raytrace2.x,    raytrace2.y,
        v1.x,           v1.y + size.y
    }
end

function Obstruction:lightIsInsideShape(v1,v2,size)
    print('i')
    return {0,0,-1,0,-1,-1,0,-1}
end