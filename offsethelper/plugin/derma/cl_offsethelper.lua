local PANEL = {};

function PANEL:Init()
	local scrW, scrH = ScrW(), ScrH();
	local itemTable = Clockwork.item:FindByID(LocalPlayer().vohUniqueID);

	local defaults = {
		loweredOrigin = Vector(itemTable.loweredOrigin.x, itemTable.loweredOrigin.y, itemTable.loweredOrigin.z);
		loweredAngles = Angle(itemTable.loweredAngles.x, itemTable.loweredAngles.y, itemTable.loweredAngles.z);
		attachmentOffsetVector = Vector(itemTable.attachmentOffsetVector.x, itemTable.attachmentOffsetVector.y ,itemTable.attachmentOffsetVector.z);
		attachmentOffsetAngles = Angle(itemTable.attachmentOffsetAngles.x, itemTable.attachmentOffsetAngles.y, itemTable.attachmentOffsetAngles.z);
	};
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
		for k, v in pairs(categories) do
			for i=120,122 do
				local c = string.char(i);

				itemTable[v][c] = defaults[v][c];
			end;
		end;

		LocalPlayer().vohUniqueID = nil;
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
	self.loweredOriginCat = catList:Add("Lowered Origin");
	self.loweredAnglesCat = catList:Add("Lowered Angles");
	self.attachmentOffsetVectorCat = catList:Add("Attachment Vector");
	self.attachmentOffsetAnglesCat = catList:Add("Attachment Angles");

	local panels = {}

	for k, v in pairs(categories) do
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
			if (string.find(v, "Angles")) then
				panels[v][c]:SetMin(-180);
				panels[v][c]:SetMax(180);
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
end;

vgui.Register("vizOffsetHelper", PANEL);