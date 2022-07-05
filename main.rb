require 'ruby2d'
require_relative 'GameObjects'

set title: "Asteroids", width: 1200, height: 650, fullscreen: true, background: '#003C5F'

asteroids = []
ammos = []
speedBoosters = []

score = Text.new(
  0.to_s,
  x: 10, y: 10,
  size: 30,
  color: 'white',
  z: 10
)

def spawnAsteroid(asteroids)
    spawnRadius = Math.sqrt(Window.width**2 + Window.height**2)
    x = Window.width * rand
    y = Math.sqrt(spawnRadius**2 - x**2) + Window.height/2

    newcircle = GameObjects::Asteroid.new(
        x,y,
        15,
        32,
        [1, 0.5, 0.2, 0],
        10
    )
    asteroids.append(newcircle)
end

def spawnAmmo(ammo)
    x = rand(0..Window.width)
    y = rand(0..Window.height)
    newAmmo = GameObjects::Ammo.new(
        x, y,
        10,
        32,
        [1, 0.5, 0.2, 0],
        10
    )
    ammo.append(newAmmo)
end

def spawnSpeedBooster(speedBoosters)
    x = rand(0..Window.width)
    y = rand(0..Window.height)
    newSpeedBooster = GameObjects::SpeedBooster.new(
        x, y,
        10,
        32,
        [1, 0.5, 0.2, 0],
        10
    )
    speedBoosters.append(newSpeedBooster)
end

player = GameObjects::Player.new(
            rand(100) + 100, rand(100) + 100,
            20,
            32,
            [1, 0.5, 0.2, 0],
            10
        )

isGameOver = false
update do
    if !isGameOver
        if rand() < 0.01
            spawnAsteroid(asteroids)
        end
        if rand() < 0.003
            spawnAmmo(ammos)
        end

        if rand() < 0.002
            spawnSpeedBooster(speedBoosters)
        end

        for ammo in ammos
            if isColliding(player, ammo)
                player.ammo += ammo.quantity
                ammo.image.remove
                ammo.remove
                ammos.delete(ammo)
            end
        end

        for speedBooster in speedBoosters
            if isColliding(player, speedBooster)
                player.speed += speedBooster.boost
                speedBooster.image.remove
                speedBooster.remove
                speedBoosters.delete(speedBooster)
            end
        end

        bullets = player.bullets
        if(bullets.length > 0 && asteroids.length > 0)
            for i in 0..bullets.length - 1
                for j in 0..asteroids.length - 1
                    if (bullets[i] != nil) && (asteroids[j] != nil)
                        if isColliding(asteroids[j], bullets[i])
                            asteroids[j].image.remove
                            bullets[i].image.remove
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
            if(distance(asteroid, player) < (asteroid.radius + player.radius))
                isGameOver = true
                gameOverText = Text.new(
                    "Game Over",
                    size: 100,
                    color: 'gray',
                    z: 10
                )
                gameOverText.x = Window.width/2 - gameOverText.width/2
                gameOverText.y = Window.height/2 - gameOverText.height/2
                finalScore = Text.new(
                    "High Score: " + score.text,
                    size: 50,
                    color: 'white',
                    z: 10
                )
                finalScore.x = Window.width/2 - finalScore.width/2
                finalScore.y = Window.height/2 + 100
            end
            asteroid.update
        end
    end
end

def distance(a, b)
    return Math.sqrt((a.x - b.x)**2 + (a.y - b.y)**2)
end

    def isColliding(a, b)
        return (distance(a, b) < (a.radius + b.radius))? true : false
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