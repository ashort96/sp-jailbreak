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
        Format(buf, sizeof(buf), "Current Warden: %N", g_WardenID);
    }
    else
    {
        Format(buf, sizeof(buf), "Current Warden: N/A");
    }

    Handle hudText = CreateHudSynchronizer();
    SetHudTextParams(-1.5, -1.7, 1.0, 255, 255, 255, 255);

    for (int i = 1; i < MaxClients; i++)
    {
        if (IsValidClient(i))
        {
            ShowSyncHudText(i, hudText, buf);
        }
    }

    return Plugin_Continue;

}