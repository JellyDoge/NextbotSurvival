include( "shared.lua" )

local TIMER_PANEL = {

    Init = function( self )

        self.Body = self:Add( "Panel" )
        self.Body:Dock( TOP )
        self.Body:SetHeight( 40 )
        function self.Body:Paint( w, h )
            surface.SetDrawColor( 150, 255, 150 )
            draw.RoundedBox( 0, -20, 0, w / 2, h, Color( 30, 30, 30, 230 ) )
        end

        self.Timer = self.Body:Add( "DLabel" )
        self.Timer:SetFont( "DermaDefaultBold" )
        self.Timer:SetTextColor( Color( 255, 255, 255, 255 ) )
        self.Timer:Dock( LEFT )
        self.Timer:SetContentAlignment( 5 )
    end,

    PerformLayout = function( self )

        self:SetSize( 200, 100 )
        self:SetPos( 0, 0 )
    end,

    Think = function( self, w, h )

        net.Receive( "round_timer", function( len, pl )
                time = net.ReadInt( 11 )
        end)

        if( time == nil ) then
            self.Timer:SetText( 5 )
        else
            local minutes = math.floor( time / 60 )
            local seconds = ( time % 60 )

            self.Timer:SetText( string.format( "%02d:%02d", minutes, seconds ) )

        end

    end
}

TIMER_PANEL = vgui.RegisterTable( TIMER_PANEL, "EditablePanel" )

RoundActive = false 

net.Receive( "round_active", function( len )
    RoundActive = net.ReadBool()
end)

local ALIVE_PANEL = {

    Init = function( self )

        self.Body = self:Add( "Panel" )
        self.Body:Dock( TOP )
        self.Body:SetHeight( 40 )
        function self.Body:Paint( w, h )
            surface.SetDrawColor( 150, 255, 150 )
            draw.RoundedBox( 0, -20, 0, w / 2, h, Color( 30, 30, 30, 230 ) )
        end

        self.Alive = self.Body:Add( "DLabel" )
        self.Alive:SetFont( "DermaDefaultBold" )
        self.Alive:SetTextColor( Color( 255, 255, 255, 255 ) )
        self.Alive:Dock( LEFT )
        self.Alive:SetContentAlignment( 5 )
    end,

    PerformLayout = function( self )

        self:SetSize( 200, 100 )
        self:SetPos( 0, 50 )
    end,

    Think = function( self, w, h )

        net.Receive( "round_alive", function( len, pl )
                alive = net.ReadInt( 10 )
        end)

        if( alive == nil ) then
            self.Alive:SetText( 0 )
        else
            self.Alive:SetText( "Alive: " .. alive )
        end
    end
}

ALIVE_PANEL = vgui.RegisterTable( ALIVE_PANEL, "EditablePanel" )

RoundActive = false 

net.Receive( "round_active", function( len )
    RoundActive = net.ReadBool()
end)

