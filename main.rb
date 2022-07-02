require 'ruby2d'
require_relative 'GameObjects'

set title: "Asteroids", width: 1200, height: 650

asteroids = []

score = Text.new(
  0.to_s,
  x: 10, y: 10,
  size: 30,
  color: 'white',
  z: 10
)

def addAsteroid(asteroids)
    spawnRadius = Math.sqrt(Window.width**2 + Window.height**2)
    x = Window.width * rand
    y = Math.sqrt(spawnRadius**2 - x**2) + Window.height/2

    newcircle = GameObjects::Asteroid.new(
        x,y,
        20,
        32,
        'white',
        10
    )
    asteroids.append(newcircle)
end

player = GameObjects::Player.new(
            rand(100) + 100, rand(100) + 100,
            15,
            32,
            'blue',
            10
        )

update do
    if rand() < 0.01
        addAsteroid(asteroids)
    end

    bullets = player.bullets
    if(bullets.length > 0 && asteroids.length > 0)
        for i in 0..bullets.length - 1
            for j in 0..asteroids.length - 1
                if (bullets[i] != nil) && (asteroids[j] != nil)
                    if distance(bullets[i], asteroids[j]) < (bullets[i].radius + asteroids[j].radius)
                        asteroids[j].remove
                        bullets[i].remove
                        asteroids.delete(asteroids[j])
                        bullets.delete(bullets[i])

                        score.text = (score.text.to_i + 1).to_s
                    end
                end
            end

            if(bullets[i] != nil)
                if(bullets[i].x > Window.width)
                    bullets[i].remove
                    bullets.delete(bullets[i])
                end
            end
            if(bullets[i] != nil)
                if(bullets[i].x < 0)
                    bullets[i].remove
                    bullets.delete(bullets[i])
                end
            end
            if(bullets[i] != nil)
                if(bullets[i].y > Window.height)
                    bullets[i].remove
                    bullets.delete(bullets[i])
                end
            end
            if(bullets[i] != nil)
                if(bullets[i].y < 0)
                    bullets[i].remove
                    bullets.delete(bullets[i])
                end
            end
        end
    end
    
    player.update
    for asteroid in asteroids
        asteroid.update
    end
end

def distance(a, b)
    return Math.sqrt((a.x - b.x)**2 + (a.y - b.y)**2)
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