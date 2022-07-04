require 'ruby2d'

module GameObjects
    class Asteroid < Circle
        def initialize (x, y, radius, sectors, color, z)
            super(x: x, y: y, radius: radius, sectors: sectors, color: color, z: z)
            @speed = 3
            randomVx = rand(-@speed..@speed)
            randomVy = rand(-@speed..@speed)
            @vy = randomVx != 0 ? randomVx : 1
            @vx = randomVy != 0 ? randomVy : 1
        end

        def update
            @x += @vx
            @y += @vy

            if(@x > Window.width)
                @x = 0
            end
            if(@x < 0)
                @x = Window.width
            end
            if(@y > Window.height)
                @y = 0
            end
            if(@y < 0)
                @y = Window.height
            end
        end
    end

    class Ammo < Circle
        attr_reader :quantity
        def initialize (x, y, radius, sectors, color, z)
            super(x: x, y: y, radius: radius, sectors: sectors, color: color, z: z)
            @quantity = rand(3..7)
        end
    end

    class SpeedBooster < Circle
        attr_reader :boost
        def initialize (x, y, radius, sectors, color, z)
            super(x: x, y: y, radius: radius, sectors: sectors, color: color, z: z)
            @boost = rand(0.1..0.5)
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
        attr_accessor :ammo
        attr_accessor :speed
        def initialize (x, y, radius, sectors, color, z)
            super(x: x, y: y, radius: radius, sectors: sectors, color: color, z: z)
            @speed = 4
            @aceleration = 0.3
            @vx = 0
            @vy = 0
            @friction = 0.95
            @health = 10
            @bullets = []
            @ammo = 5
        end

        def shootBullet(mouseX, mouseY)
            if(@ammo > 0)
                deltaVx = mouseX - @x
                deltaVy = mouseY - @y
                angle = Math.atan2( mouseY - @y, mouseX - @x )
                vx = Math.cos(angle)
                vy = Math.sin(angle)
                newBullet = Bullet.new(
                    @x, @y,
                    5,
                    32,
                    'white',
                    10,
                    vx,
                    vy 
                )
                @bullets.append(newBullet)
                @ammo -= 1
            end
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
                if @vy.abs <= @speed
                    @vy -= @aceleration
                end
            when "DOWN"
                if @vy.abs <= @speed
                    @vy += @aceleration
                end
            when "LEFT"
                if @vx.abs <= @speed
                    @vx -= @aceleration
                end
            when "RIGHT"
                if @vx.abs <= @speed
                    @vx += @aceleration
                end
            end
        end
    end
end