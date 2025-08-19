-- 4L_Admin_Blips - Config

Config = {}

-- Jobs allowed to toggle the player blips. Case-insensitive.
Config.AllowedJobs = {
    'Homeland',  -- canonical
    'homeland',  -- allow lowercase
    'Homland'    -- common typo you mentioned
}

-- Update interval for live movement (milliseconds)
Config.UpdateInterval = 1000

-- Blip appearance (applied to every player blip)
Config.Blip = {
    Sprite   = 1,        -- radar_sprite id
    Scale    = 0.85,     -- blip size
    Colour   = 29,       -- blue
    Category = 7,        -- optional category (grouping in map legend)
    Name     = 'Spieler' -- fallback label if ESX name not available
}


-- Should blips appear in the right-side legend on the big map?
Config.ShowInLegend = true

-- Legend category (7 = Other Players). See FiveM docs for SetBlipCategory.
Config.LegendCategory = 7
