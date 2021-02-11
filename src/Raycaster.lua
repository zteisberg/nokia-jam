Raycaster = Class{__includes = GameObject}

function Raycaster:init(shapes)
    self.shapes, self.segments, self.points = {}, {}, {}
    for i, shape in pairs(shapes) do self:addShape(shape) end
end

function Raycaster:addShape(shape)
    self.shapes[#self.shapes + 1] = shape
    for i = 1, #shape - 1 do
        self.segments[#self.segments + 1] = {shape[i], shape[i+1]}
        self.points[#self.points + 1] = shape[i]
    end
    self.segments[#self.segments + 1] = {shape.x, shape[#shape]}
    self.points[#self.points + 1] = shape[#shape]
end

function Raycaster:render(origin)
    self:sortByAngle(origin)
    for i, point in pairs(self.points) do
        love.graphics.setColor(i/10,0,1-i/10,1)
        love.graphics.line(origin.x - camera.pos.x, origin.y - camera.pos.y, point.x - camera.pos.x, point.y - camera.pos.y)
    end
end

-- Sorts points around a given point by angle formed between them and 
function Raycaster:sortByAngle(origin) -- Using merge sort
    -- Table to collect sorting information
    local points = {}

    -- Sorts using raw tan value (y/x), split into x>0, x<0, and x=0
    for i, point in pairs(self.points) do
        local m = 0
        local dx = point.x - origin.x
        local dy = point.y - origin.y
        local sort = -math.abs(dx)/dx % 4     
        
        -- if x=0, split into y>0 and y<0, where y=0 is casted as y<0.
        if  sort ~= sort then           
            sort = -math.abs(dy)/dy % 4 - 1 
            if  sort ~= sort then 
                sort = 2
                dy = -1
            end
        else m = dy/dx end

        points[#points + 1] = {
            q = sort,               -- First method of sorting
            slope = m,               -- Second method of sorting
            ref = point             -- Ref to original x,y point
        }
    end

    -- Function to compare using sorting values. True means v1 < v2 angle.
    function compare(p1,p2)
        if     p1.q > p2.q then return true
        elseif p1.q < p2.q then return false
        else return p1.slope < p2.slope end
    end

    -- Non-recursive merge sort. Less function calls = faster.
    local step = 2
    while step < #points*2 do
        local temp = {}
        for i = 1, #points, step do
            local a, b = i, i + math.floor(step/2)
            local end1 = math.min(#points+1, b)
            local end2 = math.min(#points+1, i+step)
            while a < end1 and b < end2 do
                if compare(points[a],points[b]) then
                    temp[#temp+1] = points[a]
                    a = a + 1
                else
                    temp[#temp+1] = points[b]
                    b = b + 1
                end
            end
            for j = a, end1-1 do temp[#temp+1] = points[j] end
            for j = b, end2-1 do temp[#temp+1] = points[j] end
        end
        points = temp
        step = step * 2
    end

    for i, point in pairs(points) do
        self.points[i] = point.ref
        self.points[i].slope = point.slope
    end
end
