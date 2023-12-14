#include <sourcemod>


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//*
//*                 AntiTK
//*                 Status: beta.
//*					Автор релиза BatrakovScripts Ник на форуме(Alexander_Mirny)
//*
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



ConVar ScoreWarn;
new Score[MAXPLAYERS];
new Player;

public OnPluginStart() 
{
	ScoreWarn = CreateConVar("WarnScore", "15", "Варн-очки", FCVAR_NOTIFY);
	HookEvent("friendly_fire", OnFriendlyFire);
	HookEvent("round_end", OnRoundEnd, EventHookMode_PostNoCopy);
	HookEvent("map_transition", MapChanges);
	CreateTimer(3.0 , SecondTimer, _, TIMER_REPEAT);
}
public MapChanges(Handle:event, const String:name[], bool:dontBroadcast)
{
	for (new i = 1; i <= GetMaxClients(); i++)
	{
		Score[i] = 0;
	}
}
public Action SecondTimer(Handle timer)
{
	if(Score[Player] == GetConVarInt(ScoreWarn))
	{
		KickClient(Player, "Вы были кикнуты по подозрении в тк своей команды!");
	}
}
public OnRoundEnd (Handle:event, const String:name[], bool:dontBroadcast)
{
	Score[Player] = 0;
}
public OnFriendlyFire(Handle:event, const String:name[], bool:dontBroadcast)
{
	new attacker  = GetClientOfUserId(GetEventInt(event, "attacker"));
	new victim  = GetClientOfUserId(GetEventInt(event, "victim"));
	Player = attacker;
	if (!attacker || !IsClientInGame(attacker)) return;
	if(attacker != victim && GetClientTeam(attacker) == 2)
	{
		Score[attacker]++;
		PrintToChat(attacker,"\x03[ANTI-TK]\x05Вы атаковали игрока \x04%N \x05Варн-очки \x04(+%d)", victim, Score[attacker]);
		PrintToChat(attacker,"\x03[ANTI-TK]\x05При достижении \x04(%d) \x05Варн-очков, вас кикнет.", GetConVarInt(ScoreWarn));
	}
}