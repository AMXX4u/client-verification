#include <amxmodx>
#include <amxmisc>
#include <nvault>
#include <reapi>
#include <CromChat>
#include <amxx4u>

// #define DEBUG_MODE
#define TASK_KICK 5482

enum _:CLIENT_CVARS (+= 1)
{
	KICK_REASON[MAX_NAME],
	SHOW_SUSPECTS,
	CLIENT_MARK[MAX_NAME],
	SHOW_MARK_SUSPECTS
};

static const NAME[]			= "Client Verification";
static const AUTHOR[]		= "NewITVision";
static const VERSION[]		= "1.0";
static const URL_AUTHOR[]	= "https://amxx4u.pl/";

static const SAVE_KEY[] 	= "amxx4u_client";

static const menu_title[]  	= "\dCLIENT VERIFICATION - AMXX4u.pl^n\r[CLIENT]\w";
static const menu_prefix[] 	= "\d›\w";
static const chat_prefix[] 	= "&x07[» AMXX4u.pl «]&x01";

static const steam_commands[][] =
{
	"/steam",
	"/client",
	"/nsblok",
	"/verificaton"
};

new steam_id[MAX_AUTHID];

new bool:all_players;
new cvar_client[CLIENT_CVARS];
new vault;

public plugin_init()
{
	register_plugin(NAME, VERSION, AUTHOR, URL_AUTHOR);

	register_commands(steam_commands, sizeof(steam_commands), "steam_menu", ADMIN_IMMUNITY);
	RegisterHookChain(RG_CBasePlayer_Spawn, "player_spawn", true);

	_register_cvars();

	vault = nvault_open("amxx4u_client");
	CC_SetPrefix(chat_prefix);
}

public plugin_cfg()
{
	all_players = nvault_get(vault, SAVE_KEY) ? false : true;

	#if defined DEBUG_MODE
		log_amx("%s Kick all: %s", debug_prefix, all_players ? "enabled" : "disabled");
	#endif
}

public plugin_end()
	nvault_close(vault);

public player_spawn(index)
{
	if(all_players)
		players_kick();
}

public steam_menu(index)
{
	if(!has_flag(index, "a"))
		return PLUGIN_HANDLED;

	new menu = menu_create(fmt("%s Client Verification", menu_title), "steam_handle");

	menu_additem(menu, fmt("%s Wyrzucaj podejrzanych graczy: %s", menu_prefix, all_players ? "\rTak" : "\yNie"));
	menu_additem(menu, fmt("%s Wyrzuc wszystkich podejrzanych graczy", menu_prefix));

	menu_addblank(menu, .slot = 0);
	menu_addtext(menu, fmt("%s\d Lista graczy:", menu_prefix), .slot = 0);

	if(cvar_client[SHOW_SUSPECTS])
	{
		ForPlayers(i)
		{
			if(!is_user_connected(i) || check_version(i))
				continue;

			menu_additem(menu, fmt("%s %n\d (%s)", menu_prefix, i, steam_id), fmt("%i", i));
		}
	}
	else
	{
		ForPlayers(i)
		{
			if(!is_user_connected(i) || is_user_hltv(i))
				continue;

			menu_additem(menu, fmt("%s %n\d (%s)\r %s", menu_prefix, i, steam_id, check_version(i) ? "": fmt("%s", cvar_client[CLIENT_MARK])), fmt("%i", i));
		}
	}

	menu_setprop(menu, MPROP_BACKNAME, fmt("%s Wroc", menu_prefix));
	menu_setprop(menu, MPROP_NEXTNAME, fmt("%s Dalej", menu_prefix));

	menu_setprop(menu, MPROP_EXITNAME, fmt("%s Wyjdz", menu_prefix));
	menu_display(index, menu);

	return PLUGIN_HANDLED;
}

