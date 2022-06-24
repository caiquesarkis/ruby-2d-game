require 'ruby2d'

set title: "Asteroids"

class Asteroid < Circle
    def initialize (x, y, radius, sectors, color, z)
        super(x: x, y: y, radius: radius, sectors: sectors, color: color, z: z)
        @vx = 1
    end
    def vx 
        @vx
    end
end

class Player < Circle
    def initialize (x, y, radius, sectors, color, z)
        super(x: x, y: y, radius: radius, sectors: sectors, color: color, z: z)
        @vx = 1
        @vy = 1
    end
    def vx 
        @vx
    end
end


class Scene
    def initialize
        @asteroids = []
    end
    def asteroids
        @asteroids
    end
    def addAsteroid
        newcircle = Asteroid.new(
            rand(100) + 100,rand(100) + 100,
            50,
            32,
            'fuchsia',
            10
        )
        @asteroids.append(newcircle)
    end
end

def spawnAsteroid(scene)
    if rand() < 0.03
        scene.addAsteroid
    end
end




player = Player.new(
            rand(100) + 100, rand(100) + 100,
            25,
            32,
            'black',
            10
        )
scene = Scene.new

update do
    spawnAsteroid(scene)
    for asteroid in scene.asteroids
        asteroid.x += 1
    end
end

on :key do |event| 
    case event.key
    when "w"
        player.y -= 1        
    when "s"
        player.y += 1        
    when "a"
        player.x -= 1        
    when "d"
        player.x += 1        
    end
end

show