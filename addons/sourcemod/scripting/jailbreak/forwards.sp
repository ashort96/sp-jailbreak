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

void FireOnWardenRemove(int client)
{
    static GlobalForward hForward;

    if (hForward == null)
    {
        hForward = new GlobalForward("Jailbreak_OnWardenRemove", ET_Ignore, Param_Cell);   
    }

    Call_StartForward(hForward);
    Call_PushCell(client);
    Call_Finish();
}

void FireOnWardenBecome(int client)
{
    static GlobalForward hForward;

    if (hForward == null)
    {
        hForward = new GlobalForward("Jailbreak_OnWardenBecome", ET_Ignore, Param_Cell);
    }

    Call_StartForward(hForward);
    Call_PushCell(client);
    Call_Finish();
}