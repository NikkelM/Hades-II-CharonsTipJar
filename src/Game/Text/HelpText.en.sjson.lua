local order = {
  "Id",
  "DisplayName",
  "OverwriteLocalization"
}

local newData = {
	{
		Id = "ModsNikkelMCharonsTipJar_NPCUseTextSpecial",
		DisplayName = "{SI} Tip {$GameState.Resources.Money}{!Icons.Currency}",
    OverwriteLocalization = true
	},
	{
		Id = "ModsNikkelMCharonsTipJar_NPCUseTextGiftAndSpecial",
		DisplayName = "{G} Gift\n {SI} Tip {$GameState.Resources.Money}{!Icons.Currency}",
    OverwriteLocalization = true
	},
	{
		Id = "ModsNikkelMCharonsTipJar_NPCUseTextTalkAndSpecial",
		DisplayName = "{I} Talk\n {SI} Tip {$GameState.Resources.Money}{!Icons.Currency}",
    OverwriteLocalization = true
	},
	{
		Id = "ModsNikkelMCharonsTipJar_NPCUseTextTalkGiftAndSpecial",
		DisplayName = "{I} Talk\n {G} Gift\n {SI} Tip {$GameState.Resources.Money}{!Icons.Currency}",
    OverwriteLocalization = true
	}
}
local helpTextFile = rom.path.combine(rom.paths.Content, 'Game/Text/en/HelpText.en.sjson')

sjson.hook(helpTextFile, function(data)
	for _, newValue in ipairs(newData) do
		table.insert(data.Texts, sjson.to_object(newValue, order))
	end
end)