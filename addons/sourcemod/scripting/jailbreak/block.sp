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

#include <SetCollisionGroup>
#include <sourcemod>

bool g_BlockEnabled;

public void Block_OnPluginStart()
{
    RegConsoleCmd("sm_wb", Command_WardenBlock);
    RegConsoleCmd("sm_wub", Command_WardenUnblock);

    RegAdminCmd("sm_block", Command_Block, ADMFLAG_KICK);
    RegAdminCmd("sm_ublock", Command_Unblock, ADMFLAG_KICK);

    HookEvent("player_spawn", Block_OnPlayerSpawn);
    HookEvent("round_start", Block_OnRoundStart);

    g_BlockEnabled = true;
}

///////////////////////////////////////////////////////////////////////////////
// Regular Commands
///////////////////////////////////////////////////////////////////////////////
public Action Command_WardenBlock(int client, int args)
{
    if (client != g_WardenID)
    {
        PrintToChat(client, "%s Only the Warden can use this command!", g_Prefix);
        return Plugin_Handled;
    }

    Callback_EnableBlock();
    return Plugin_Handled;
}

public Action Command_WardenUnblock(int client, int args)
{
    if (client != g_WardenID)
    {
        PrintToChat(client, "%s Only the Warden can use this command!", g_Prefix);
        return Plugin_Handled;
    }

    Callback_DisableBlock();
    return Plugin_Handled;
}

///////////////////////////////////////////////////////////////////////////////
// Admin Commands
///////////////////////////////////////////////////////////////////////////////
public Action Command_Block(int client, int args)
{
    Callback_EnableBlock();
    return Plugin_Handled;
}

public Action Command_Unblock(int client, int args)
{
    Callback_DisableBlock();
    return Plugin_Handled;
}

///////////////////////////////////////////////////////////////////////////////
// Event Hooks
///////////////////////////////////////////////////////////////////////////////
public void Block_OnPlayerSpawn(Handle event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(GetEventInt(event, "userid"));
    if (IsValidClient(client) && IsPlayerAlive(client))
    {
        if (!g_BlockEnabled)
            SetEntityCollisionGroup(client, COLLISION_GROUP_DEBRIS_TRIGGER);
    }
}

public void Block_OnRoundStart(Handle event, const char[] name, bool dontBroadcast)
{
    Callback_EnableBlock(true);
}

///////////////////////////////////////////////////////////////////////////////
// Callbacks
///////////////////////////////////////////////////////////////////////////////
void Callback_EnableBlock(bool dontBroadcast = false)
{
    g_BlockEnabled = true;
    
    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsValidClient(i) && IsPlayerAlive(i))
            SetEntityCollisionGroup(i, COLLISION_GROUP_PLAYER);
    }
    if (!dontBroadcast)
        PrintCenterTextAll("Block enabled!");

}

void Callback_DisableBlock(bool dontBroadcast = false)
{
    g_BlockEnabled = false;

    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsValidClient(i) && IsPlayerAlive(i))
            SetEntityCollisionGroup(i, COLLISION_GROUP_DEBRIS_TRIGGER);
    }

    if (!dontBroadcast)
        PrintCenterTextAll("Noblock Enabled!");

}