#pragma semicolon 1

#include <sourcemod>

int g_BeamSprite;
int g_HaloSprite;

public void Circle_OnMapStart()
{
	g_BeamSprite = PrecacheModel("materials/sprites/laser.vmt");
	g_HaloSprite = PrecacheModel("materials/sprites/halo01.vmt");
}

public void Circle_OnPluginStart()
{
    CreateTimer(0.1, Timer_WardenCircle, _, TIMER_REPEAT);
}

///////////////////////////////////////////////////////////////////////////////
// Timers
///////////////////////////////////////////////////////////////////////////////
public Action Timer_WardenCircle(Handle timer)
{
    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsValidClient(i) && IsPlayerAlive(i) && i == g_WardenID)
        {
            float vec[3];
            GetClientAbsOrigin(i, vec);
            vec[2] += 10;
            TE_SetupBeamRingPoint(vec, 35.0, 35.1, g_BeamSprite, g_HaloSprite, 0, 5, 0.1, 5.2, 0.0, COLOR_PURPLE, 1000, 0);
            TE_SendToAll();
        }
    }
}