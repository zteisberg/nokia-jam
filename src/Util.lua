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

function interpolateSegment (segment, percent)
    return interpolate( segment[1], segment[2], percent )
end

function drawLine (pointA, pointB)
    love.graphics.line(
        globalToLocalX(pointA), globalToLocalY(pointA),
        globalToLocalX(pointB), globalToLocalY(pointB)
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