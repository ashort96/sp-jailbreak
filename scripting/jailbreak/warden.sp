#pragma semicolon 1

#include <cstrike>
#include <sdktools>
#include <sourcemod>

public void Warden_OnPluginStart()
{
    RegConsoleCmd("sm_w", Command_Warden);
    RegConsoleCmd("sm_uw", Command_Unwarden);

    RegAdminCmd("sm_rw", Command_RemoveWarden, ADMFLAG_KICK);

    HookEvent("player_death", Warden_OnPlayerDeath);
    HookEvent("player_disconnect", Warden_OnPlayerDisconnect);
}

public APLRes Warden_AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    CreateNative("GetWardenID", Native_GetWardenID);
    CreateNative("RemoveWarden", Native_RemoveWarden);
    CreateNative("EnableWarden", Native_EnableWarden);
    CreateNative("DisableWarden", Native_DisableWarden);
    return APLRes_Success;
}

///////////////////////////////////////////////////////////////////////////////
// Natvies
///////////////////////////////////////////////////////////////////////////////
public int Native_GetWardenID(Handle plugin, int numParams)
{
    return g_WardenID;
}

public any Native_RemoveWarden(Handle plugin, int numParams)
{
    Callback_RemoveWarden();
}

public any Native_EnableWarden(Handle plugin, int numParams)
{
    g_WardenEnable = true;
}

public any Native_DisableWarden(Handle plugin, int numParams)
{
    g_WardenEnable = false;
}

///////////////////////////////////////////////////////////////////////////////
// Regular Commands
///////////////////////////////////////////////////////////////////////////////
public Action Command_Warden(int client, int args)
{
    // Make sure there isn't already a Warden
    if (g_WardenID != INVALID_WARDEN)
    {
        PrintToChat(client, "%s There is already a Warden!", WARDEN_PREFIX);
        return Plugin_Handled;
    }

    if (!IsPlayerAlive(client))
    {
        PrintToChat(client, "%s You cannot Warden whilst dead!", WARDEN_PREFIX);
        return Plugin_Handled;
    }

    if (!(GetClientTeam(client) == CS_TEAM_CT))
    {
        PrintToChat(client, "%s Only CTs may become the Warden!", WARDEN_PREFIX);
        return Plugin_Handled;
    }

    if (!g_WardenEnable)
    {
        PrintToChat(client, "%s Warden is currently disabled!", WARDEN_PREFIX);
        return Plugin_Handled;
    }

    // TODO: Add check if Special Day 
    PrintCenterTextAll("New Warden: %N", client);
    PrintToChatAll("%s New Warden: %N", WARDEN_PREFIX, client);

    g_WardenID = client;
    SetEntityRenderColor(client, 0, 0, 255, 255);

    // Print Commands to the Warden
    char color1[] = "\x07FF0000";
    char color2[] = "\x07800080";
    char color3[] = "\x07F8F8FF";

    PrintToChat(client,"%s!w           %s- %sbecome warden", color1, color2, color3);
    PrintToChat(client,"%s!uw         %s- %sexit warden", color1, color2, color3);
    PrintToChat(client,"%s!wb         %s- %sturn on block", color1, color2, color3);
    PrintToChat(client,"%s!wub       %s- %sturn off block", color1, color2, color3);
    PrintToChat(client,"%s!laser       %s- %sswitch point/draw laser", color1, color2, color3);
    PrintToChat(client,"%s!laser_color       %s- %schange laser color", color1, color2, color3);
    PrintToChat(client,"%s!marker  %s- %s+marker, use mouse to adjust size, then -marker", color1, color2, color3);
    // PrintToChat(client,"%s!wsd           %s- %sstart sd after %d rounds", color1, color2, color3, ROUND_WARDEN_SD);
    PrintToChat(client,"%s!color           %s- %scolor players'", color1, color2, color3);	
    PrintToChat(client,"%s!reset_color           %s- %sreset player colors'", color1, color2, color3);

    return Plugin_Handled;
}

public Action Command_Unwarden(int client, int args)
{
    Callback_RemoveWarden();
}

///////////////////////////////////////////////////////////////////////////////
// Admin Commands
///////////////////////////////////////////////////////////////////////////////
public Action Command_RemoveWarden(int client, int args)
{
    Callback_RemoveWarden();
}

///////////////////////////////////////////////////////////////////////////////
// Event Hooks
///////////////////////////////////////////////////////////////////////////////
public void Warden_OnPlayerDeath(Handle event, const char[] name, bool dontBroadcast)
{
    Callback_RemoveWarden();
}

public void Warden_OnPlayerDisconnect(Handle event, const char[] name, bool dontBroadcast)
{
    PrintToChatAll("%s The Warden has left the game!", WARDEN_PREFIX);
    Callback_RemoveWarden();
}

///////////////////////////////////////////////////////////////////////////////
// Callbacks
///////////////////////////////////////////////////////////////////////////////
public void Callback_RemoveWarden()
{
    if (g_WardenID == INVALID_WARDEN)
    {
        return;
    }

    PrintCenterTextAll("%N is no longer Warden!", g_WardenID);
    PrintToChatAll("%N is no longer Warden!", g_WardenID);

    SetEntityRenderColor(g_WardenID, 255, 255, 255, 255);

    g_WardenID = INVALID_WARDEN;
}