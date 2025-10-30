local order = {
	"Id",
	"DisplayName",
	"OverwriteLocalization"
}

local newData = {
	-- If the player has money
	{
		Id = "ModsNikkelMCharonsTipJar_TipJarUseText",
		DisplayName = "{I}小费{$GameState.Resources.Money}{!Icons.Currency}",
	},
	-- If the player has no money
	{
		Id = "ModsNikkelMCharonsTipJar_TipJarUseText_NoMoney",
		DisplayName = "{I}{#LockedFormat}小费{!Icons.Currency}？",
	},
	-- If the player has money, but has already tipped
	{
		Id = "ModsNikkelMCharonsTipJar_TipJarUseText_AlreadyTipped",
		DisplayName = "{I}{#LockedFormat}小费{$GameState.Resources.Money}{!Icons.Currency}？",
	},
	-- Floating text overhead if tipping with no money
	{
		Id = "ModsNikkelMCharonsTipJar_NoMoney_FloatText",
		DisplayName = "没有{#CombatTextHighlightFormat}金币{!Icons.Currency}{#Prev}给小费！",
	},
	-- Floating text overhead if already tipped
	{
		Id = "ModsNikkelMCharonsTipJar_AlreadyTipped_FloatText",
		DisplayName = "已经给过小费了{!Icons.Currency}{#CombatTextHighlightFormat}{$Keywords.CharCharon}{#Prev}！",
	},
	-- Floating text overhead while tipping
	{
		Id = "ModsNikkelMCharonsTipJar_TipInProgress_FloatText",
		DisplayName = "{#CombatTextHighlightFormat}{$Keywords.CharCharon}{#Prev}收到小费{!Icons.Currency}！",
	},
	-- Floating text overhead while tipping with >=200 money
	{
		Id = "ModsNikkelMCharonsTipJar_TipInProgress_Generous_FloatText",
		DisplayName =
		"{#CombatTextHighlightFormat}{$Keywords.CharCharon}{#Prev}收到{#Emph}慷慨的{#Prev}小费{!Icons.Currency}！",
	},

	-- Localizations of the intro conversations
	-- If Charon is present
	{
		Id = "ModsNikkelMCharonsTipJarTipJarIntro01_A_Melinoe01",
		InheritFrom = "BaseNarrative",
		DisplayName = "卡戎大人，这是什么？这个装满钱币的盒子？我猜，这莫非是某种能助我完成任务的新货物？",
		-- Original: "What is this over here, Lord Charon? The box with all the coins in it? I don't suppose this is some sort of new ware to help me with my task, is it?"
	},
	{
		Id = "ModsNikkelMCharonsTipJarTipJarIntro01_A_Melinoe02",
		InheritFrom = "BaseNarrative",
		DisplayName = "您说得对，我身上剩下的金币对我来说也确实没什么用了。无论如何，我很快都将重归阴影。不如现在就把钱币留给您，也好让它们物尽其用。",
		-- Original: "You're right, I won't have any use for the remaining Gold in my possession going forward. One way or another, I will return to shadow soon. I might as well leave the coins with you now to have them disposed of properly."
	},
	{
		Id = "ModsNikkelMCharonsTipJarTipJarIntro01_A_Melinoe03",
		InheritFrom = "BaseNarrative",
		DisplayName = "哎呀，多谢！您明知完全没必要将这些'小费'也算进您的忠诚度计划里，但尽管如此，我依然感激不尽，我的大人。",
		-- Original: "Why thank you! I hope you know it is entirely unnecessary for you to include these tips in your loyalty program, but I do appreciate it nonetheless, my lord."
	},
	-- If Charon is not present
	{
		Id = "ModsNikkelMCharonsTipJarTipJarIntro01_B_Melinoe01",
		InheritFrom = "BaseNarrative",
		DisplayName = "哦，这盒子上有张字条……{#Emph}“嘿，小墨。把你剩下的金子放这儿就行。赫尔墨斯会转交给我。——卡戎”",
		-- Original: "Oh, there is a note on this box... {#Emph}Hey M. Leave any leftover Gold you have in here. Hermes will get it to me. Charon"
	},
	{
		Id = "ModsNikkelMCharonsTipJarTipJarIntro01_B_Melinoe02",
		InheritFrom = "BaseNarrative",
		DisplayName = "他说得对。我身上剩下的金币对我来说也确实没什么用了。无论如何，我很快都将重归阴影。",
		-- Original: "He's right. I won't have any use for the remaining Gold in my possession going forward. One way or another, I will return to shadow soon."
	},
	{
		Id = "ModsNikkelMCharonsTipJarTipJarIntro01_B_Melinoe03",
		InheritFrom = "BaseNarrative",
		DisplayName = "背面还有字……{#Emph}“你留的小费我会给你记在奖励里。全凭自觉。”",
		-- Original: "There is more on the back... {#Emph}I will count any tips you leave towards your rewards. Honor system."
	},
}
local helpTextFile = rom.path.combine(rom.paths.Content, 'Game/Text/zh-CN/HelpText.zh-CN.sjson')

sjson.hook(helpTextFile, function(data)
	for _, newValue in ipairs(newData) do
		table.insert(data.Texts, sjson.to_object(newValue, order))
	end
end)
