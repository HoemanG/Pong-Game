class = require("class")

Paddle = class{}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.spd = 0 --tốc độ
end

--move the paddle  
function Paddle:update(dt)
    if self.spd < 0 then
        self.y = math.max(0, self.y + self.spd *dt)
        love.graphics.print("abcdefghi")
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.spd * dt)
    end
    --love.graphics.print("123456")
end

--render the paddle
function Paddle:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

