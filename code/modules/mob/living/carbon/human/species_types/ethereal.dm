#define ELZUOSE_EMAG_COLORS list("#00ffff", "#ffc0cb", "#9400D3", "#4B0082", "#0000FF", "#00FF00", "#FFFF00", "#FF7F00", "#FF0000")

/datum/species/elzuose
	name = "\improper Elzuose"
	id = SPECIES_ELZUOSE
	attack_verb = "burn"
	attack_sound = 'sound/weapons/etherealhit.ogg'
	miss_sound = 'sound/weapons/etherealmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/ethereal
	mutantstomach = /obj/item/organ/stomach/ethereal
	mutanttongue = /obj/item/organ/tongue/ethereal
	siemens_coeff = 0.5 //They thrive on energy
	brutemod = 1.25 //They're weak to punches
	attack_type = BURN //burn bish
	exotic_bloodtype = "E"
	damage_overlay_type = "" //We are too cool for regular damage overlays
	species_age_max = 300
	species_traits = list(DYNCOLORS, EYECOLOR, HAIR, FACEHAIR)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/ethereal
	inherent_traits = list(TRAIT_NOHUNGER)
	sexes = FALSE //no fetish content allowed
	toxic_food = NONE
	// Body temperature for ethereals is much higher then humans as they like hotter environments
	bodytemp_normal = (HUMAN_BODYTEMP_NORMAL + 50)
	bodytemp_heat_damage_limit = FIRE_MINIMUM_TEMPERATURE_TO_SPREAD // about 150C
	// Cold temperatures hurt faster as it is harder to move with out the heat energy
	bodytemp_cold_damage_limit = (T20C - 10) // about 10c
	hair_color = "fixedmutcolor"
	hair_alpha = 140
	mutant_bodyparts = list("elzu_horns", "tail_elzu")
	default_features = list("elzu_horns" = "None", "tail_elzu" = "None", "body_size" = "Normal")
	species_eye_path = 'icons/mob/ethereal_parts.dmi'
	mutant_organs = list(/obj/item/organ/tail/elzu)

	species_chest = /obj/item/bodypart/chest/ethereal
	species_head = /obj/item/bodypart/head/ethereal
	species_l_arm = /obj/item/bodypart/l_arm/ethereal
	species_r_arm = /obj/item/bodypart/r_arm/ethereal
	species_l_leg = /obj/item/bodypart/leg/left/ethereal
	species_r_leg = /obj/item/bodypart/leg/right/ethereal

	var/current_color
	var/EMPeffect = FALSE
	var/emag_effect = FALSE
	var/static/unhealthy_color = rgb(237, 164, 149)
	loreblurb = "Elzuosa are an uncommon and unusual species best described as crystalline, electrically-powered plantpeople. They hail from the warm planet Kalixcis, where they evolved alongside the Sarathi. Kalixcian culture places no importance on blood-bonds, and those from it tend to consider their family anyone they are sufficiently close to, and choose their own names."
	var/drain_time = 0 //used to keep ethereals from spam draining power sources
	var/obj/effect/dummy/lighting_obj/ethereal_light
	var/datum/action/innate/root/rooting
	// how it takes to enter and exit rooting
	var/dig_time = (7.5 SECONDS)
	// how long to charge while rooting
	var/root_time = (3 SECONDS)
	// how much charge you get from rooting
	var/root_charge_gain = (5 * ELZUOSE_CHARGE_SCALING_MULTIPLIER)

/datum/species/elzuose/Destroy(force)
	if(ethereal_light)
		QDEL_NULL(ethereal_light)
	return ..()

