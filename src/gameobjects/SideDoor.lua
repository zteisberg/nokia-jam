SideDoor = Class{__includes = Interactable}

function SideDoor:init(x, y, orientation)
    if orientation == 'right' then orientation = 'side-door-right'
    elseif orientation == 'left' then orientation = 'side-door-left' end
    Interactable.init(self, x, y, orientation, 30, 'z', SideDoor.use)
    self.open = false
    self.wall = nil
    self.uiButton = nil
    self.alwaysVisible = true
    self.animation.frame = 0
end

function SideDoor:update()
    Interactable.update(self)
    if self.uiButton then self.uiButton.inRange = self.inRange end
    if self.wall and self.animation.speed > 0 then
        local direction = (self.pos.x - player.pos.x > 0) and 1 or -1
        for i, pt in pairs(self.wall) do
            pt.x = self.pos.x + self.animation.frame * 20 * direction
        end
    end
    if not self.open and self.inRange then
        local dx = self.pos.x - player.pos.x
        if dx > 0 and dx < 10 then
            player.pos.x = self.pos.x - 10
        elseif dx < 0 and dx > -10 then
            player.pos.x = self.pos.x + 10
        end
    end
end

function SideDoor.use(target)
    target.animation.speed = 0.5
    if target.open then
        target.animation.reverse = true
        SoundSystem.queue('close_door')
        if target.wall then 
            for i, pt in pairs(target.wall) do pt.y = pt.y - 1000 end
        end
    else
        target.animation.reverse = false
        SoundSystem.queue('open_door')
    end
    if target.uiButton then target.uiButton.isActive = false end
    target.open = not target.open
    target.animation.callback = function()
        if target.uiButton then target.uiButton.isActive = true end
        target.isActive = true
        target.animation.speed = 0
        if target.open then target.animation.frame = 4
        else target.animation.frame = 0 end

        if target.wall and target.open then 
            for i, pt in pairs(target.wall) do pt.y = pt.y + 1000 end
        end
    end
end