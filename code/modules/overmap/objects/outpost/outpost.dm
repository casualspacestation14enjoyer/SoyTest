// DEBUG: make this a hackmd document for outpost creation
// specify skin X in code/__DEFINES/overmap.dm, make it's included in the list
// multiple outposts to a skin is allowed
// map datums should be in code/modules/overmap/objects/outpost/map_template/skin_X.dm
// map files themselves in _maps/outpost/outpost_X.dmm, _maps/outpost/elevators/elevator_X.dmm, _maps/outpost/hangars/hangar_X_YxZ.dmm

// hangars must have one and only one elevator shaft w/ landmark
// outpost map should be 121x121 exactly -- technically (QUADRANT_MAP_SIZE - 2 * QUADRANT_SIZE_BORDER)^2

// elevator landmark should be placed where bottom-left of elevator template should be placed, on hangars AND outposts. this is crucial to correct anchor alignment
// elevator template MUST contain an /obj/machinery/elevator_floor_button, on the same turf as a platform, to be functional
// elevator template MAY contain an /obj/machinery/status_display/elevator, on the same turf as a platform

// elevator SHAFTS on outpost+hangar maps MUST have a /obj/machinery/elevator_floor_button, accessible from outside, to be functional -- marked with landmark?
// elevator SHAFTS on outpost+hangar maps MAY contain one or more /obj/machinery/door on the outside marked with door landmarks, with CORRECT var/shaft

// specify that landmarks mark TURFS, and from there get their contents, not mark objs directly


// DEBUG: documentation
/datum/overmap/outpost
	name = "outpost"
	char_rep = "T"
	token_icon_state = "station"

	// DEBUG: test radio message networking.
	/// The mapzone used by the outpost level and hangars. Using a single mapzone means networked radio messages.
	var/datum/map_zone/mapzone

	/// Controls whether the outpost has a central + persistent area connected by elevators in hangars that crews can meet up in.
	var/has_phys_level = TRUE
	// The "skin" used for the outpost's hangars and elevator.
	var/skin
	// The map template used for the outpost. May be null if has_phys_level is false.
	var/datum/map_template/outpost/template

	// DEBUG: make sure this is supported correctly for has_phys_level = FALSE outposts
	var/list/datum/hangar_shaft/shaft_datums = list()

	// DEBUG: replace with a generalized solution (docking ticket-based?) for simultaneous-dock merge SGTs
	var/list/landing_in_progress_docks = list()


	/// List of missions that can be accepted at this outpost.
	var/list/datum/mission/missions
	var/max_missions = 15

// DEBUG: document source_template arg
/datum/overmap/outpost/Initialize(position, datum/map_template/outpost/source_template, ...)
	. = ..()
	Rename(gen_outpost_name())

	if(!source_template)
		var/template_name = pick(SSmapping.outpost_templates)
		source_template = SSmapping.outpost_templates[template_name]

	// DEBUG: doesn't support non-physical outposts using skins without full-blown templates
	skin = source_template.skin
	if(has_phys_level)
		template = source_template
		// DEBUG: what if somebody docks during load_main_level() CHECK_TICK?
		load_main_level()
	else
		shaft_datums += new("A", null)

	fill_missions()
	addtimer(CALLBACK(src, .proc/fill_missions), 10 MINUTES, TIMER_STOPPABLE|TIMER_LOOP|TIMER_DELETE_ME)

// DEBUG: consider more detailed cleanup behavior. cleanup missions? cleanup hangars? delete main level? lots of weird questions
/datum/overmap/outpost/Destroy(...)
	// cleanup our data structures
	for(var/list/datum/hangar_shaft/h_shaft as anything in shaft_datums)
		qdel(h_shaft)
		shaft_datums -= h_shaft
	. = ..()

/datum/overmap/outpost/get_jump_to_turf()
	if(has_phys_level)
		// the main level is (hopefully) going to be the first in the mapzone's virtual levels
		var/datum/virtual_level/vlevel = mapzone.virtual_levels[1]
		return locate(round((vlevel.low_x + vlevel.high_x) / 2), round((vlevel.low_y + vlevel.high_y) / 2), vlevel.z_value)
	else
		var/datum/hangar_shaft/rand_shaft = pick(shaft_datums)
		var/datum/hangar/rand_hangar = pick(rand_shaft.hangars)
		return rand_hangar.dock.loc

