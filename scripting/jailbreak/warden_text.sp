#include <cstrike>
#include <sourcemod>

public void WardenText_OnPluginStart()
{
    CreateTimer(1.0, Timer_PrintWardenText, _, TIMER_REPEAT);
}

public APLRes WardenText_AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    CreateNative("EnableWardenText", Native_EnableWardenText);
    CreateNative("DisableWardenText", Native_DisableWardenText);
    return APLRes_Success;
}

///////////////////////////////////////////////////////////////////////////////
// Natvies
///////////////////////////////////////////////////////////////////////////////
public any Native_EnableWardenText(Handle plugin, int numParams)
{
    g_WardenTextEnable = true;
}

public any Native_DisableWardenText(Handle plugin, int numParams)
{
    g_WardenTextEnable = false;
}

///////////////////////////////////////////////////////////////////////////////
// Timers
///////////////////////////////////////////////////////////////////////////////
public Action Timer_PrintWardenText(Handle timer)
{
    if (!g_WardenTextEnable)
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
    SetHudTextParams(1.5, -1.7, 1.0, 255, 255, 255, 255);

    for (int i = 1; i < MaxClients; i++)
    {
        if (IsValidClient(i))
        {
            ShowSyncHudText(i, hudText, buf);
        }
    }

    return Plugin_Continue;

}