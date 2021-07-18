// sp-jailbreak
// Copyright (C) 2021  Adam Short

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

#pragma semicolon 1

#define PLUGIN_NAME         "CS:S Jailbreak"
#define PLUGIN_AUTHOR       "organharvester, Jordi, Dunder"
#define PLUGIN_DESCRIPTION  "Jailbreak Warden Plugin"
#define PLUGIN_VERSION      "4.3"
#define PLUGIN_URL          "https://github.com/ashort96/sp-jailbreak"

#include <jailbreak>
#include <sourcemod>

#pragma newdecls required

#include "jailbreak/block.sp"
#include "jailbreak/circle.sp"
#include "jailbreak/forwards.sp"
#include "jailbreak/laser.sp"
#include "jailbreak/marker.sp"
#include "jailbreak/warday.sp"
#include "jailbreak/warden.sp"
#include "jailbreak/warden_hud.sp"
#include "jailbreak/warden_text.sp"

ConVar g_ConVarPrefix;
ConVar g_ConVarWardenPrefix;
ConVar g_ConVarWardenChatPrefix;
ConVar g_ConVarWardayCooldown;

public Plugin myinfo =
{
    name = PLUGIN_NAME,
    author = PLUGIN_AUTHOR,
    description = PLUGIN_DESCRIPTION,
    version = PLUGIN_VERSION,
    url = PLUGIN_URL
}

public void OnMapStart()
{
    Circle_OnMapStart();
    Laser_OnMapStart();
    Marker_OnMapStart();
    Warday_OnMapStart();
}

public void OnPluginStart()
{

    EngineVersion game = GetEngineVersion();

    if (game != Engine_CSS)
    {
        SetFailState("This plugin is for CS:S only!");
    }

    Block_OnPluginStart();
    Circle_OnPluginStart();
    Laser_OnPluginStart();
    Marker_OnPluginStart();
    Warday_OnPluginStart();
    Warden_OnPluginStart();
    WardenHud_OnPluginStart();

    HookEvent("player_spawn", OnPlayerSpawn);

    g_ConVarPrefix = CreateConVar("sm_jailbreak_prefix", "[Jailbreak]", "Prefix for messages from the plugin");
    g_ConVarPrefix.AddChangeHook(OnPrefixChange);
    g_ConVarWardenPrefix = CreateConVar("sm_jailbreak_warden_prefix", "[Warden]", "Prefix for warden messages");
    g_ConVarWardenPrefix.AddChangeHook(OnWardenPrefixChange);
    g_ConVarWardenChatPrefix = CreateConVar("sm_jailbreak_warden_chat_prefix", "[Warden]", "Prefix for warden chat messages");
    g_ConVarWardenChatPrefix.AddChangeHook(OnWardenChatPrefixChange);
    g_ConVarWardayCooldown = CreateConVar("sm_jailbreak_warday_cooldown", "3", "Number of rounds before another warday", 0, true, 0.0);
    g_ConVarWardenChatPrefix.AddChangeHook(OnWardayCooldownChange);

    char tmpbuffer[32];
    g_ConVarPrefix.GetString(tmpbuffer, sizeof(tmpbuffer));
    Format(g_Prefix, sizeof(g_Prefix), "\x04%s\x07F8F8FF", tmpbuffer);

    g_ConVarWardenPrefix.GetString(tmpbuffer, sizeof(tmpbuffer));
    Format(g_WardenPrefix, sizeof(g_WardenPrefix), "\x04%s\x07F8F8FF", tmpbuffer);

    g_ConVarWardenChatPrefix.GetString(tmpbuffer, sizeof(tmpbuffer));
    Format(g_WardenChatPrefix, sizeof(g_WardenChatPrefix), "\x04%s\x07B94FFF", tmpbuffer);

    AutoExecConfig(true);

}

///////////////////////////////////////////////////////////////////////////////
// ConVar Changes
///////////////////////////////////////////////////////////////////////////////
public void OnPrefixChange(ConVar convar, char[] oldValue, char[] newValue)
{
    Format(g_Prefix, sizeof(g_Prefix), "\x04%s\x07F8F8FF", newValue);
}

public void OnWardenPrefixChange(ConVar convar, char[] oldValue, char[] newValue)
{
    Format(g_WardenPrefix, sizeof(g_WardenPrefix), "\x04%s\x07F8F8FF", newValue);    
}

public void OnWardenChatPrefixChange(ConVar convar, char[] oldValue, char[] newValue)
{
    Format(g_WardenChatPrefix, sizeof(g_WardenChatPrefix), "\x04%s\x07B94FFF", newValue);
}

public void OnWardayCooldownChange(ConVar convar, char[] oldValue, char[] newValue)
{
    g_WardayRoundCountdown = g_ConVarWardayCooldown.IntValue;
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    Warden_AskPluginLoad2(myself, late, error, err_max);
    WardenHud_AskPluginLoad2(myself, late, error, err_max);
    return APLRes_Success;
}

public Action OnPlayerSpawn(Handle event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(GetEventInt(event, "userid"));

    if (GetClientTeam(client) == CS_TEAM_CT)
    {
        GivePlayerItem(client, "item_kevlar");
        SetEntProp(client, Prop_Send, "m_ArmorValue", 50, 1);
    }
}