// Shamelessly cribbed from how Elite: Dangerous does station names.
/datum/overmap/outpost/proc/gen_outpost_name()
	var/person_name
	if(prob(40))
		// fun fact: "Hutton" is in last_names
		person_name = pick(GLOB.last_names)
	else
		// DEBUG: why no vox? also, tbh, this should be the server hub-name
		switch(rand(1, 4))
			if(1)
				person_name = pick(GLOB.moth_last)
			if(2)
				person_name = pick(prob(50) ? GLOB.lizard_names_male : GLOB.lizard_names_female)
			if(3)
				person_name = pick(GLOB.spider_last)
			if(4)
				person_name = kepori_name()

	return "[person_name] [pick(GLOB.station_suffixes)]"

/datum/overmap/outpost/proc/fill_missions()
	while(LAZYLEN(missions) < max_missions)
		var/mission_type = get_weighted_mission_type()
		var/datum/mission/M = new mission_type(src)
		LAZYADD(missions, M)

/datum/overmap/outpost/proc/ensure_mapzone()
	if(mapzone)
		return
	mapzone = SSmapping.create_map_zone("[name]")


/datum/overmap/outpost/proc/load_main_level()
	if(!template)
		CRASH("[src] ([src.type]) tried to load without a template!")

	log_game("[src] [REF(src)] OUTPOST MAP LEVEL INIT")
	log_shuttle("[src] [REF(src)] OUTPOST MAP LEVEL INIT")
	ensure_mapzone()

	// DEBUG: "planetary" outposts should use baseturf specification and possibly different ztrait sun type
	var/datum/virtual_level/vlevel = SSmapping.create_virtual_level(
		name,
		list(
			ZTRAIT_STATION = TRUE,
			ZTRAIT_SUN_TYPE = AZIMUTH
		),
		mapzone,
		QUADRANT_MAP_SIZE,
		QUADRANT_MAP_SIZE,
		ALLOCATION_QUADRANT,
		QUADRANT_MAP_SIZE
	)
	vlevel.reserve_margin(QUADRANT_SIZE_BORDER)

	template.load(vlevel.get_unreserved_bottom_left_turf())

	// outpost map is loaded, now we need to initialize the elevators / hangar shafts
	// step 1 is finding the template for later
	var/elevator_string = "elevator_[skin]"
	var/datum/map_template/outpost_elevator/ele_template = SSmapping.elevator_templates[elevator_string]
	if(!ele_template)
		CRASH("[src] ([src.type]) could not find the elevator map [elevator_string]!")

	// assoc list of lists of landmarks in a shaft, starting with the main landmark.
	var/list/list/shaft_lists = list()
	for(var/obj/effect/landmark/outpost/elevator/ele_mark in GLOB.outpost_landmarks)
		if(!vlevel.is_in_bounds(ele_mark))
			continue
		if(!istext(ele_mark.shaft)) // DEBUG: unnecessary check unless we use this name somewhere
			stack_trace("Invalid shaft var [ele_mark.shaft] on [ele_mark] found when loading [template]!")
			qdel(ele_mark)
		else
			shaft_lists[ele_mark.shaft] = list(ele_mark)

	if(!shaft_lists.len)
		stack_trace("No elevator shafts found while loading [template]! The map will be inaccessible!")

	// now we get the machine landmarks (button, doors) and add them to the shaft list
	for(var/obj/effect/landmark/outpost/elevator_machine/mach_mark in GLOB.outpost_landmarks)
		if(!vlevel.is_in_bounds(mach_mark))
			continue
		if(!(mach_mark.shaft in shaft_lists))
			stack_trace("Invalid shaft var [mach_mark.shaft] on [mach_mark] found when loading [template]!")
			qdel(mach_mark)
		else
			shaft_lists[mach_mark.shaft] += mach_mark

	for(var/shaft_name in shaft_lists)
		var/list/obj/shaft_li = shaft_lists[shaft_name]
		var/obj/effect/landmark/outpost/elevator/anchor_landmark = shaft_li[1]
		var/obj/structure/elevator_platform/plat

		// load the template
		ele_template.load(anchor_landmark.loc)
		plat = locate() in anchor_landmark.loc
		// create the shaft datum
		shaft_datums += new /datum/hangar_shaft(shaft_name, anchor_landmark.shaft_type, plat.master_datum)

		// find the call button and floor doors if they exist
		var/obj/machinery/elevator_call_button/call_button
		var/list/obj/machinery/door/floor_doors = list()
		// look at the machine marks again
		for(var/obj/effect/landmark/outpost/elevator_machine/mach_mark as anything in (shaft_li - anchor_landmark))
			if(!call_button)
				call_button = locate() in mach_mark.loc
			var/obj/machinery/door/floor_door = locate() in mach_mark.loc
			if(floor_door)
				floor_doors += floor_door

		plat.master_datum.add_floor(anchor_landmark.loc, call_button, floor_doors)
		QDEL_LIST(shaft_li) // don't need them anymore

