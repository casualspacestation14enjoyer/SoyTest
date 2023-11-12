/datum/component/spawner
	var/mob_types = list(/mob/living/simple_animal/hostile/carp)
	var/spawn_time = 300 //30 seconds default
	var/list/spawned_mobs = list()
	var/spawn_delay = 0
	var/max_mobs = 5
	var/list/spawn_text = list("emerges from")
	var/list/faction = list("mining")
	var/list/spawn_sound = list()


/datum/component/spawner/Initialize(_mob_types, _spawn_time, _faction, _spawn_text, _max_mobs, _spawn_sound)
	if(_spawn_time)
		spawn_time=_spawn_time
	if(_mob_types)
		mob_types=_mob_types
	if(_faction)
		faction=_faction
	if(_spawn_text)
		spawn_text=_spawn_text
	if(_max_mobs)
		max_mobs=_max_mobs
	if(_spawn_sound)
		spawn_sound=_spawn_sound

	RegisterSignal(parent, list(COMSIG_PARENT_QDELETING), PROC_REF(stop_spawning))
	START_PROCESSING(SSprocessing, src)

/datum/component/spawner/process()
	try_spawn_mob()


/datum/component/spawner/proc/stop_spawning(force)
	SIGNAL_HANDLER

	STOP_PROCESSING(SSprocessing, src)
	for(var/mob/living/simple_animal/L in spawned_mobs)
		if(L.nest == src)
			L.nest = null
	spawned_mobs = null

/datum/component/spawner/proc/try_spawn_mob()
	var/atom/P = parent
	if(spawned_mobs.len >= max_mobs)
		return 0
	if(spawn_delay > world.time)
		return 0
	spawn_delay = world.time + spawn_time
	var/chosen_mob_type = pickweight(mob_types)
	var/mob/living/simple_animal/L = new chosen_mob_type(P.loc)
	L.flags_1 |= (P.flags_1 & ADMIN_SPAWNED_1)
	spawned_mobs += L
	L.nest = src
	L.faction = src.faction
	P.visible_message("<span class='danger'>[L] [pick(spawn_text)] [P].</span>")
	if(length(spawn_sound))
		playsound(P, pick(spawn_sound), 50, TRUE)
