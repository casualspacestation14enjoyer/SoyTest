/datum/map_generator/planet_generator/snow
	mountain_height = 0.40
	perlin_zoom = 55

	initial_closed_chance = 45
	smoothing_iterations = 20
	birth_limit = 4
	death_limit = 3

	primary_area_type = /area/overmap_encounter/planetoid/ice

	biome_table = list(
		BIOME_COLDEST = list(
			BIOME_LOWEST_HUMIDITY = /datum/biome/arctic/rocky,
			BIOME_LOW_HUMIDITY = /datum/biome/snow,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/iceberg/lake,
			BIOME_HIGH_HUMIDITY = /datum/biome/iceberg,
			BIOME_HIGHEST_HUMIDITY = /datum/biome/iceberg
		),
		BIOME_COLD = list(
			BIOME_LOWEST_HUMIDITY = /datum/biome/arctic,
			BIOME_LOW_HUMIDITY = /datum/biome/arctic/rocky,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/snow/lush,
			BIOME_HIGH_HUMIDITY = /datum/biome/snow,
			BIOME_HIGHEST_HUMIDITY = /datum/biome/iceberg
		),
		BIOME_WARM = list(
			BIOME_LOWEST_HUMIDITY = /datum/biome/snow/thawed,
			BIOME_LOW_HUMIDITY = /datum/biome/snow/forest,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/snow,
			BIOME_HIGH_HUMIDITY = /datum/biome/snow/lush,
			BIOME_HIGHEST_HUMIDITY = /datum/biome/iceberg
		),
		BIOME_TEMPERATE = list(
			BIOME_LOWEST_HUMIDITY = /datum/biome/snow/lush,
			BIOME_LOW_HUMIDITY = /datum/biome/snow/forest/dense,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/snow/forest/dense,
			BIOME_HIGH_HUMIDITY = /datum/biome/snow/forest,
			BIOME_HIGHEST_HUMIDITY = /datum/biome/snow/lush
		),
		BIOME_HOT = list(
			BIOME_LOWEST_HUMIDITY = /datum/biome/snow,
			BIOME_LOW_HUMIDITY = /datum/biome/snow/forest,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/snow/thawed,
			BIOME_HIGH_HUMIDITY = /datum/biome/snow/lush,
			BIOME_HIGHEST_HUMIDITY = /datum/biome/snow
		),
		BIOME_HOTTEST = list(
			BIOME_LOWEST_HUMIDITY = /datum/biome/snow/forest/dense,
			BIOME_LOW_HUMIDITY = /datum/biome/snow/forest,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/snow/thawed,
			BIOME_HIGH_HUMIDITY = /datum/biome/snow/forest/dense,
			BIOME_HIGHEST_HUMIDITY = /datum/biome/snow/thawed
		)
	)

	cave_biome_table = list(
		BIOME_COLDEST_CAVE = list(
			BIOME_LOWEST_HUMIDITY = /datum/biome/cave/snow,
			BIOME_LOW_HUMIDITY = /datum/biome/cave/snow,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/cave/snow,
			BIOME_HIGH_HUMIDITY = /datum/biome/cave/snow,
			BIOME_HIGHEST_HUMIDITY = /datum/biome/cave/snow/ice
		),
		BIOME_COLD_CAVE = list(
			BIOME_LOWEST_HUMIDITY = /datum/biome/cave/snow,
			BIOME_LOW_HUMIDITY = /datum/biome/cave/snow,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/cave/snow,
			BIOME_HIGH_HUMIDITY = /datum/biome/cave/snow/ice,
			BIOME_HIGHEST_HUMIDITY = /datum/biome/cave/snow/ice
		),
		BIOME_WARM_CAVE = list(
			BIOME_LOWEST_HUMIDITY = /datum/biome/cave/snow,
			BIOME_LOW_HUMIDITY = /datum/biome/cave/snow,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/cave/snow/thawed,
			BIOME_HIGH_HUMIDITY = /datum/biome/cave/snow/thawed,
			BIOME_HIGHEST_HUMIDITY = /datum/biome/cave/snow
		),
		BIOME_HOT_CAVE = list(
			BIOME_LOWEST_HUMIDITY = /datum/biome/cave/snow/thawed,
			BIOME_LOW_HUMIDITY = /datum/biome/cave/snow/thawed,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/cave/volcanic/lava/plasma,
			BIOME_HIGH_HUMIDITY = /datum/biome/cave/volcanic/lava,
			BIOME_HIGHEST_HUMIDITY = /datum/biome/cave/volcanic/lava/total
		)
	)

