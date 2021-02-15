Dad = Class{__includes = Player}

function Dad:init(x,y)
    local animations = {
        ['idle']         = Animation(textures['FatherCycles1'], cycles['DadIdle'],          0.25, 30, 31, 12, 30),
        ['idleFL']       = Animation(textures['FatherCycles1'], cycles['DadIdleFL'],        0.25, 30, 31, 12, 30),
        ['idleFL45']     = Animation(textures['FatherCycles2'], cycles['DadIdleFL45'],      0.25, 27, 31, 10, 30),
        ['idleFL90']     = Animation(textures['FatherCycles2'], cycles['DadIdleFL90'],      0.25, 27, 31, 10, 30),
        
        ['walk']         = Animation(textures['FatherCycles1'], cycles['DadWalk'],          0.5,  30, 31, 12, 30),
        ['walkFL']       = Animation(textures['FatherCycles1'], cycles['DadWalkFL'],        0.5,  30, 31, 12, 30),
        ['walkFL45']     = Animation(textures['FatherCycles2'], cycles['DadWalkFL45'],      0.5,  27, 31, 11, 30),
        ['walkFL90']     = Animation(textures['FatherCycles2'], cycles['DadWalkFL90'],      0.5,  27, 31, 12, 30),
        
        ['stairsEnter']  = Animation(textures['FatherCycles4'], cycles['DadStairsEnter'],   0.2, 21, 38, 10, 38),
        ['stairsExit']   = Animation(textures['FatherCycles4'], cycles['DadStairsExit'],    0.2, 21, 38, 10, 38),
        ['stairsExitFL'] = Animation(textures['FatherCycles4'], cycles['DadStairsExitFL'],  0.2, 21, 38, 10, 38),
        ['stairsUp']     = Animation(textures['FatherCycles3'], cycles['DadStairsUp'],      0.5,  53, 73, 15, 73),
        ['stairsUpFL']   = Animation(textures['FatherCycles3'], cycles['DadStairsUpFL'],    0.5,  53, 73, 15, 73),
        ['stairsDown']   = Animation(textures['FatherCycles3'], cycles['DadStairsDown'],    0.5,  53, 73, 15, 73),
        ['stairsDownFL'] = Animation(textures['FatherCycles3'], cycles['DadStairsDownFL'],  0.5,  53, 73, 15, 73),
    }

    local flashlightOffsets = {
        ['idleFL'] = {
            {10, 9}, {10, 9}, {10, 9}, 
            {10, 9}, {10, 9}, {10, 9}, 
            {10, 8}, {10, 8}, {10, 8},    
        },
        ['idleFL45'] = {
            {11, 11}, {11, 11}, {11, 11}, 
            {11, 11}, {11, 11}, {11, 11}, 
            {11, 10}, {11, 10}, {11, 10}, 
        },
        ['idleFL90'] = {
            {10, 18}, {10, 18}, {10, 18}, 
            {10, 18}, {10, 18}, {10, 18}, 
            {10, 17}, {10, 17}, {10, 17}, 
        },
        ['walkFL'] = {
            {10, 8}, {10, 8}, {10, 9}, {10, 8},
            {10, 8}, {10, 8}, {10, 9}, {10, 9},   
        },
        ['walkFL45'] = {
            {11, 10}, {11, 10}, {11, 11}, {11, 11}, 
            {11, 10}, {11, 11}, {11, 12}, {11, 12},
        },
        ['walkFL90'] = {
            {10, 18}, {10, 18}, {10, 19}, {10, 19},
            {10, 18}, {10, 19}, {10, 20}, {10, 19},
        },
        ['stairsEnter'] = {
            {-5, 9}, {-5, 11}, {-5, 13}
        },
        ['stairsExit'] = {
            {-5, 13}, {-5, 11}, {-5, 9}
        },
    }

    Player.init(self,x,y,animations,flashlightOffsets)
end

function Dad:update()
    Player.update(self)
    if self.state == 'walking' then
        if self.animation:getFrame() % 4 == 1 then
            SoundSystem.playIfQuiet('steps')
        end
    elseif self.state == 'stairs' then
        -- if self.animation:getFrame() % 2 == 0 then
        --     SoundSystem.playIfQuiet('interact')
        -- end
    end
end