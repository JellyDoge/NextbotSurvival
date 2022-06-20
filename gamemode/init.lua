AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "roundsystem.lua" )

include( "shared.lua" )
include( "teamsetup.lua" )
include( "roundsystem.lua" )

roundActive = false
spawnPointsNPC = {}
util.AddNetworkString( "round_timer" )
util.AddNetworkString( "round_active" )
util.AddNetworkString( "round_alive" )
util.AddNetworkString( "PlayFinalMusic" )

function GM:PlayerInitialSpawn( ply )
spawnPointsNPC = util.KeyValuesToTable( file.Read( "nextbotsurvival/spawnpoints/" .. tostring( game.GetMap() ) .. "/spawnpointsnpc.txt", "DATA" ) )

end

function GM:PlayerSpawn( ply )
    print( "Player: " .. ply:Nick() .. " has spawned!" )

    ply:SetupPlayer()
    ply:SetupHands()

    if( roundActive == true ) then
        ply:KillSilent()
        return
    else
        RoundStart()
    end
end

function GM:PlayerDeath( ply )

end

function GM:PlayerDeathThink( ply )
    if( roundActive == false ) then
        ply:Spawn()
        return true
    else
        return false
    end
end

function GM:PlayerDisconnected( ply )

end

function GM:PlayerSetHandsModel( ply, ent )

    local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
    local info = player_manager.TranslatePlayerHands( simplemodel )
    if( info ) then
        ent:SetModel( info.model )
        ent:SetSkin( info.skin )
        ent:SetBodyGroups( info.body )
    end
end

--function GM:PlayerCanSeePlayersChat( text, teamOnly, listener, speaker )
--
--    local dist = listener:GetPos():Distance( speaker:GetPos() )
--
--    if( dist <= 200 ) then
--        print( "You have been heard." )
--        return true 
--    end
--
--    print( "You have not been heard." )
--    return false
--end

--function GM:PlayerCanHearPlayersVoice( listener, speaker )
--    return( listener:GetPos():Distance( speaker:GetPos() ) < 500 )
--end

if( SERVER ) then util.AddNetworkString( "notify" ) end

hook.Add( "PlayerSay", "CommandIdent", function( ply, text, team )

    textTable = string.Explode( " ", text )

    if( textTable[1] == "!setspawn" ) then
        
        if( textTable[2] ~= nil ) then
            Notify( ply, "Invalid Input", 5, "Error" )
            return
        end

        if( !file.Exists( "nextbotsurvival", "DATA") ) then
            file.CreateDir( "nextbotsurvival", "DATA" )
        end

        if( !file.Exists( "nextbotsurvival/spawnpoints/" .. tostring( game.GetMap() ) .. "/spawnpointsnpc.txt", "DATA" ) ) then
            file.Write( "nextbotsurvival/spawnpoints/" .. tostring( game.GetMap() ) .. "/spawnpointsnpc.txt", util.TableToKeyValues( spawnPointsNPC ) )
        else
            --spawnPointsNPC = util.KeyValuesToTable( file.Read( "nextbotsurvival/spawnpoints/" .. tostring( game.GetMap() ) .. "/spawnpointsnpc.txt", "DATA" ) )
        end

        Notify( ply, "Added spawnpoint!", 5, "Generic" )

        table.insert( spawnPointsNPC, tostring( ply:GetPos() + Vector( 0, 0, 2 ) ) )
        file.Write( "nextbotsurvival/spawnpoints/" .. tostring( game.GetMap() ) .. "/spawnpointsnpc.txt", util.TableToKeyValues( spawnPointsNPC ) )

    elseif( textTable[1] == "!roundcheck" ) then
        RoundEndCheck()
    end
    
end)