/datum/biome/snow
	open_turf_types = list(
		/turf/open/floor/plating/asteroid/snow/lit = 25
	)
	flora_spawn_list = list(
		/obj/structure/flora/tree/pine = 2,
		/obj/structure/flora/rock/icy = 2,
		/obj/structure/flora/rock/pile/icy = 2,
		/obj/structure/flora/grass/both = 6,
		/obj/structure/flora/ash/chilly = 2,
		/obj/structure/flora/ash/garden/frigid = 1,
	)
	flora_spawn_chance = 10
	mob_spawn_chance = 1
	mob_spawn_list = list(
		/mob/living/simple_animal/hostile/asteroid/wolf/random = 30,
		/obj/structure/spawner/ice_moon = 3,
		/obj/structure/spawner/ice_moon/polarbear = 3,
		/mob/living/simple_animal/hostile/asteroid/polarbear/random = 30,
		/mob/living/simple_animal/hostile/asteroid/hivelord/legion/snow = 50,
		/mob/living/simple_animal/hostile/asteroid/goldgrub = 10,
		/mob/living/simple_animal/hostile/asteroid/ice_demon/random = 10,
		/mob/living/simple_animal/hostile/asteroid/ice_whelp = 10,
		/mob/living/simple_animal/hostile/asteroid/lobstrosity = 10,
	)
	feature_spawn_chance = 0.1
	feature_spawn_list = list(
		/obj/structure/spawner/ice_moon/demonic_portal = 1,
		/obj/structure/spawner/ice_moon/demonic_portal/ice_whelp = 1,
		/obj/structure/spawner/ice_moon/demonic_portal/snowlegion = 1,
		/obj/effect/spawner/lootdrop/anomaly/ice = 1
	)

/datum/biome/snow/lush
	open_turf_types = list(
		/turf/open/floor/plating/asteroid/snow/lit = 25
	)
	flora_spawn_list = list(
		/obj/structure/flora/grass/both = 1,
	)
	flora_spawn_chance = 30

/datum/biome/snow/thawed
	open_turf_types = list(
		/turf/open/floor/plating/asteroid/icerock/lit = 1
	)
	flora_spawn_chance = 40
	flora_spawn_list = list(
		/obj/structure/flora/ausbushes/fullgrass = 1,
		/obj/structure/flora/ausbushes/sparsegrass = 1,
		/obj/structure/flora/ausbushes = 1,
		/obj/structure/flora/ausbushes/ppflowers = 1,
		/obj/structure/flora/ausbushes/lavendergrass = 1,
		/obj/structure/flora/ash/garden/frigid = 1,
	)

/datum/biome/snow/forest
	flora_spawn_chance = 15
	flora_spawn_list = list(
		/obj/structure/flora/tree/pine = 10,
		/obj/structure/flora/tree/dead = 3,
		/obj/structure/flora/grass/both = 4
	)

/datum/biome/snow/forest/dense
	flora_spawn_chance = 25
	flora_spawn_list = list(
		/obj/structure/flora/tree/pine = 20,
		/obj/structure/flora/grass/both = 6,
		/obj/structure/flora/tree/dead = 3,
	)

