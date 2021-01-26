#include <chat-processor>
#include <cstrike>

#define MAX_MESSAGE_LENGTH 250
Database g_hDatabase;

Menu g_mColorsMenu, g_mNameMenu;

char g_szSteamID[MAXPLAYERS+1][32];

bool veteran[MAXPLAYERS + 1] = false;
bool trusted[MAXPLAYERS + 1] = false;
int grad[MAXPLAYERS + 1] = 0;

public Plugin myinfo = { 
  name = "Tags", 
  author = "Lawyn#5015", 
  description = "Official plugin made by Lawyn#5015 | JB.NEVERGO.RO", 
  version = "2.3",
  url = "https://nevergo.ro"
};

char g_sColorNames[][] =  {
    "DEFAULT", 
    "DARKRED", 
    "GREEN", 
    "TEAM", 
    "OLIVE", 
    "LIME", 
    "RED", 
    "GREY", 
    "YELLOW", 
    "GOLD", 
    "SILVER", 
    "BLUE", 
    "DARKBLUE", 
    "BLUEGREY", 
    "PINK", 
    "LIGHTRED"
};
char g_sColorCodes[][] =  {
    "\x01", 
    "\x02", 
    "\x04", 
    "\x03", 
    "\x05", 
    "\x06", 
    "\x07", 
    "\x08", 
    "\x09", 
    "\x10", 
    "\x0A", 
    "\x0B", 
    "\x0C", 
    "\x0D", 
    "\x0E", 
    "\x0F"
};

enum ChatData {
    Chat, 
    Name,
    String:ChatHex[16],
    String:NameHex[128],
    String:Tag[128]
};

int g_iPlayerInfo[MAXPLAYERS + 1][ChatData];
bool g_bLate = false;

public APLRes AskPluginLoad2(Handle myself, bool late, char[] err, int len)
{
    g_bLate = late;
}

public void OnPluginStart()
{    
    DB_Load();
    RegAdminCmd("sm_chatcolors", Command_Colors, ADMFLAG_CUSTOM3);
    RegAdminCmd("sm_namecolors", Command_NameColors, ADMFLAG_CUSTOM3);
	RegAdminCmd("sm_cc", Command_Colors, ADMFLAG_CUSTOM3);
    RegAdminCmd("sm_nc", Command_NameColors, ADMFLAG_CUSTOM3);
    RegConsoleCmd("sm_tags", tags);
	HookEvent("player_spawn", Event_PlayerSpawn);
    
    if (g_bLate)
    {
        for (int i = 1; i <= MaxClients; i++)
        if (IsClientInGame(i))
            OnClientPostAdminCheck(i);
    }
}

public Action Event_PlayerSpawn(Handle event, char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	char i1[256], i2[256], i3[256], i4[256], i5[256], i6[256], i7[256], i8[256], i9[256], i10[256], i11[256], i12[256], i13[256];
	char sName[128];
    GetClientName(client, sName, sizeof(sName));
	if(client > 0 && IsClientInGame(client)) 
    { 
        char szSteamID[32] 
        GetClientAuthId(client, AuthId_Steam2, szSteamID, sizeof(szSteamID)) 
		if(GetUserFlagBits(client) & ADMFLAG_ROOT && grad[client] == 7) 
        {
        	Format(i3, 256, "[Owner] (#%i)", GetClientUserId(client));
	        CS_SetClientClanTag(client, i3);
        } 
        else if(GetUserFlagBits(client) & ADMFLAG_UNBAN && grad[client] == 6)  
        {
            Format(i4, 256, "[Co-Owner] (#%i)", GetClientUserId(client));
	        CS_SetClientClanTag(client, i4);
        }
		else if(GetUserFlagBits(client) & ADMFLAG_RESERVATION && grad[client] == 5) 
        {
        	Format(i5, 256, "[Operator] (#%i)", GetClientUserId(client));
	        CS_SetClientClanTag(client, i5);
        } 
		else if(GetUserFlagBits(client) & ADMFLAG_BAN && grad[client] == 4) 
        {
        	Format(i6, 256, "[Moderator] (#%i)", GetClientUserId(client));
	        CS_SetClientClanTag(client, i6);
            //CS_SetClientClanTag(client, "[Moderator] (#%i)", GetClientUserId(client)) 
        }
        else if(GetUserFlagBits(client) & ADMFLAG_VOTE && grad[client] == 3) 
		{
			Format(i7, 256, "[Admin] (#%i)", GetClientUserId(client));
	        CS_SetClientClanTag(client, i7);
            //CS_SetClientClanTag(client, "[Admin] (#%i)", GetClientUserId(client)) 
        }
        else if(GetUserFlagBits(client) & ADMFLAG_SLAY && grad[client] == 2) 
        {
        	Format(i8, 256, "[Helper] (#%i)", GetClientUserId(client));
	        CS_SetClientClanTag(client, i8);
            //CS_SetClientClanTag(client, "[Helper] (#%i)", GetClientUserId(client)) 
        }
		else if((GetUserFlagBits(client) & ADMFLAG_CUSTOM1) && grad[client] == 1) 
        {
        	Format(i9, 256, "[VIP] (#%i)", GetClientUserId(client));
	        CS_SetClientClanTag(client, i9);
            //CS_SetClientClanTag(client, "[VIP] (#%i)", GetClientUserId(client)) 
        }
        else
        {
        	Format(i13, 256, "(#%i)", GetClientUserId(client));
	        CS_SetClientClanTag(client, i13);
       	}
		if (StrEqual(szSteamID, "STEAM_1:1:540063729"))
        {
        	Format(i11, 256, "[Nasu`] (#%i)", GetClientUserId(client));
	        CS_SetClientClanTag(client, i11);
            //CS_SetClientClanTag(client, "[Nasu`] (#%i)", GetClientUserId(client)) 
        }
		if (StrEqual(szSteamID, "STEAM_1:0:533509135"))
        {
        	Format(i12, 256, "[YouTuber] (#%i)", GetClientUserId(client));
	        CS_SetClientClanTag(client, i12);
            //CS_SetClientClanTag(client, "[YouTuber] (#%i)", GetClientUserId(client)) 
        }
    }
}

