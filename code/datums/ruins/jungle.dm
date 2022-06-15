// Hey! Listen! Update \config\jungleruinblacklist.txt with your new ruins!

/datum/map_template/ruin/jungle/jungle_botany_ruin
	id = "jungle_botany-ruin"
	suffix = "jungle_botany.dmm"
	name = "Ruined Botany Research Facility"
	description = "A research facility of great botany discoveries. Long since abandoned, willingly or not..."

/datum/map_template/ruin/jungle
	prefix = "_maps/RandomRuins/JungleRuins/"

/datum/map_template/ruin/jungle/solgov_crash
	name = "Abandoned SolGov Exploration Pod"
	id = "jungle-solgov-explorer"
	description = "A recently abandoned standard SolGov exploration pod. It may not be powerful or resilient, but it can fly in a pinch."
	suffix = "jungle_surface_abandonedsolgov.dmm"

/datum/map_template/ruin/jungle/ai_ikea
	name = "Space Ikea AI Shipment"
	id = "ikea-ai"
	description = "A Space Ikea Brand AI Core and Necessities Crate, it seems to have missed its intended target."
	suffix = "jungle_surface_ikea_ai.dmm"

/datum/map_template/ruin/jungle/coffinpirate
	name = "Coffin-Shaped Pirate Hut"
	id = "coffinpirate"
	description = "An odd coffin shaped pirate hut that the inhabitant of died in."
	suffix = "jungle_surface_coffinpirate.dmm"

///how bad can i possibly be?
/datum/map_template/ruin/jungle/onceler
	name = "Thneed Factory"
	id = "tumblr-sexyman"
	description = "After a logging incident gone wrong, the Syndicate invade this factory to stop the beast."
	suffix = "jungle_surface_tumblr_sexyman.dmm"

//industrial society blah blah blah
/datum/map_template/ruin/jungle/unabomber
	name = "Bombmaker's Cabin"
	id = "unabomber-cabin"
	description = "The Industrial Revolution and its consequences have been a disaster for the human race."
	suffix = "jungle_surface_unabomber_cabin.dmm"

/datum/map_template/ruin/jungle/weedshack
	name = "Stoner's Cabin"
	id = "weed-shack"
	description = "The Industrial Revolution and its consequences have been a disaster for the human race."
	suffix = "jungle_surface_weed_shack.dmm"

//vae's jungle ruins from bungalowstation
/datum/map_template/ruin/jungle/pizzawave
	name = "Jungle Pizzawave"
	id = "pizzawave"
	description = "Get some pizza my dude."
	suffix = "jungle_pizzawave.dmm"

/datum/map_template/ruin/jungle/nest
	name = "Jungle Xenonest"
	id = "xenonestjungle"
	description = "A Xeno nest crammed into the Jungle."
	suffix = "jungle_nest.dmm"

/datum/map_template/ruin/jungle/seedling
	name = "Seedling ruin"
	id = "seedling"
	description = "A rare seedling plant."
	suffix = "jungle_seedling.dmm"

/datum/map_template/ruin/jungle/demon
	name = "Demonic Office"
	id = "demonjungle"
	description = "They handle the paperwork that comes with selling your soul."
	suffix = "jungle_demon.dmm"

/datum/map_template/ruin/jungle/hangar
	name = "Abandoned Hangar"
	id = "hangar"
	description = "An abandoned hangar containing exosuits."
	suffix = "jungle_hangar.dmm"

/datum/map_template/ruin/jungle/spider
	name = "Jungle Spiders"
	id = "spiderjungle"
	description = "A genetic experiment gone wrong."
	suffix = "jungle_spider.dmm"

/datum/map_template/ruin/jungle/pirate
	name = "Jungle Pirates"
	id = "piratejungle"
	description = "A group of pirates on a small ship in the jungle."
	suffix = "jungle_pirate.dmm"

/datum/map_template/ruin/jungle/syndicate
	name = "Jungle Syndicate Bunker"
	id = "syndicatebunkerjungle"
	description = "A small bunker owned by the Syndicate."
	suffix = "jungle_syndicate.dmm"

/datum/map_template/ruin/jungle/village
	name = "Monkey Village"
	id = "monkeyvillage"
	description = "A small village of monkeys."
	suffix = "jungle_village.dmm"

/datum/map_template/ruin/jungle/witch
	name = "Jungle Witch"
	id = "witchjungle"
	description = "Some heretical sorcerer living in a dingy hut, with a cat."
	suffix = "jungle_witch.dmm"

/datum/map_template/ruin/jungle/roommates
	name = "Roommates"
	id = "roommates"
	description = "And they were roommates."
	suffix = "jungle_surface_roommates.dmm"

/datum/map_template/ruin/jungle/ninjashrine
	name = "Ninja Shrine"
	id = "ninjashrine"
	description = "A ninja shrine."
	suffix = "jungle_surface_ninjashrine.dmm"

/datum/map_template/ruin/jungle/interceptor
	name = "Old Crashed Interceptor"
	id = "crashedcondor"
	description = "An overgrown crashed Condor Class, a forgotten remnant of the Corporate Wars."
	suffix = "jungle_interceptor.dmm"

/area/ruin/jungle/interceptor/crashsite
	name = "Nanotrasen Interceptor Crashsite"
	icon_state = "yellow"
	always_unpowered = TRUE

/area/ruin/jungle/interceptor/afthall
	name = "NTSV Retribution Aft Hall"
	icon_state = "hallA"
	always_unpowered = TRUE

/area/ruin/jungle/interceptor/porthall
	name = "NTSV Retribution Port Hall"
	icon_state = "hallP"
	always_unpowered = TRUE

/area/ruin/jungle/interceptor/starhall
	name = "NTSV Retribution Starbard Hall"
	icon_state = "hallS"
	always_unpowered = TRUE

/area/ruin/jungle/interceptor/forehall
	name = "NTSV Retribution Fore Hall"
	icon_state = "hallF"
	always_unpowered = TRUE

/area/ruin/jungle/interceptor/bridge
	name = "NTSV Retribution Bridge"
	icon_state = "bridge"
	always_unpowered = TRUE

/area/ruin/jungle/interceptor/portmaints
	name = "NTSV Retribution Port Maintenance"
	icon_state = "pmaint"
	always_unpowered = TRUE

/area/ruin/jungle/interceptor/starmaints
	name = "NTSV Retribution Starboard Maintenance"
	icon_state = "smaint"
	always_unpowered = TRUE

/area/ruin/jungle/interceptor/security
	name = "NTSV Retribution Security"
	icon_state = "security"
	always_unpowered = TRUE

/area/ruin/jungle/interceptor/security
	name = "NTSV Retribution Security"
	icon_state = "security"
	always_unpowered = TRUE

/area/ruin/jungle/interceptor/crewquarters
	name = "NTSV Retribution Crewquarters"
	icon_state = "crew_quarters"
	always_unpowered = TRUE

/area/ruin/jungle/interceptor/starlauncherone
	name = "NTSV Retribution Starboard Launcher One"
	icon_state = "red"
	always_unpowered = TRUE

/area/ruin/jungle/interceptor/starlaunchertwo
	name = "NTSV Retribution Starboard Launcher Two"
	icon_state = "red"
	always_unpowered = TRUE
