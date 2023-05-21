require("love")
require("conf")
push = require("push")
class = require("class")
require("Ball")
require("Paddle")


WINDOW_HEIGHT = 720
WINDOW_WIDTH = 1280

VIRTUAL_HEIGHT = 500
VIRTUAL_WIDTH = 889

speed = 350

P1score = 0
P2score = 0

    --tạo object paddle1 và paddle2 từ file Paddle.lua có sẵn
paddle1 = Paddle(13, 60, 13, 52)
paddle2 = Paddle(VIRTUAL_WIDTH - 26, VIRTUAL_HEIGHT - 60, 13, 52)


function love.load()
    love.graphics.setBackgroundColor(248/255, 11/255, 255/255) -- chỉnh màu background
    love.graphics.setDefaultFilter("nearest", "nearest") --chỉnh filter thành "nearest"

    --[[   love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { 
        fullscreen = false,
        resizable = false,
        vsync = true,
   }) --]] --setmode cho màn hình đơn giản nhất, tạo màn hình 1280x720
    --tạo resolution ảo
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, 
    {
        resizable = false,
        fullscreen = false,
        vsync = true
    })

    --tạo object ball từ file Ball.lua có sẵn
    ball = Ball(VIRTUAL_WIDTH/2 - 8, VIRTUAL_HEIGHT/2 - 8, 16, 16)

    --tạo table (bản) âm thanh

    ssounds = {
        ["wall_hit"] = love.audio.newSource("sounds/wallhit.mp3", "static"),
        ["score"] = love.audio.newSource("sounds/score.mp3", "static"),
        ["paddle_hit"] = love.audio.newSource("sounds/paddlehit.mp3", "static"),
        ["win_game"] = love.audio.newSource("sounds/wingame.mp3", "static")
    }

    --thêm font mới 
    aNewFont = love.graphics.newFont("font/afont.ttf", 12)
    bNewFont = love.graphics.newFont("font/bfont.otf", 8)
    love.graphics.setFont(bNewFont)

    math.randomseed(os.time()) --tương tự srand(time(NULL)); trong C
    gstate = "Start" --gamestate

end

function love.update(dt)

    --di chuyển của paddle1 và paddle2
    if love.keyboard.isDown("w") then
        paddle1.spd = -speed
    elseif love.keyboard.isDown("s") then
        paddle1.spd = speed
    else 
        paddle1.spd = 0 
    end

    if love.keyboard.isDown("up") then
        paddle2.spd = -speed
    elseif love.keyboard.isDown("down") then
        paddle2.spd = speed
    else 
        paddle2.spd = 0 
    end

    if gstate == "Play" then 
        ball:update(dt) -- xem hàm trong Ball.lua
        if ball:collisions(paddle1) then
            ssounds["paddle_hit"]:play()
            ball.DeltaX = -ball.DeltaX * 1.05 --tăng tốc độ của ball lên 5%
            ball.X = paddle1.x + 13 --tạo cảm giác nhồi (giá trị cộng vào phải >= chiều rộng của paddle)
            if ball.DeltaY < 0 
            then
                ball.DeltaY = -math.random(10, 150)
            else 
                ball.DeltaY = math.random(10, 150)
            end
        end

        if ball:collisions(paddle2) then
            ssounds["paddle_hit"]:play()
            ball.DeltaX = -ball.DeltaX * 1.05 --tăng tốc độ của ball lên 5%
            ball.X = paddle2.x - 13 --tạo cảm giác nhồi (giá trị cộng vào phải >= chiều rộng của paddle)
            if ball.DeltaY < 0 
            then
                ball.DeltaY = -math.random(10, 150)
            else 
                ball.DeltaY = math.random(10, 150)
            end
        end

        if ball.Y < 0 then --tạo chuyển động nhồi trên và dưới
            ssounds["wall_hit"]:play()
            ball.y = 0 --tạo cảm giác nhồi
            ball.DeltaY = -ball.DeltaY
        elseif ball.Y + ball.height > VIRTUAL_HEIGHT then
            ssounds["wall_hit"]:play()
            ball.Y = VIRTUAL_HEIGHT - ball.height --tạo cảm giác nhồi
            ball.DeltaY = -ball.DeltaY
        end

    elseif gstate == "Start" then 
        ball:reset(dt)
    end

    if ball:winstate() == 2 then
        ssounds["score"]:play()
        ball:reset()
        gstate = "serving2" --P2 won
        P2score = P2score + 1
    elseif ball:winstate() == 1 then
        ball:reset()
        ssounds["score"]:play()
        gstate = "serving1" --P1 won
        P1score = P1score + 1
    end

    if P1score == 5 then
        gstate = "P1won"
    elseif P2score == 5 then
        gstate = "P2won"
    end

    paddle1:update(dt) -- xem hàm trong Paddle.lua
    paddle2:update(dt)
