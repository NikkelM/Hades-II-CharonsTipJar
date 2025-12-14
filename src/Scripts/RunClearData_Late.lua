-- Doing this after all other mods to ensure the message added by Zagreus' Journey already exists

-- Prevent the player from being eligible for the ClearMoneyNone run clear title if they used the tip jar
table.insert(game.GameData.RunClearMessageData.ClearMoneyNone.GameStateRequirements, {
	PathFalse = { "CurrentRun", "ModsNikkelMCharonsTipJarCharonTipped" },
})
-- And the same for the Hades I message, compatibility with Zagreus' Journey
if game.GameData.ModsNikkelMHadesBiomesRunClearMessageData ~= nil then
	table.insert(
		game.GameData.ModsNikkelMHadesBiomesRunClearMessageData.ModsNikkelMHadesBiomes_RunClear_ClearMoneyNone
		.GameStateRequirements, {
			PathFalse = { "CurrentRun", "ModsNikkelMCharonsTipJarCharonTipped" },
		})
end