public steam_handle(index, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}

	switch(item)
	{
		case 0:
		{
			all_players = !all_players;
			nvault_set(vault, SAVE_KEY, all_players ? "0" : "1");

			CC_SendMessage(index, "Wyrzucanie podejrzanych %s", all_players ? "&x04wlaczone&x01 (Od nastepnego spawna, wszyscy podejrzani zostana wyrzuceni)" : "&x07wylaczone");
		}
		case 1:
		{
			ForPlayers(i)
			{
				if(!is_user_connected(i) || is_user_hltv(i))
					continue;

				if(check_version(i))
				{
					#if defined DEBUG_MODE
						log_amx("%s [ALL] Client Steam: %n", debug_prefix, i);
					#endif

					CC_SendMessage(index, "Brak graczy do wyrzucenia.");
					return PLUGIN_HANDLED;
				}

				server_cmd("amx_kick #%d ^"%s^"", get_user_userid(i), cvar_client[KICK_REASON]);
				return PLUGIN_HANDLED;
			}
		}
		default:
		{
			new data[6];

			menu_item_getinfo(menu, item, _, data, charsmax(data));
			menu_destroy(menu);

			new target = str_to_num(data);

			if(!is_user_connected(target))
			{
				CC_SendMessage(index, "Wybrany gracz&x07 wyszedl&x01 z serwera.");
				return PLUGIN_HANDLED;
			}

			if(check_version(target))
			{
				#if defined DEBUG_MODE
					log_amx("%s [ITEM] Client Steam: %n", debug_prefix, target);
				#endif

				CC_SendMessage(index, "Wybrany gracz nie jest podejrzanym graczem.");
				return PLUGIN_HANDLED;
			}

			server_cmd("amx_kick #%d ^"%s^"", get_user_userid(target), cvar_client[KICK_REASON]);
		}
	}
	return PLUGIN_HANDLED;
}

public client_putinserver(index)
{
	if(is_user_hltv(index))
		return PLUGIN_HANDLED;

	get_user_authid(index, steam_id, charsmax(steam_id));

	if(all_players)
		players_kick();

	#if defined DEBUG_MODE
		if(check_version(index))
		{
			log_amx("%s [ERROR] Steam = Player: %n | SteamID: %s", debug_prefix, index, steam_id);
			return PLUGIN_HANDLED;
		}

		log_amx("[WARNING | PUTINSERVER] Player: %n | SteamID: %s", index, steam_id);
	#endif

	return PLUGIN_HANDLED;
}

public players_kick()
{
	if(task_exists(TASK_KICK))
		remove_task(TASK_KICK);

	ForPlayers(i)
	{
		if(!is_user_connected(i) || is_user_hltv(i) || check_version(i))
			continue;

		server_cmd("amx_kick #%d ^"%s^"", get_user_userid(i), cvar_client[KICK_REASON]);
	}
}

stock bool:check_version(index)
{
	#define get_steam(%1) containi(steam_id, %1) != -1

	get_user_authid(index, steam_id, charsmax(steam_id));

	if(get_steam("STEAM_0:0:") || get_steam("STEAM_0:1:") || get_steam("STEAM_1:0:") || get_steam("STEAM_2:0:"))
		return true;

	return false;
}

_register_cvars()
{
	bind_pcvar_string(create_cvar("amxx4u_kick_reason", "AMXX4u.pl - Client blocked",
		.description = "Powód wyrzucenia podejrzanych graczy/a"), cvar_client[KICK_REASON], charsmax(cvar_client[KICK_REASON]));

	bind_pcvar_num(create_cvar("amxx4u_show_suspects", "0",
		.description = "Wyświetlać tylko podejrzanych graczy w menu?"), cvar_client[SHOW_SUSPECTS]);

	bind_pcvar_string(create_cvar("amxx4u_client_mark", "#",
		.description = "Znak wyświetlany przy podejrzanych"), cvar_client[CLIENT_MARK], charsmax(cvar_client[CLIENT_MARK]));

	bind_pcvar_num(create_cvar("amxx4u_mark_suspects", "1",
		.description = "Wyświetlać znak (#) przy?"), cvar_client[SHOW_MARK_SUSPECTS]);

	create_cvar("amxx4u_pl", VERSION, FCVAR_SERVER);
}