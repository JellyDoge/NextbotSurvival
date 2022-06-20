GM.Name = "Nextbot Survival"
GM.Author = "JellyDoge"

NS = NS or {}

function Notify( ply, str, duration, notifytype )
    if( SERVER && duration >= 0 ) then
        net.Start( "notify" )
            net.WriteString( notifytype )
            net.WriteString( str )
            net.WriteInt( duration, 16 )
        net.Send( ply)
    elseif ( CLIENT ) then
        if( notifytype == "Error" ) then
            notification.AddLegacy( str, NOTIFY_ERROR, duration )
        elseif( notifytype == "Generic" ) then
            notification.AddLegacy( str, NOTIFY_GENERIC, duration )
        end
    end
end

if( CLIENT ) then
    net.Receive( "notify", function()
        local notifytype = net.ReadString()
        if( notifytype == "Error" ) then
            notification.AddLegacy( net.ReadString(), NOTIFY_ERROR, net.ReadInt( 16 ) )
        elseif( notifytype == "Generic" ) then
            notification.AddLegacy( net.ReadString(), NOTIFY_GENERIC, net.ReadInt( 16 ) )
        end
    end)
end

if SERVER then
    function NS:PlayMusic()
        net.Start( "PlayFinalMusic" )
        net.Broadcast()
    end
end