KeywordIgnore = {
};
KeywordIgnore.autoIgnoremsgSend = 0;
local Org_ChatFrame_OnEvent;
local IGlastWisperPlayer = "";
UIPanelWindows["KeywordIgnoreFrame"] = { area = "left", pushable = 999 };
StaticPopupDialogs["ADD_KEYWORDIGNORE"] = {
	text = KEYWORDIGNORE_TEXT1,
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	hasEditBox = 1,
	maxLetters = 32,
	OnAccept = function()
		local editBox = getglobal(this:GetParent():GetName().."EditBox");
		AddIgnoreKeyword(editBox:GetText());
	end,
	OnShow = function()
		getglobal(this:GetName().."EditBox"):SetFocus();
	end,
	OnHide = function()
		if ( ChatFrameEditBox:IsVisible() ) then
			ChatFrameEditBox:SetFocus();
		end
		getglobal(this:GetName().."EditBox"):SetText("");
	end,
	EditBoxOnEnterPressed = function()
		local editBox = getglobal(this:GetParent():GetName().."EditBox");
		AddIgnoreKeyword(editBox:GetText());
		this:GetParent():Hide();
	end,
	EditBoxOnEscapePressed = function()
		this:GetParent():Hide();
	end,
	timeout = 0,
	exclusive = 1,
	whileDead = 1
};

function AddIgnoreKeyword(keyword)
	for k,v in KeywordIgnore.KeywordList do
		if (v==keyword) then return; end
	end
	table.insert(KeywordIgnore.KeywordList,keyword);
	table.sort(KeywordIgnore.KeywordList);
	for k,v in KeywordIgnore.KeywordList do
		if (v==keyword) then 
			KeywordIgnoreFrame.selectedIgnore = k;
			break;
		end
	end
	if (KeywordIgnoreFrame.selectedIgnore>FauxScrollFrame_GetOffset(KeywordIgnoreFrameKeywordIgnoreScrollFrame)+IGNORES_TO_DISPLAY) then
		FauxScrollFrame_SetOffset(KeywordIgnoreFrameKeywordIgnoreScrollFrame,KeywordIgnoreFrame.selectedIgnore-IGNORES_TO_DISPLAY);
	end
	KeywordIgnoreList_Update();
end

function KeywordIgnoreFrameKeywordIgnoreButton_OnClick()
	KeywordIgnoreFrame.selectedIgnore = this:GetID();
	KeywordIgnoreList_Update();
end

function KeywordIgnoreFrame_UnIgnore()
	if (KeywordIgnoreFrame.selectedIgnore>FauxScrollFrame_GetOffset(KeywordIgnoreFrameKeywordIgnoreScrollFrame)+IGNORES_TO_DISPLAY) then
		return; 
	end
	table.remove(KeywordIgnore.KeywordList,KeywordIgnoreFrame.selectedIgnore);
	KeywordIgnoreList_Update();
end

function KeywordIgnoreList_Update()
	local numIgnores = table.getn(KeywordIgnore.KeywordList);
	local nameText;
	local name;
	local ignoreButton;
	if ( numIgnores > 0 ) then
		if ( KeywordIgnoreFrame.selectedIgnore == 0 ) then
			KeywordIgnoreFrame.selectedIgnore = 1;
		end
		KeywordIgnoreFrameStopKeywordIgnoreButton:Enable();
	else
		KeywordIgnoreFrameStopKeywordIgnoreButton:Disable();
	end

	local ignoreOffset = FauxScrollFrame_GetOffset(KeywordIgnoreFrameKeywordIgnoreScrollFrame);
	local ignoreIndex;
	for i=1, IGNORES_TO_DISPLAY, 1 do
		ignoreIndex = i + ignoreOffset;
		nameText = getglobal("KeywordIgnoreFrameKeywordIgnoreButton"..i.."ButtonTextName");
		nameText:SetText(KeywordIgnore.KeywordList[ignoreIndex]);
                nameText:SetFont("Interface\\AddOns\\CustomNameplates\\Fonts\\Basic.ttf",14);
		ignoreButton = getglobal("KeywordIgnoreFrameKeywordIgnoreButton"..i);
		ignoreButton:SetID(ignoreIndex);
		-- Update the highlight
		if ( ignoreIndex == KeywordIgnoreFrame.selectedIgnore ) then
			ignoreButton:LockHighlight();
		else
			ignoreButton:UnlockHighlight();
		end
		
		if ( ignoreIndex > numIgnores ) then
			ignoreButton:Hide();
		else
			ignoreButton:Show();
		end
	end
	
	-- ScrollFrame stuff
	FauxScrollFrame_Update(KeywordIgnoreFrameKeywordIgnoreScrollFrame, numIgnores, IGNORES_TO_DISPLAY, FRIENDS_FRAME_IGNORE_HEIGHT );
end

function KeywordIgnoreFrame_OnShow()
	KeywordIgnoreList_Update();
end

function KeywordIgnoreFrame_OnHide()
end

