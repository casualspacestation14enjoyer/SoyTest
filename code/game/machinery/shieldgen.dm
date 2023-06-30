/obj/structure/emergency_shield
	name = "emergency energy shield"
	desc = "An energy shield used to contain hull breaches."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-old"
	density = TRUE
	move_resist = INFINITY
	opacity = FALSE
	anchored = TRUE
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	max_integrity = 200 //The shield can only take so much beating (prevents perma-prisons)
	CanAtmosPass = ATMOS_PASS_DENSITY

/obj/structure/emergency_shield/Initialize()
	. = ..()
	setDir(pick(GLOB.cardinals))
	air_update_turf(1)

/obj/structure/emergency_shield/Move()
	var/turf/T = loc
	. = ..()
	move_update_air(T)

/obj/structure/emergency_shield/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_SELF)
		return
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			take_damage(50, BRUTE, "energy", 0)

/obj/structure/emergency_shield/play_attack_sound(damage, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BURN)
			playsound(loc, 'sound/effects/empulse.ogg', 75, TRUE)
		if(BRUTE)
			playsound(loc, 'sound/effects/empulse.ogg', 75, TRUE)

/obj/structure/emergency_shield/take_damage(damage, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(.) //damage was dealt
		new /obj/effect/temp_visual/impact_effect/ion(loc)

/obj/structure/emergency_shield/sanguine
	name = "sanguine barrier"
	desc = "A potent shield summoned by cultists to defend their rites."
	icon_state = "shield-red"
	max_integrity = 60

/obj/structure/emergency_shield/sanguine/emp_act(severity)
	return

/obj/structure/emergency_shield/invoker
	name = "Invoker's Shield"
	desc = "A weak shield summoned by cultists to protect them while they carry out delicate rituals."
	color = "#FF0000"
	max_integrity = 20
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_MOB_LAYER

/obj/structure/emergency_shield/invoker/emp_act(severity)
	return


/obj/machinery/shieldgen
	name = "anti-breach shielding projector"
	desc = "Used to seal minor hull breaches."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shieldoff"
	density = TRUE
	opacity = FALSE
	anchored = FALSE
	pressure_resistance = 2*ONE_ATMOSPHERE
	req_access = list(ACCESS_ENGINE)
	max_integrity = 100
	var/active = FALSE
	var/list/deployed_shields
	var/locked = FALSE
	var/shield_range = 4

/obj/machinery/shieldgen/Initialize(mapload)
	. = ..()
	deployed_shields = list()
	if(mapload && active && anchored)
		shields_up()

/obj/machinery/shieldgen/Destroy()
	QDEL_LIST(deployed_shields)
	return ..()


/obj/machinery/shieldgen/proc/shields_up()
	active = TRUE
	update_icon()
	move_resist = INFINITY

	for(var/turf/target_tile in range(shield_range, src))
		if(isspaceturf(target_tile) && !(locate(/obj/structure/emergency_shield) in target_tile))
			if(!(machine_stat & BROKEN) || prob(33))
				deployed_shields += new /obj/structure/emergency_shield(target_tile)

/obj/machinery/shieldgen/proc/shields_down()
	active = FALSE
	move_resist = initial(move_resist)
	update_icon()
	QDEL_LIST(deployed_shields)

/obj/machinery/shieldgen/process()
	if((machine_stat & BROKEN) && active)
		if(deployed_shields.len && prob(5))
			qdel(pick(deployed_shields))


/obj/machinery/shieldgen/deconstruct(disassembled = TRUE)
	obj_break()
	locked = pick(0,1)

/obj/machinery/shieldgen/interact(mob/user)
	. = ..()
	if(.)
		return
	if(locked && !issilicon(user))
		to_chat(user, "<span class='warning'>The machine is locked, you are unable to use it!</span>")
		return
	if(panel_open)
		to_chat(user, "<span class='warning'>The panel must be closed before operating this machine!</span>")
		return

	if (active)
		user.visible_message("<span class='notice'>[user] deactivated \the [src].</span>", \
			"<span class='notice'>You deactivate \the [src].</span>", \
			"<span class='hear'>You hear heavy droning fade out.</span>")
		shields_down()
	else
		if(anchored)
			user.visible_message("<span class='notice'>[user] activated \the [src].</span>", \
				"<span class='notice'>You activate \the [src].</span>", \
				"<span class='hear'>You hear heavy droning.</span>")
			shields_up()
		else
			to_chat(user, "<span class='warning'>The device must first be secured to the floor!</span>")
	return

/obj/machinery/shieldgen/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_SCREWDRIVER)
		W.play_tool_sound(src, 100)
		panel_open = !panel_open
		if(panel_open)
			to_chat(user, "<span class='notice'>You open the panel and expose the wiring.</span>")
		else
			to_chat(user, "<span class='notice'>You close the panel.</span>")
	else if(istype(W, /obj/item/stack/cable_coil) && (machine_stat & BROKEN) && panel_open)
		var/obj/item/stack/cable_coil/coil = W
		if (coil.get_amount() < 1)
			to_chat(user, "<span class='warning'>You need one length of cable to repair [src]!</span>")
			return
		to_chat(user, "<span class='notice'>You begin to replace the wires...</span>")
		if(do_after(user, 30, target = src))
			if(coil.get_amount() < 1)
				return
			coil.use(1)
			obj_integrity = max_integrity
			set_machine_stat(machine_stat & ~BROKEN)
			to_chat(user, "<span class='notice'>You repair \the [src].</span>")
			update_icon()

	else if(W.tool_behaviour == TOOL_WRENCH)
		if(locked)
			to_chat(user, "<span class='warning'>The bolts are covered! Unlocking this would retract the covers.</span>")
			return
		if(!anchored && !isinspace())
			W.play_tool_sound(src, 100)
			to_chat(user, "<span class='notice'>You secure \the [src] to the floor!</span>")
			set_anchored(TRUE)
		else if(anchored)
			W.play_tool_sound(src, 100)
			to_chat(user, "<span class='notice'>You unsecure \the [src] from the floor!</span>")
			if(active)
				to_chat(user, "<span class='notice'>\The [src] shuts off!</span>")
				shields_down()
			set_anchored(FALSE)

	else if(W.GetID())
		if(allowed(user) && !(obj_flags & EMAGGED))
			locked = !locked
			to_chat(user, "<span class='notice'>You [locked ? "lock" : "unlock"] the controls.</span>")
		else if(obj_flags & EMAGGED)
			to_chat(user, "<span class='danger'>Error, access controller damaged!</span>")
		else
			to_chat(user, "<span class='danger'>Access denied.</span>")

	else
		return ..()

