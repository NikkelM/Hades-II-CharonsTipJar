local mod = modutil.mod.Mod.Register(_PLUGIN.guid)

table.insert(game.RoomSetData.F.F_PreBoss01.StartUnthreadedEvents,
	{
		-- TODO: Spawn mailbox in final preboss rooms
		FunctionName = _PLUGIN.guid .. '.' .. 'SpawnCharonsTipJar'
	})

function mod.SpawnCharonsTipJar()
	-- Charon NPC
	local spawnId = 561301 -- TODO: This is in F_PreBoss -- check others
	local tipJar = game.DeepCopyTable(game.HubRoomData.Hub_Main.ObstacleData[583652])
	tipJar.OnUsedFunctionName = _PLUGIN.guid .. '.' .. 'TipCharon'
	tipJar.UseText = "ModsNikkelMCharonsTipJar_TipJarUseText"
	tipJar.ObjectId = SpawnObstacle({
		Name = "SupplyDropObject",
		Group = "FX_Terrain",
		DestinationId = spawnId,
		AttachedTable = tipJar,
		OffsetX = 0,
		OffsetY = 300,
	})
	tipJar.ActivateIds = { tipJar.ObjectId }
	tipJar.SetupEvents = {}
	SetScale({ Id = tipJar.ObjectId, Fraction = 0.2 })
	game.SetupObstacle(tipJar)
	AddToGroup({ Id = tipJar.ObjectId, Name = "ModsNikkelMCharonsTipJar.TipJar" })
end


-- TODO: If the player has no money when approaching Charon, use the normal salute useText and function name
function mod.TipCharon(usee, args)
	print(usee.ObjectId)
	local moneyTipped = game.GameState.Resources.Money
	if moneyTipped == 0 then
		return
	end

	-- Remove money
	game.SpendResources({ Money = moneyTipped }, "ModsNikkelMCharonsTipJarCharonTip")
	-- Count towards rewards card progress
	game.HandleCharonPurchase("ModsNikkelMCharonsTipJarTipCharon", moneyTipped)
	-- Update UI
	game.UpdateMoneyUI(true)
	-- Play sound and animation
	game.ShoppingSuccessItemPresentation(usee)
	-- Play the normal interact animation, using the custom voicelines defined above
	game.SpecialInteractSalute(usee, args)
end