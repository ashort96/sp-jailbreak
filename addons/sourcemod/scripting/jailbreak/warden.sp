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

#include <cstrike>
#include <sdktools>
#include <sourcemod>

public void Warden_OnPluginStart()
{
    RegConsoleCmd("jointeam", Warden_OnJoinTeam);
    RegConsoleCmd("sm_w", Command_Warden);
    RegConsoleCmd("sm_uw", Command_Unwarden);

    RegAdminCmd("sm_rw", Command_RemoveWarden, ADMFLAG_KICK);

    HookEvent("player_death", Warden_OnPlayerDeath);
    HookEvent("player_disconnect", Warden_OnPlayerDisconnect);
    HookEvent("round_start", Warden_OnRoundBegin);
    HookEvent("round_end", Warden_OnRoundEnd);
}

public void Warden_OnMapStart()
{
    g_WardenID = INVALID_WARDEN;
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
        PrintToChat(client, "%s There is already a Warden!", g_WardenPrefix);
        return Plugin_Handled;
    }

    if (!IsPlayerAlive(client))
    {
        PrintToChat(client, "%s You cannot Warden whilst dead!", g_WardenPrefix);
        return Plugin_Handled;
    }

    if (!(GetClientTeam(client) == CS_TEAM_CT))
    {
        PrintToChat(client, "%s Only CTs may become the Warden!", g_WardenPrefix);
        return Plugin_Handled;
    }

    if (!g_WardenEnable)
    {
        PrintToChat(client, "%s Warden is currently disabled!", g_WardenPrefix);
        return Plugin_Handled;
    }

    PrintCenterTextAll("New Warden: %N", client);
    PrintToChatAll("%s New Warden: %N", g_WardenPrefix, client);

    g_WardenID = client;
    SetEntityRenderColor(client, 118, 9, 186, 255);

    // Print Commands to the Warden
    char color1[] = "\x07FF0000";
    char color2[] = "\x07800080";
    char color3[] = "\x07F8F8FF";

    PrintToChat(client,"%s!w           %s- %sbecome warden", color1, color2, color3);
    PrintToChat(client,"%s!uw         %s- %sexit warden", color1, color2, color3);
    PrintToChat(client,"%s!wb         %s- %sturn on block", color1, color2, color3);
    PrintToChat(client,"%s!wub       %s- %sturn off block", color1, color2, color3);
    PrintToChat(client,"%s!laser       %s- %sswitch point/draw laser", color1, color2, color3);
    PrintToChat(client,"%s!marker  %s- %s+marker, use mouse to adjust size, then -marker", color1, color2, color3);
    // PrintToChat(client,"%s!wsd           %s- %sstart sd after %d rounds", color1, color2, color3, ROUND_WARDEN_SD);


    if (g_WardayRoundCountdown == 0)
    {
        PrintToChat(client, "%s You can call a warday!", g_WardenPrefix);
        PrintToChat(client, "%s!warday <location>", color1);
    }

    FireOnWardenBecome(g_WardenID);

    return Plugin_Handled;
}

public Action Command_Unwarden(int client, int args)
{
    if (client != g_WardenID)
    {
        PrintToChat(client, "%s You can't fire the Warden!", g_WardenPrefix);
        return Plugin_Handled;
    }
    Callback_RemoveWarden();
    return Plugin_Handled;

}

public Action Warden_OnJoinTeam(int client, int args)
{
    char teamString[3];
    GetCmdArg(1, teamString, sizeof(teamString));
    int newTeam = StringToInt(teamString);

    if (client == g_WardenID && newTeam != CS_TEAM_CT)
    {
        PrintToChatAll("%s The Warden has left the team!", g_WardenPrefix);
        Callback_RemoveWarden();
    }
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
    int client = GetClientOfUserId(GetEventInt(event, "userid"));
    if (g_WardenID == client)
    {
        Callback_RemoveWarden();
    }
}

public void Warden_OnPlayerDisconnect(Handle event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(GetEventInt(event, "userid"));
    if (g_WardenID == client)
    {
        PrintToChatAll("%s The Warden has left the game!", g_WardenPrefix);
        Callback_RemoveWarden(true);
    }
}

public void Warden_OnRoundBegin(Handle event, const char[] name, bool dontBroadcast)
{
    Callback_RemoveWarden(true);
}

public void Warden_OnRoundEnd(Handle event, const char[] name, bool dontBroadcast)
{

    Callback_RemoveWarden(true);
}

///////////////////////////////////////////////////////////////////////////////
// Callbacks
///////////////////////////////////////////////////////////////////////////////
void Callback_RemoveWarden(bool dontBroadcast = false)
{
    if (g_WardenID == INVALID_WARDEN)
    {
        return;
    }

    if (!dontBroadcast)
    {
        PrintCenterTextAll("%N is no longer Warden!", g_WardenID);
        PrintToChatAll("%s %N is no longer Warden!", g_WardenPrefix, g_WardenID);
    }

    FireOnWardenRemove(g_WardenID);

    SetEntityRenderColor(g_WardenID, 255, 255, 255, 255);

    g_WardenID = INVALID_WARDEN;
}