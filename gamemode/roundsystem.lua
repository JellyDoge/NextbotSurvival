function UpdateTimer( time )
    net.Start( "round_timer" )
        net.WriteInt( time, 11 )
    net.Broadcast()
end

function UpdateAlive( alive )
    net.Start( "round_alive" )
        net.WriteInt( alive, 10 )
    net.Broadcast()
end

function RoundStart()

    local time = 10
    UpdateTimer( time )
    timer.Create( "round", 1, time, function()
        
        time = time - 1

        -- Counts all players
        local Alive = 0
        for k, v in pairs( player.GetAll() ) do
            if( v:Alive() ) then
                Alive = Alive + 1
            end
        end

        if( Alive >= table.Count( player.GetAll() ) && table.Count( player.GetAll() ) > 1 && time <= 0 ) then
            roundActive = true
            net.Start( "round_active" )
                net.WriteBool( true )
            net.Broadcast()

        elseif( table.Count( player.GetAll() )  < 2 ) then
            UpdateTimer( 5 )
            return
        end

        if( time <= 0 ) then
            print( "Round started: " .. tostring(roundActive) )
            RoundEndCheck()
        end

        -- Activates BotSpawner()
        if( roundActive == true ) then
            print( "Bot spawner started...")
            BotSpawner()
        end


        UpdateTimer( time )
        UpdateAlive( Alive )

    end)

    print( "Round started: " .. tostring(roundActive) )
    RoundEndCheck()
end

function RoundEndCheck()
    print( "Round active: ".. tostring(roundActive) )

    spawnPointsNPC = util.KeyValuesToTable( file.Read( "nextbotsurvival/spawnpoints/" .. tostring( game.GetMap() ) .. "/spawnpointsnpc.txt", "DATA" ) )

    -- Spawns players at custom spwnpts
    for k, v in pairs( player.GetAll() ) do
        v:SetPos( Vector( spawnPointsNPC[ math.random( 1, #spawnPointsNPC ) ] ) )
    end

    time = 181
    if( roundActive == false ) then return end

    timer.Create( "checkdelay", 1, time, function()
        time = time - 1
        UpdateTimer( time )

        if( time <= 0 ) then
            EndRound( "No one" )
        end

        local roundAlive = 0
        for k, v in pairs( player.GetAll() ) do
            if( v:Alive() ) then
                roundAlive = roundAlive + 1
            end
        end

        UpdateAlive( roundAlive )

        --print( "Alive players: " .. tostring(roundAlive) )

        if( roundAlive <= 1 ) then
            EndRound()
        end

        if( time == 180 && roundActive == true ) then
            NS:PlayMusic()
        end

    end)

    --if( roundAlive == 0 ) then
    --    timer.Create( "failsale" , 5, 1, function() 
    --       EndRound()
    --    end)
    --end



    --
    --    for i, ply in pairs( player.GetAll() ) do
    --        if ply:Alive() then
    --            EndRound( tostring( ply:Nick() ) )
    --        end
    --    end

end

function EndRound( winners )
    --print( winners .. " won the round!")
    --for _, v in pairs( player.GetAll() ) do
    --    if( ply:Nick() == winners ) then
    --        print( " Reward debug " .. tostring( ply:Nick() ) )
    --    end
    --end
    print( "Round ended..." )

    timer.Remove( "checkdelay" )
    timer.Create( "cleanup", 3, 1, function()
        game.CleanUpMap( false, {} )
        RunConsoleCommand("stopsound")

        timer.Remove( "Bot1" )
        timer.Remove( "Bot2" )
        timer.Remove( "Bot3" )
        timer.Remove( "Bot4" )
        timer.Remove( "Final" )

        for _, v in pairs( player.GetAll() ) do
            if( v:Alive() ) then
                v:SetupHands()
                v:StripWeapons()
                v:KillSilent()
            end
            v:SetupPlayer()
        end
        net.Start( "round_active" )
            net.WriteBool( false )
        net.Broadcast()
        roundActive = false
    end)
end

function BotSpawner()
    
    Saul = false
    Sandy = false
    Quandale = false
    Bing = false

    timer.Create( "Bot1", 10, 1, function()
        -- 10
        print( "Bot 1 Timer" )
        local saul = ents.Create( "npc_anim_skeletons" )
        saul:SetPos( Vector( spawnPointsNPC[ math.random( 1, #spawnPointsNPC ) ] ) )
        saul:Spawn()

    end)
    
    timer.Create( "Bot2", 70, 1, function()
        -- 70
        print( "Bot 2 Timer" )
        local sandy = ents.Create( "npc_walter" )
        sandy:SetPos( Vector( spawnPointsNPC[ math.random( 1, #spawnPointsNPC ) ] ) )
        sandy:Spawn()

    end)

    timer.Create( "Bot3", 130, 1, function()
        -- 130
        print( "Bot 3 Timer" )
        local quandale = ents.Create( "npc_pervertedapple" )
        quandale:SetPos( Vector( spawnPointsNPC[ math.random( 1, #spawnPointsNPC ) ] ) )
        quandale:Spawn()

    end)

    timer.Create( "Bot4", 190, 1, function()
        -- 190
        print( "Bot 4 Timer" )
        local bc = ents.Create( "npc_therock" )
        bc:SetPos( Vector( spawnPointsNPC[ math.random( 1, #spawnPointsNPC ) ] ) )
        bc:Spawn()

    end)

    timer.Create( "Final", 500, 1, function()
        -- 310
        print( "Final Timer" )


    end)


        -- bing chilling
        -- saul
        -- sandy
        -- quandale
end

-- npc_bc
-- npc_monstrum_fiend
-- npc_anim_skeletons
-- npc_gigachad_soldier
-- npc_pervertedapple
-- npc_quandale
-- npc_sandy
-- npc_luayer
-- npc_therock
-- npc_uncle
-- npc_walter
