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
	-- If the player has money, but has already tipped
	{
		Id = "ModsNikkelMCharonsTipJar_TipJarUseText_AlreadyTipped",
		DisplayName = "{I} {#LockedFormat}{$GameState.Resources.Money}{!Icons.Currency} als Trinkgeld geben?",
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

	-- Localizations of the intro conversations
	-- If Charon is present
	{
		Id = "ModsNikkelMCharonsTipJarTipJarIntro01_A_Melinoe01",
		InheritFrom = "BaseNarrative",
		DisplayName =
		"Was steht denn hier, ehrwürdiger Charon? Diese Kiste mit all den Münzen darin? Könnte dies eine neue Ware sein, die mir bei meiner Aufgabe helfen kann?"
		-- DisplayName = "What is this over here, Lord Charon? The box with all the coins in it? I don't suppose this is some sort of new ware to help me with my task, is it?"
	},
	{
		Id = "ModsNikkelMCharonsTipJarTipJarIntro01_A_Melinoe02",
		InheritFrom = "BaseNarrative",
		DisplayName =
		"Ihr habt recht, ich werde heute Nacht keine Verwendung mehr für die restlichen Goldkronen in meinem Besitz haben. So oder so werde ich bald wieder in die Schatten zurückkehren. Ich kann die Münzen genauso gut jetzt bei Euch lassen, damit Ihr sie ordnungsgemäß entsorgen könnt."
		-- DisplayName = "You're right, I won't have any use for the remaining Gold in my possession going forward. One way or another, I will return to shadow soon. I might as well leave the coins with you now to have them disposed of properly."
	},
	{
		Id = "ModsNikkelMCharonsTipJarTipJarIntro01_A_Melinoe03",
		InheritFrom = "BaseNarrative",
		DisplayName =
		"Oh, wie nett von Euch! Ich hoffe es ist Euch bewusst, dass Ihr diese Trinkgelder nicht in Euer Prämienprogramm miteinbeziehen müsst, aber ich schätze es dennoch, ehrwürdiger Charon."
		-- DisplayName = "Why thank you! I hope you know it is entirely unnecessary for you to include these tips in your loyalty program, but I do appreciate it nonetheless, my lord."
	},
	-- If Charon is not present
	{
		Id = "ModsNikkelMCharonsTipJarTipJarIntro01_B_Melinoe01",
		InheritFrom = "BaseNarrative",
		DisplayName =
		"Oh, es hängt eine Notiz an dieser Kiste... {#Emph}„Hey M. Hier kannst du übergebliebenes Gold einwerfen. Hermes wird es mir bringen. Charon”"
		-- DisplayName = "Oh, there is a note on this box... {#Emph}Hey M. Leave any leftover Gold you have in here. Hermes will get it to me. Charon"
	},
	{
		Id = "ModsNikkelMCharonsTipJarTipJarIntro01_B_Melinoe02",
		InheritFrom = "BaseNarrative",
		DisplayName =
		"Charon hat recht, ich werde heute Nacht keine Verwendung mehr für die restlichen Goldkronen in meinem Besitz haben. So oder so werde ich bald wieder in die Schatten zurückkehren."
		-- DisplayName = "He's right. I won't have any use for the remaining Gold in my possession going forward. One way or another, I will return to shadow soon."
	},
	{
		Id = "ModsNikkelMCharonsTipJarTipJarIntro01_B_Melinoe03",
		InheritFrom = "BaseNarrative",
		DisplayName =
		"Auf der Rückseite steht noch mehr... {#Emph}„Alles eingeworfene Trinkgeld werde ich auf dein Prämienprogramm anrechnen. Ehrensache.”"
		-- DisplayName = "There is more on the back... {#Emph}I will count any tips you leave towards your rewards. Honor system."
	},
}
local helpTextFile = rom.path.combine(rom.paths.Content, 'Game/Text/de/HelpText.de.sjson')

sjson.hook(helpTextFile, function(data)
	for _, newValue in ipairs(newData) do
		table.insert(data.Texts, sjson.to_object(newValue, order))
	end
end)
