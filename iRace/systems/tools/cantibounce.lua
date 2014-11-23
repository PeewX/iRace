--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 09.11.2014 - Time: 14:34
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--

addEventHandler("onClientVehicleCollision", root, function(hE)
    if not getElementData(me, "antiBounce") then return end
    if hE ~= nil then if getElementType(hE) ~= "object" then return end	end
    if getElementType(source) ~= "vehicle" then return end
    if getVehicleOccupant(source) ~= me then return end

    local tx, ty, tz = getVehicleTurnVelocity(source)
    if (ty > 0.1 and tz > 0.1) then
        local vx,vy,vz = getElementVelocity(source)
        setVehicleTurnVelocity(source, 0, 0, 0)
        setElementVelocity(source, vx, vy, vz)
    end
end)

_getVehicleTurnVelocity = getVehicleTurnVelocity
function getVehicleTurnVelocity(vehicle)
    local tX, tY, tZ = _getVehicleTurnVelocity(vehicle)
    local eM = getElementMatrix(vehicle)
    local cX = math.abs(tX * eM[1][1]) + math.abs(tY * eM[1][2]) + math.abs(tZ * eM[1][3])
    local cY = math.abs(tX * eM[2][1]) + math.abs(tY * eM[2][2]) + math.abs(tZ * eM[2][3])
    local cZ = math.abs(tX * eM[3][1]) + math.abs(tY * eM[3][2]) + math.abs(tZ * eM[3][3])
    return cX, cY, cZ
end