/datum/species/elzuose/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	. = ..()
	if(!ishuman(C))
		return
	var/mob/living/carbon/human/ethereal = C
	default_color = "#[ethereal.dna.features["ethcolor"]]"
	RegisterSignal(ethereal, COMSIG_ATOM_EMAG_ACT, PROC_REF(on_emag_act))
	RegisterSignal(ethereal, COMSIG_ATOM_EMP_ACT, PROC_REF(on_emp_act))
	ethereal_light = ethereal.mob_light()
	spec_updatehealth(ethereal)
	rooting = new
	rooting.Grant(C)
	RegisterSignal(ethereal, COMSIG_DIGOUT, PROC_REF(digout))
	RegisterSignal(ethereal, COMSIG_MOVABLE_MOVED, PROC_REF(uproot))

	//The following code is literally only to make admin-spawned ethereals not be black.
	C.dna.features["mcolor"] = C.dna.features["ethcolor"] //Ethcolor and Mut color are both dogshit and will be replaced
	for(var/obj/item/bodypart/BP as anything in C.bodyparts)
		if(BP.limb_id == SPECIES_ELZUOSE)
			BP.update_limb(is_creating = TRUE)

/datum/species/elzuose/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	UnregisterSignal(C, COMSIG_ATOM_EMAG_ACT)
	UnregisterSignal(C, COMSIG_ATOM_EMP_ACT)
	UnregisterSignal(C, COMSIG_DIGOUT)
	UnregisterSignal(C, COMSIG_TURF_CHANGE)
	QDEL_NULL(ethereal_light)
	if(rooting)
		rooting.Remove(C)
	return ..()

/datum/action/innate/root
	name = "Root"
	desc = "Root into good soil to gain charge."
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "plant-22"
	icon_icon = 'icons/obj/flora/plants.dmi'
	background_icon_state = "bg_alien"

/datum/action/innate/root/Activate()
	var/mob/living/carbon/human/H = owner
	var/datum/species/elzuose/E = H.dna.species
	// this is healthy for elzu, they shouldnt be able to overcharge and get heart attacks from this
	var/obj/item/organ/stomach/ethereal/stomach = H.getorganslot(ORGAN_SLOT_STOMACH)

	if(H.wear_suit && istype(H.wear_suit, /obj/item/clothing))
		var/obj/item/clothing/CS = H.wear_suit
		if (CS.clothing_flags & THICKMATERIAL)
			to_chat(H, span_warning("Your [CS.name] is too thick to root in!"))
			return

	if(stomach.crystal_charge > ELZUOSE_CHARGE_FULL)
		to_chat(H,span_warning("Your charge is full!"))
		return
	E.drain_time = world.time + E.root_time
	H.visible_message(span_notice("[H] is digging into the ground"),span_warning("You start to dig yourself into the ground to root. You won't won't be able to move once you start the process."),span_notice("You hear digging."))
	if(!do_after(H,E.dig_time, target = H))
		to_chat(H,span_warning("You were interupted!"))
		return
	H.apply_status_effect(/datum/status_effect/rooted)
	// ADD_TRAIT(H,TRAIT_IMMOBILIZED,SPECIES_TRAIT)
	// ADD_TRAIT(H,TRAIT_PUSHIMMUNE,SPECIES_TRAIT)
	to_chat(H, span_notice("You root into the ground and begin to feed."))

	while(do_after(H, E.root_time, target = H))
		if(istype(stomach))
			to_chat(H, span_notice("You receive some charge from rooting."))
			stomach.adjust_charge(E.root_charge_gain)
			H.adjustBruteLoss(-3)
			H.adjustFireLoss(-3)

			if(stomach.crystal_charge > ELZUOSE_CHARGE_FULL)
				stomach.crystal_charge = ELZUOSE_CHARGE_FULL
				break
				to_chat(H, span_notice("You're pretty full."))
				// H.visible_message(span_notice("[H] is digging out of the ground."),span_notice("You finish rooting and begin digging yourself out."),span_notice("You hear digging."))
				// E.digout(H, E)
		else
			to_chat(H,span_warning("You're missing your biological battery and can't recieve charge from rooting!"))
			break

	// Your rooting do afters weren't completed
	// while(HAS_TRAIT_FROM(H, TRAIT_IMMOBILIZED, SPECIES_TRAIT))
	// while(H.has_status_effect(/datum/status_effect/rooted))
	// 	// Rooting was interupted, so we start digging yourself out.
	// 	if(!(get_dist(terrain, H) <= 0 && isturf(H.loc)))
	// 		//You got moved and uprooted, time to suffer the consequences.
	// 		H.visible_message(span_warning("[H] is forcefully uprooted. That looked like it hurt."),span_warning("You're forcefully unrooted! Ouch!"),span_warning("You hear someone scream in pain."))
	// 		H.apply_damage(8,BRUTE,BODY_ZONE_CHEST)
	// 		H.apply_damage(8,BRUTE,BODY_ZONE_L_LEG)
	// 		H.apply_damage(8,BRUTE,BODY_ZONE_R_LEG)
	// 		H.emote("scream")
	// 		H.remove_status_effect(/datum/status_effect/rooted)
	// 		// REMOVE_TRAIT(H,TRAIT_IMMOBILIZED,SPECIES_TRAIT)
	// 		// REMOVE_TRAIT(H,TRAIT_PUSHIMMUNE,SPECIES_TRAIT)
	// 		return
	// 	H.visible_message(span_notice("[H] is digging out of the ground."),span_notice(">Your rooting was interupted and you begin digging yourself out."),span_notice("You hear digging."))
	// 	E.digout(H, E)

	// H.remove_status_effect(/datum/status_effect/rooted)
	// return