function ToggleKeywordIgnoreFrame()
	if ( KeywordIgnoreFrame:IsVisible() ) then
		HideUIPanel(KeywordIgnoreFrame);
	else
		ShowUIPanel(KeywordIgnoreFrame);
	end
end

function KeywordIgnoreFrame_OnEvent()
	if (event == "VARIABLES_LOADED") then
		if (not KeywordIgnore.Config) then
			KeywordIgnore.Config = {};
		end
		
		if (not KeywordIgnore.KeywordList) then
			KeywordIgnore.KeywordList = {};
		end
		
		if (not KeywordIgnore.Config.IgnoreNameOnly) then
			KeywordIgnore.Config.IgnoreNameOnly = 1;
		end

		if (not KeywordIgnore.Config.Enable) then
			KeywordIgnore.Config.Enable = 1;
		end

		KeywordIgnoreFrameEnableButton:SetChecked(KeywordIgnore.Config.Enable);
		KeywordIgnoreFrameIgnoreNameButton:SetChecked(KeywordIgnore.Config.IgnoreNameOnly);
		if ( EarthFeature_AddButton ) then
			EarthFeature_AddButton(
				{
					id="KEYWORDIGNORE";
					name=KEYWORDIGNORE_TEXT2;
					subtext="";
					helptext=KEYWORDIGNORE_TEXT3;
					icon="Interface\\Icons\\Ability_Rogue_KidneyShot";
					callback=ToggleKeywordIgnoreFrame;
				}
			);
		end
	end
end

local function KeywordIgnore_Check(player,msg)
	local found=false;
	for k,v in KeywordIgnore.KeywordList do
		v = ".*"..v..".*";
		found = string.find(player, v);
		if ((not found) and KeywordIgnore.Config.IgnoreNameOnly~=1) then
			found = string.find(msg, v);
		end
		if (found) then
			break;
		end
	end
	return found;
end

function KeywordIgnore_ChatFrame_OnEvent(event)
	if ((event == "CHAT_MSG_CHANNEL" or event == "CHAT_MSG_YELL" or event == "CHAT_MSG_SAY" or event == "CHAT_MSG_TEXT_EMOTE" or event == "CHAT_MSG_EMOTE") and KeywordIgnore.Config.Enable == 1) then
		local KeywordIgnore_msg = arg1;
		local KeywordIgnore_player = arg2;
		if (KeywordIgnore_msg ~= nil or KeywordIgnore_player ~= nil or KeywordIgnore_player~=UnitName("player")) then
			if (KeywordIgnore_Check(KeywordIgnore_player,KeywordIgnore_msg)) then
				return;
			end
		end
	end
	if ((event == "CHAT_MSG_WHISPER") and KeywordIgnore.Config.Enable == 1) then
		local KeywordIgnore_msg = arg1;
		local KeywordIgnore_player = arg2;
		if (KeywordIgnore_msg ~= nil and KeywordIgnore_player ~= nil and KeywordIgnore_player~=UnitName("player")) then
			if (KeywordIgnore_Check(KeywordIgnore_player,KeywordIgnore_msg)) then
				if (IGlastWisperPlayer == arg2) then
					return;			
				end
				if (KeywordIgnore.autoIgnoremsgSend == 1) then
					local language = GetDefaultLanguage("unit");
					SendChatMessage(autoIgnoremsg,"WHISPER",language,KeywordIgnore_player);
					IGlastWisperPlayer = arg2;
				end
				return;
			end
		end		
	end
	Org_ChatFrame_OnEvent(event);
end

function KeywordIgnoreFrame_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	KeywordIgnoreFrame.selectedIgnore = 1;
	
	Org_ChatFrame_OnEvent = ChatFrame_OnEvent;
	ChatFrame_OnEvent = KeywordIgnore_ChatFrame_OnEvent;

	SLASH_IGNOREPLAYER1 = "/IgnorePlayer";
	SlashCmdList["IGNOREPLAYER"] = function(msg)
		ToggleKeywordIgnoreFrame();
	end
	
end

function KeywordIgnoreFrame_LoadConfig()
  
  gLim_RegisterConfigClass(
	"gLimIgnore",
	"KeywordIgnore",
	"Pigbaby"
	);
  gLim_RegisterConfigSection(
	"gLimIgnoreSection",
	"智能屏蔽",
	"智能屏蔽 by Pigbaby(gLim开发小组)",
	"Pigbaby",
	"gLimIgnore");
  gLim_RegisterConfigCheckBox(
	"gLimIgnore_Enable",
	"是否开启自动回复",
	"屏蔽不良信息的同时发送回复警告对方",
	KeywordIgnore.autoIgnoremsgSend,
	autoIgnoremsgSend_Enable,
	"gLimIgnore"
	);
  gLim_RegisterConfigButton(
	"gLimIgnore_Options",
	"打开屏蔽语言的设置窗口",
	"打开屏蔽语言的设置窗口",
	"详细设置",
	function()
		ToggleKeywordIgnoreFrame();
	end,
	"gLimIgnore"
	);
  
end
function autoIgnoremsgSend_Enable(toggle)
	KeywordIgnore.autoIgnoremsgSend = toggle;
end