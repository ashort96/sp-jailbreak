#pragma semicolon 1

#include <sdktools>
#include <sourcemod>

int g_LaserBeam;
int g_LaserPoint;

bool g_DrawLaser;
bool g_LaserUse;
bool g_LaserEnabled;

float g_PreviousPosition[3];

public void Laser_OnMapStart()
{
    g_LaserBeam = PrecacheModel("materials/sprites/laserbeam.vmt");
    g_LaserPoint = PrecacheModel("materials/sprites/glow07.vmt");

    CreateTimer(0.1, Timer_LaserDraw, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public void Laser_OnPluginStart()
{
    g_DrawLaser = false;
    g_LaserUse = false;
    g_LaserEnabled = true;

    RegConsoleCmd("sm_laser", Command_Laser);
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon)
{

    if (client != g_WardenID)
    {
        return Plugin_Continue;
    }

    if (!g_LaserEnabled)
    {
        return Plugin_Continue;
    }

    if (!(buttons & IN_USE))
    {
        g_PreviousPosition[0] = 0.0;
        g_PreviousPosition[1] = 0.0;
        g_PreviousPosition[2] = 0.0;
        return Plugin_Continue;
    }

    g_LaserUse = true;

    if (client == g_WardenID && g_LaserUse && IsValidClient(client))
    {
        SetupLaser(client, COLOR_PURPLE);
    }

    if (client == g_WardenID && g_DrawLaser)
    {
        if (!g_LaserUse)
        {
            GetClientSightEnd(client, g_PreviousPosition);
        }
        g_LaserUse = true;
    }

    return Plugin_Continue;
}

///////////////////////////////////////////////////////////////////////////////
// Regular Commands
///////////////////////////////////////////////////////////////////////////////
public Action Command_Laser(int client, int args)
{
    if (!IsValidClient(client) || client != g_WardenID)
    {
        PrintToChat(client, "%s Only the Warden may use the laser!", JB_PREFIX);
        return Plugin_Handled;
    }

    Panel laserPanel = new Panel();
    laserPanel.SetTitle("Laser Selection");
    laserPanel.DrawItem("Normal Laser");
    laserPanel.DrawItem("Draw Laser");
    laserPanel.DrawItem("Disable Laser");

    laserPanel.Send(client, MenuHandler_Laser, 20);
    return Plugin_Handled;
}

///////////////////////////////////////////////////////////////////////////////
// Timers
///////////////////////////////////////////////////////////////////////////////
public Action Timer_LaserDraw(Handle timer)
{
    if (g_WardenID != INVALID_WARDEN && g_DrawLaser && g_LaserUse)
    {
        float position[3];
        GetClientSightEnd(g_WardenID, position);

        bool initialDraw = g_PreviousPosition[0] == 0.0 && g_PreviousPosition[1] == 0.0 && g_PreviousPosition[2] == 0.0;

        if (!initialDraw)
        {
            TE_SetupBeamPoints(g_PreviousPosition, position, g_LaserBeam, 0, 0, 0, 25.0, 2.0, 2.0, 10, 0.0, {118, 9, 186, 255}, 0);
            TE_SendToAll();
        }

        g_PreviousPosition = position;
    }
}

///////////////////////////////////////////////////////////////////////////////
// Menu Handlers
///////////////////////////////////////////////////////////////////////////////
public int MenuHandler_Laser(Menu menu, MenuAction action, int client, int param2)
{
    if (action == MenuAction_Select)
    {
        switch(param2)
        {
            case 1:
            {
                g_LaserEnabled = true;
                g_DrawLaser = false;
                PrintToChat(client, "%s Normal Laser enabled", JB_PREFIX);
            }
            case 2:
            {
                g_LaserEnabled = true;
                g_DrawLaser = true;
                PrintToChat(client, "%s Draw Laser enabled", JB_PREFIX);
            }
            case 3:
            {
                g_LaserEnabled = false;
                g_DrawLaser = false;
                PrintToChat(client, "%s Laser disabled", JB_PREFIX);
            }
        }

    }
    else if (action == MenuAction_Cancel)
    {
        PrintToServer("Cliend %d's menu was cancelled. Reason: %d", client, param2);
    }
    else if (action == MenuAction_End)
    {
        delete menu;
    }
} 

///////////////////////////////////////////////////////////////////////////////
// Helper Functions
///////////////////////////////////////////////////////////////////////////////
stock bool TraceFilter_IgnorePlayers(int entity, int contentsMask)
{
    return !IsValidClient(entity);
}

stock void GetClientSightEnd(int client, float out[3])
{
    float eyes[3];
    float angles[3];

    GetClientEyePosition(client, eyes);
    GetClientEyeAngles(client, angles);

    TR_TraceRayFilter(eyes, angles, MASK_PLAYERSOLID, RayType_Infinite, TraceFilter_IgnorePlayers);

    if (TR_DidHit())
    {
        TR_GetEndPosition(out);
    }
}

stock void SetupLaser(int client, int color[4])
{

    float origin[3];
    float impact[3];

    GetClientEyePosition(client, origin);
    GetClientSightEnd(client, impact);

    TE_SetupBeamPoints(origin, impact, g_LaserBeam, 0, 0, 0, 0.1, 0.8, 0.8, 2, 0.0, color, 0);
    TE_SendToAll();

    TE_SetupGlowSprite(impact, g_LaserPoint, 0.1, 0.2, 255);
    TE_SendToAll();
}