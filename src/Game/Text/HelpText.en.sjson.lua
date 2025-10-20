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
	},
	-- If the player has no money
	{
		Id = "ModsNikkelMCharonsTipJar_TipJarUseText_NoMoney",
		DisplayName = "{I} {#LockedFormat}Tip {!Icons.Currency}?",
	},
	-- If the player has money, but has already tipped
	{
		Id = "ModsNikkelMCharonsTipJar_TipJarUseText_AlreadyTipped",
		DisplayName = "{I} {#LockedFormat}Tip {$GameState.Resources.Money}{!Icons.Currency}?",
	},
	-- Floating text overhead if tipping with no money
	{
		Id = "ModsNikkelMCharonsTipJar_NoMoney_FloatText",
		DisplayName = "No {#CombatTextHighlightFormat}Gold{!Icons.Currency} {#Prev}to tip!",
	},
	-- Floating text overhead if already tipped
	{
		Id = "ModsNikkelMCharonsTipJar_AlreadyTipped_FloatText",
		DisplayName = "Already tipped {!Icons.Currency} {#CombatTextHighlightFormat}{$Keywords.CharCharon}{#Prev}!",
	},
	-- Floating text overhead while tipping
	{
		Id = "ModsNikkelMCharonsTipJar_TipInProgress_FloatText",
		DisplayName = "{#CombatTextHighlightFormat}{$Keywords.CharCharon} {#Prev} accepts the Tip {!Icons.Currency}!",
	},
	-- Floating text overhead while tipping with >=200 money
	{
		Id = "ModsNikkelMCharonsTipJar_TipInProgress_Generous_FloatText",
		DisplayName =
		"{#CombatTextHighlightFormat}{$Keywords.CharCharon} {#Prev} accepts the {#Emph}generous {#Prev} Tip {!Icons.Currency}!",
	},

	-- Localizations of the intro conversations
	-- If Charon is present
	{
		Id = "ModsNikkelMCharonsTipJarTipJarIntro01_A_Melinoe01",
		InheritFrom = "BaseNarrative",
		DisplayName =
		"What is this over here, Lord Charon? The box with all the coins in it? I don't suppose this is some sort of new ware to help me with my task, is it?"
	},
	{
		Id = "ModsNikkelMCharonsTipJarTipJarIntro01_A_Melinoe02",
		InheritFrom = "BaseNarrative",
		DisplayName =
		"You're right, I won't have any use for the remaining Gold in my possession going forward. One way or another, I will return to shadow soon. I might as well leave the coins with you now to have them disposed of properly."
	},
	{
		Id = "ModsNikkelMCharonsTipJarTipJarIntro01_A_Melinoe03",
		InheritFrom = "BaseNarrative",
		DisplayName =
		"Why thank you! I hope you know it is entirely unnecessary for you to include these tips in your loyalty program, but I do appreciate it nonetheless, my lord."
	},
	-- If Charon is not present
	{
		Id = "ModsNikkelMCharonsTipJarTipJarIntro01_B_Melinoe01",
		InheritFrom = "BaseNarrative",
		DisplayName =
		"Oh, there is a note on this box... {#Emph}Hey M. Leave any leftover Gold you have in here. Hermes will get it to me. Charon"
	},
	{
		Id = "ModsNikkelMCharonsTipJarTipJarIntro01_B_Melinoe02",
		InheritFrom = "BaseNarrative",
		DisplayName =
		"He's right. I won't have any use for the remaining Gold in my possession going forward. One way or another, I will return to shadow soon."
	},
	{
		Id = "ModsNikkelMCharonsTipJarTipJarIntro01_B_Melinoe03",
		InheritFrom = "BaseNarrative",
		DisplayName =
		"There is more on the back... {#Emph}I will count any tips you leave towards your rewards. Honor system."
	},
}
local helpTextFile = rom.path.combine(rom.paths.Content, 'Game/Text/en/HelpText.en.sjson')

sjson.hook(helpTextFile, function(data)
	for _, newValue in ipairs(newData) do
		table.insert(data.Texts, sjson.to_object(newValue, order))
	end
end)
