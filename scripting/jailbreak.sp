#pragma semicolon 1

#define PLUGIN_NAME         "CS:S Jailbreak"
#define PLUGIN_AUTHOR       "organharvester, Jordi, Dunder"
#define PLUGIN_DESCRIPTION  "Jailbreak Warden Plugin"
#define PLUGIN_VERSION      "4.0"
#define PLUGIN_URL          ""

#include <jailbreak>
#include <sourcemod>

#pragma newdecls required

#include "jailbreak/block.sp"
#include "jailbreak/circle.sp"
#include "jailbreak/laser.sp"
#include "jailbreak/warday.sp"
#include "jailbreak/warden.sp"
#include "jailbreak/warden_text.sp"
#include "jailbreak/warden_hud.sp"

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
}

public void OnPluginStart()
{

    EngineVersion game = GetEngineVersion();

    if (game != Engine_CSS)
    {
        SetFailState("This plugin is for CS:S only!");
    }

    RegConsoleCmd("sm_samira", Command_Samira);

    Block_OnPluginStart();
    Circle_OnPluginStart();
    Laser_OnPluginStart();
    Warday_OnPluginStart();
    Warden_OnPluginStart();
    WardenHud_OnPluginStart();

}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    Laser_AskPluginLoad2(myself, late, error, err_max);
    Warden_AskPluginLoad2(myself, late, error, err_max);
    WardenHud_AskPluginLoad2(myself, late, error, err_max);
    return APLRes_Success;
}

///////////////////////////////////////////////////////////////////////////////
// Regular Commands
///////////////////////////////////////////////////////////////////////////////
public Action Command_Samira(int client, int args)
{  
    PrintToChat(client,"\x07( ͡° ͜ʖ ͡°)\x04------------------\x02( ͡° ͜ʖ ͡°)\x02--------------\x07( ͡° ͜ʖ ͡°)");
    PrintToChat(client,"\x07( ͡° ͜ʖ ͡°)\x04This plugin is sponsored by Samira\x02( ͡° ͜ʖ ͡°)");
    PrintToChat(client,"\x07( ͡° ͜ʖ ͡°)\x04----------\x07Thanks\x02( ͡° ͜ʖ ͡°)\x07Samira\x02------\x07( ͡° ͜ʖ ͡°)");
    PrintToChat(client,"\x07( ͡° ͜ʖ ͡°)\x04------------------\x02( ͡° ͜ʖ ͡°)\x02--------------\x07( ͡° ͜ʖ ͡°)");
    PrintToChat(client,"\x07( ͡° ͜ʖ ͡°)\x04----------\x07Organ\x02♥\x07( ͡° ͜ʖ ͡°)\x02♥\x07Jordi\x04-------\x07( ͡° ͜ʖ ͡°)");
    return Plugin_Handled;
}