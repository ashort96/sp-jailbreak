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

/**
* Credits to Original Author: shavit
* Link: https://github.com/shavitush
*/

#include <sdktools>
#include <sourcemod>

bool g_MarkerStatus;

int g_MarkerBeam;
int g_MarkerHalo;

float g_MarkerPoints[2][3];

public void Marker_OnPluginStart()
{
    RegConsoleCmd("sm_marker", Command_MarkerMenu);
    RegConsoleCmd("+marker", Command_Marker);
    RegConsoleCmd("-marker", Command_Marker);

    HookEvent("round_start", Marker_OnRoundStart);
}

public void Marker_OnMapStart()
{
    g_MarkerBeam = PrecacheModel("materials/sprites/hostage_following_offscreen.vmt", true);
    g_MarkerHalo = PrecacheModel("materials/sprites/hostage_following_offscreen.vmt", true);

    CreateTimer(0.1, Timer_MarkerDraw, _, TIMER_REPEAT);
}

///////////////////////////////////////////////////////////////////////////////
// Regular Commands
///////////////////////////////////////////////////////////////////////////////
public Action Command_MarkerMenu(int client, int args)
{
    if (client != g_WardenID)
    {
        PrintToChat(client, "%s Only the Warden can use the marker!", g_Prefix);
        return Plugin_Handled;
    }

    Menu markerMenu = new Menu(MenuHandler_Marker, MENU_ACTIONS_DEFAULT|MenuAction_DisplayItem);
    markerMenu.SetTitle("Marker Menu");
    markerMenu.AddItem("marker", "");
    markerMenu.ExitButton = true;

    markerMenu.Display(client, MENU_TIME_FOREVER);

    return Plugin_Handled;

}

public Action Command_Marker(int client, int args)
{
    if (client != g_WardenID)
    {
        return Plugin_Handled;
    }

    char command[16];

    GetCmdArg(0, command, sizeof(command));

    ToggleDrawing(client, command[0] == '+');

    return Plugin_Handled;
}

///////////////////////////////////////////////////////////////////////////////
// Event Hooks
///////////////////////////////////////////////////////////////////////////////
public void Marker_OnRoundStart(Handle event, const char[] name, bool dontBroadcast)
{
    g_MarkerStatus = false;
    g_MarkerPoints[0] = NULL_VECTOR;
    g_MarkerPoints[1] = NULL_VECTOR;
}

///////////////////////////////////////////////////////////////////////////////
// Menu Handlers
///////////////////////////////////////////////////////////////////////////////
public int MenuHandler_Marker(Menu menu, MenuAction action, int param1, int param2)
{
    char choice[16];

    if (action == MenuAction_Select)
    {
        menu.GetItem(param2, choice, sizeof(choice));

        if (StrEqual(choice, "marker"))
        {
            ToggleDrawing(param1, !g_MarkerStatus);
        }

        menu.Display(param1, MENU_TIME_FOREVER);

 
    }

    else if (action == MenuAction_DisplayItem)
    {
        menu.GetItem(param2, choice, 16);

        char display[64];

        if (StrEqual(choice, "marker"))
        {
            strcopy(display, sizeof(display), (g_MarkerStatus) ? "-marker" : "+marker");
        }

        return RedrawMenuItem(display);
    }

    return 0;
}

///////////////////////////////////////////////////////////////////////////////
// Timers
///////////////////////////////////////////////////////////////////////////////
public Action Timer_MarkerDraw(Handle timer)
{
    for (int i = 1; i <= MaxClients; i++)
    {
        if (!IsValidClient(i) || i != g_WardenID)
            continue;
        
        if (g_MarkerStatus)
        {
            GetAimPosition(i, g_MarkerPoints[1]);
        }

        float dist = GetVectorDistance(g_MarkerPoints[0], g_MarkerPoints[1]) * 2.0;

        TE_SetupBeamRingPoint(g_MarkerPoints[0], dist - 0.1, dist, g_MarkerBeam, g_MarkerHalo, 0, 60, 0.1, 5.0, 0.0, {0, 255, 0, 255}, 10, 0);
        TE_SendToAll();
    }

    return Plugin_Continue;
}

///////////////////////////////////////////////////////////////////////////////
// Helper Functions
///////////////////////////////////////////////////////////////////////////////
void GetAimPosition(int client, float[3] position)
{
    float pos[3];
    float angles[3];

    GetClientEyePosition(client, pos);
    GetClientEyeAngles(client, angles);

    TR_TraceRayFilter(pos, angles, MASK_SHOT, RayType_Infinite, TraceFilter_IgnorePlayers, client);

    if (TR_DidHit())
    {
        float end[3];
        float final[3];

        TR_GetEndPosition(end);
        final = end;

        final[0] = float(RoundToNearest(end[0] / 16) * 16);
        final[1] = float(RoundToNearest(end[1] / 16) * 16);
        final[2] = end[2];

        TE_SetupEnergySplash(g_MarkerPoints[0], NULL_VECTOR, false);
        TE_SendToAll();

        position = final;
        return;
    }

    position = pos;
    return;

}

void ToggleDrawing(int client, bool status)
{
    g_MarkerStatus = status;
    if (g_MarkerStatus)
    {
        GetAimPosition(client, g_MarkerPoints[0]);
    }

}