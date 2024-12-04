-- If the currently set up store is the PreBoss store before the final boss of a run, replace the Salute logic with the tipping logic

-- TODO: With deepCopyTable, the logic doesn't work (functions and texts are not overwritten)
local originalCharonUnitSetData = game.UnitSetData.NPC_Charon --game.DeepCopyTable(game.UnitSetData.NPC_Charon)
local tippingInteractVoicelines = game.UnitSetData.NPC_Charon.NPC_Charon_01.InteractVoiceLines --game.DeepCopyTable(game.UnitSetData.NPC_Charon.NPC_Charon_01.InteractVoiceLines)
-- These are the "SaluteVoiceLines"
tippingInteractVoicelines[1] = {
	{ Cue = "/VO/Melinoe_2358",      Text = "This is for you!" },
	-- { Cue = "/VO/Melinoe_3789", Text = "This is for you." }, -- works, but cutey (familiar voiceline)
	{ Cue = "/VO/Melinoe_2358_B",    Text = "This is for you!" },
	-- { Cue = "/VO/Melinoe_3789_B", Text = "This is for you." }, -- works, but cutey (familiar voiceline)
	{ Cue = "/VO/Melinoe_0187",      Text = "A gift..." },
	-- { Cue = "/VO/Melinoe_0248", Text = "Got something for you." }, -- doesn't sound good (pacing)
	{ Cue = "/VO/Melinoe_2355",      Text = "For you!" },
	{ Cue = "/VO/Melinoe_3425",      Text = "In service to the realm.", },
	{ Cue = "/VO/Melinoe_0557",      Text = "Here's the Gold.", },
	-- { Cue = "/VO/Melinoe_1221", Text = "Here's the Gold.",}, -- a bit too forceful - this is a tip, not a transaction
	{ Cue = "/VO/MelinoeField_1630", Text = "Who needs Gold anyway..." }
}
-- Remove the global voicelines
tippingInteractVoicelines[2] = {}

modutil.mod.Path.Wrap("SetupWorldShop", function(base, source, args)
	-- Reset to the original in case we overwrote it in a previous shop room
	game.UnitSetData.NPC_Charon = originalCharonUnitSetData

	-- We need to be in either the Tartarus (I) or Olympus (P) PreBoss shop
	-- or game.CurrentRun.CurrentRoom.RoomSetName == "F"
	-- TODO: Once the final overworld region is added, change Olympus to that
	if (game.CurrentRun.CurrentRoom.RoomSetName == "I" or game.CurrentRun.CurrentRoom.RoomSetName == "P" or game.CurrentRun.CurrentRoom.RoomSetName == "F") then
		if string.find(game.CurrentRun.CurrentRoom.Name, "PreBoss") then
			game.UnitSetData.NPC_Charon.NPC_Charon_01.UseTextSpecial = "ModsNikkelMCharonsTipJar_NPCUseTextSpecial"
			game.UnitSetData.NPC_Charon.NPC_Charon_01.UseTextTalkGiftAndSpecial =
			"ModsNikkelMCharonsTipJar_NPCUseTextGiftAndSpecial"
			game.UnitSetData.NPC_Charon.NPC_Charon_01.UseTextTalkAndSpecial =
			"ModsNikkelMCharonsTipJar_NPCUseTextTalkAndSpecial"
			game.UnitSetData.NPC_Charon.NPC_Charon_01.UseTextGiftAndSpecial =
			"ModsNikkelMCharonsTipJar_NPCUseTextTalkGiftAndSpecial"

			game.UnitSetData.NPC_Charon.NPC_Charon_01.SpecialInteractFunctionName = "ModsNikkelMCharonsTipJarTipCharon"

			game.UnitSetData.NPC_Charon.NPC_Charon_01.InteractVoiceLines = tippingInteractVoicelines
		end
	end

	base(source, args)
end)


-- Reset the Charon unit set data when entering the Crossroads, to make sure the tipping logic is removed in case he appears
-- TODO: Test if this is needed
-- modutil.mod.Path.Wrap("DeathAreaRoomTransition", function(base, source, args)
-- 	game.UnitSetData.NPC_Charon = originalCharonUnitSetData
-- 	base(source, args)
-- end)
