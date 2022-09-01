--[[ Included ]]--
local ResourceManager = require("ResourceManager")
local WindField = require("Script.Library.windfield")
local Camera = require("Script.Library.hump.camera")



--[[ Variables ]]--
local ResourceMgr = ResourceManager()
local BlockResource = nil
local TileResource = nil

local GameCamera = nil
local GameCollision = nil
local GroundCollider = nil
local CollisionCount = 0

local Block = {}
local Score = 0



--[[ Functions ]]--
local AddNewBlock = function ()
    local tempBlock = {
        X = 50,
        Speed = 300,
        IsFall = false,
    }

    if (#Block == 0) then
        tempBlock.Y = (ConfigMgr.window.height/2 + 70)
    else
        tempBlock.Y = (Block[#Block].Y) - 150
    end

    local rand = love.math.random(0, 4)
    if (rand == 0) then tempBlock.Image = BlockResource.Beige 
    elseif (rand == 1) then tempBlock.Image = BlockResource.Blue
    elseif (rand == 2) then tempBlock.Image = BlockResource.Green
    elseif (rand == 3) then tempBlock.Image = BlockResource.Pink
    elseif (rand == 4) then tempBlock.Image = BlockResource.Yellow
    else tempBlock.Image = nil end

    tempBlock.Collider = GameCollision:newRectangleCollider(tempBlock.X, tempBlock.Y, tempBlock.Image:getWidth(), tempBlock.Image:getHeight())
    tempBlock.Collider:setCollisionClass("Block")
    tempBlock.Collider:setGravityScale(0)
    tempBlock.Collider:setRestitution(0)
    -- tempBlock.Collider:setInertia(0)
    -- tempBlock.Collider:setMass(0)

    table.insert(Block, tempBlock)
end



--[[ Callbacks ]]--
function love.load()
    -- 폰트 크기 설정
    love.graphics.setNewFont(30)

    -- 리소스 불러오기
    BlockResource = ResourceMgr:GetBlockResource()
    TileResource = ResourceMgr:GetTileResource()

    -- 카메라
    GameCamera = Camera()

    -- 충돌
    GameCollision = WindField.newWorld(0, 0)
    GameCollision:setGravity(0, 384)
    GameCollision:addCollisionClass("Ground")
    GameCollision:addCollisionClass("Block")

    GroundCollider = GameCollision:newLineCollider(0, (ConfigMgr.window.height - TileResource:getHeight()), ConfigMgr.window.width, (ConfigMgr.window.height - TileResource:getHeight()))
    GroundCollider:setCollisionClass("Ground")
    GroundCollider:setType("static")
end

function love.update(dt)
    GameCollision:update(dt)

    -- 초기 블럭 생성
    if (#Block == 0) then
        AddNewBlock()
    end

    -- 게임 로직
    if (CollisionCount < 2) then
        for i=1, #Block do
            -- 땅에 닿았을 때
            if (Block[i].Collider:enter("Ground")) then
                CollisionCount = CollisionCount + 1

                if (CollisionCount == 2) then
                    return;
                else
                    AddNewBlock()
                    Score = Score + 1
                end
            end

            -- 블럭에 닿았을 때
            local CurrentBlock = #Block
            if (Block[CurrentBlock].Collider:enter("Block")) then
                AddNewBlock();
                Score = Score + 1
            end

            -- 블럭 좌우 움직이기
            if (Block[i].IsFall == true) then
                if (Block[i].Collider:enter("Block")) then
                    
                else
                    Block[i].Collider:setLinearVelocity(0, Block[i].Speed)
                end
            else
                if (Block[i].X <= 50) then Block[i].Collider:setLinearVelocity(Block[i].Speed + Score, 0) end
                if ((Block[i].X + Block[i].Image:getWidth()) >= (ConfigMgr.window.width)) then Block[i].Collider:setLinearVelocity(-Block[i].Speed - Score, 0) end
            end

            -- 좌표 반영
            Block[i].X, Block[i].Y = Block[i].Collider:getPosition()

            if (#Block > 1) then
                GameCamera:lookAt(ConfigMgr.window.width/2, Block[CurrentBlock].Y - (Block[CurrentBlock].Image:getHeight()/2))
            else
                GameCamera:lookAt(ConfigMgr.window.width/2, ConfigMgr.window.height/2)
            end
        end
    end
end

function love.draw()
    -- 배경색
    love.graphics.setBackgroundColor(195/255, 235/255, 240/255)
 
    GameCamera:draw(function ()
        -- 바닥
        for i=1, math.ceil(ConfigMgr.window.width / TileResource:getWidth()) do
            love.graphics.draw(TileResource, 0 + ((i-1) * TileResource:getWidth()), (ConfigMgr.window.height - TileResource:getHeight()))
        end
        
        -- 블럭
        for i=1, #Block do
            love.graphics.draw(Block[i].Image, Block[i].X - (Block[i].Image:getWidth() / 2), Block[i].Y - (Block[i].Image:getHeight() / 2))
        end
    
        GameCollision:draw()
    end)

    -- 점수
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(tostring(Score), 0, 50, ConfigMgr.window.width, "center")
    love.graphics.setColor(1, 1, 1, 1)
end

function love.keypressed(key)
    if (key == "space") then
        for i=1, #Block do
            if (Block[i].IsFall == false) then
                Block[i].IsFall = true
            end
        end
    end

    if (key == "return") then
        if (CollisionCount >= 2) then
            for i=1, #Block do
                Block[i].Collider:destroy()
                Block[i] = nil
            end
            Block = nil
            Block = {}
            Score = 0
            CollisionCount = 0;
        end
    end
end