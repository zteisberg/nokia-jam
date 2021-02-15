Raycaster = Class{__includes = GameObject}

function Raycaster:init(shapes)
    self.shapes, self.points = {}, {}
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

function Raycaster:render(origin)
    self:sortByAngle(origin)

    local visible = {}
    local openSegments = {}
    local nearest, previous = nil, nil
    local pointD, pointC = nil, nil
    local minDistance = 1/0

    -- Do an initial sweep to determine the first obstacle at an angle of zero degrees from the origin
    for i, pointA in pairs(self.points) do
        for j, pointB in pairs(pointA.connectedPoints) do
            if pointA.angle < pointB.angle then
                local A = self:raycast({origin, {x=origin.x+1, y=origin.y}}, {pointA,pointB})
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
            if (pointA.angle < pointB.angle and pointA.angle > pointB.angle - 4) or pointA.angle > pointB.angle + 4 then
                openSegments[#openSegments + 1] = {pointA, pointB}
                if toggleDebug then
                    drawColorLine( pointA, pointB, i/#self.points, 0, 1-i/#self.points, 0.5 )
                end
            end
            -- print(i, #openSegments, math.floor(pointA.angle*10)/10, math.floor(pointB.angle*10)/10, action)
        end

        minDistance = 1/0
        nearest = nil
        local pointC, pointD, pointE = nil, nil, nil

        for k, segment in pairs(openSegments) do
            local A = self:raycast({origin, pointA}, segment)
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

                if toggleDebug and A.u >= 0 and A.u <= 1 then
                    love.graphics.setColor(0,0,0,0.5)
                    drawCircle(intersection,4)
                    drawColorLine( origin, intersection, 1,1,1,0.2 ) 
                    -- print(i .. ':', math.floor(A.u*1000)/1000, previous == nearest)
                end
            end
        end

        -- if at the end of an endpoint of the nearest obstacle, add the endpoint to visible
        if pointC and dist2(pointC, origin) <= minDistance then
            -- if #visible == 0 or (pointC.x ~= visible[#visible].x and pointC.y ~= visible[#visible].y) then
                visible[#visible+1] = pointC
            -- end

            if toggleDebug then
                love.graphics.setColor(0.5,0,0,0.5)
                drawCircle(pointC,4)
            end
        end
        
        -- If the nearest raycasted point (not on an endpoint) is on a different segment than the last, add it to visible
        -- if nearest ~= previous then
            -- if #visible == 0 or (pointD.x ~= visible[#visible].x and pointD.y ~= visible[#visible].y) then
                visible[#visible+1] = pointD
            -- end
        -- end
        
        -- If at the start of an endpoint of the nearest obstacle, add the endpoint to visible
        if pointE and dist2(pointE, origin) <= minDistance then
            -- if #visible == 0 or (pointE.x ~= visible[#visible].x and pointE.y ~= visible[#visible].y) then
                visible[#visible+1] = pointE
            -- end
            if toggleDebug then
                love.graphics.setColor(0,0.5,0,0.5)
                drawCircle(pointE,4)
            end
        end

        -- Update which segment was last used to add to visible
        previous = nearest

        for j, pointB in pairs(pointA.connectedPoints) do
        --- if (pointA.angle < pointB.angle and pointA.angle > pointB.angle - 4) or pointA.angle > pointB.angle + 4 then
            if not (pointA.angle < pointB.angle and pointA.angle > pointB.angle - 4) and pointA.angle <= pointB.angle + 4 then
                for k, segment in pairs(openSegments) do
                    if  (segment[1] == pointB or segment[2] == pointB)
                    and (segment[1] == pointA or segment[2] == pointA) then
                        table.remove(openSegments, k)
                    end
                end
            end
        end


        if toggleDebug then
            love.graphics.setColor(0,0,1,0.5)
            drawText(i, pointA)
        end
    end

    for i = #visible, 2, -1 do
        if visible[i].x == visible[i-1].x and visible[i].y == visible[i-1].y then
            table.remove(visible, i)
        end
    end

    if toggleDebug then
        for i, pt in pairs(visible) do
            love.graphics.setColor(0,1,0,.5)
            love.graphics.rectangle('fill', pt.x - camera.pos.x-1, pt.y - camera.pos.y-1, 2, 2)
            love.graphics.print(i, pt.x - camera.pos.x - 15, pt.y - camera.pos.y - 15)
        end
    end
    
    love.graphics.setColor(0,1,0,0.2)
    local source = {x = origin.x - camera.pos.x, y = origin.y - camera.pos.y}
    for i = 1, #visible-1 do
        love.graphics.polygon('fill', source.x, source.y,
            visible[i].x - camera.pos.x, visible[i].y - camera.pos.y,
            visible[i+1].x - camera.pos.x, visible[i+1].y - camera.pos.y
        )
    end
    
    love.graphics.polygon('fill', source.x, source.y,
        visible[1].x - camera.pos.x, visible[1].y - camera.pos.y,
        visible[#visible].x - camera.pos.x, visible[#visible].y - camera.pos.y
    )
end

-- Sorts points around a given point by angle formed between them and 
function Raycaster:sortByAngle(origin) -- Using merge sort
    -- Table to collect sorting information

    -- Calculate psuedoangle for all points
    for i, point in pairs(self.points) do
        local dx = point.x - origin.x
        local dy = point.y - origin.y
        point.angle = self:pseudoangle(dx, dy) % 8
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

function Raycaster:pseudoangle(dx, dy)   -- Uses the tan/cot functions to generate a pseudoangle from -1 to 7. See https://stackoverflow.com/a/27253590
    local diag  = dx >  dy  -- if true, angle must be from -135 to 45 degrees and vice versa. The name  diag refers to the  diagonal formed from y = x  (slope = /)
    local adiag = dx > -dy  -- if true, angle must be from -45 to 135 degrees and vice versa The name adiag refers to anti-diagonal formed from y = -x (slope = \)
    local angle = adiag and 0 or 4   -- Baseline to start (using dy=0 as reference), angle starts at either 0 or 180 degrees (0 or 4)
    if dy == 0 then return angle end -- If there is no dy, pseudoangle is already correct
    if diag ~= adiag then            -- There are four quadrants formed from the lines y=x and y=-x
         return angle - dx/dy + 2    -- If in top or bottom quadrant, sub cot (dx/dy) and add 2. (Quadrants are offset by a value of 2)
    else return angle + dy/dx end    -- If in left or right quadrant, add tan (dy/dx). No need to offset since angle starts in left or right quadrants already.
end

-- Returns a determinant that defines if two lines/rays/segments intersect. See https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection
function Raycaster:raycast(segment1, segment2)
    local x1, y1 = segment1[1].x, segment1[1].y
    local x2, y2 = segment1[2].x, segment1[2].y
    local x3, y3 = segment2[1].x, segment2[1].y
    local x4, y4 = segment2[2].x, segment2[2].y
    local denominator = ( (x1-x2)*(y3-y4) - (y1-y2)*(x3-x4) )
    local t = ( (x1-x3)*(y3-y4) - (y1-y3)*(x3-x4) )    /    denominator     -- Determinant for line 1
    local u = ( (x2-x1)*(y1-y3) - (y2-y1)*(x1-x3) )    /    denominator     -- Determinant for line 2
    return {t=t, u=u}
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