/obj/machinery/shieldgen/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		to_chat(user, "<span class='warning'>The access controller is damaged!</span>")
		return
	obj_flags |= EMAGGED
	locked = FALSE
	playsound(src, "sparks", 100, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	to_chat(user, "<span class='warning'>You short out the access controller.</span>")

/obj/machinery/shieldgen/update_icon_state()
	if(active)
		icon_state = (machine_stat & BROKEN) ? "shieldonbr":"shieldon"
	else
		icon_state = (machine_stat & BROKEN) ? "shieldoffbr":"shieldoff"

#define ACTIVE_SETUPFIELDS 1
#define ACTIVE_HASFIELDS 2
/obj/machinery/power/shieldwallgen
	name = "shield wall generator"
	desc = "A shield generator."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "shield_wall_gen"
	anchored = FALSE
	density = TRUE
	req_access = list(ACCESS_TELEPORTER)
	flags_1 = CONDUCT_1
	use_power = NO_POWER_USE
	idle_power_usage = 10
	active_power_usage = 50
	circuit = /obj/item/circuitboard/machine/shieldwallgen
	max_integrity = 300
	var/active = FALSE
	var/id = null
	var/locked = TRUE
	var/shield_range = 8
	var/shocked = FALSE
	var/obj/structure/cable/attached // the attached cable

/obj/machinery/power/shieldwallgen/xenobiologyaccess		//use in xenobiology containment
	name = "xenobiology shield wall generator"
	desc = "A shield generator meant for use in xenobiology."
	req_access = list(ACCESS_XENOBIOLOGY)

/obj/machinery/power/shieldwallgen/anchored
	anchored = TRUE

/obj/machinery/power/shieldwallgen/Initialize()
	. = ..()
	wires = new /datum/wires/shieldwallgen(src)
	if(anchored)
		connect_to_network()

/obj/machinery/power/shieldwallgen/Destroy()
	for(var/direction in GLOB.cardinals)
		cleanup_field(direction)
	QDEL_NULL(wires)
	return ..()

/*WS Edit - Reverted Smartwire
/obj/machinery/power/shieldwallgen/should_have_node()
	return anchored
*/

/obj/machinery/power/shieldwallgen/connect_to_network()
	if(!anchored)
		return FALSE
	. = ..()

/obj/machinery/power/shieldwallgen/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	id = "[REF(port)][id]"

/obj/machinery/power/shieldwallgen/process()
	if(active)
		if(active == ACTIVE_SETUPFIELDS)
			var/fields = 0
			for(var/direction in GLOB.cardinals)
				if(setup_field(direction))
					fields++
			if(fields)
				active = ACTIVE_HASFIELDS
		if(!active_power_usage || surplus() >= active_power_usage)
			add_load(active_power_usage)
		else
			visible_message("<span class='danger'>The [src.name] shuts down due to lack of power!</span>", \
				"If this message is ever seen, something is wrong.",
				"<span class='hear'>You hear heavy droning fade out.</span>")
			active = FALSE
			log_game("[src] deactivated due to lack of power at [AREACOORD(src)]")
			for(var/direction in GLOB.cardinals)
				cleanup_field(direction)
	else
		for(var/direction in GLOB.cardinals)
			cleanup_field(direction)
	update_icon()

/obj/machinery/power/shieldwallgen/update_icon_state()
	if(active)
		icon_state = initial(icon_state) + "_on"
	else
		icon_state = initial(icon_state)

/obj/machinery/power/shieldwallgen/update_overlays()
	. = ..()
	if((machine_stat & MAINT) || panel_open)
		. += initial(icon_state)+"-maint"

/// Constructs the actual field walls in the specified direction, cleans up old/stuck shields before doing so
/obj/machinery/power/shieldwallgen/proc/setup_field(direction)
	if(!direction)
		return

	var/turf/turf = loc
	var/obj/machinery/power/shieldwallgen/generator
	var/steps = 0
	var/opposite_direction = turn(direction, 180)

	for(var/i in 1 to shield_range) //checks out to 8 tiles away for another generator
		turf = get_step(turf, direction)
		generator = locate(/obj/machinery/power/shieldwallgen) in turf
		if(generator)
			if(!generator.active)
				return
			generator.cleanup_field(opposite_direction)
			break
		else
			steps++

	if(!generator || !steps) //no shield gen or no tiles between us and the gen
		return

	for(var/i in 1 to steps) //creates each field tile
		turf = get_step(turf, opposite_direction)
		new/obj/machinery/shieldwall(turf, src, generator)
	return TRUE

/// cleans up fields in the specified direction if they belong to this generator
/obj/machinery/power/shieldwallgen/proc/cleanup_field(direction)
	var/obj/machinery/shieldwall/field
	var/obj/machinery/power/shieldwallgen/generator
	var/turf/turf = loc

	for(var/i in 1 to shield_range)
		turf = get_step(turf, direction)

		generator = (locate(/obj/machinery/power/shieldwallgen) in turf)
		if(generator && !generator.active)
			break

		field = (locate(/obj/machinery/shieldwall) in turf)
		if(field && (field.gen_primary == src || field.gen_secondary == src)) //it's ours, kill it.
			qdel(field)

/obj/machinery/power/shieldwallgen/can_be_unfasten_wrench(mob/user, silent)
	if(active)
		if(!silent)
			to_chat(user, "<span class='warning'>Turn off the shield generator first!</span>")
		return FAILED_UNFASTEN
	return ..()


/obj/machinery/power/shieldwallgen/wrench_act(mob/living/user, obj/item/item)
	. = ..()
	. |= default_unfasten_wrench(user, item, 0)
	var/turf/turf = get_turf(src)
//	update_cable_icons_on_turf(T) - Removed because smartwire Revert
//WS Begin - Smartwire Revert
	var/obj/structure/cable/cable = locate(/obj/structure/cable) in turf
	cable.update_icon()
//WS End - Smartwire Revert
	if(. == SUCCESSFUL_UNFASTEN && anchored)
		connect_to_network()


/obj/machinery/power/shieldwallgen/attackby(obj/item/item, mob/user, params)
	if(default_deconstruction_screwdriver(user, icon_state, icon_state, item))
		update_icon()
		updateUsrDialog()
		return TRUE

	if(default_deconstruction_crowbar(item))
		return TRUE

	if(panel_open && is_wire_tool(item))
		wires.interact(user)
		return TRUE

	if(user.a_intent == INTENT_HARM) //so we can hit the machine
		return ..()

	if(machine_stat)
		return TRUE

	if(item.GetID())
		if(allowed(user) && !(obj_flags & EMAGGED))
			locked = !locked
			to_chat(user, "<span class='notice'>You [src.locked ? "lock" : "unlock"] the controls.</span>")
		else if(obj_flags & EMAGGED)
			to_chat(user, "<span class='danger'>Error, access controller damaged!</span>")
		else
			to_chat(user, "<span class='danger'>Access denied.</span>")

	else
		add_fingerprint(user)
		return ..()

/obj/machinery/power/shieldwallgen/interact(mob/user)
	. = ..()
	if(.)
		return
	if(shocked && !(machine_stat & NOPOWER))
		shock(user,50)
		return
	if(!anchored)
		to_chat(user, "<span class='warning'>\The [src] needs to be firmly secured to the floor first!</span>")
		return
	if(locked && !issilicon(user))
		to_chat(user, "<span class='warning'>The controls are locked!</span>")
		return
	if(!powernet)
		to_chat(user, "<span class='warning'>\The [src] needs to be powered by a wire!</span>")
		return

	if(active)
		user.visible_message("<span class='notice'>[user] turned \the [src] off.</span>", \
			"<span class='notice'>You turn off \the [src].</span>", \
			"<span class='hear'>You hear heavy droning fade out.</span>")
		active = FALSE
		log_game("[src] was deactivated by [key_name(user)] at [AREACOORD(src)]")
	else
		user.visible_message("<span class='notice'>[user] turned \the [src] on.</span>", \
			"<span class='notice'>You turn on \the [src].</span>", \
			"<span class='hear'>You hear heavy droning.</span>")
		active = ACTIVE_SETUPFIELDS
		log_game("[src] was activated by [key_name(user)] at [AREACOORD(src)]")
	add_fingerprint(user)

/obj/machinery/power/shieldwallgen/proc/toggle()
	if(!anchored)
		return
	if(!powernet)
		return
	if(active)
		visible_message("<span class= 'notice'>The [src.name] hums as it powers down.</span>", \
			"If this message is ever seen, something is wrong.", \
			"<span class= 'notice'>You hear heavy droning fade out.</span>")
		playsound(src, 'sound/machines/synth_no.ogg', 50, TRUE, frequency = 6120)
		active = FALSE
		log_game("[src] was deactivated by wire pulse at [AREACOORD(src)]")
	else
		visible_message("<span class= 'notice'>The [src.name] beeps as it powers up.</span>", \
			"If this message is ever seen, something is wrong.", \
			"<span class= 'notice'>You hear heavy droning.</span>")
		playsound(src, 'sound/machines/synth_yes.ogg', 50, TRUE, frequency = 6120)
		active = ACTIVE_SETUPFIELDS
		log_game("[src] was activated by wire pulse at [AREACOORD(src)]")

/obj/machinery/power/shieldwallgen/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		to_chat(user, "<span class='warning'>The access controller is damaged!</span>")
		return
	obj_flags |= EMAGGED
	locked = FALSE
	playsound(src, "sparks", 100, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	to_chat(user, "<span class='warning'>You short out the access controller.</span>")

/obj/machinery/power/shieldwallgen/proc/shock(mob/user, prb)
	if(machine_stat & (BROKEN|NOPOWER))		// unpowered, no shock
		return FALSE
	if(!prob(prb))
		return FALSE
	var/datum/effect_system/spark_spread/spark = new /datum/effect_system/spark_spread
	spark.set_up(5, 1, src)
	spark.start()
	if (electrocute_mob(user, get_area(src), src, 0.7, TRUE))
		return TRUE
	else
		return FALSE

/obj/machinery/power/shieldwallgen/proc/reset(wire)
	switch(wire)
		if(WIRE_SHOCK)
			if(!wires.is_cut(wire))
				shocked = FALSE

/obj/machinery/power/shieldwallgen/atmos
	name = "holofield generator"
	desc = "A holofield generator designed for use in ship loading bays."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "shield_wall_gen_atmos"
	circuit = /obj/item/circuitboard/machine/shieldwallgen/atmos
	anchored = FALSE
	density = FALSE
	req_access = list()
	locked = FALSE
	shield_range = 8

/obj/machinery/power/shieldwallgen/atmos/roundstart
	anchored = TRUE
	active = ACTIVE_SETUPFIELDS

/obj/machinery/power/shieldwallgen/atmos/strong //these are for ruins and large hangars, try to not use them on ships
	name = "high power holofield generator"
	desc = "A holofield generator designed for use in starbase bays."
	circuit = /obj/item/circuitboard/machine/shieldwallgen/atmos/strong
	shield_range = 20
	active_power_usage = 1000

/obj/machinery/power/shieldwallgen/atmos/strong/roundstart
	anchored = TRUE
	active = ACTIVE_SETUPFIELDS

/obj/machinery/power/shieldwallgen/atmos/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation, ROTATION_ALTCLICK | ROTATION_CLOCKWISE | ROTATION_COUNTERCLOCKWISE | ROTATION_VERBS, null, CALLBACK(src, PROC_REF(can_be_rotated)))

/obj/machinery/power/shieldwallgen/atmos/proc/can_be_rotated(mob/user, rotation_type)
	if (anchored)
		to_chat(user, "<span class='warning'>It is fastened to the floor!</span>")
		return FALSE
	return TRUE

/// Same as in the normal shieldwallgen, but with the shieldwalls replaced with atmos shieldwalls
/obj/machinery/power/shieldwallgen/atmos/setup_field(direction)
	if(!direction)
		return
	if(direction != dir)
		return

	var/turf/turf = loc
	var/obj/machinery/power/shieldwallgen/generator
	var/steps = 0
	var/opposite_direction = turn(direction, 180)

	for(var/i in 1 to shield_range) //checks out to 8 tiles away for another generator
		turf = get_step(turf, direction)
		generator = locate(/obj/machinery/power/shieldwallgen/atmos) in turf
		if(generator)
			if(!generator.active)
				return
			generator.cleanup_field(opposite_direction)
			break
		else
			steps++

	if(!generator) //no shield gen, generators are allowed to function adjacent to eachother
		return

	for(var/i in 1 to steps+2) //creates each field tile
		new /obj/machinery/shieldwall/atmos(turf, src, generator)
		turf = get_step(turf, opposite_direction)
	return TRUE

/obj/machinery/power/shieldwallgen/atmos/cleanup_field(direction)
	var/obj/machinery/shieldwall/field
	var/obj/machinery/power/shieldwallgen/generator
	var/turf/turf = loc

	for(var/i in 1 to shield_range+1)

		generator = (locate(/obj/machinery/power/shieldwallgen) in turf)
		if(generator && !generator.active)
			break

		field = (locate(/obj/machinery/shieldwall) in turf)
		if(field && (field.gen_primary == src || field.gen_secondary == src)) //it's ours, kill it.
			qdel(field)

		turf = get_step(turf, direction)

//////////////Containment Field START
/obj/machinery/shieldwall
	name = "shield wall"
	desc = "An energy shield."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldwall"
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	light_range = 3
	var/needs_power = FALSE
	var/hardshield = TRUE
	var/obj/machinery/power/shieldwallgen/gen_primary
	var/obj/machinery/power/shieldwallgen/gen_secondary

/obj/machinery/shieldwall/Initialize(mapload, obj/machinery/power/shieldwallgen/first_gen, obj/machinery/power/shieldwallgen/second_gen)
	. = ..()
	gen_primary = first_gen
	gen_secondary = second_gen
	if(gen_primary && gen_secondary)
		needs_power = TRUE
		setDir(get_dir(gen_primary, gen_secondary))
	if(hardshield == TRUE)
		for(var/mob/living/victim in get_turf(src))
			visible_message("<span class='danger'>\The [src] is suddenly occupying the same space as \the [victim]!</span>")
			victim.gib()

/obj/machinery/shieldwall/Destroy()
	gen_primary = null
	gen_secondary = null
	return ..()

/obj/machinery/shieldwall/process()
	if(needs_power)
		if(!gen_primary || !gen_primary.active || !gen_secondary || !gen_secondary.active)
			qdel(src)
			return

		drain_power(50)

//Atmos shields suck more power
/obj/machinery/shieldwall/atmos/process()
	if(needs_power)
		if(!gen_primary || !gen_primary.active || !gen_secondary || !gen_secondary.active)
			qdel(src)
			return

		drain_power(500)

/obj/machinery/shieldwall/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BURN)
			playsound(loc, 'sound/effects/empulse.ogg', 75, TRUE)
		if(BRUTE)
			playsound(loc, 'sound/effects/empulse.ogg', 75, TRUE)

