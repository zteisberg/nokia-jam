SoundSystem = Class{}

local queuedSounds = {}

function SoundSystem:Load()
    sounds = {
        ['interact'] = love.audio.newSource('assets/sounds/interact.wav', 'static'),
        ['low_scream'] = love.audio.newSource('assets/sounds/low_scream.wav', 'static'),
        ['high_scream'] = love.audio.newSource('assets/sounds/high_scream.wav', 'static'),
        ['close_door'] = love.audio.newSource('assets/sounds/close_door.wav', 'static'),
        ['open_door'] = love.audio.newSource('assets/sounds/open_door.wav', 'static'),
        ['steps'] = love.audio.newSource('assets/sounds/steps.wav', 'static'),
        ['win'] = love.audio.newSource('assets/sounds/win.wav', 'static'),
        ['turn_on_flashlight'] = love.audio.newSource('assets/sounds/turn_on_flashlight.wav', 'static')
    }
end
function SoundSystem.play(sound)
    love.audio.stop()
    love.audio.play(sounds[sound])
end

function SoundSystem.playIfQuiet(sound)
    if love.audio.getActiveSourceCount() == 0 then
        SoundSystem.play(sound)
    end
end

function SoundSystem.queue(sound)
    queuedSounds[#queuedSounds + 1] = sound
end

function SoundSystem.update()
    if #queuedSounds > 0 and love.audio.getActiveSourceCount() == 0 then
        SoundSystem.play(table.remove(queuedSounds,1))
    end
end