end

function love.draw()
    push:apply("start") -- bắt đầu render resolution ảo
    love.graphics.setFont(aNewFont) --chỉnh font thành aNewFont
    love.graphics.clear({248/255, 11/255, 255/255}, 0, 0) -- chỉnh màu background (lần 2, vẫn là 1 màu)
    ball:render() -- xem hàm trong Ball.lual
    paddle1:render() -- xem hàm trong Paddle.lua
    paddle2:render() -- xem hàm trong Paddle.lua

    love.graphics.print(tostring(P1score), VIRTUAL_WIDTH/2 - 100, 140, 0, 4, 4) -- hiển thị playerscore lên màn hình
    love.graphics.print(tostring(P2score), VIRTUAL_WIDTH/2 + 60, 140, 0, 4, 4)
    

    displayFPS() --display FPS
   
    if gstate == "serving1" then
        serve1()
    elseif gstate == "serving2" then
        serve2()
    end

    winning()

    push:apply("end") -- kết thúc render resolution ảo
end

function serve1()
    love.graphics.print("Player 2's serve, to the left", VIRTUAL_WIDTH/2 - 175, 60, 0, 2, 2)
end

function serve2()
    love.graphics.print("Player 1's serve, to the right", VIRTUAL_WIDTH/2 - 175, 60, 0, 2, 2)
end

function winning()
    if gstate == "P1won" then
        love.graphics.print("Player 1 won", VIRTUAL_WIDTH/2 - 90, 60, 0, 2, 2)
        ssounds["win_game"]:play()
    elseif gstate == "P2won" then
        love.graphics.print("Player 2 won", VIRTUAL_WIDTH/2 - 90, 60, 0, 2, 2)
        ssounds["win_game"]:play()
    end
end    

function love.keypressed(key)
    if key == "escape" then 
        love.event.quit() -- bấm escape để thoát
    end

    if key == "return" or key == "enter" then -- bấm enter (bên trái hoặc phải) để bắt đầu hoặc restart trò chơi
        ssounds["win_game"]:stop()
        if gstate == "Start" then
            gstate = "Play"
        elseif gstate == "serving2" then
            gstate = "Play"
            ball.DeltaX = 400
        elseif gstate == "serving1" then
            gstate = "Play"
            ball.DeltaX = -400
        elseif gstate == "Play" then
            gstate = "Start"
        elseif gstate == "P1won" then
            gstate = "Start"
            P1score = 0
            P2score = 0
        elseif gstate == "P2won" then
            gstate = "Start"
            P1score = 0
            P2score = 0
        end
    end
end


function displayFPS() --hàm
    love.graphics.setFont(aNewFont) --set font
    love.graphics.setColor(154, 255, 0, 1) --chỉnh màu
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 1, 1) -- hiển thị fps lên màn hình
    --love.graphics.print(gstate, 1, 1) --hiển thị gstate (gamestate)
    --love.timer.getFPS()
end


--Đã hoàn thành, mặc dù không phải là 1 chặng đường quá dài nhưng ít nhất chúng ta đã đi được bước đâu tiên <3