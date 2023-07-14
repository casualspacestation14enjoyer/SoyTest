/obj/effect/ebeam/curse_arm
	name = "curse arm"
	layer = LARGE_MOB_LAYER

/obj/projectile/curse_hand
	name = "curse hand"
	icon_state = "cursehand0"
	hitsound = 'sound/effects/curse4.ogg'
	layer = LARGE_MOB_LAYER
	damage_type = BURN
	damage = 10
	paralyze = 20
	speed = 2
	range = 16
	var/datum/beam/arm
	var/handedness = 0

/obj/projectile/curse_hand/Initialize(mapload)
	. = ..()
	handedness = prob(50)
	icon_state = "cursehand[handedness]"

/obj/projectile/curse_hand/update_icon_state()
	icon_state = "[initial(icon_state)][handedness]"

/obj/projectile/curse_hand/fire(setAngle)
	if(starting)
		arm = starting.Beam(src, icon_state = "curse[handedness]", time = INFINITY, maxdistance = INFINITY, beam_type=/obj/effect/ebeam/curse_arm)
	..()

/obj/projectile/curse_hand/prehit_pierce(atom/target)
	return (target == original)? PROJECTILE_PIERCE_NONE : PROJECTILE_PIERCE_PHASE

/obj/projectile/curse_hand/Destroy()
	QDEL_NULL(arm)
	return ..()

/// The visual effect for the hand disappearing
/obj/projectile/curse_hand/proc/finale()
	if(arm)
		QDEL_NULL(arm)
	if((movement_type & PHASING))
		playsound(src, 'sound/effects/curse3.ogg', 25, TRUE, -1)
	var/turf/T = get_step(src, dir)
	var/obj/effect/temp_visual/dir_setting/curse/hand/leftover = new(T, dir)
	leftover.icon_state = icon_state
	for(var/obj/effect/temp_visual/dir_setting/curse/grasp_portal/G in starting)
		qdel(G)
	if(!T) //T can be in nullspace when src is set to QDEL
		return
	new /obj/effect/temp_visual/dir_setting/curse/grasp_portal/fading(starting, dir)
	var/datum/beam/D = starting.Beam(T, icon_state = "curse[handedness]", time = 32, beam_type=/obj/effect/ebeam/curse_arm)
	animate(D.visuals, alpha = 0, time = 32)

/obj/projectile/curse_hand/on_range()
	finale()
	return ..()

/obj/projectile/curse_hand/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if (. == BULLET_ACT_HIT)
		finale()

/obj/projectile/curse_hand/phantom
	name = "phantom hand"
	damage = 15
	paralyze = 5
