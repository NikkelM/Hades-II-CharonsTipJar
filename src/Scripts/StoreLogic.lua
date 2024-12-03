-- If the currently set up store is the PreBoss store before the final boss of a run, replace the Salute logic with the tipping logic

-- TODO: It is probably still being overwritten for the DeathArea Charon (who delivers the Mailbox items), so it needs to be reset when entering the DeathArea as well
local originalCharonUnitSetData = game.UnitSetData.NPC_Charon

modutil.mod.Path.Wrap("SetupWorldShop", function(base, source, args)
	-- Reset to the original in case we overwrote it in a previous shop room
	game.UnitSetData.NPC_Charon = originalCharonUnitSetData

	-- We need to be in either the Tartarus (I) or Olympus (P) PreBoss shop
	-- TODO: Once the final overworld region is added, change Olympus to that
	-- TODO: For debugging, use Erebus (F)
	if (game.CurrentRun.CurrentRoom.RoomSetName == "I" or game.CurrentRun.CurrentRoom.RoomSetName == "P" or game.CurrentRun.CurrentRoom.RoomSetName == "F") then
		if string.find(game.CurrentRun.CurrentRoom.Name, "PreBoss") then
			game.UnitSetData.NPC_Charon.NPC_Charon_01.UseTextSpecial = "ModsNikkelMCharonsTipJarNPCUseTextSpecial"
			game.UnitSetData.NPC_Charon.NPC_Charon_01.UseTextTalkGiftAndSpecial = "ModsNikkelMCharonsTipJarNPCUseTextGiftAndSpecial"
			game.UnitSetData.NPC_Charon.NPC_Charon_01.UseTextTalkAndSpecial = "ModsNikkelMCharonsTipJarNPCUseTextTalkAndSpecial"
			game.UnitSetData.NPC_Charon.NPC_Charon_01.UseTextGiftAndSpecial = "ModsNikkelMCharonsTipJarNPCUseTextTalkGiftAndSpecial"
		end
	end

	base(source, args)
end)