/datum/biome/arctic
	open_turf_types = list(
		/turf/open/floor/plating/asteroid/snow/lit = 1
	)
	feature_spawn_chance = 0.1
	feature_spawn_list = list(
		/obj/structure/spawner/ice_moon = 3,
		/obj/structure/spawner/ice_moon/polarbear = 3,
		/obj/structure/statue/snow/snowman = 3,
		/obj/structure/statue/snow/snowlegion = 1
	)
	mob_spawn_list = list(
		/mob/living/simple_animal/hostile/asteroid/wolf/random = 30,
		/obj/structure/spawner/ice_moon = 3,
		/obj/structure/spawner/ice_moon/polarbear = 3,
		/mob/living/simple_animal/hostile/asteroid/polarbear/random = 30,
		/mob/living/simple_animal/hostile/asteroid/hivelord/legion/snow = 50,
		/mob/living/simple_animal/hostile/asteroid/goldgrub = 10,
		/mob/living/simple_animal/hostile/asteroid/ice_demon/random = 5,
		/mob/living/simple_animal/hostile/asteroid/ice_whelp = 5,
		/mob/living/simple_animal/hostile/asteroid/lobstrosity = 5,
	)
	mob_spawn_chance = 1

/datum/biome/arctic/rocky
	flora_spawn_chance = 5
	flora_spawn_list = list(
		/obj/structure/flora/rock/icy = 2,
		/obj/structure/flora/rock/pile/icy = 2,
	)

/datum/biome/iceberg
	open_turf_types = list(
		/turf/open/floor/plating/asteroid/iceberg/lit = 6,
		/turf/open/floor/plating/ice/iceberg/lit = 1,
		/turf/closed/mineral/ice = 10
	)
	mob_spawn_chance = 2
	mob_spawn_list = list(
		/mob/living/simple_animal/hostile/asteroid/wolf/random = 30,
		/mob/living/simple_animal/hostile/asteroid/polarbear/random = 30,
		/mob/living/simple_animal/hostile/asteroid/hivelord/legion/snow = 50,
		/mob/living/simple_animal/hostile/asteroid/goldgrub = 10,
		/mob/living/simple_animal/hostile/asteroid/ice_demon/random = 5,
		/mob/living/simple_animal/hostile/asteroid/ice_whelp = 5,
		/mob/living/simple_animal/hostile/asteroid/lobstrosity = 5,
	)
	feature_spawn_chance = 0.3
	feature_spawn_list = list(
		/obj/effect/spawner/lootdrop/anomaly/ice = 1,
		/obj/effect/spawner/lootdrop/anomaly/big = 0.1
		/obj/structure/spawner/ice_moon/demonic_portal/low_threat = 25,
		/obj/structure/spawner/ice_moon/demonic_portal/medium_threat = 50,
		/obj/structure/spawner/ice_moon/demonic_portal/high_threat = 13,
		/obj/structure/spawner/ice_moon/demonic_portal/extreme_threat = 12
	)


/datum/biome/iceberg/lake
	open_turf_types = list(
		/turf/open/floor/plating/ice/lit = 1
	)

/datum/biome/plasma
	open_turf_types = list(
		/turf/open/lava/plasma/ice_moon = 5,
		/turf/open/floor/plating/asteroid/icerock/smooth = 1
	)