/datum/overmap/outpost/pre_docked(datum/overmap/ship/controlled/dock_requester)
	var/datum/hangar/hangar_to_use = null
	var/list/dock_size = get_hangar_size(dock_requester.shuttle_port)
	// DEBUG: correctly propagate docking ticket errors upwards to inform user what the fuck is going on, instead of just returning false
	if(!dock_size)
		return FALSE

	hangar_to_use = ensure_hangar(dock_size, ELEVATOR_SHAFT_NORMAL)

	if(!hangar_to_use)
		stack_trace(
			"Outpost [src] (type [src.type], skin [skin]) unable to create a hangar for ship " +\
			"[dock_requester] (template [dock_requester.source_template], size [dock_size[1]]x[dock_size[2]])!"
		)
		return FALSE

	landing_in_progress_docks += hangar_to_use.dock
	adjust_dock_to_shuttle(hangar_to_use.dock, dock_requester.shuttle_port)
	return new /datum/docking_ticket(hangar_to_use.dock, src, dock_requester)

/datum/overmap/outpost/proc/ensure_hangar(list/size, shaft_type)
	. = null
	// DEBUG: devolve this behavior? data structure datums in byond are kinda dumb
	for(var/datum/hangar_shaft/h_shaft as anything in shaft_datums)
		if(h_shaft.shaft_type != shaft_type)
			continue
		for(var/datum/hangar/h_datum as anything in h_shaft.hangars)
			var/obj/docking_port/stationary/dock = h_datum.dock
			// i'm so fucking sorry
			// a dock + undock cycle might flip the dock's height + width due to dock adjustment,
			// so we need to check both orderings to make sure they match
			if( \
				!(dock in landing_in_progress_docks) && !dock.docked && \
				( \
					(dock.width == size[1] && dock.height == size[2]) || \
					(dock.height == size[1] && dock.width == size[2]) \
				) \
			)
				. = h_datum
				break
		if(.)
			break

	// we didn't find a valid hangar, so we have to make one
	if(!.)
		var/datum/hangar_shaft/chosen_shaft
		// pick a random shaft to add on to. shuffle() returns a copy so we're not modifying the list
		for(var/datum/hangar_shaft/shaft as anything in shuffle(shaft_datums))
			if(shaft.shaft_type == shaft_type)
				chosen_shaft = shaft
				break

		// DEBUG: what if somebody docks during make_hangar() CHECK_TICK?
		var/datum/hangar/new_hangar = make_hangar(size, chosen_shaft)
		. = new_hangar

// DEBUG: send an announcement or radio message saying "you've docked to hangar SHAFT-NUM" for immersion + so that people can look back in their chatlog if they forget
/datum/overmap/outpost/post_docked(datum/overmap/ship/controlled/dock_requester)
	// removes the stationary dock from the list, so that we don't have to worry about it causing merge SGTs
	landing_in_progress_docks -= dock_requester.shuttle_port.docked

	for(var/mob/M as anything in GLOB.player_list)
		if(dock_requester.shuttle_port.is_in_shuttle_bounds(M))
			M.play_screen_text("<span class='maptext' style=font-size:24pt;text-align:center valign='top'><u>[name]</u></span><br>[station_time_timestamp_fancy("hh:mm")]")

	return

/datum/overmap/outpost/post_undocked(datum/overmap/ship/controlled/dock_requester)
	// DEBUG: implement
	// if(delete_hangar_on_empty)
	return