// have digout triggered by a register signal???
/datum/species/elzuose/proc/digout(mob/living/carbon/human/H)
	var/datum/species/elzuose/E = H.dna.species
	if(do_after(H, E.dig_time,target = H))
		to_chat(H,span_notice("You finish digging yourself out."))
		H.remove_status_effect(/datum/status_effect/rooted)
		// REMOVE_TRAIT(H,TRAIT_IMMOBILIZED,SPECIES_TRAIT)
		// REMOVE_TRAIT(H,TRAIT_PUSHIMMUNE,SPECIES_TRAIT)
		return

/datum/species/elzuose/proc/uproot(mob/living/carbon/human/H)
	//You got moved and uprooted, time to suffer the consequences.
	if(H.has_status_effect(/datum/status_effect/rooted))
		H.visible_message(span_warning("[H] is forcefully uprooted. That looked like it hurt."),span_warning("You're forcefully unrooted! Ouch!"),span_warning("You hear someone scream in pain."))
		H.apply_damage(8,BRUTE,BODY_ZONE_CHEST)
		H.apply_damage(8,BRUTE,BODY_ZONE_L_LEG)
		H.apply_damage(8,BRUTE,BODY_ZONE_R_LEG)
		H.emote("scream")
		H.remove_status_effect(/datum/status_effect/rooted)
		return

/datum/action/innate/root/IsAvailable()
	if(..())
		var/mob/living/carbon/human/H = owner
		var/turf/terrain = get_turf(H)
		if(H.has_status_effect(/datum/status_effect/rooted))
			return FALSE
		if(istype(terrain,/turf/open/floor/plating/grass) || istype(terrain,/turf/open/floor/grass/ship) ||  istype(terrain,/turf/open/floor/ship/dirt) ||  istype(terrain,/turf/open/floor/plating/dirt))
			return TRUE
		return FALSE

/datum/species/elzuose/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_lizard_name(gender)

	var/randname = lizard_name(gender)

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/elzuose/spec_updatehealth(mob/living/carbon/human/H)
	. = ..()
	if(!ethereal_light)
		return

	if(H.stat != DEAD && !EMPeffect)
		if(!emag_effect)
			current_color = health_adjusted_color(H, default_color)
		set_ethereal_light(H, current_color)
		ethereal_light.set_light_on(TRUE)
		fixed_mut_color = copytext_char(current_color, 2)
	else
		ethereal_light.set_light_on(FALSE)
		fixed_mut_color = rgb(128,128,128)

	for(var/obj/item/bodypart/parts_to_update as anything in H.bodyparts)
		parts_to_update.species_color = fixed_mut_color
		parts_to_update.update_limb()

	H.update_body()
	H.update_hair()

