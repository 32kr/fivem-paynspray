---@class PayNSprayLocation
---@field x number
---@field y number
---@field z number

---@class PayNSprayConfig
---@field Locations PayNSprayLocation[]
---@field RepairPrice number
---@field DrawDistance number

---@type PayNSprayConfig
PayNSpray = {
    Locations = {
        { x = -211.55, y = -1324.55, z = 30.89 }, -- LS Customs
        { x = 1174.92, y = 2640.46, z = 37.75 },  -- Sandy Shores
    },
    RepairPrice = 500, -- Price to repair the vehicles
    DrawDistance = 4.0 --  Distance to draw the marker
}