
//make incision
/datum/surgery_step/incise
	name = "make incision"
	implements = list(
		TOOL_SCALPEL = 100,
		/obj/item/melee/transforming/energy/sword = 40,
		/obj/item/kitchen/knife = 20,
		/obj/item/shard = 15,
		/obj/item = 10) // 10% success with any sharp item. (why)
	time = 1.6 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'

/datum/surgery_step/incise/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You begin to make an incision in [target]'s [parse_zone(target_zone)]...</span>",
		"<span class='notice'>[user] begins to make an incision in [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] begins to make an incision in [target]'s [parse_zone(target_zone)].</span>")

/datum/surgery_step/incise/tool_check(mob/user, obj/item/tool)
	if(implement_type == /obj/item && !tool.get_sharpness())
		return FALSE

	return TRUE

/datum/surgery_step/incise/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if ishuman(target)
		var/mob/living/carbon/human/H = target
		if (!(NOBLOOD in H.dna.species.species_traits))
			display_results(user, target, "<span class='notice'>Blood pools around the incision in [H]'s [parse_zone(target_zone)].</span>",
				"<span class='notice'>Blood pools around the incision in [H]'s [parse_zone(target_zone)].</span>",
				"")
			H.bleed_rate += 3
	return ..()

/datum/surgery_step/incise/nobleed //silly friendly!
	experience_given = 1 //safer so not as much XP

/datum/surgery_step/incise/nobleed/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You begin to <i>carefully</i> make an incision in [target]'s [parse_zone(target_zone)]...</span>",
		"<span class='notice'>[user] begins to <i>carefully</i> make an incision in [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] begins to <i>carefully</i> make an incision in [target]'s [parse_zone(target_zone)].</span>")

/datum/surgery_step/incise/nobleed/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	user?.mind.adjust_experience(/datum/skill/healing, experience_given)
	return TRUE

//clamp bleeders
/datum/surgery_step/clamp_bleeders
	name = "clamp bleeders"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_WIRECUTTER = 30,
		/obj/item/stack/packageWrap = 15,
		/obj/item/stack/cable_coil = 10)
	time = 2.4 SECONDS
	preop_sound = 'sound/surgery/hemostat1.ogg'

/datum/surgery_step/clamp_bleeders/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You begin to clamp bleeders in [target]'s [parse_zone(target_zone)]...</span>",
		"<span class='notice'>[user] begins to clamp bleeders in [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] begins to clamp bleeders in [target]'s [parse_zone(target_zone)].</span>")

/datum/surgery_step/clamp_bleeders/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	if(locate(/datum/surgery_step/saw) in surgery.steps)
		target.heal_bodypart_damage(20,0)
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		H.bleed_rate = max((H.bleed_rate - 3), 0)
	return ..()

//retract skin
/datum/surgery_step/retract_skin
	name = "retract skin"
	implements = list(
		TOOL_RETRACTOR = 100,
		TOOL_SCREWDRIVER = 20,
		TOOL_WIRECUTTER = 15,
		/obj/item/stack/rods = 10)
	time = 2.4 SECONDS
	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'

/datum/surgery_step/retract_skin/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You begin to retract the skin in [target]'s [parse_zone(target_zone)]...</span>",
		"<span class='notice'>[user] begins to retract the skin in [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] begins to retract the skin in [target]'s [parse_zone(target_zone)].</span>")



//close incision
/datum/surgery_step/close
	name = "mend incision"
	implements = list(
		TOOL_CAUTERY = 100,
		TOOL_WELDER = 40,
		/obj/item/gun/energy/laser = 60,
		/obj/item = 30) // 30% success with any hot item. //this is fine, and decently reasonable
	time = 2.4 SECONDS
	preop_sound = 'sound/surgery/cautery1.ogg'
	success_sound = 'sound/surgery/cautery2.ogg'

/datum/surgery_step/close/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You begin to mend the incision in [target]'s [parse_zone(target_zone)]...</span>",
		"<span class='notice'>[user] begins to mend the incision in [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] begins to mend the incision in [target]'s [parse_zone(target_zone)].</span>")

/datum/surgery_step/close/tool_check(mob/user, obj/item/tool)
	if(implement_type == TOOL_WELDER || implement_type == /obj/item)
		return tool.get_temperature()

	return TRUE

/datum/surgery_step/close/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	if(locate(/datum/surgery_step/saw) in surgery.steps)
		target.heal_bodypart_damage(45,0)
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		H.bleed_rate = max((H.bleed_rate - 3), 0)
	return ..()



//saw bone
/datum/surgery_step/saw
	name = "saw bone"
	implements = list(
		TOOL_SAW = 100,
		/obj/item/melee/arm_blade = 40,
		/obj/item/fireaxe = 30,
		/obj/item/hatchet = 25,
		/obj/item/kitchen/knife/butcher = 10,
		/obj/item = 10) //10% success (sort of) with any sharp item with a force>=10
	time = 5.4 SECONDS
	preop_sound = list(
		/obj/item/circular_saw = 'sound/surgery/saw.ogg',
		/obj/item/melee/arm_blade = 'sound/surgery/scalpel1.ogg',
		/obj/item/fireaxe = 'sound/surgery/scalpel1.ogg',
		/obj/item/hatchet = 'sound/surgery/scalpel1.ogg',
		/obj/item/kitchen/knife/butcher = 'sound/surgery/scalpel1.ogg',
		/obj/item = 'sound/surgery/scalpel1.ogg',
	)
	success_sound = 'sound/surgery/bone3.ogg'

/datum/surgery_step/saw/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You begin to saw through the bone in [target]'s [parse_zone(target_zone)]...</span>",
		"<span class='notice'>[user] begins to saw through the bone in [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] begins to saw through the bone in [target]'s [parse_zone(target_zone)].</span>")

/datum/surgery_step/saw/tool_check(mob/user, obj/item/tool)
	if(implement_type == /obj/item && !(tool.get_sharpness() && (tool.force >= 10)))
		return FALSE
	return TRUE

/datum/surgery_step/saw/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	target.apply_damage(50, BRUTE, "[target_zone]")
	display_results(user, target, "<span class='notice'>You saw [target]'s [parse_zone(target_zone)] open.</span>",
		"<span class='notice'>[user] saws [target]'s [parse_zone(target_zone)] open!</span>",
		"<span class='notice'>[user] saws [target]'s [parse_zone(target_zone)] open!</span>")
	return ..()

//drill bone
/datum/surgery_step/drill
	name = "drill bone"
	implements = list(
		TOOL_DRILL = 100,
		/obj/item/screwdriver/power = 30,
		/obj/item/pickaxe/drill = 25,
		TOOL_SCREWDRIVER = 20,
		/obj/item/kitchen/spoon = 4.13) //i made this as awful as possible.
	time = 30

/datum/surgery_step/drill/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You begin to drill into the bone in [target]'s [parse_zone(target_zone)]...</span>",
		"<span class='notice'>[user] begins to drill into the bone in [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] begins to drill into the bone in [target]'s [parse_zone(target_zone)].</span>")

/datum/surgery_step/drill/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, "<span class='notice'>You drill into [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] drills into [target]'s [parse_zone(target_zone)]!</span>",
		"<span class='notice'>[user] drills into [target]'s [parse_zone(target_zone)]!</span>")
	return ..()
