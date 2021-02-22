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
#define PLUGIN_VERSION      "4.1"
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