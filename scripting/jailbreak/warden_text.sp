#pragma semicolon 1

#include <sourcemod>

public Action OnClientSayCommand(int client, const char[] command, const char[] sArgs)
{
    if (g_WardenID != client)
        return Plugin_Continue;

    static const char color1[] = "\x07000000";
    static const char color2[] = "\x07FFFFFF";

    if (!StrEqual(command, "say_team"))
    {
        if (!CheckCommandAccess(client, "sm_say", ADMFLAG_CHAT))
        {
            PrintToChatAll("%s %N %s: %s%s", WARDEN_PLAYER_PREFIX, client, color1, color2, sArgs);
            LogAction(client, -1, "[Warden] %N : %s", client, sArgs);
            return Plugin_Handled;
        }
        else
        {
            if (sArgs[0] != '@')
            {
                PrintToChatAll("%s %N %s: %s%s", WARDEN_PLAYER_PREFIX, client, color1, color2, sArgs);
                LogAction(client, -1, "[Warden] %N : %s", client, sArgs);
                return Plugin_Handled;
            }
        }
    }

    else
    {
        for (int i = 1; i < MaxClients; i++)
        {
            if (IsValidClient(i) && GetClientTeam(i) == CS_TEAM_CT)
            {
                if (sArgs[0] != '@')
                {
                    PrintToChat(i, "\x01(Counter-Terrorist) %s %N %s: %s%s", WARDEN_PLAYER_PREFIX, client, color1, color2, sArgs);
                }
            }
        }
        LogAction(client, -1, "[Warden] (CT) %N : %s", client, sArgs);                    
        return Plugin_Handled;
    }

    return Plugin_Handled;
}