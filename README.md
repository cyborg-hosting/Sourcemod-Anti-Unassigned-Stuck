# Sourcemod-Anti-Unassigned-Stuck

This is useful when people gets stuck in \<Spectator\> or \<Unassigned\> team.

This does forces user to change team automatically by user command ``autoteam``

## Convars and Commands

### Convars
- ``sm_antiuastuck_version``: Plugin's Version Convar. DO NOT CHANGE THIS!
- ``sm_antiuastuck_announce``: Whether plugin announces plugin's info before player connected or not.
- ``sm_antiuastuck_beforejoin``: Whether plugin uses ``autoteam`` command before player connected or not.
- ``sm_antiuastuck_afterjoin``: Whether plugin uses ``autoteam`` command if player is still in <Unassigned> team after join.

### Client/Public Commands
- ``!stuck`` ``!antistuck`` ``!jointeam`` ``!autoteam``: Use this when you're in stuck with spectator/unassigned team.

### Server/Admin Commands
