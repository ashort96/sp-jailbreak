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
#include <sourcemod>

public void WardenHud_OnPluginStart()
{
    CreateTimer(1.0, Timer_PrintWardenHud, _, TIMER_REPEAT);
}

public APLRes WardenHud_AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    CreateNative("EnableWardenHud", Native_EnableWardenHud);
    CreateNative("DisableWardenHud", Native_DisableWardenHud);
    return APLRes_Success;
}

///////////////////////////////////////////////////////////////////////////////
// Natvies
///////////////////////////////////////////////////////////////////////////////
public any Native_EnableWardenHud(Handle plugin, int numParams)
{
    g_WardenHudEnable = true;
}

public any Native_DisableWardenHud(Handle plugin, int numParams)
{
    g_WardenHudEnable = false;
}

///////////////////////////////////////////////////////////////////////////////
// Timers
///////////////////////////////////////////////////////////////////////////////
public Action Timer_PrintWardenHud(Handle timer)
{
    if (!g_WardenHudEnable)
        return Plugin_Continue;
    
    char buf[256];

    if (g_WardenID != INVALID_WARDEN)
    {
        Format(buf, sizeof(buf), "Warden: %N", g_WardenID);
    }
    else
    {
        Format(buf, sizeof(buf), "Warden: N/A");
    }

    Handle hudText = CreateHudSynchronizer();
    SetHudTextParams(-1.5, -1.7, 1.0, 255, 255, 255, 255);

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