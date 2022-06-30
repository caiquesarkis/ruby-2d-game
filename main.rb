require 'ruby2d'
require_relative 'GameObjects'

set title: "Asteroids"

asteroids = []

def addAsteroid(asteroids)
    spawnRadius = Math.sqrt(Window.width**2 + Window.height**2)
    x = spawnRadius * Math.cos(3.14*rand) + Window.width/2
    y = spawnRadius * Math.sin(3.14*rand) + Window.height/2

    newcircle = GameObjects::Asteroid.new(
        x,y,
        20,
        32,
        'fuchsia',
        10
    )
    asteroids.append(newcircle)
end

player = GameObjects::Player.new(
            rand(100) + 100, rand(100) + 100,
            15,
            32,
            'white',
            10
        )

update do
    if rand() < 0.03
        addAsteroid(asteroids)
    end

    player.update
    for asteroid in asteroids
        asteroid.update
    end
end

on :key do |event| 
    case event.key
    when "w"
        player.move("UP")
    when "s"
        player.move("DOWN")
    when "a"
        player.move("LEFT")
    when "d"
        player.move("RIGHT")
    end
end

on :mouse_down do |event|
  case event.button
  when :left
    player.shootBullet(event.x, event.y)
  end
end

show