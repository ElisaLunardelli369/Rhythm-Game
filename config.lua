--
-- For more information on config.lua see the Project Configuration Guide at:
-- https://docs.coronalabs.com/guide/basics/configSettings
--

-- abbiamo scelto di impostare il valore scale con zoomEven per una scelta estetica.
-- In questo modo i cerchi che creiamo escono dallo schermo senza passare dalle
-- bande nere, che altrimenti sarebbero presenti.
application =
{
	content =
	{
		width = 320,
		height = 480, 
		scale = "zoomEven", 
		fps = 60,           
		
		--[[
		imageSuffix =
		{
			    ["@2x"] = 2,
			    ["@4x"] = 4,
		},
		--]]
	},
}
