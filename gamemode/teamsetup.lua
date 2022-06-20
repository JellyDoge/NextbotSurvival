local ply = FindMetaTable("Player")

pistolTable = { 
    "mg_357",
    "mg_deagle",
    "mg_p320",
    "mg_m1911",
    "mg_m9",
    "mg_makarov",
    "mg_glock"
}

function ply:SetupPlayer()


    self:SetHealth( 100 )
    self:SetMaxHealth( 100 )
    self:SetWalkSpeed( 250 ) --250
    self:SetRunSpeed( 500 ) --400
    self:SetModel( "models/player/Group03m/Male_0" .. math.random(1,9) .. ".mdl" )

    self:GiveWeapons()

end

function ply:GiveWeapons()
    --self:Give( pistolTable[ math.random( 1, #pistolTable ) ] )
    self:Give( "weapon_ai_scanner" )
    self:Give( "weapon_357")
    --self:Give( "weapon_smg1" )
    --self:Give( "weapon_rpg" )

    self:GiveAmmo( 12, "357", true )
    --self:GiveAmmo( 0, "smg1", true)
end

-- weapon_ai_scanner
-- mg_357
-- mg_deagle
-- mg_p320
-- mg_m1911
-- mg_m9
-- mg_makarov
-- mg_glock