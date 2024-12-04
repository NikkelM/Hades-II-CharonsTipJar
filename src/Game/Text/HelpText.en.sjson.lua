local order = {
  "Id",
  "DisplayName",
  "OverwriteLocalization"
}

local newData = {
	{
		Id = "ModsNikkelMCharonsTipJar_TipJarUseText",
		DisplayName = "{I} Tip {$GameState.Resources.Money}{!Icons.Currency}",
    OverwriteLocalization = true
	}
	-- TODO: Text for if no money (greyed out)
}
local helpTextFile = rom.path.combine(rom.paths.Content, 'Game/Text/en/HelpText.en.sjson')

sjson.hook(helpTextFile, function(data)
	for _, newValue in ipairs(newData) do
		table.insert(data.Texts, sjson.to_object(newValue, order))
	end
end)