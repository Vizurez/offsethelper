local PANEL = {};

function PANEL:Init()
	local scrW, scrH = ScrW(), ScrH();
	local itemTable = Clockwork.item:FindByID(Clockwork.Client.vohUniqueID);

	local defaults = {};

	if (itemTable.AdjustAttachmentOffsetInfo) then
		local inventoryItems = Clockwork.inventory:GetItemsByID(Clockwork.inventory.client, itemTable.uniqueID);

		if (inventoryItems) then
			for k, v in pairs(inventoryItems) do
				v.AdjustAttachmentOffsetInfo = nil;
			end;
		end;

		defaults.AdjustAttachmentOffsetInfo = itemTable.AdjustAttachmentOffsetInfo;
		itemTable.AdjustAttachmentOffsetInfo = nil;
	end;

	local categories = {
		"loweredOrigin",
		"loweredAngles",
		"attachmentOffsetVector",
		"attachmentOffsetAngles"
	};

	local main = vgui.Create("DFrame");
	main:SetTitle("Viz Offset Helper");
	main:SetSize(0.156 * scrW, 0.277 * scrH); // 300, 300
	main:Center();
	main:SetSizable(true);
	main:MakePopup();
	main.OnClose = function(panel)
		if (defaults.AdjustAttachmentOffsetInfo) then
			local inventoryItems = Clockwork.inventory:GetItemsByID(Clockwork.inventory.client, itemTable.uniqueID);

			if (inventoryItems) then
				for k, v in pairs(inventoryItems) do
					v.AdjustAttachmentOffsetInfo = defaults.AdjustAttachmentOffsetInfo;
				end;
			end;

			itemTable.AdjustAttachmentOffsetInfo = defaults.AdjustAttachmentOffsetInfo;
		end;

		for k, v in pairs(categories) do
			if (!itemTable[v]) then continue; end;

			for i=120,122 do
				local c = string.char(i);

				itemTable[v][c] = defaults[v][c];
			end;
		end;

		Clockwork.Client.vohUniqueID = nil;
	end;

	local labelPanel = vgui.Create("DPanel", main)
	labelPanel:Dock(TOP);
	labelPanel:DockMargin(1, 0, 1, 4);
	labelPanel:SetTall(20);

	local label = vgui.Create("DLabel", labelPanel);
	label:SetText("Closing this panel will reset all values!");
	label:SetFont("DermaDefaultBold");
	label:SetPaintBackgroundEnabled(true);
	label:SetBGColor(Color(255, 255, 255, 255));
	label:SetTextColor(Color(0, 0, 0, 255));
	label:SetContentAlignment(5);
	label:Dock(FILL);

	local catList = vgui.Create("DCategoryList", main);
	catList:Dock(FILL);

	local panels = {}

	for k, v in pairs(categories) do
		if (!itemTable[v]) then continue; end;

		if (string.find(v, "Angle")) then
			defaults[v] = Angle(itemTable[v].x, itemTable[v].y, itemTable[v].z);
		else
			defaults[v] = Vector(itemTable[v].x, itemTable[v].y, itemTable[v].z);
		end;

		self[v.."Cat"] = catList:Add("ITEM."..v);
		self[v.."Cat"]:SetExpanded(0);
		self[v.."Panel"] = vgui.Create("Panel");
		panels[v] = {};

		panels[v].reset = vgui.Create("DButton", self[v.."Panel"]);
		panels[v].reset:Dock(TOP);
		panels[v].reset:DockMargin(4, 4, 4, 0);
		panels[v].reset:SetText("RESET");
		panels[v].reset:SizeToContents();

		for i=120,122 do
			local c = string.char(i);

			panels[v][c] = vgui.Create("DNumSlider", self[v.."Panel"]);
			panels[v][c]:Dock(TOP);
			panels[v][c]:DockMargin(4, 4, 4, 0);
			if (string.find(v, "Angle")) then
				panels[v][c]:SetMin(0);
				panels[v][c]:SetMax(360);
			else
				panels[v][c]:SetMin(-64);
				panels[v][c]:SetMax(64);
			end;
			panels[v][c]:SetText(string.upper(c)..":");
			panels[v][c]:SetDark(true);
			panels[v][c]:SetValue(defaults[v][c]);
			panels[v][c].OnValueChanged = function(panel, value)
				itemTable[v][c] = value;
			end;
		end;

		panels[v].reset.DoClick = function(panel)
			for i=120,122 do
				local c = string.char(i);

				panels[v][c]:SetValue(defaults[v][c]);
			end;
		end;

		self[v.."Cat"]:SetContents(self[v.."Panel"]);
	end;

	for k, v in pairs(panels) do
		if (string.find(k, "Angle")) then
			v.x:SetText("Pitch:");
			v.y:SetText("Yaw:");
			v.z:SetText("Roll:");
		end;
	end;
end;

vgui.Register("vizOffsetHelper", PANEL);