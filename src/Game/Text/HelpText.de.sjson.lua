local order = {
	"Id",
	"DisplayName",
	"OverwriteLocalization"
}

local newData = {
	-- If the player has money
	{
		Id = "ModsNikkelMCharonsTipJar_TipJarUseText",
		DisplayName = "{I} {$GameState.Resources.Money}{!Icons.Currency} als Trinkgeld geben",
	},
	-- If the player has no money
	{
		Id = "ModsNikkelMCharonsTipJar_TipJarUseText_NoMoney",
		DisplayName = "{I} {#LockedFormat}Trinkgeld geben {!Icons.Currency}?",
	},
	-- Floating text overhead if tipping with no money
	{
		Id = "ModsNikkelMCharonsTipJar_NoMoney_FloatText",
		DisplayName = "Keine {#CombatTextHighlightFormat}Goldkronen{!Icons.Currency} {#Prev}für Trinkgeld!",
	},
	-- Floating text overhead if already tipped
	{
		Id = "ModsNikkelMCharonsTipJar_AlreadyTipped_FloatText",
		DisplayName = "{#CombatTextHighlightFormat}{$Keywords.CharCharon} {#Prev} schon Trinkgeld {!Icons.Currency} gegeben!",
	},
	-- Floating text overhead while tipping
	{
		Id = "ModsNikkelMCharonsTipJar_TipInProgress_FloatText",
		DisplayName =
		"{#CombatTextHighlightFormat}{$Keywords.CharCharon} {#Prev} akzeptiert das Trinkgeld {!Icons.Currency}!",
	},
	-- Floating text overhead while tipping with >=200 money
	{
		Id = "ModsNikkelMCharonsTipJar_TipInProgress_Generous_FloatText",
		DisplayName =
		"{#CombatTextHighlightFormat}{$Keywords.CharCharon} {#Prev} akzeptiert das {#Emph}großzügige {#Prev} Trinkgeld {!Icons.Currency}!",
	},
}
local helpTextFile = rom.path.combine(rom.paths.Content, 'Game/Text/de/HelpText.de.sjson')

sjson.hook(helpTextFile, function(data)
	for _, newValue in ipairs(newData) do
		table.insert(data.Texts, sjson.to_object(newValue, order))
	end
end)