public Action Command_Colors(int client, int args)
{
    if (0 >= client > MaxClients)
        return Plugin_Handled;
    
    if (!IsClientInGame(client))
        return Plugin_Handled;
    
    g_mColorsMenu.Display(client, MENU_TIME_FOREVER);
    return Plugin_Handled;
}

public Action Command_NameColors(int client, int args)
{
    if (0 >= client > MaxClients)
        return Plugin_Handled;
    
    if (!IsClientInGame(client))
        return Plugin_Handled;
    
    g_mNameMenu.Display(client, MENU_TIME_FOREVER);
    return Plugin_Handled;
}

public void OnClientPostAdminCheck(int client)
{
	grad[client] = 0;
	char i1[256], i2[256];
	char sName[128];
	GetClientName(client, sName, sizeof(sName));
	if(GetUserFlagBits(client) & ADMFLAG_ROOT) 
    {
        grad[client] = 7;
    } 
    else if(GetUserFlagBits(client) & ADMFLAG_UNBAN)  
    {
        grad[client] = 6;
    }
	else if(GetUserFlagBits(client) & ADMFLAG_RESERVATION) 
    {
        grad[client] = 5;
    } 
	else if(GetUserFlagBits(client) & ADMFLAG_BAN) 
    {
        grad[client] = 4;
    }
    else if(GetUserFlagBits(client) & ADMFLAG_VOTE) 
	{
        grad[client] = 3;
    }
    else if(GetUserFlagBits(client) & ADMFLAG_SLAY) 
    {
        grad[client] = 2;
    }
	else if(GetUserFlagBits(client) & ADMFLAG_CUSTOM1) 
    {
        grad[client] = 1;
    }
	veteran[client] = false;
	trusted[client] = false;
    g_iPlayerInfo[client][Chat] = 0;
    g_iPlayerInfo[client][Name] = 3;
    CreateTimer(1.5, Timer_LoadDelay, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
    GetClientAuthId(client, AuthId_Steam2, g_szSteamID[client], sizeof(g_szSteamID[]))
}

public Action Timer_LoadDelay(Handle timer, any userid)
{
    int client = GetClientOfUserId(userid);
    if (0 > client > MaxClients && !IsClientInGame(client))
        return Plugin_Handled;
    
    bool n = CheckCommandAccess(client, "sm_namecolors", ADMFLAG_CUSTOM6);
    bool chat = CheckCommandAccess(client, "sm_chatcolors", ADMFLAG_CUSTOM6);
    if (!n && !chat )
        return Plugin_Handled;
    char sQuery[256], steamid[64];
    if (!GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid)))
        return Plugin_Handled;
    int count = 0;
    if (n) { count++; }
    if (chat) { count++; }
    if (count > 1)
        Format(sQuery, sizeof(sQuery), "SELECT %s%s%s FROM customchat WHERE steamid='%s';", n ? "namecolor, " : "", chat ? "chatcolor, " : "", steamid);
    else
        Format(sQuery, sizeof(sQuery), "SELECT %s%s%s FROM customchat WHERE steamid='%s';", n ? "namecolor" : "", chat ? "chatcolor" : "", steamid);
    g_hDatabase.Query(DB_LoadColors, sQuery, userid);
    return Plugin_Handled;
}

