function globalToLocal(pos)
    return {x = pos.x - camera.pos.x, y = pos.y - camera.pos.y}
end

function globalToLocalX (pos)
    return pos.x - camera.pos.x
end

function globalToLocalY (pos)
    return pos.y - camera.pos.y
end

function dist2 (pointA, pointB)
    return (pointA.x - pointB.x)^2 + (pointA.y - pointB.y)^2
end

-- Returns a point on the line formed from A & B at a distance from A calculated as a given percentage of the distance between A and B
function interpolate (pointA, pointB, percent)
    return {
        x = pointA.x * (1-percent) + pointB.x * percent,
        y = pointA.y * (1-percent) + pointB.y * percent
    }
end

function offsetPoint (point, x, y)
    return {
        x = point.x + x,
        y = point.y + y
    }
end

function pseudoangle(dx, dy)   -- Uses the tan/cot functions to generate a pseudoangle from -1 to 7. See https://stackoverflow.com/a/27253590
    local diag  = dx >  dy  -- if true, angle must be from -135 to 45 degrees and vice versa. The name  diag refers to the  diagonal formed from y = x  (slope = /)
    local adiag = dx > -dy  -- if true, angle must be from -45 to 135 degrees and vice versa The name adiag refers to anti-diagonal formed from y = -x (slope = \)
    local angle = adiag and 0 or 4   -- Baseline to start (using dy=0 as reference), angle starts at either 0 or 180 degrees (0 or 4)
    if dy == 0 then return angle end -- If there is no dy, pseudoangle is already correct
    if diag ~= adiag then            -- There are four quadrants formed from the lines y=x and y=-x
         return angle - dx/dy + 2    -- If in top or bottom quadrant, sub cot (dx/dy) and add 2. (Quadrants are offset by a value of 2)
    else return angle + dy/dx end    -- If in left or right quadrant, add tan (dy/dx). No need to offset since angle starts in left or right quadrants already.
end

-- Returns a determinant that defines if two lines/rays/segments intersect. See https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection
function intersect(segment1, segment2)
    local x1, y1 = segment1[1].x, segment1[1].y
    local x2, y2 = segment1[2].x, segment1[2].y
    local x3, y3 = segment2[1].x, segment2[1].y
    local x4, y4 = segment2[2].x, segment2[2].y
    local denominator = ( (x1-x2)*(y3-y4) - (y1-y2)*(x3-x4) )
    local t = ( (x1-x3)*(y3-y4) - (y1-y3)*(x3-x4) )    /    denominator     -- Determinant for line 1
    local u = ( (x2-x1)*(y1-y3) - (y2-y1)*(x1-x3) )    /    denominator     -- Determinant for line 2
    return {t=t, u=u}
end

function interpolateSegment (segment, percent)
    return interpolate( segment[1], segment[2], percent )
end

function drawLine (pointA, pointB)
    love.graphics.line(
        globalToLocalX(pointA), globalToLocalY(pointA),
        globalToLocalX(pointB), globalToLocalY(pointB)
    )
end

function drawLineSegment(segment)
    love.graphics.line(
        globalToLocalX(segment[1]), globalToLocalY(segment[1]),
        globalToLocalX(segment[2]), globalToLocalY(segment[2])
    )
end

function drawColorLine (pointA, pointB, r, g, b, a)
    love.graphics.setColor(r or 0, g or 0, b or 0, a or 1)
    drawLine( pointA, pointB )
end

function drawCircle (pos, radius, mode)
    love.graphics.circle(more or 'fill', globalToLocalX(pos), globalToLocalY(pos), radius, radius)
end

function drawRectangle (pos, width, height, mode)
    love.graphics.rectangle(mode or 'fill', globalToLocalX(pos), globalToLocalY(pos), width, height)
end

function drawText (text, pos)
    love.graphics.print(text, globalToLocalX(pos), globalToLocalY(pos))
end