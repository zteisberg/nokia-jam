Raycaster = Class{__includes = GameObject}

function Raycaster:init(shapes)
    self.shapes, self.points, self.visible = {}, {}, {}
    for i, shape in pairs(shapes or {}) do self:addShape(shape, i) end
end

function Raycaster:addShape(shape, name)
    local index = name or #self.shapes + 1
    self.shapes[index] = shape
    shape[1].connectedPoints = {shape[#shape]}

    if #shape > 2 then
        for i = 1, #shape - 1 do
            self.points[#self.points + 1] = shape[i]
            shape[i].connectedPoints[2] = shape[i+1]
            shape[i+1].connectedPoints = {shape[i]}
        end
        shape[#shape].connectedPoints[2] = shape[1]
    else shape[#shape].connectedPoints = {shape[1]}
        self.points[#self.points + 1] = shape[1]
    end
    self.points[#self.points + 1] = shape[#shape]
end

function Raycaster:render(origin, debug)
    self:sortByAngle(origin)

    self.visible = {}
    local openSegments = {}
    local nearest, previous = nil, nil
    local pointD, pointC = nil, nil
    local minDistance = 1/0

    -- Do an initial sweep to determine the first obstacle at an angle of zero degrees from the origin
    for i, pointA in pairs(self.points) do
        for j, pointB in pairs(pointA.connectedPoints) do
            if pointA.angle < pointB.angle then
                local A = intersect({origin, {x=origin.x, y=origin.y-1}}, {pointA,pointB})
                if A.t > 0 and A.u > 0 and A.u < 1 then
                    openSegments[#openSegments + 1] = {pointA, pointB}
                    local intersection = interpolate( pointA, pointB, A.u )
                    local distance = dist2( intersection, origin )
                    if (distance < minDistance) then
                        minDistance = distance
                        previous = openSegments[#openSegments]
                    end
                end
            end
        end
    end

    -- love.graphics.setColor(0,1,0,.5)
    -- for k, segment in pairs(openSegments) do
    --     drawLine(pointA, pointB)
    -- end

    for i, pointA in pairs(self.points) do
        for j, pointB in pairs(pointA.connectedPoints) do
            if (pointA.angle < pointB.angle and pointA.angle > pointB.angle - math.pi) or pointA.angle > pointB.angle + math.pi then
                openSegments[#openSegments + 1] = {pointA, pointB}
                if toggleDebug and debug then
                    drawColorLine( pointA, pointB, i/#self.points, 0, 1-i/#self.points, 0.5 )
                end
            end
            -- print(i, #openSegments, math.floor(pointA.angle*180/math.pi), math.floor(pointB.angle*180/math.pi), action)
        end

        minDistance = 1/0
        nearest = nil
        local pointC, pointD, pointE = nil, nil, nil

        for k, segment in pairs(openSegments) do
            local A = intersect({origin, pointA}, segment)
            if A.t > 0 then
                local intersection = interpolateSegment(segment, A.u)
                if A.u > 0 and A.u < 1 then
                    local distance = dist2( intersection, origin )
                    if distance < minDistance then
                        minDistance = distance
                        nearest = segment
                        pointD = intersection
                    end
                elseif A.u == 0 then pointE = intersection
                elseif A.u == 1 then pointC = intersection end

                if toggleDebug and debug and A.u >= 0 and A.u <= 1 then
                    love.graphics.setColor(0,0,0,0.5)
                    drawCircle(intersection,4)
                    drawColorLine( origin, intersection, 1,1,1,0.2 ) 
                    -- print(i .. ':', math.floor(A.u*1000)/1000, previous == nearest)
                end
            end
        end

        -- if at the end of an endpoint of the nearest obstacle, add the endpoint to visible
        if pointC and dist2(pointC, origin) < minDistance then
            -- if #self.visible == 0 or (pointC.x ~= self.visible[#self.visible].x and pointC.y ~= self.visible[#self.visible].y) then
            self.visible[#self.visible+1] = pointC
            -- end

            if toggleDebug and debug then
                love.graphics.setColor(0.5,0,0,0.5)
                drawCircle(pointC,4)
            end
        end
        
        -- If the nearest raycasted point (not on an endpoint) is on a different segment than the last, add it to visible
        -- if nearest ~= previous then
            -- if #self.visible == 0 or (pointD.x ~= self.visible[#self.visible].x and pointD.y ~= self.visible[#self.visible].y) then
            self.visible[#self.visible+1] = pointD
            -- end
        -- end
        
        -- If at the start of an endpoint of the nearest obstacle, add the endpoint to visible
        if pointE and dist2(pointE, origin) < minDistance then
            -- if #self.visible == 0 or (pointE.x ~= self.visible[#self.visible].x and pointE.y ~= self.visible[#self.visible].y) then
            self.visible[#self.visible+1] = pointE
            -- end
            if toggleDebug and debug then
                love.graphics.setColor(0,0.5,0,0.5)
                drawCircle(pointE,4)
            end
        end

        -- Update which segment was last used to add to visible
        previous = nearest

        for j, pointB in pairs(pointA.connectedPoints) do
            if not (pointA.angle < pointB.angle and pointA.angle > pointB.angle - math.pi) and pointA.angle <= pointB.angle + math.pi then
                for k, segment in pairs(openSegments) do
                    if  (segment[1] == pointB or segment[2] == pointB)
                    and (segment[1] == pointA or segment[2] == pointA) then
                        table.remove(openSegments, k)
                    end
                end
            end
        end


        if toggleDebug and debug then
            love.graphics.setColor(0,0,1,0.5)
            drawText(i, pointA)
        end
    end

    for i = #self.visible, 2, -1 do
        if self.visible[i].x == self.visible[i-1].x and self.visible[i].y == self.visible[i-1].y then
            table.remove(self.visible, i)
        end
    end

    if toggleDebug and debug then
        for i, pt in pairs(self.visible) do
            love.graphics.setColor(0,1,0,.5)
            love.graphics.rectangle('fill', pt.x - camera.pos.x-1, pt.y - camera.pos.y-1, 2, 2)
            -- love.graphics.print(i, pt.x - camera.pos.x - 15, pt.y - camera.pos.y - 15)
        end
    end
    
    love.graphics.setColor(0,1,0,0.2)
    local source = {x = origin.x - camera.pos.x, y = origin.y - camera.pos.y}
    for i = 1, #self.visible-1 do
        love.graphics.polygon('fill', source.x, source.y,
        self.visible[i].x - camera.pos.x, self.visible[i].y - camera.pos.y,
        self.visible[i+1].x - camera.pos.x, self.visible[i+1].y - camera.pos.y
        )
    end
    
    love.graphics.polygon('fill', source.x, source.y,
    self.visible[1].x - camera.pos.x, self.visible[1].y - camera.pos.y,
        self.visible[#self.visible].x - camera.pos.x, self.visible[#self.visible].y - camera.pos.y
    )
end

function Raycaster:rerender(origin)
    local source = {x = origin.x - camera.pos.x, y = origin.y - camera.pos.y}
    for i = 1, #self.visible-1 do
        love.graphics.polygon('fill', source.x, source.y,
        self.visible[i].x - camera.pos.x, self.visible[i].y - camera.pos.y,
        self.visible[i+1].x - camera.pos.x, self.visible[i+1].y - camera.pos.y
        )
    end
    
    love.graphics.polygon('fill', source.x, source.y,
    self.visible[1].x - camera.pos.x, self.visible[1].y - camera.pos.y,
        self.visible[#self.visible].x - camera.pos.x, self.visible[#self.visible].y - camera.pos.y
    )
end


-- Sorts points around a given point by angle formed between them and 
function Raycaster:sortByAngle(origin) -- Using merge sort
    -- Table to collect sorting information

    -- Calculate psuedoangle for all points
    for i, point in pairs(self.points) do
        local dx = point.x - origin.x
        local dy = point.y - origin.y
        point.angle = (math.atan2(dx, dy) + math.pi) % (math.pi * 2)
    end

    -- Non-recursive merge sort. Less function calls = faster.
    local step = 2
    while step < #self.points*2 do
        local temp = {}
        for i = 1, #self.points, step do
            local a, b = i, i + math.floor(step/2)
            local end1 = math.min(#self.points+1, b)
            local end2 = math.min(#self.points+1, i+step)
            while a < end1 and b < end2 do
                if self.points[a].angle < self.points[b].angle then
                    temp[#temp+1] = self.points[a]
                    a = a + 1
                else
                    temp[#temp+1] = self.points[b]
                    b = b + 1
                end
            end
            for j = a, end1-1 do temp[#temp+1] = self.points[j] end
            for j = b, end2-1 do temp[#temp+1] = self.points[j] end
        end
        self.points = temp
        step = step * 2
    end
end



-- -- Returns true if a reference point is to the left of an infinite line formed using A & B
-- function leftOfSegment(ref, pointA, pointB)
--     return 0 > -- Calculates and returns sign of cross product
--         100 * (pointB.x - pointA.x) * (ref.y - pointA.y) -
--         100 * (pointB.y - pointA.y) * (ref.x - pointA.x)
-- end

-- -- Returns true if segment A is closer than segment B to a reference point
-- function nearestSegment(ref, pointA1, pointA2, pointB1, pointB2)
--     local A1 = leftOfSegment(interpolate(pointB1, pointB2, 0.01), pointA1, pointA2)
--     local A2 = leftOfSegment(interpolate(pointB2, pointB1, 0.01), pointA1, pointA2)
--     local A3 = leftOfSegment(ref, pointA1, pointA2)
--     local B1 = leftOfSegment(interpolate(pointB1, pointB2, 0.01), pointA1, pointA2)
--     local B2 = leftOfSegment(interpolate(pointB2, pointB1, 0.01), pointA1, pointA2)
--     local B3 = leftOfSegment(ref, pointA1, pointA2)
--     if B1 == B2 and B2 ~= B3 then return true end
--     if A1 == A2 then
--         if A2 == A3 then return true
--         else return false end end
--     if B1 == B2 then return false end
-- end