public void DB_LoadColors(Database db, DBResultSet results, const char[] error, any data)
{
    if (db == null || results == null)
    {
        LogError("DB_LoadColors returned error: %s", error);
        return;
    }
    
    int client = GetClientOfUserId(data);
    if (0 > client > MaxClients && !IsClientInGame(client))
        return;
    if(results.RowCount <= 0)
        return;
    int chatcol, namecol;
    bool chat = results.FieldNameToNum("chatcolor", chatcol);
    bool name = results.FieldNameToNum("namecolor", namecol);
    results.FetchRow();
    
    if(chat)
        g_iPlayerInfo[client][Chat] = results.FetchInt(chatcol);
    if(name)
        g_iPlayerInfo[client][Name] = results.FetchInt(namecol);
}

void DB_Load()
{
    Database.Connect(DB_Connect, "chatcolors");
}

public void DB_Connect(Database db, const char[] error, any data)
{
    if (db == null)
    {
        LogError("DB_Connect returned invalid Database Handle");
        return;
    }
    
    g_hDatabase = db;
    db.Query(DB_Generic, "CREATE TABLE customchat (steamid varchar(64) NOT NULL, chatcolor INT DEFAULT 0, namecolor INT DEFAULT 4, tag varchar(64) DEFAULT NULL, PRIMARY KEY(steamid));");
}

public void DB_UpdateColors(int client)
{
    if (g_hDatabase == null)
        return;
    
    char sQuery[256], steamid[64];
    if (!GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid)))
        return;
    Format(sQuery, sizeof(sQuery), "INSERT INTO customchat (steamid, chatcolor, namecolor, tag) VALUES ('%s', %d, %d, '%s') ON DUPLICATE KEY UPDATE chatcolor=VALUES(chatcolor), namecolor=VALUES(namecolor), tag=VALUES(tag);", steamid, g_iPlayerInfo[client][Chat], g_iPlayerInfo[client][Name], g_iPlayerInfo[client][Tag]);
    g_hDatabase.Query(DB_Generic, sQuery);
}

public void DB_Generic(Database db, DBResultSet results, const char[] error, any data)
{
    if (db == null || results == null)
    {
        LogError("DB_Generic returned error: %s", error);
        return;
    }
}

public void OnMapStart()
{
    Menu menu = new Menu(MenuHandler_ChatColor);
    menu.SetTitle("Select your chat color!");
    for (int i = 0; i < sizeof(g_sColorNames); i++)
    {
        char info[16];
        IntToString(i, info, sizeof(info));
        menu.AddItem(info, g_sColorNames[i]);
    }
    menu.ExitButton = true;
    g_mColorsMenu = menu;
    
    Menu menu2 = new Menu(MenuHandler_NameColor);
    menu2.SetTitle("Select your name color!");
    for (int i = 0; i < sizeof(g_sColorNames); i++)
    {
        char info[16];
        IntToString(i, info, sizeof(info));
        menu2.AddItem(info, g_sColorNames[i]);
    }
    menu2.ExitButton = true;
    g_mNameMenu = menu2;
}

public void OnMapEnd()
{
    CloseMenu(g_mColorsMenu);
    CloseMenu(g_mNameMenu);
}

stock void CloseMenu(Menu& menu)
{
    if(menu != null)
    {
        CloseHandle(menu);
    }
    menu = null;
}

public int MenuHandler_ChatColor(Menu menu, MenuAction action, int client, int choice)
{
    if (action != MenuAction_Select)
        return;
    PrintToChat(client, " \x0C[ JBGO ] \x01Ti-ai setat culoarea la chat in %s%s", g_sColorCodes[choice],g_sColorNames[choice]);
    g_iPlayerInfo[client][Chat] = choice;
    DB_UpdateColors(client);
}