/datum/species/elzuose/proc/health_adjusted_color(mob/living/carbon/human/H, default_color)
	var/health_percent = max(H.health, 0) / 100

	var/static/unhealthy_color_red_part   = GETREDPART(unhealthy_color)
	var/static/unhealthy_color_green_part = GETGREENPART(unhealthy_color)
	var/static/unhealthy_color_blue_part  = GETBLUEPART(unhealthy_color)

	var/default_color_red_part   = GETREDPART(default_color)
	var/default_color_green_part = GETGREENPART(default_color)
	var/default_color_blue_part  = GETBLUEPART(default_color)

	var/result = rgb(
		unhealthy_color_red_part   + ((default_color_red_part   - unhealthy_color_red_part)   * health_percent),
		unhealthy_color_green_part + ((default_color_green_part - unhealthy_color_green_part) * health_percent),
		unhealthy_color_blue_part  + ((default_color_blue_part  - unhealthy_color_blue_part)  * health_percent)
	)
	return result

/datum/species/elzuose/proc/set_ethereal_light(mob/living/carbon/human/H, current_color)
	if(!ethereal_light)
		return

	var/health_percent = max(H.health, 0) / 100

	var/light_range = 1 + (1 * health_percent)
	var/light_power = 1 + round(0.5 * health_percent)

	ethereal_light.set_light_range_power_color(light_range, light_power, current_color)

/datum/species/elzuose/proc/on_emp_act(mob/living/carbon/human/H, severity)
	EMPeffect = TRUE
	spec_updatehealth(H)
	to_chat(H, span_notice("You feel the light of your body leave you."))
	switch(severity)
		if(EMP_LIGHT)
			addtimer(CALLBACK(src, PROC_REF(stop_emp), H), 10 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE) //We're out for 10 seconds
		if(EMP_HEAVY)
			addtimer(CALLBACK(src, PROC_REF(stop_emp), H), 20 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE) //We're out for 20 seconds

/datum/species/elzuose/proc/on_emag_act(mob/living/carbon/human/H, mob/user)
	if(emag_effect)
		return
	emag_effect = TRUE
	if(user)
		to_chat(user, span_notice("You tap [H] on the back with your card."))
	H.visible_message(span_danger("[H] starts flickering in an array of colors!"))
	handle_emag(H)
	addtimer(CALLBACK(src, PROC_REF(stop_emag), H), 30 SECONDS) //Disco mode for 30 seconds! This doesn't affect the ethereal at all besides either annoying some players, or making someone look badass.

/datum/species/elzuose/spec_life(mob/living/carbon/human/H)
	.=..()
	handle_charge(H)

/datum/species/elzuose/proc/stop_emp(mob/living/carbon/human/H)
	EMPeffect = FALSE
	spec_updatehealth(H)
	to_chat(H, span_notice("You feel more energized as your shine comes back."))

/datum/species/elzuose/proc/handle_emag(mob/living/carbon/human/H)
	if(!emag_effect)
		return
	current_color = pick(ELZUOSE_EMAG_COLORS)
	spec_updatehealth(H)
	addtimer(CALLBACK(src, PROC_REF(handle_emag), H), 5) //Call ourselves every 0.5 seconds to change color

/datum/species/elzuose/proc/stop_emag(mob/living/carbon/human/H)
	emag_effect = FALSE
	spec_updatehealth(H)
	H.visible_message(span_danger("[H] stops flickering and goes back to their normal state!"))

/datum/species/elzuose/proc/handle_charge(mob/living/carbon/human/H)
	brutemod = 1.25
	switch(get_charge(H))
		if(ELZUOSE_CHARGE_NONE to ELZUOSE_CHARGE_LOWPOWER)
			if(get_charge(H) == ELZUOSE_CHARGE_NONE)
				H.throw_alert("ELZUOSE_CHARGE", /atom/movable/screen/alert/etherealcharge, 3)
			else
				H.throw_alert("ELZUOSE_CHARGE", /atom/movable/screen/alert/etherealcharge, 2)
			if(H.health > 10.5)
				apply_damage(0.2, TOX, null, null, H)
			brutemod = 1.75
		if(ELZUOSE_CHARGE_LOWPOWER to ELZUOSE_CHARGE_NORMAL)
			H.throw_alert("ELZUOSE_CHARGE", /atom/movable/screen/alert/etherealcharge, 1)
			brutemod = 1.5
		if(ELZUOSE_CHARGE_FULL to ELZUOSE_CHARGE_OVERLOAD)
			H.throw_alert("ethereal_overcharge", /atom/movable/screen/alert/ethereal_overcharge, 1)
			brutemod = 1.5
		if(ELZUOSE_CHARGE_OVERLOAD to ELZUOSE_CHARGE_DANGEROUS)
			H.throw_alert("ethereal_overcharge", /atom/movable/screen/alert/ethereal_overcharge, 2)
			brutemod = 1.75
			if(prob(10)) //10% each tick for ethereals to explosively release excess energy if it reaches dangerous levels
				discharge_process(H)
		else
			H.clear_alert("ELZUOSE_CHARGE")
			H.clear_alert("ethereal_overcharge")

