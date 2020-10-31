#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = {
    name        = "Anti <Unassigned> Stuck",
    author      = "Jobggun",
    description = "",
    version     = "1.0.0",
    url         = ""
};

public void OnClientPutInServer(int client)
{
    FakeClientCommandEx(client, "autoteam");
}