public int MenuHandler_NameColor(Menu menu, MenuAction action, int client, int choice)
{
    if (action != MenuAction_Select)
        return;
    PrintToChat(client, " \x0C[ JBGO ] \x01Ti-ai setat culoarea la nume in %s%s", g_sColorCodes[choice], g_sColorNames[choice]);
    g_iPlayerInfo[client][Name] = choice;
    DB_UpdateColors(client);
}

public Action OnChatMessage(int & author, Handle recipients, char[] name, char[] message)
{
    bool n = CheckCommandAccess(author, "sm_namecolors", ADMFLAG_CUSTOM6);
    bool chat = CheckCommandAccess(author, "sm_chatcolors", ADMFLAG_CUSTOM6);
    if (!n && !chat )
        return Plugin_Continue;
    
    char ctag[32];
    bool changed;
    bool needspace = false;
    if (chat)
    {
        if (g_iPlayerInfo[author][Chat] != 0)
        {
            Format(message, MAX_MESSAGE_LENGTH, "%s%s", g_sColorCodes[g_iPlayerInfo[author][Chat]], message);
            changed = true;
        }
        if (CheckCommandAccess(author, "sm_colors_parse", ADMFLAG_CUSTOM6))
            ProcessColors(message, MAX_MESSAGE_LENGTH);
    }
    
    if (n)
    {
        if (g_iPlayerInfo[author][Name] != 3)
        {
            Format(name, MAX_NAME_LENGTH, " %s%s", g_sColorCodes[g_iPlayerInfo[author][Name]], name);
            changed = true;
            needspace = true;
        }
    }


    Format(name, MAX_NAME_LENGTH, "%s%s%s", needspace ? " " : "", ctag, name);
    
    if (changed)
        return Plugin_Changed;
    return Plugin_Continue;
}

void ProcessColors(char[] buffer, int maxlen)
{
    for (int i = 1; i < sizeof(g_sColorNames); i++)
    {
        char tmp[32];
        Format(tmp, sizeof(tmp), "{%s}", g_sColorNames[i]);
        ReplaceString(buffer, maxlen, tmp, g_sColorCodes[i]);
    }
} 

public void OnClientDisconnect(int iClient) {
  g_szSteamID[iClient][0] = '\0';
}