/datum/species/elzuose/proc/discharge_process(mob/living/carbon/human/H)
	to_chat(H,span_warning("You begin to lose control over your charge!"))
	H.visible_message(span_danger("[H] begins to spark violently!"))
	var/static/mutable_appearance/overcharge //shameless copycode from lightning spell
	overcharge = overcharge || mutable_appearance('icons/effects/effects.dmi', "electricity", EFFECTS_LAYER)
	H.add_overlay(overcharge)
	if(do_mob(H, H, 50, 1))
		H.flash_lighting_fx(5, 7, current_color)
		var/obj/item/organ/stomach/ethereal/stomach = H.getorganslot(ORGAN_SLOT_STOMACH)
		playsound(H, 'sound/magic/lightningshock.ogg', 100, TRUE, extrarange = 5)
		H.cut_overlay(overcharge)
		tesla_zap(H, 2, (stomach.crystal_charge / ELZUOSE_CHARGE_SCALING_MULTIPLIER) * 50, ZAP_OBJ_DAMAGE | ZAP_ALLOW_DUPLICATES)
		if(istype(stomach))
			stomach.adjust_charge(ELZUOSE_CHARGE_FULL - stomach.crystal_charge)
		to_chat(H,span_warning("You violently discharge energy!"))
		H.visible_message(span_danger("[H] violently discharges energy!"))
		if(prob(10)) //chance of developing heart disease to dissuade overcharging oneself
			var/datum/disease/D = new /datum/disease/heart_failure
			H.ForceContractDisease(D)
			to_chat(H, span_userdanger("You're pretty sure you just felt your heart stop for a second there."))
			H.playsound_local(H, 'sound/effects/singlebeat.ogg', 100, 0)
		H.Paralyze(100)
		return

/datum/species/elzuose/proc/get_charge(mob/living/carbon/H) //this feels like it should be somewhere else. Eh?
	var/obj/item/organ/stomach/ethereal/stomach = H.getorganslot(ORGAN_SLOT_STOMACH)
	if(istype(stomach))
		return stomach.crystal_charge
	return ELZUOSE_CHARGE_NONE

/datum/species/elzuose/spec_attacked_by(obj/item/I, mob/living/user, obj/item/bodypart/affecting, intent, mob/living/carbon/human/H)
	if(istype(I, /obj/item/multitool))
		if(user.a_intent == INTENT_HARM)
			. = ..() // multitool beatdown
			return

		if (emag_effect == TRUE)
			to_chat(user, span_warning("The multitool can't get a lock on [H]'s EM frequency!"))
			return

		if(user != H)
			// random color change
			default_color = "#" + GLOB.color_list_ethereal[pick(GLOB.color_list_ethereal)]
			current_color = health_adjusted_color(H, default_color)
			spec_updatehealth(H)
			H.visible_message(span_danger("[H]'s EM frequency is scrambled to a random color."))
		else
			// select new color
			var/new_etherealcolor = input(user, "Choose your Elzuose color:", "Character Preference",default_color) as color|null
			if(new_etherealcolor)
				var/temp_hsv = RGBtoHSV(new_etherealcolor)
				if(ReadHSV(temp_hsv)[3] >= ReadHSV("#505050")[3]) // elzu colors should be bright ok??
					default_color = sanitize_hexcolor(new_etherealcolor, 6, TRUE)
					current_color = health_adjusted_color(H, default_color)
					spec_updatehealth(H)
					H.visible_message(span_notice("[H] modulates \his EM frequency to [new_etherealcolor]"))
				else
					to_chat(user, span_danger("Invalid color. Your color is not bright enough."))
	else
		. = ..()
