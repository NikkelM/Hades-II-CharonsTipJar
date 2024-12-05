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
	-- TODO: If the player has no money when approaching Charon, use a different useText
	tipJar.UseText = "ModsNikkelMCharonsTipJar_TipJarUseText"
	tipJar.ObjectId = SpawnObstacle({
		Name = "SupplyDropObject",
		-- TODO: Mailbox is currently always behind Melinoe, should be in front of her model if she is standing behind it
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

function mod.TipCharon(usee, args)
	local moneyTipped = game.GameState.Resources.Money
	if moneyTipped == 0 then
		return
	end
	AddInputBlock({ Name = "MelUsedTipJar" })

	-- Play gift giving animation
	GiftGivingAnimation(usee)

	-- Remove money
	game.SpendResources({ Money = moneyTipped }, "ModsNikkelMCharonsTipJarCharonTip")
	-- Count towards rewards card progress
	game.HandleCharonPurchase("ModsNikkelMCharonsTipJarTipCharon", moneyTipped)
	-- Update UI
	game.UpdateMoneyUI(true)
	-- Play sound as if buying something
	game.ShoppingSuccessItemPresentation(usee)
	-- Replace tip jar with closed version, and disable using it
	SetAnimation({ Name = "SupplyDropObjectClosed", DestinationId = usee.ObjectId })
	UseableOff({ Id = usee.ObjectId })

	game.wait(0.2)
	RemoveInputBlock({ Name = "MelUsedTipJar" })
end

function GiftGivingAnimation(usee)
	AngleTowardTarget({ Id = game.CurrentRun.Hero.ObjectId, DestinationId = usee.ObjectId })
	SetAnimation({ Name = "MelTalkGifting01", DestinationId = game.CurrentRun.Hero.ObjectId })

	game.wait(0.40)
	SetAnimation({ Name = "MelTalkGifting01ReturnToIdle", DestinationId = game.CurrentRun.Hero.ObjectId })
	game.wait(0.65)
end