public Action CP_OnChatMessage(int& iAuthor, ArrayList hRecipients, char[] szFlagString, char[] szName, char[] szMessage, bool& bProcessColors, bool& bRemoveColors) {
    //STEAM_1:0:528153588
	//STEAM_1:0:533509135
	char i1[256], i2[256], i3[256], i4[256], i5[256], i6[256], i7[256], i8[256], i9[256], i10[256], i11[256], i12[256], i13[256];
	char sName[128];
    char szSteamID[32];
    GetClientAuthId(iAuthor, AuthId_Steam2, szSteamID, sizeof(szSteamID));
	if (StrEqual(szSteamID, "STEAM_1:1:540063729")) {
		Format(i1, sizeof(i1), "[Nasu`] (#%i)", GetClientUserId(iAuthor));
		CS_SetClientClanTag(iAuthor, i1); 
        Format(szName, MAXLENGTH_NAME, " \x0E[Nasu`] \x10(#%i) %s%s", GetClientUserId(iAuthor),g_sColorCodes[g_iPlayerInfo[iAuthor][Name]], szName);
        Format(szMessage, MAX_MESSAGE_LENGTH, "%s%s", g_sColorCodes[g_iPlayerInfo[iAuthor][Chat]], szMessage);
        return Plugin_Changed;
    }
	if (StrEqual(szSteamID, "STEAM_1:0:533509135")) {
		Format(i2, sizeof(i2), "[YouTuber] (#%i)", GetClientUserId(iAuthor));
		CS_SetClientClanTag(iAuthor, i2); 
        Format(szName, MAXLENGTH_NAME, " \x07[YouTuber] \x10(#%i) %s%s", GetClientUserId(iAuthor),g_sColorCodes[g_iPlayerInfo[iAuthor][Name]], szName);
        Format(szMessage, MAX_MESSAGE_LENGTH, "%s%s", g_sColorCodes[g_iPlayerInfo[iAuthor][Chat]], szMessage);
        return Plugin_Changed;
    }
    int iFlagBits = GetUserFlagBits(iAuthor);
    if (iFlagBits & ADMFLAG_ROOT && grad[iAuthor] == 7) {
    	Format(i3, sizeof(i3), "[Owner] (#%i)", GetClientUserId(iAuthor));
		CS_SetClientClanTag(iAuthor, i3); 
        Format(szName, MAXLENGTH_NAME, " \x02[Owner] \x10(#%i) %s%s", GetClientUserId(iAuthor),g_sColorCodes[g_iPlayerInfo[iAuthor][Name]], szName); 
        Format(szMessage, MAX_MESSAGE_LENGTH, "%s%s", g_sColorCodes[g_iPlayerInfo[iAuthor][Chat]], szMessage);
    }
	else if (iFlagBits & ADMFLAG_UNBAN && grad[iAuthor] == 6) {
		Format(i4, sizeof(i4), "[Co-Owner] (#%i)", GetClientUserId(iAuthor));
		CS_SetClientClanTag(iAuthor, i4); 
        Format(szName, MAXLENGTH_NAME, " \x0E[Co-Owner] \x10(#%i) %s%s", GetClientUserId(iAuthor), g_sColorCodes[g_iPlayerInfo[iAuthor][Name]], szName);
        Format(szMessage, MAX_MESSAGE_LENGTH, "%s%s", g_sColorCodes[g_iPlayerInfo[iAuthor][Chat]], szMessage);
    }   
    else if (iFlagBits & ADMFLAG_RESERVATION && grad[iAuthor] == 5) {
    	Format(i5, sizeof(i5), "[Operator] (#%i)", GetClientUserId(iAuthor));
		CS_SetClientClanTag(iAuthor, i5); 
        Format(szName, MAXLENGTH_NAME, " \x07[Operator] \x10(#%i) %s%s", GetClientUserId(iAuthor),g_sColorCodes[g_iPlayerInfo[iAuthor][Name]], szName);
        Format(szMessage, MAX_MESSAGE_LENGTH, "%s%s", g_sColorCodes[g_iPlayerInfo[iAuthor][Chat]], szMessage);
    }
	else if (iFlagBits & ADMFLAG_BAN && grad[iAuthor] == 4) {
		Format(i6, sizeof(i6), "[Moderator] (#%i)", GetClientUserId(iAuthor));
		CS_SetClientClanTag(iAuthor, i6); 
        Format(szName, MAXLENGTH_NAME, " \x0B[Moderator] \x10(#%i) %s%s", GetClientUserId(iAuthor),g_sColorCodes[g_iPlayerInfo[iAuthor][Name]], szName);
        Format(szMessage, MAX_MESSAGE_LENGTH, "%s%s", g_sColorCodes[g_iPlayerInfo[iAuthor][Chat]], szMessage);
    }
    else if (iFlagBits & ADMFLAG_VOTE && grad[iAuthor] == 3) {
    	Format(i7, sizeof(i7), "[Admin] (#%i)", GetClientUserId(iAuthor));
		CS_SetClientClanTag(iAuthor, i7); 
        Format(szName, MAXLENGTH_NAME, " \x0B[Admin] \x10(#%i) %s%s", GetClientUserId(iAuthor),g_sColorCodes[g_iPlayerInfo[iAuthor][Name]], szName);
        Format(szMessage, MAX_MESSAGE_LENGTH, "%s%s", g_sColorCodes[g_iPlayerInfo[iAuthor][Chat]], szMessage);
    }          
    else if (iFlagBits & ADMFLAG_SLAY && grad[iAuthor] == 2) {
    	Format(i8, sizeof(i8), "[Helper] (#%i)", GetClientUserId(iAuthor));
		CS_SetClientClanTag(iAuthor, i8); 
        Format(szName, MAXLENGTH_NAME, " \x04[Helper] \x10(#%i) %s%s", GetClientUserId(iAuthor),g_sColorCodes[g_iPlayerInfo[iAuthor][Name]], szName);
        Format(szMessage, MAX_MESSAGE_LENGTH, "%s%s", g_sColorCodes[g_iPlayerInfo[iAuthor][Chat]], szMessage);
    }
	else if ((iFlagBits & ADMFLAG_CUSTOM1) && grad[iAuthor] == 1) {
		Format(i9, sizeof(i9), "[VIP] (#%i)", GetClientUserId(iAuthor));
		CS_SetClientClanTag(iAuthor, i9); 
        Format(szName, MAXLENGTH_NAME, " \x07[VIP] \x10(#%i) %s%s", GetClientUserId(iAuthor),g_sColorCodes[g_iPlayerInfo[iAuthor][Name]], szName);
        Format(szMessage, MAX_MESSAGE_LENGTH, "%s%s", g_sColorCodes[g_iPlayerInfo[iAuthor][Chat]], szMessage);
    }
    else
    {
    	Format(i13, sizeof(i13), "(#%i)", GetClientUserId(iAuthor));
    	CS_SetClientClanTag(iAuthor, i13); 
        Format(szName, MAXLENGTH_NAME, " \x10(#%i) %s%s", GetClientUserId(iAuthor),g_sColorCodes[g_iPlayerInfo[iAuthor][Name]], szName);
        Format(szMessage, MAX_MESSAGE_LENGTH, "%s%s", g_sColorCodes[g_iPlayerInfo[iAuthor][Chat]], szMessage);
   	}

    return Plugin_Changed; 
}

