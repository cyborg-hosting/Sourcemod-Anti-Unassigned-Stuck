#include <sourcemod>
#include <tf2_stocks>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = {
    name        = "Anti <Unassigned> Stuck",
    author      = "Jobggun",
    description = "",
    version     = "2.0.0",
    url         = ""
};

public void OnPluginStart()
{
    LoadTranslations("antiuastuck.phrases");
    
    RegConsoleCmd("sm_stuck", Cmd_AntiStuck, "Use this when you're in stuck with spectator/unassigned team.");
    RegConsoleCmd("sm_antistuck", Cmd_AntiStuck, "Use this when you're in stuck with spectator/unassigned team.");
    RegConsoleCmd("sm_jointeam", Cmd_AntiStuck, "Use this when you're in stuck with spectator/unassigned team.");
    RegConsoleCmd("sm_autoteam", Cmd_AntiStuck, "Use this when you're in stuck with spectator/unassigned team.");
}

public void OnClientPutInServer(int client)
{
    CreateTimer(10.0, Timer_AntiStuck, GetClientSerial(client));
    
    if(IsInvalidClient(client))
    {
        return;
    }
    
    FakeClientCommandEx(client, "autoteam");
    
    PrintToChat(client, "[AntiUAStuck] %t", "Welcome");
}


public Action Cmd_AntiStuck(int client, int args)
{
    if(IsInvalidClient(client))
    {
        ReplyToCommand(client, "Sorry, but this command is available only for in-game players.");
        
        return Plugin_Handled;
    }
    
    FakeClientCommandEx(client, "autoteam");
    
    return Plugin_Handled;
}

public Action Timer_AntiStuck(Handle timer, int serial)
{
    int client = GetClientFromSerial(serial);
    
    if(IsInvalidClient(client))
    {
        return Plugin_Stop;
    }
    
    if(TF2_GetClientTeam(client) == TFTeam_Unassigned)
    {
        FakeClientCommandEx(client, "autoteam");
    }
    
    return Plugin_Stop;
}

bool IsInvalidClient(int client)
{
    if(client < 1 || client > MaxClients || !IsClientInGame(client) || IsFakeClient(client))
    {
        return true;
    }
    else
    {
        return false;
    }
}