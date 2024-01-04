/datum/job/brig_phys
	name = "Brig Physician"
	minimal_player_age = 7
	wiki_page = "Guide_to_Medicine" //WS Edit - Wikilinks/Warning

	outfit = /datum/outfit/job/brig_phys

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_FORENSICS_LOCKERS, ACCESS_MEDICAL, ACCESS_EVA)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_FORENSICS_LOCKERS, ACCESS_MEDICAL)
	mind_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_BRIG_PHYS

/datum/outfit/job/brig_phys
	name = "Brig Physician (Independent)"
	job_icon = "brigphysician"
	jobtype = /datum/job/brig_phys

	belt = /obj/item/pda/brig_phys
	gloves = /obj/item/clothing/gloves/color/latex/nitrile
	ears = /obj/item/radio/headset/headset_medsec/alt
	uniform = /obj/item/clothing/under/rank/security/brig_phys
	shoes = /obj/item/clothing/shoes/sneakers/white
	glasses = /obj/item/clothing/glasses/hud/health
	suit = /obj/item/clothing/suit/toggle/labcoat
	head = /obj/item/clothing/head/beret/sec/brig_phys
	alt_suit = null
	dcoat = /obj/item/clothing/suit/hooded/wintercoat/security
	suit_store = /obj/item/flashlight/pen

	implants = list(/obj/item/implant/mindshield)


/datum/outfit/job/brig_phys/nanotrasen
	name = "Brig Physician (Nanotrasen)"

	uniform = /obj/item/clothing/under/rank/security/brig_phys/nt
	gloves = /obj/item/clothing/gloves/color/latex/nitrile/evil
	head = /obj/item/clothing/head/soft/sec
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/toggle/labcoat/brig_phys
	alt_suit = /obj/item/clothing/suit/armor/vest/security/brig_phys
