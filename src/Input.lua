Input = Class{}

function Input:init()
    self.keysPressed = {
        ['a'] = false,
        ['s'] = false,
        ['d'] = false,
        ['w'] = false,
        ['q'] = false,
        ['e'] = false,
        ['f5'] = false,
        ['f6'] = false,
        ['space'] = false,
    }
    self.keysReleased = {}
    self.keysDown = {}
    self.keysDownDuration = {}
    for key in pairs(self.keysPressed) do
        self.keysReleased[key] = false
        self.keysDown[key] = false
        self.keysDownDuration[key] = 0
    end
end

function Input:update()
    -- keysPressed only stays true for one frame
    for key in pairs(self.keysPressed) do
        self.keysPressed[key] = false
        self.keysReleased[key] = false
    end

    -- keysDown stays true the entire time the key is pressed down
    for key in pairs(self.keysDownDuration) do
        if self.keysDown[key] then
             self.keysDownDuration[key] = self.keysDownDuration[key] + 1
        else self.keysDownDuration[key] = 0 end
    end
end

function love.keypressed(key)
    if not input.keysDown[key] then
        input.keysPressed[key] = true
        input.keysDown[key] = true
    end
end

function love.keyreleased(key)
    input.keysDown[key] = false
    input.keysReleased[key] = true
end
