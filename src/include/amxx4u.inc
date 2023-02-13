#if defined _amxx4u_included
	#endinput
#endif
#define _amxx4u_included

#if !defined ForPlayers
	#define ForPlayers(%1) for(new %1 = 1; %1 <= MAX_PLAYERS; %1++)
#endif

#if !defined ForArray
	#define ForArray(%1,%2) for(new %1 = 0; %1 < sizeof %2; %1++)
#endif

#if !defined ForDynamicArray
	#define ForDynamicArray(%1,%2) for(new %1 = 0; %1 < ArraySize(%2); %1++)
#endif

#if !defined ForRange
	#define ForRange(%1,%2,%3) for(new %1 = %2; %1 <= %3; %1++)
#endif

#define MAX_NAME 		MAX_NAME_LENGTH 				// 32
#define MAX_SAFE_NAME   MAX_NAME * 2					// 64
#define MAX_DESC        MAX_MENU_LENGTH 				// 512
#define MAX_IP 	 		MAX_IP_LENGTH 					// 16
#define MAX_IP_PORT		MAX_IP_WITH_PORT_LENGTH 		// 22
#define MAX_AUTHID 		MAX_AUTHID_LENGTH 				// 64
#define MAX_PATH		MAX_RESOURCE_PATH_LENGTH * 2	// 128
#define MAX_MOTD 		MAX_MOTD_LENGTH 				// 1536
#define MAX_USER_INFO 	MAX_USER_INFO_LENGTH 			// 256
#define MAX_MENU 		MAX_MENU_LENGTH 				// 512
#define MAX_MESSAGE 	192

stock register_commands(const array[][], array_size, function[], flags = -1)
{
	ForRange(i, 0, array_size - 1)
	{
		ForRange(j, 0, 1)
			register_clcmd(fmt("%s %s", !j ? "say" : "say_team", array[i]), function, flags);
	}
}