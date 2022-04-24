/obj/machinery/door/poddoor
	name = "blast door"
	desc = "A heavy duty blast door that opens mechanically."
	icon = 'icons/obj/doors/blastdoor.dmi'
	icon_state = "closed"
	var/id = 1
	layer = BLASTDOOR_LAYER
	closingLayer = CLOSED_BLASTDOOR_LAYER
	sub_door = TRUE
	explosion_block = 3
	heat_proof = TRUE
	safe = FALSE
	max_integrity = 600
	armor = list("melee" = 50, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 50, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 70)
	resistance_flags = FIRE_PROOF
	damage_deflection = 70
	poddoor = TRUE
	var/open_sound = 'sound/machines/blastdoor.ogg'
	var/close_sound = 'sound/machines/blastdoor.ogg'
/obj/machinery/door/poddoor/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	id = "[REF(port)][id]"

/obj/machinery/door/poddoor/preopen
	icon_state = "open"
	density = FALSE
	opacity = FALSE

/obj/machinery/door/poddoor/ert
	name = "hardened blast door"
	desc = "A heavy duty blast door that only opens for dire emergencies."
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

//special poddoors that open when emergency shuttle docks at centcom
/obj/machinery/door/poddoor/shuttledock
	var/checkdir = 4	//door won't open if turf in this dir is `turftype`
	var/turftype = /turf/open/space

/obj/machinery/door/poddoor/shuttledock/proc/check()
	var/turf/T = get_step(src, checkdir)
	if(!istype(T, turftype))
		INVOKE_ASYNC(src, .proc/open)
	else
		INVOKE_ASYNC(src, .proc/close)

/obj/machinery/door/poddoor/incinerator_toxmix
	name = "combustion chamber vent"
	id = INCINERATOR_TOXMIX_VENT

/obj/machinery/door/poddoor/incinerator_atmos_main
	name = "turbine vent"
	id = INCINERATOR_ATMOS_MAINVENT

/obj/machinery/door/poddoor/incinerator_atmos_aux
	name = "combustion chamber vent"
	id = INCINERATOR_ATMOS_AUXVENT

/obj/machinery/door/poddoor/incinerator_syndicatelava_main
	name = "turbine vent"
	id = INCINERATOR_SYNDICATELAVA_MAINVENT

/obj/machinery/door/poddoor/incinerator_syndicatelava_aux
	name = "combustion chamber vent"
	id = INCINERATOR_SYNDICATELAVA_AUXVENT

/obj/machinery/door/poddoor/Bumped(atom/movable/AM)
	if(density)
		return 0
	else
		return ..()

//"BLAST" doors are obviously stronger than regular doors when it comes to BLASTS.
/obj/machinery/door/poddoor/ex_act(severity, target)
	if(severity == 3)
		return
	..()

/obj/machinery/door/poddoor/do_animate(animation)
	switch(animation)
		if("opening")
			flick("opening", src)
			playsound(src, open_sound, 30, FALSE)
		if("closing")
			flick("closing", src)
			playsound(src, close_sound, 30, FALSE)

/obj/machinery/door/poddoor/update_icon_state()
	if(density)
		icon_state = "closed"
	else
		icon_state = "open"

/obj/machinery/door/poddoor/try_to_activate_door(mob/user)
	return

/obj/machinery/door/poddoor/try_to_crowbar(obj/item/I, mob/user)
	if(machine_stat & NOPOWER)
		open(TRUE)

/obj/machinery/door/poddoor/attack_alien(mob/living/carbon/alien/humanoid/user)
	if(density & !(resistance_flags & INDESTRUCTIBLE))
		add_fingerprint(user)
		user.visible_message("<span class='warning'>[user] begins prying open [src].</span>",\
					"<span class='noticealien'>You begin digging your claws into [src] with all your might!</span>",\
					"<span class='warning'>You hear groaning metal...</span>")
		playsound(src, 'sound/machines/airlock_alien_prying.ogg', 100, TRUE)

		var/time_to_open = 5 SECONDS
		if(hasPower())
			time_to_open = 15 SECONDS

		if(do_after(user, time_to_open, TRUE, src))
			if(density && !open(TRUE)) //The airlock is still closed, but something prevented it opening. (Another player noticed and bolted/welded the airlock in time!)
				to_chat(user, "<span class='warning'>Despite your efforts, [src] managed to resist your attempts to open it!</span>")

	else
		return ..()

/obj/machinery/door/poddoor/multi_tile
	name = "large pod door"
	layer = CLOSED_DOOR_LAYER
	closingLayer = CLOSED_DOOR_LAYER

/obj/machinery/door/poddoor/multi_tile/New()
	. = ..()
	apply_opacity_to_my_turfs(opacity)

/obj/machinery/door/poddoor/multi_tile/open()
	if(..())
		apply_opacity_to_my_turfs(opacity)


/obj/machinery/door/poddoor/multi_tile/close()
	if(..())
		apply_opacity_to_my_turfs(opacity)

/obj/machinery/door/poddoor/multi_tile/Destroy()
	apply_opacity_to_my_turfs(0)
	return ..()

//Multi-tile poddoors don't turn invisible automatically, so we change the opacity of the turfs below instead one by one.
/obj/machinery/door/poddoor/multi_tile/proc/apply_opacity_to_my_turfs(var/new_opacity)
	for(var/turf/T in locs)
		T.opacity = new_opacity
		T.directional_opacity = ALL_CARDINALS
		T.reconsider_lights()
		T.air_update_turf(1)
	update_freelook_sight()

/obj/machinery/door/poddoor/multi_tile/four_tile_ver/
	icon = 'whitesands/icons/obj/doors/1x4blast_vert.dmi'
	bound_height = 128
	dir = NORTH

/obj/machinery/door/poddoor/multi_tile/three_tile_ver/
	icon = 'whitesands/icons/obj/doors/1x3blast_vert.dmi'
	bound_height = 96
	dir = NORTH

/obj/machinery/door/poddoor/multi_tile/two_tile_ver/
	icon = 'whitesands/icons/obj/doors/1x2blast_vert.dmi'
	bound_height = 64
	dir = NORTH

/obj/machinery/door/poddoor/multi_tile/four_tile_hor/
	icon = 'whitesands/icons/obj/doors/1x4blast_hor.dmi'
	bound_width = 128
	dir = EAST

/obj/machinery/door/poddoor/multi_tile/three_tile_hor/
	icon = 'whitesands/icons/obj/doors/1x3blast_hor.dmi'
	bound_width = 96
	dir = EAST

/obj/machinery/door/poddoor/multi_tile/two_tile_hor/
	icon = 'whitesands/icons/obj/doors/1x2blast_hor.dmi'
	bound_width = 64
	dir = EAST
