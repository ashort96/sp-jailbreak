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

#if defined _jailbreak_included
    #endinput
#endif
#define _jailbreak_included

#define JB_PREFIX "\x04[GP Jailbreak]\x07F8F8FF"
#define WARDEN_PREFIX "\x04[GP Warden]\x07F8F8FF"
#define WARDEN_PLAYER_PREFIX "\x04[GP Warden]\x07B94FFF"

#define COLOR_PURPLE {118, 9, 186, 255}

///////////////////////////////////////////////////////////////////////////////
// Warday
///////////////////////////////////////////////////////////////////////////////
#define WARDAY_COOLDOWN 3
stock int g_WardayRoundCooldown = 0;

///////////////////////////////////////////////////////////////////////////////
// Warden
///////////////////////////////////////////////////////////////////////////////
#define INVALID_WARDEN -1
stock int g_WardenID = INVALID_WARDEN;
stock bool g_WardenEnable = true;

///////////////////////////////////////////////////////////////////////////////
// WardenHud
///////////////////////////////////////////////////////////////////////////////
stock bool g_WardenHudEnable = true;

///////////////////////////////////////////////////////////////////////////////
// Warden Natvies
///////////////////////////////////////////////////////////////////////////////

/**
* Get the ID of the Warden
* @return   ClientID of the Warden
*/
native int GetWardenID();
/**
* Remove the Warden
* @return   none
*/
native any RemoveWarden();
/**
* Re-enable the ability to become Warden
* @return   none
*/
native any EnableWarden();
/**
* Disable the ability to become Warden
* @return   none
*/
native any DisableWarden();

///////////////////////////////////////////////////////////////////////////////
// WardenHud Natvies
///////////////////////////////////////////////////////////////////////////////

/**
* Enables the Warden text to show on the hud
* @return   none
*/
native any EnableWardenHud();
/**
* Disable the Warden text from showing on the hud
* @return   none
*/
native any DisableWardenHud();

/**
* Called when a client becomes Warden.
* @param    client  Client index
*/
forward void Jailbreak_OnWardenBecome(int client);

/**
* Called when a client is no longer the Warden. Make sure you verify
* that the client is still valid.
* @param    client  Client index
*/
forward void Jailbreak_OnWardenRemove(int client);

///////////////////////////////////////////////////////////////////////////////
// Stocks
///////////////////////////////////////////////////////////////////////////////
stock bool IsValidClient(int client)
{
    if (client <= 0)
        return false;
    
    if (client > MaxClients)
        return false;
    
    if (!IsClientConnected(client))
        return false;
    
    if (IsFakeClient(client))
        return false;

    return IsClientInGame(client);
}

stock bool TraceFilter_IgnorePlayers(int entity, int contentsMask)
{
    return !IsValidClient(entity);
}