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

#include <sdktools>
#include <sourcemod>


bool g_WardayActive;

static const char sound[] = "npc/attack_helicopter/aheli_damaged_alarm1.wav";

public void Warday_OnPluginStart()
{

    g_WardayActive = false;

    RegConsoleCmd("sm_warday", Command_Warday);

    RegAdminCmd("sm_awarday", Command_AdminWarday, ADMFLAG_CHANGEMAP);
    RegAdminCmd("sm_cwarday", Command_CancelWarday, ADMFLAG_KICK);

    HookEvent("round_start", Warday_OnRoundStart);
    HookEvent("round_end", Warday_OnRoundEnd);
}

public void Warday_OnMapStart()
{
    PrecacheSound(sound);
}

///////////////////////////////////////////////////////////////////////////////
// Regular Commands
///////////////////////////////////////////////////////////////////////////////
public Action Command_Warday(int client, int args)
{

    if (client != g_WardenID)
    {
        PrintToChat(client, "%s Only the Warden may call a Warday!", g_Prefix);
        return Plugin_Handled;
    }

    if (args < 1)
    {
        PrintToChat(client, "%s You must specify a location!", g_Prefix);
        return Plugin_Handled;
    }

    if (g_WardayRoundCountdown > 0)
    {
        PrintToChat(client, "%s You must wait %d more round(s) before calling a Warday!", g_Prefix, g_WardayRoundCountdown);
        return Plugin_Handled;
    }

    char location[32];
    GetCmdArgString(location, sizeof(location));

    g_WardayRoundCountdown = g_WardayCooldown + 1;

    Callback_Warday(location);

    return Plugin_Handled;

}

///////////////////////////////////////////////////////////////////////////////
// Admin Commands
///////////////////////////////////////////////////////////////////////////////
public Action Command_AdminWarday(int client, int args)
{

    if (args < 1)
    {
        PrintToChat(client, "%s You must specify a location!", g_Prefix);
        return Plugin_Handled;
    }

    if (g_WardayActive)
    {
        PrintToChat(client, "%s There is already a warday! To cancel type !cwarday", g_Prefix);
        return Plugin_Handled;
    }

    LogAction(client, -1, "Admin warday called");

    char location[32];
    GetCmdArgString(location, sizeof(location));

    Callback_Warday(location);

    return Plugin_Handled;

}

public Action Command_CancelWarday(int client, int args)
{
    if (!g_WardayActive)
    {
        PrintToChat(client, "%s There is not an active warday!", g_Prefix);
        return Plugin_Handled;
    }

    PrintCenterTextAll("Warden cancelled!");
    PrintToChatAll("%s Warday cancelled by %N!", g_Prefix, client);

    LogAction(client, -1, "Warday cancelled");

    g_WardayActive = false;
    g_WardenHudEnable = true;

    return Plugin_Handled;
}

///////////////////////////////////////////////////////////////////////////////
// Event Hooks
///////////////////////////////////////////////////////////////////////////////
public void Warday_OnRoundStart(Handle event, const char[] name, bool dontBroadcast)
{

    if (g_WardayRoundCountdown > 0)
        g_WardayRoundCountdown--;
    
    g_WardenHudEnable = true;

}

public void Warday_OnRoundEnd(Handle event, const char[] name, bool dontBroadcast)
{
    g_WardayActive = false;
}

public Action Timer_PrintWardayHud(Handle timer, DataPack hPack)
{

    if (!g_WardayActive)
        return Plugin_Stop;

    hPack.Reset();
    char location[32];

    hPack.ReadString(location, sizeof(location));

    Handle hudText = CreateHudSynchronizer();
    SetHudTextParams(-1.5, -1.7, 30.0, 255, 255, 255, 255);

    char buf[64];
    Format(buf, sizeof(buf), "Warday: %s", location);

    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsValidClient(i))
        {
            ShowSyncHudText(i, hudText, buf);
        }
    }

    CloseHandle(hudText);
    
    return Plugin_Continue;

}

public void Callback_Warday(const char[] location)
{
    g_WardenHudEnable = false;
    g_WardayActive = true;

    DataPack hPack;
    CreateDataTimer(1.0, Timer_PrintWardayHud, hPack, TIMER_REPEAT);
    hPack.WriteString(location);
    EmitSoundToAll(sound);
    PrintCenterTextAll("WARDAY!!!");
}