public Action tags(client, args)
{
	Menu tagmenu = new Menu(tagmenu_call);
	tagmenu.SetTitle("Lista tagurilor");
	tagmenu.AddItem("default", "Default", ITEMDRAW_DEFAULT);
	tagmenu.AddItem("vip", "VIP", (GetUserFlagBits(client) & ADMFLAG_CUSTOM1) ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	tagmenu.AddItem("helper", "Helper", (GetUserFlagBits(client) & ADMFLAG_SLAY) ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	tagmenu.AddItem("admin", "Admin", (GetUserFlagBits(client) & ADMFLAG_VOTE) ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	tagmenu.AddItem("moderator", "Moderator", (GetUserFlagBits(client) & ADMFLAG_BAN) ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	tagmenu.AddItem("operator", "Operator", (GetUserFlagBits(client) & ADMFLAG_RESERVATION) ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	tagmenu.AddItem("co-owner", "Co-Owner", (GetUserFlagBits(client) & ADMFLAG_UNBAN) ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	tagmenu.AddItem("owner", "Owner", (GetUserFlagBits(client) & ADMFLAG_ROOT) ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	tagmenu.Display(client, MENU_TIME_FOREVER);
}

public int tagmenu_call(Menu tagmenu, MenuAction action, client, param2)
{
	switch(action)
	{
		case MenuAction_End:
		{
			delete tagmenu;
		}
		case MenuAction_Select:
		{
			char item[56];
			tagmenu.GetItem(param2, item, sizeof(item));
			if(StrEqual(item, "default"))
			{
				grad[client] = 0;
				PrintToChat(client, " \x0C[ JBGO ] \x01Ti-ai setat tagul in \x08[Default]");
			}
			if(StrEqual(item, "vip"))
			{
				grad[client] = 1;
				PrintToChat(client, " \x0C[ JBGO ] \x01Ti-ai setat tagul in \x07[VIP]");
			}
			if(StrEqual(item, "helper"))
			{
				grad[client] = 2;
				PrintToChat(client, " \x0C[ JBGO ] \x01Ti-ai setat tagul in \x04[Helper]");
			}
			if(StrEqual(item, "admin"))
			{
				grad[client] = 3;
				PrintToChat(client, " \x0C[ JBGO ] \x01Ti-ai setat tagul in \x0B[Admin]");
			}
			if(StrEqual(item, "moderator"))
			{
				grad[client] = 4;
				PrintToChat(client, " \x0C[ JBGO ] \x01Ti-ai setat tagul in \x0B[Moderator]");
			}
			if(StrEqual(item, "operator"))
			{
				grad[client] = 5;
				PrintToChat(client, " \x0C[ JBGO ] \x01Ti-ai setat tagul in \x07[Operator]");
			}
			if(StrEqual(item, "co-owner"))
			{
				grad[client] = 6;
				PrintToChat(client, " \x0C[ JBGO ] \x01Ti-ai setat tagul in \x0E[Co-Owner]");
			}
			if(StrEqual(item, "owner"))
			{
				grad[client] = 7;
				PrintToChat(client, " \x0C[ JBGO ] \x01Ti-ai setat tagul in \x02[Owner]");
			}
			if(StrEqual(item, "trusted"))
			{
				grad[client] = 9;
				PrintToChat(client, " \x0C[ JBGO ] \x01Ti-ai setat tagul in \x05[Trusted]");
			}
			if(StrEqual(item, "veteran"))
			{
				grad[client] = 8;
				PrintToChat(client, " \x0C[ JBGO ] \x01Ti-ai setat tagul in \x0C[Veteran]");
			}
			if(StrEqual(item, "getgift2020"))
			{
				grad[client] = -1;
				PrintToChat(client, " \x0C[ JBGO ] \x01Ti-ai setat tagul in \x02[\x06NEVERGO\x0C2020\x02]");
			}
		}
	}
}
