-- If the currently set up store is the PreBoss store before the final boss of a run, replace the Salute logic with the tipping logic

local originalCharonUnitSetData = game.UnitSetData.NPC_Charon

modutil.mod.Path.Wrap("SetupWorldShop", function(base, source, args)
	-- Reset to the original in case we overwrote it in a previous shop room
	game.UnitSetData.NPC_Charon = originalCharonUnitSetData

	-- We need to be in either the Tartarus (I) or Olympus (P) PreBoss shop
	-- TODO: Once the final overworld region is added, change Olympus to that
	-- TODO: For debugging, using Erebus (F)
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
		end
	end

	base(source, args)
end)

function game.ModsNikkelMCharonsTipJarTipCharon()
	local moneyTipped = game.GameState.Resources.Money
	-- Remove money
	game.SpendResources( { Money = moneyTipped }, "ModsNikkelMCharonsTipJarCharonTip", { SkipQuestStatusCheck = true,  } ) --Silent = true
	-- Count towards rewards card progress
	game.HandleCharonPurchase( "ModsNikkelMCharonsTipJarTipCharon", moneyTipped )
	-- Update UI
	game.UpdateMoneyUI( true )
	-- Play sound and animation
	game.ShoppingSuccessItemPresentation( game.UnitSetData.NPC_Charon.NPC_Charon_01 )
end

-- Reset the Charon unit set data when entering the Crossroads, to make sure the tipping logic is removed in case he appears
-- TODO: Test if this is needed
-- modutil.mod.Path.Wrap("DeathAreaRoomTransition", function(base, source, args)
-- 	game.UnitSetData.NPC_Charon = originalCharonUnitSetData
-- 	base(source, args)
-- end)

