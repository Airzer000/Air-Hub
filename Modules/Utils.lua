local Utils = {}

function Utils.lerp(a, b, t)
    return a + (b - a) * t
end

function Utils.updateDrawings(FOVring, Cam, Settings)
    FOVring.Position = Cam.ViewportSize / 2
    FOVring.Radius = Settings.FOV
    FOVring.Visible = Settings.AimbotEnabled
end

return Utils