/datum/biome/cave/snow
	open_turf_types = list(
		/turf/open/floor/plating/asteroid/icerock = 1
	)
	flora_spawn_chance = 6
	flora_spawn_list = list(
		/obj/structure/flora/grass/both = 5,
		/obj/structure/flora/rock/pile/icy = 1,
		/obj/structure/flora/rock/icy = 1,
		/obj/structure/flora/ash/space = 1,
		/obj/structure/flora/ash/leaf_shroom = 1,
		/obj/structure/flora/ash/cap_shroom = 1,
		/obj/structure/flora/ash/stem_shroom = 1,
		/obj/structure/flora/ash/puce = 1,
		/obj/structure/flora/ash/garden/frigid = 1,
	)
	closed_turf_types = list(
		/turf/closed/mineral/random/snow = 1
	)
	mob_spawn_chance = 2
	mob_spawn_list = list(
		/mob/living/simple_animal/hostile/asteroid/wolf/random = 30,
		/obj/structure/spawner/ice_moon = 3,
		/obj/structure/spawner/ice_moon/polarbear = 3,
		/mob/living/simple_animal/hostile/asteroid/polarbear/random = 30,
		/mob/living/simple_animal/hostile/asteroid/hivelord/legion/snow = 50,
		/mob/living/simple_animal/hostile/asteroid/goldgrub = 10,
		/mob/living/simple_animal/hostile/asteroid/ice_demon/random = 5,
		/mob/living/simple_animal/hostile/asteroid/ice_whelp = 5,
		/mob/living/simple_animal/hostile/asteroid/lobstrosity = 10,
	)
	feature_spawn_chance = 0.2
	feature_spawn_list = list(
		/obj/structure/spawner/ice_moon/demonic_portal = 1,
		/obj/structure/spawner/ice_moon/demonic_portal/ice_whelp = 1,
		/obj/structure/spawner/ice_moon/demonic_portal/snowlegion = 1,
		/obj/structure/spawner/ice_moon = 1,
		/obj/structure/spawner/ice_moon/polarbear = 1,
		/obj/effect/spawner/lootdrop/anomaly/ice = 1
	)

/datum/biome/cave/snow/thawed
	open_turf_types = list(
		/turf/open/floor/plating/asteroid/icerock/cracked = 1
	)
	closed_turf_types = list(
		/turf/closed/mineral/random/snow = 1
	)

/datum/biome/cave/snow/ice
	open_turf_types = list(
		/turf/open/floor/plating/asteroid/icerock = 20,
		/turf/open/floor/plating/ice = 3
	)
	closed_turf_types = list(
		/turf/closed/mineral/random/snow = 1
	)

/datum/biome/cave/volcanic
	open_turf_types = list(
		/turf/open/floor/plating/asteroid/basalt = 1
	)
	closed_turf_types = list(
		/turf/closed/mineral/random/snow = 1
		)
	mob_spawn_chance = 2
	mob_spawn_list = list(
		/mob/living/simple_animal/hostile/asteroid/wolf/random = 30,
		/mob/living/simple_animal/hostile/asteroid/polarbear/random = 30,
		/mob/living/simple_animal/hostile/asteroid/hivelord/legion/snow = 50,
		/mob/living/simple_animal/hostile/asteroid/goldgrub = 10,
		/mob/living/simple_animal/hostile/asteroid/ice_demon/random = 10,
		/mob/living/simple_animal/hostile/asteroid/ice_whelp = 10,
		/mob/living/simple_animal/hostile/asteroid/lobstrosity = 10,
	)
	flora_spawn_chance = 3
	flora_spawn_list = list(
		/obj/structure/flora/ash/leaf_shroom = 1,
		/obj/structure/flora/ash/cap_shroom = 1,
		/obj/structure/flora/ash/stem_shroom = 1,
	)
	feature_spawn_chance = 0.2
	feature_spawn_list = list(
		/obj/structure/spawner/ice_moon/demonic_portal = 1,
		/obj/structure/spawner/ice_moon/demonic_portal/ice_whelp = 1,
		/obj/structure/spawner/ice_moon/demonic_portal/snowlegion = 1,
		/obj/structure/spawner/ice_moon = 3,
		/obj/structure/spawner/ice_moon/polarbear = 3,
		/obj/effect/spawner/lootdrop/anomaly/ice = 1
	)

/datum/biome/cave/volcanic/lava
	open_turf_types = list(
		/turf/open/lava/smooth = 10,
		/turf/open/floor/plating/asteroid/icerock/smooth = 1
	)

/datum/biome/cave/volcanic/lava/total
	open_turf_types = list(
		/turf/open/lava/smooth = 1
	)

/datum/biome/cave/volcanic/lava/plasma
	open_turf_types = list(
		/turf/open/lava/plasma = 7,
		/turf/open/floor/plating/asteroid/icerock/smooth = 1
	)
