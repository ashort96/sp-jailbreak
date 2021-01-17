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
        PrintToChat(client, "%s Only the Warden can use this command!", JB_PREFIX);
        return Plugin_Handled;
    }

    Callback_EnableBlock();
    return Plugin_Handled;
}

public Action Command_WardenUnblock(int client, int args)
{
    if (client != g_WardenID)
    {
        PrintToChat(client, "%s Only the Warden can use this command!", JB_PREFIX);
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

void Callback_DisableBlock()
{
    g_BlockEnabled = false;

    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsValidClient(i) && IsPlayerAlive(i))
            SetEntityCollisionGroup(i, COLLISION_GROUP_DEBRIS_TRIGGER);
    }

    PrintCenterTextAll("Noblock Enabled!");

}