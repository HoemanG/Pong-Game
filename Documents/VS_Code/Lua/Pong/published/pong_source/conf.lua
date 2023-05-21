function love.conf(t)
    t.window.title = "Pong Game"
    t._VERSION = "Alpha.69"
    t.console = false
    t.window.icon = "icon/icon.jpg"
    --t.window.borderless = true
    t.window.x = 1920/2 - 1280/2
    t.window.y = 1080/2 - 720/2
    t.timer = true --dùng khi thực sực biết
end