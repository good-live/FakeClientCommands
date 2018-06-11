#include <sourcemod>
#include <sdktools>
 
public Plugin myinfo =
{
	name = "Fake Client Commands",
	author = "good_live",
	description = "Allows an admin to fake client commands.",
	version = "1.0.0.0",
	url = "http://www.sourcemod.net/"
}
 
public void OnPluginStart()
{
	LoadTranslations("common.phrases");
	RegAdminCmd("sm_force", Command_Force, ADMFLAG_ROOT);
}
 
public Action Command_Force(int client, int args)
{
    if(args < 2) {
        ReplyToCommand(client, "You need to provide at least two arguments");
        return Plugin_Handled;
    }

    char sArgs[512];
    int iLength;
    GetCmdArgString(sArgs, sizeof(sArgs));

    char sPlayerName[MAX_TARGET_LENGTH];
    iLength = BreakString(sArgs, sPlayerName, sizeof(sPlayerName));
    
    char sTargetName[MAX_TARGET_LENGTH];
    int iTargetList[MAXPLAYERS];
    int iTargetCount;
    bool bTranslation;

	if ((iTargetCount = ProcessTargetString(
			sPlayerName,
			client,
			iTargetList,
			MAXPLAYERS,
			COMMAND_FILTER_CONNECTED | COMMAND_FILTER_NO_BOTS, /* Only allow connected players */
			sTargetName,
			sizeof(sTargetName),
			bTranslation)) <= 0)
	{
		/* This function replies to the admin with a failure message */
		ReplyToTargetError(client, iTargetCount);
		return Plugin_Handled;
	}
 
	for (int i = 0; i < iTargetCount; i++)
	{
		FakeClientCommandEx(iTargetList[i], sArgs[iLength]);
		LogAction(client, iTargetList[i], "\"%L\" faked command %s as \"%L\"", client, sArgs[iLength], iTargetList[i]);
	}
 
	if (bTranslation)
	{
		ReplyToCommand(client, "[SM] Faked command for %t", sTargetName);
	}
	else
	{
		ReplyToCommand(client, "[SM] Faked command for %s", sTargetName);
	}
 
	return Plugin_Handled;
}
