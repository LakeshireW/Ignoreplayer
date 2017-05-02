--Chinese (by iWOW)

if (GetLocale() == "zhCN") then

BINDING_HEADER_IGNOREPLAYER_TITLE = "关键字屏蔽";
BINDING_NAME_IGNOREPLAYER_TOGGLE = "关键字屏蔽选项";

KEYWORDIGNORE_TEXT1 = "输入想要屏蔽的关键字";
KEYWORDIGNORE_TEXT2 = "关键字屏蔽";
KEYWORDIGNORE_TEXT3 = "使你能使用关键字屏蔽讨厌的人，比如卖金币的，刷屏的";
KEYWORDIGNORE_UI_TEXT1 = "关键字屏蔽列表";
KEYWORDIGNORE_UI_TEXT2 = "启用关键字屏蔽";
KEYWORDIGNORE_UI_TEXT3 = "仅屏蔽名字";
KEYWORDIGNORE_UI_TEXT4 = "屏蔽关键字";
KEYWORDIGNORE_UI_TEXT5 = "删除关键字";

KEYWORDIGNORE_UI_TOOLTIP1 = "选择时使用关键字屏蔽功能.";
KEYWORDIGNORE_UI_TOOLTIP2 = "选择时仅对名字进行过滤，否则对所有发言进行过滤.";
KEYWORDIGNORE_UI_TOOLTIP3 = "添加过滤聊天频道所用的关键字.";
KEYWORDIGNORE_UI_TOOLTIP4 = "将选定的关键字移除出你的过滤列表";
autoIgnoremsg = "你的语言已被防火墙屏蔽.";

else

BINDING_HEADER_IGNOREPLAYER_TITLE = "Key word filter";
BINDING_NAME_IGNOREPLAYER_TOGGLE = "Options";

KEYWORDIGNORE_TEXT1 = "Enter the keyword";
KEYWORDIGNORE_TEXT2 = "Key word filter";
KEYWORDIGNORE_TEXT3 = "allow you to ignore ,such as gold seller ,spam";
KEYWORDIGNORE_UI_TEXT1 = "Ignore list";
KEYWORDIGNORE_UI_TEXT2 = "Keywords";
KEYWORDIGNORE_UI_TEXT3 = "Name";
KEYWORDIGNORE_UI_TEXT4 = "Add";
KEYWORDIGNORE_UI_TEXT5 = "Delete";

KEYWORDIGNORE_UI_TOOLTIP1 = "Filter chat message by keywords";
KEYWORDIGNORE_UI_TOOLTIP2 = "Filter chat message by name";
KEYWORDIGNORE_UI_TOOLTIP3 = "Add the keyword to list";
KEYWORDIGNORE_UI_TOOLTIP4 = "Remove the keyword from list";
autoIgnoremsg = "Your message has been blocked.";


end