/datum/overmap/outpost/proc/make_hangar(list/size_list, datum/hangar_shaft/shaft)
	var/map_string = "hangar_[skin]_[size_list[1]]x[size_list[2]]"
	var/datum/map_template/hangar/hangar_template = SSmapping.hangar_templates[map_string]
	if(!hangar_template)
		CRASH("[src] ([src.type]) could not find the hangar [map_string]!")

	// DEBUG: is this even necessary?
	log_game("[src] [REF(src)] OUTPOST HANGAR INIT")
	log_shuttle("[src] [REF(src)] OUTPOST HANGAR INIT")

	ensure_mapzone()
	// DEBUG: "planetary" outposts should use baseturf specification and possibly different ztrait sun type
	var/datum/virtual_level/vlevel = SSmapping.create_virtual_level(
		"[src.name] Loading Hangar", // we actually need to change this later; we can't number the hangar if we CHECK_TICK before we add the hangar to the list
		list(
			// DEBUG: review ZTRAIT_STATION; use here likely to cause problems due to its use as a flag for "safe" area teleportation fallback?
			// ZTRAIT_STATION = TRUE,
			ZTRAIT_SUN_TYPE = AZIMUTH
		),
		mapzone,
		hangar_template.width+2,
		hangar_template.height+2,
		ALLOCATION_FREE
	)
	// DEBUG: too thin? meson exploits are a possibility. also, consider a #define (make sure to update the width + height above)
	vlevel.reserve_margin(1)

	hangar_template.load(vlevel.get_unreserved_bottom_left_turf())

	var/turf/dock_turf
	for(var/obj/effect/landmark/outpost/hangar_dock/dock_mark in GLOB.outpost_landmarks)
		if(vlevel.is_in_bounds(dock_mark))
			dock_turf = dock_mark.loc
			qdel(dock_mark, TRUE)
			break
	if(!dock_turf)
		CRASH("[src] ([src.type]) could not find a hangar docking port landmark for its spawned hangar [map_string]!")

	var/obj/docking_port/stationary/hangar_dock = new(dock_turf)
	hangar_dock.dir = NORTH
	hangar_dock.width = size_list[1] // hangar ports are wider than they are tall -- size list is in descending order, so it checks out
	hangar_dock.height = size_list[2]

	if(!shaft.shaft_elevator)
		// if there's no elevator in this shaft, then delete the landmarks
		for(var/obj/effect/landmark/outpost/mark as anything in GLOB.outpost_landmarks)
			if(vlevel.is_in_bounds(mark))
				qdel(mark)
	else
		var/turf/anchor_turf
		var/obj/machinery/elevator_call_button/call_button
		var/list/obj/machinery/door/floor_doors = list()

		for(var/obj/effect/landmark/outpost/elevator/ele_mark in GLOB.outpost_landmarks)
			if(vlevel.is_in_bounds(ele_mark))
				anchor_turf = ele_mark.loc
				qdel(ele_mark)
				break

		for(var/obj/effect/landmark/outpost/elevator_machine/mach_mark in GLOB.outpost_landmarks)
			if(!vlevel.is_in_bounds(mach_mark))
				continue
			if(!call_button)
				call_button = locate() in mach_mark.loc
			var/obj/machinery/door/floor_door = locate() in mach_mark.loc
			if(floor_door)
				floor_doors += floor_door
			qdel(mach_mark)

		if(!anchor_turf)
			stack_trace("No anchor turf found when loading [hangar_template]! The hangar will not have an elevator!")
		if(!call_button)
			stack_trace("No elevator call button found when loading [hangar_template]! The hangar will not have an elevator!")

		// DEBUG: subtype to /datum/elevator_shaft ? could actually make sense, if it is passed the vlevel and handles initialization
		shaft.shaft_elevator.add_floor(anchor_turf, call_button, floor_doors)
	var/datum/hangar/new_hangar = new /datum/hangar(hangar_dock)
	shaft.hangars += new_hangar

	// we do these AFTER adding to the list, so that multiple hangars added simultaneously don't assume the same number
	var/hangar_num = length(shaft.hangars)
	var/hangar_name = "[src.name] Hangar [shaft.name]-[hangar_num]"
	hangar_dock.name = hangar_name
	vlevel.name = hangar_name

	return new_hangar

// DEBUG: reanalyze this code
/// Returns a list containing the size of the hangar dock corresponding to the passed mobile docking port, or null if the port is too large for a hangar.
/// The first element in the list will be larger than the second.
/datum/overmap/outpost/proc/get_hangar_size(obj/docking_port/mobile/request_port)
	var/list/size_descending
	if(request_port.width > request_port.height)
		size_descending = list(request_port.width, request_port.height)
	else
		size_descending = list(request_port.height, request_port.width)

	if(size_descending[1] > RESERVE_DOCK_MAX_SIZE_LONG || size_descending[2] > RESERVE_DOCK_MAX_SIZE_SHORT)
		return null

	// rounds up to the nearest multiple of 20
	// i pray that there is never a port with a width or height of 0
	size_descending = list(
		CEILING(size_descending[1], 20),
		CEILING(size_descending[2], 20)
	)

	// for each rounded dimension, if it is larger than the multiple of 20 that is closest to the corresponding max size,
	// it is capped to that max size.
	return list(
		size_descending[1] >= round(RESERVE_DOCK_MAX_SIZE_LONG, 20) ? RESERVE_DOCK_MAX_SIZE_LONG : size_descending[1],
		size_descending[2] >= round(RESERVE_DOCK_MAX_SIZE_SHORT, 20) ? RESERVE_DOCK_MAX_SIZE_SHORT : size_descending[2]
	)