function HUD()

    if( !IsValid( TimerPanel ) ) then
        TimerPanel = vgui.CreateFromTable( TIMER_PANEL )
    end

    if( IsValid( TimerPanel ) ) then
        TimerPanel:Show()
    end

    if( !IsValid( AlivePanel ) ) then
        AlivePanel = vgui.CreateFromTable( ALIVE_PANEL )
    end

    if( IsValid( AlivePanel ) ) then
        AlivePanel:Show()
    end

    local ply = LocalPlayer()

    if !ply:Alive() then
        return
    end

    draw.RoundedBox( 0, 0, ScrH() - 100, 250, 100, Color(30, 30, 30, 230))

    draw.SimpleText( "Health: "..ply:Health().."%", "DermaDefaultBold", 10, ScrH() - 90, Color( 255, 255, 255, 255 ), 0, 0)
    draw.RoundedBox( 0, 10, ScrH() - 75, 100 * 2.25, 15, Color( 255, 0, 0, 30 ) )
    draw.RoundedBox( 0, 10, ScrH() - 75, math.Clamp( ply:Health(), 0, 100 ) * 2.25, 15, Color( 255, 0, 0, 255) )
    draw.RoundedBox( 0, 10, ScrH() - 75, math.Clamp( ply:Health(), 0, 100 ) * 2.25, 5, Color( 255, 30, 30, 255) )

    draw.SimpleText( "Armor: "..ply:Armor().."%", "DermaDefaultBold", 10, ScrH() - 45, Color( 255, 255, 255, 255 ), 0, 0)
    draw.RoundedBox( 0, 10, ScrH() - 30, 100 * 2.25, 15, Color( 0, 0, 255, 30 ) )
    draw.RoundedBox( 0, 10, ScrH() - 30, math.Clamp( ply:Armor(), 0, 100 ) * 2.25, 15, Color( 0, 0, 255, 255) )
    draw.RoundedBox( 0, 10, ScrH() - 30, math.Clamp( ply:Armor(), 0, 100 ) * 2.25, 5, Color( 15, 15, 255, 255) )

    draw.RoundedBox( 0, 255, ScrH() - 70, 125, 70, Color( 30, 30, 30, 230) )

    if ( ply:GetActiveWeapon():IsValid() ) then
        local curWeapon = ply:GetActiveWeapon():GetClass()

        if ( ply:GetActiveWeapon():GetPrintName() !=nil ) then
            draw.SimpleText( ply:GetActiveWeapon():GetPrintName(), "DermaDefaultBold", 260, ScrH() - 60, Color(255, 255, 255, 255), 0, 0 )
        end

        if ( curWeapon != "weapon_physgun" && curWeapon != "weapon_physcannon" && curWeapon != "weapon_crowbar" ) then
            if ( ply:GetActiveWeapon():Clip1() != -1 ) then
                draw.SimpleText( "Ammo: " .. ply:GetActiveWeapon():Clip1() .. "/" .. ply:GetAmmoCount(ply:GetActiveWeapon():GetPrimaryAmmoType() ), "DermaDefaultBold", 260, ScrH() - 40, Color(255, 255, 255, 255), 0, 0)
            else
                draw.SimpleText( "Ammo: " .. ply:GetAmmoCount( ply:GetActiveWeapon():GetPrimaryAmmoType() ), "DermaDefaultBold", 260, ScrH() - 40, Color(255, 255, 255, 255), 0, 0)
            end

            if ( ply:GetAmmoCount( ply:GetActiveWeapon():GetSecondaryAmmoType() ) > 0 ) then
                draw.SimpleText("Secondary: " .. ply:GetAmmoCount( ply:GetActiveWeapon():GetSecondaryAmmoType() ), "DermaDefaultBold", 260, ScrH - 25, Color( 255, 255, 255, 255 ), 0, 0 )
            end
        end
    end
end
hook.Add("HUDPaint", "TestHud", HUD)

function GM:HUDShouldDraw( name )
    local hud = { "CHudHealth","CHudBattery","CHudSecondaryAmmo","CHudAmmo", "CHudCrosshair", "CHudDeathNotice" }
    for k, element in pairs ( hud ) do
        if name == element then return false end
    end
    return true
end
hook.Add( "HUDShouldDraw", "HideDefaultHud", HideHud )

net.Receive( "PlayFinalMusic", function()
    surface.PlaySound( "survive.wav" )
end)

hook.Add( "HUDPaint", "Crosshair", function()

    local center = Vector( ScrW() / 2, ScrH() / 2, 0 )
    local scale = Vector( 100, 100, 0 )

    surface.SetDrawColor( 255, 238, 0)

    surface.DrawLine( center.x, center.y, center.x, center.y + 10 )
    surface.DrawLine( center.x, center.y, center.x + 10, center.y )
    surface.DrawLine( center.x, center.y, center.x, center.y - 10 )
    surface.DrawLine( center.x, center.y, center.x - 10, center.y )


end )