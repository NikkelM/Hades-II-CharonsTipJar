local order = {
  "Id",
  "DisplayName",
  "OverwriteLocalization"
}

local newData = {
	-- If the player has money
	{
		Id = "ModsNikkelMCharonsTipJar_TipJarUseText",
		DisplayName = "{I} Tip {$GameState.Resources.Money}{!Icons.Currency}",
    OverwriteLocalization = true
	},
	-- If the player has no money
	{
		Id = "ModsNikkelMCharonsTipJar_TipJarUseText_NoMoney",
		DisplayName = "{I} {#LockedFormat}Tip {!Icons.Currency}?",
    OverwriteLocalization = true
	},
	-- Floating text overhead if tipping with no money
	{
		Id = "ModsNikkelMCharonsTipJar_TipJarUseText_NoMoney_FloatText",
		DisplayName = "No {#CombatTextHighlightFormat}Gold{!Icons.Currency} {#Prev}to tip!",
    OverwriteLocalization = true
	},
	-- Floating text overhead if already tipped
	{
		Id = "ModsNikkelMCharonsTipJar_TipJarUseText_AlreadyTipped_FloatText",
		-- TODO: Charon name formatting
		DisplayName = "Already tipped Charon!",
    OverwriteLocalization = true
	}
}
local helpTextFile = rom.path.combine(rom.paths.Content, 'Game/Text/en/HelpText.en.sjson')

sjson.hook(helpTextFile, function(data)
	for _, newValue in ipairs(newData) do
		table.insert(data.Texts, sjson.to_object(newValue, order))
	end
end)