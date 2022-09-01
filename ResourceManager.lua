--[[ Included ]]--
local class = require("Script.Library.middleclass")



--[[ Class ]]--
local ResourceManager = class("ResourceManager")



--[[ Member Variables ]]--
local BlockResource = {
    Beige = nil,
    Blue = nil,
    Green = nil,
    Pink = nil,
    Yellow = nil,
}
local TileResource = nil



--[[ Member Methods ]]--
local LoadResource = function ()
    BlockResource.Beige = love.graphics.newImage("Data/Image/alienBeige_square.png")
    BlockResource.Blue = love.graphics.newImage("Data/Image/alienBlue_square.png")
    BlockResource.Green = love.graphics.newImage("Data/Image/alienGreen_square.png")
    BlockResource.Pink = love.graphics.newImage("Data/Image/alienPink_square.png")
    BlockResource.Yellow = love.graphics.newImage("Data/Image/alienYellow_square.png")

    TileResource = love.graphics.newImage("Data/Image/dirt.png")
end



--[[ Constructor ]]--
function ResourceManager:initialize()
    LoadResource()
end



--[[ Methods ]]--
function ResourceManager:GetBlockResource() return BlockResource end
function ResourceManager:GetTileResource() return TileResource end



return ResourceManager