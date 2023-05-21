class = require("class")
paddle = require("Paddle")
Ball = class{}

--[[
    The init function on our class is called just once,
    when the object is first created. 
    Used to set up all variables in the class and get it ready for use
]]--
function Ball:init(x, y, width, height, DeltaX, DeltaY)
    self.X = x
    self.Y = y
    self.width = width
    self.height = height
    self.DeltaX = math.random(2) == 1 and 400 or -400
    self.DeltaY = math.random(-100, 100)*2
end

--reset the Ball to the center of the screen
function Ball:reset(DeltaX, DeltaY)
    self.X = VIRTUAL_WIDTH/2 - 8
    self.Y = VIRTUAL_HEIGHT/2 - 8
-- math.random(num) ==SomeNum "and" ValueReturnedIfTrue "or" ValueReturnedIfFalse
    self.DeltaX = math.random(2) == 1 and 400 or -400
    self.DeltaY = math.random(-100, 100)*2
end

--check collisions
function Ball:collisions(paddle)
    --check collisions a the left and the right edge
        --nếu toạ độ x của ball > toạ độ x của padđle + chiều rộng paddle (bên trái)
            --Note: toạ độ của 1 hình dược tính từ góc trái trên của hình đó
        --nếu toạ độ x của ball + chiều rộng ball < toạ độ x của padđle (bên phải)
    if (self.X > paddle.x + paddle.width) or (self.X + self.width < paddle.x) then
        return false
    end
    
    --check collisions a the left and the right edge
        --nếu toạ độ y của ball > toạ độ y của padđle + chiều cao paddle (dưới)
        --nếu toạ độ y của ball + chiều cao ball  < toạ độ y của padđle (trên)
    if (self.Y > paddle.y + paddle.height) or (self.Y + self.height < paddle.y) then
        return false
    end

    return true

end

--move the Ball
function Ball:update(dt)
    self.X = self.X + self.DeltaX*dt
    self.Y = self.Y + self.DeltaY*dt
end

--render the Ball
function Ball:render()
    love.graphics.rectangle("fill", self.X, self.Y, self.width, self.height)
end

--reset the ball
function Ball:winstate()
    if self.X + self.width < 0 then
        return 2
    elseif self.X > VIRTUAL_WIDTH then
        return 1
    end
end