require 'ruby2d'

module GameObjects
    class Asteroid < Circle
        def initialize (x, y, radius, sectors, color, z)
            super(x: x, y: y, radius: radius, sectors: sectors, color: color, z: z)
            @vy = rand(-3..3) + rand(-0.1..0.1)
            @vx = rand(-3..3) + rand(-0.1..0.1)
        end

        def update
            @x += @vx
            @y += @vy

            if(@x > Window.width)
                @x -= Window.width
            end
            if(@x < 0)
                @x += Window.width
            end
            if(@y > Window.height)
                @y -= Window.height
            end
            if(@y < 0)
                @y += Window.height
            end
        end
    end

    class Bullet < Circle
        def initialize (x, y, radius, sectors, color, z, vx, vy)
            super(x: x, y: y, radius: radius, sectors: sectors, color: color, z: z)
            @speed = 10
            @vx = @speed * vx
            @vy = @speed * vy 
        end

        def update
            @x += @vx
            @y += @vy
        end
    end

    class Player < Circle
        attr_reader :bullets
        def initialize (x, y, radius, sectors, color, z)
            super(x: x, y: y, radius: radius, sectors: sectors, color: color, z: z)
            @speed = 4
            @vx = 0
            @vy = 0
            @friction = 0.9
            @health = 10
            @bullets = []
        end

        def shootBullet(mouseX, mouseY)
            deltaVx = mouseX - @x
            deltaVy = mouseY - @y
            angle = Math.atan2( mouseY - @y, mouseX - @x )
            vx = Math.cos(angle)
            vy = Math.sin(angle)
            newBullet = Bullet.new(
                @x, @y,
                5,
                32,
                'red',
                10,
                vx,
                vy 
            )
            @bullets.append(newBullet)
        end

        def update
            @x += @vx
            @y += @vy
            @vx *= @friction
            @vy *= @friction
            for bullet in @bullets
                bullet.update
            end
        end

        def move(direction)
            case direction
            when "UP"
                @vy = -@speed
            when "DOWN"
                @vy = @speed
            when "LEFT"
                @vx = -@speed
            when "RIGHT"
                @vx = @speed
            end
        end
    end
end