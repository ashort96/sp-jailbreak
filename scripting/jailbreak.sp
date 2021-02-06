#pragma semicolon 1

#define PLUGIN_NAME         "CS:S Jailbreak"
#define PLUGIN_AUTHOR       "organharvester, Jordi, Dunder"
#define PLUGIN_DESCRIPTION  "Jailbreak Warden Plugin"
#define PLUGIN_VERSION      "4.0"
#define PLUGIN_URL          ""

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