//the shield wall is immune to damage but it drains the stored power of the generators.
/obj/machinery/shieldwall/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(damage_type == BRUTE || damage_type == BURN)
		drain_power(damage_amount)

/// succs power from the connected shield wall generator
/obj/machinery/shieldwall/proc/drain_power(drain_amount)
	if(needs_power && gen_primary)
		gen_primary.add_load(drain_amount * 0.5)
		if(gen_secondary) //using power may cause us to be destroyed
			gen_secondary.add_load(drain_amount * 0.5)

/obj/machinery/shieldwall/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(hardshield == TRUE)
		if(istype(mover) && (mover.pass_flags & PASSGLASS))
			return prob(20)
		else
			if(istype(mover, /obj/projectile))
				return prob(10)

//atmos blocking shieldwalls for shiptest use
/obj/machinery/shieldwall/atmos
	name = "holofield wall"
	desc = "An energy shield capable of blocking gas movement."
	icon = 'icons/effects/effects.dmi'
	icon_state = "holofan_new"
	density = FALSE
	CanAtmosPass = ATMOS_PASS_NO
	CanAtmosPassVertical = 1
	hardshield = FALSE
	layer = ABOVE_BLASTDOOR_LAYER
	light_color = "#f6e384"
	light_system = MOVABLE_LIGHT //for instant visual feedback reguardless of lag

/obj/machinery/shieldwall/atmos/Initialize()
	. = ..()
	air_update_turf(TRUE)
