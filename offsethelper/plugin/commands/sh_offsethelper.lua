local COMMAND = Clockwork.command:New("OffsetHelper");

COMMAND.tip = "Helps you setup item weapon offsets.";
COMMAND.text = "<string UniqueID>";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER);
COMMAND.access = "s";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local weapon = Clockwork.item:FindByID(arguments[1]);

	if (weapon) then
		if (Clockwork.item:IsWeapon(weapon)) then
			Clockwork.datastream:Start(player, "OpenOffsetHelper", {uniqueID = weapon.uniqueID});
		else
			Clockwork.player:Notify(player, "This item is not a valid weapon!");
		end;
	else
		Clockwork.player:Notify(player, "This is not a valid item!");
	end;
end;

COMMAND:Register();