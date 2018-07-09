if (CLIENT) then
	Clockwork.datastream:Hook("OpenOffsetHelper", function(data)
		LocalPlayer().vohUniqueID = data.uniqueID;
		vgui.Create("vizOffsetHelper");
	end);
end;