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