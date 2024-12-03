local order = {
  "Id",
  "DisplayName"
}

local newData = {
	{
		Id = "ModsNikkelMCharonsTipJarNPCUseTextSpecial",
		DisplayName = "{SI} Tip"
	},
	{
		Id = "ModsNikkelMCharonsTipJarNPCUseTextGiftAndSpecial",
		DisplayName = "{G} Gift\n {SI} Tip"
	},
	{
		Id = "ModsNikkelMCharonsTipJarNPCUseTextTalkAndSpecial",
		DisplayName = "{I} Talk\n {SI} Tip"
	},
	{
		Id = "ModsNikkelMCharonsTipJarNPCUseTextTalkGiftAndSpecial",
		DisplayName = "{I} Talk\n {G} Gift\n {SI} Tip"
	}
}
local helpTextFile = rom.path.combine(rom.paths.Content, 'Game/Text/en/HelpText.en.sjson')

sjson.hook(helpTextFile, function(data)
	for _, newValue in ipairs(newData) do
		table.insert(data.Texts, sjson.to_object(newValue, order))
	end
end)