function love.conf(t)
    if package.config:sub(1,1) == "\\" then
        t.console = true
    else
        t.console = false
    end
    t.window.title = "uhhhhhhhhh game"
end 