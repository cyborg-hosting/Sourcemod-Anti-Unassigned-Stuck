#include <sourcemod>
#include <tf2_stocks>

#undef REQUIRE_PLUGIN
#include <updater>
#define REQUIRE_PLUGIN

#define VERSION "3.0.0"

#define UPDATE_URL  "https://raw.githubusercontent.com/jobggun/Sourcemod-Anti-Unassigned-Stuck/main/sourcemod/updatefile.txt"

#pragma semicolon 1
#pragma newdecls required

ConVar Cvar_PluginVersion;
ConVar Cvar_PluginEnabledBeforeJoin;
ConVar Cvar_AnnounceAntiUAStuck;
ConVar Cvar_PluginEnabledAfterJoin;

float Float_TimerAnnounce = 6.0;
float Float_TimerSecondAfterJoin = 6.0;

public Plugin myinfo = {
    name        = "Anti <Unassigned> Stuck",
    author      = "Jobggun",
    description = "A plugin which deal with <Unassigned> Team problem when players join.",
    version     = VERSION,
    url         = "https://github.com/jobggun/Sourcemod-Anti-Unassigned-Stuck"
};

public void OnPluginStart()
{
    if (LibraryExists("updater"))
    {
        Updater_AddPlugin(UPDATE_URL);
    }

    LoadTranslations("antiuastuck.phrases");

    Cvar_PluginVersion = CreateConVar("sm_antiuastuck_version", VERSION, "Plugin's version. DO NOT CHANGE!");
    Cvar_AnnounceAntiUAStuck = CreateConVar("sm_antiuastuck_announce", "1", "Whether plugin announces plugin's info before player connected or not.", _, true, 0.0, true, 1.0);
    Cvar_PluginEnabledBeforeJoin = CreateConVar("sm_antiuastuck_beforejoin", "1", "Whether plugin uses \'autoteam\' command before player connected or not.", _, true, 0.0, true, 1.0);
    Cvar_PluginEnabledAfterJoin = CreateConVar("sm_antiuastuck_afterjoin", "1", "Whether plugin uses \'autoteam\' command if player is still in <Unassigned> team after join.", _, true, 0.0, true, 1.0);

    RegConsoleCmd("sm_stuck", Cmd_AntiStuck, "Use this when you're in stuck with spectator/unassigned team.");
    RegConsoleCmd("sm_antistuck", Cmd_AntiStuck, "Use this when you're in stuck with spectator/unassigned team.");
    RegConsoleCmd("sm_jointeam", Cmd_AntiStuck, "Use this when you're in stuck with spectator/unassigned team.");
    RegConsoleCmd("sm_autoteam", Cmd_AntiStuck, "Use this when you're in stuck with spectator/unassigned team.");
}

public void OnLibraryAdded(const char[] name)
{
    if (StrEqual(name, "updater"))
    {
        Updater_AddPlugin(UPDATE_URL);
    }
}

public void OnClientPutInServer(int client)
{
    if(Cvar_AnnounceAntiUAStuck.BoolValue)
    {
        CreateTimer(Float_TimerAnnounce, Timer_Announce, GetClientSerial(client));
    }
    if(Cvar_PluginEnabledAfterJoin.BoolValue)
    {
        CreateTimer(Float_TimerSecondAfterJoin, Timer_AntiStuck, GetClientSerial(client));
    }

    if(IsInvalidClient(client) || !Cvar_PluginEnabledBeforeJoin.BoolValue)
    {
        return;
    }

    FakeClientCommandEx(client, "autoteam");
}


public Action Cmd_AntiStuck(int client, int args)
{
    if(IsInvalidClient(client))
    {
        ReplyToCommand(client, "Sorry, but this command is available only for in-game players.");

        return Plugin_Handled;
    }

    if(TF2_GetClientTeam(client) == TFTeam_Unassigned)
    {
        FakeClientCommandEx(client, "autoteam");
    }

    return Plugin_Handled;
}

public Action Timer_Announce(Handle timer, int serial)
{
    int client = GetClientFromSerial(serial);

    if(IsInvalidClient(client))
    {
        return Plugin_Stop;
    }

    PrintToChat(client, "[AntiUAStuck] %t", "Welcome");

    return Plugin_Stop;
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
