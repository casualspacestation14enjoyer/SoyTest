/datum/supply_pack/exploration
	group = "Exploration"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/exploration/mining
	name = "Lava Exploration Kit"
	desc = "Contains two pickaxes, 60 lavaproof rods, and goggles to protect eyes from the heat"
	cost = 1500
	contains = list(
		/obj/item/pickaxe/mini,
		/obj/item/pickaxe/mini,
		/obj/item/clothing/glasses/heat,
		/obj/item/clothing/glasses/heat,
		/obj/item/clothing/glasses/heat,
		/obj/item/clothing/glasses/heat,
		/obj/item/stack/rods/lava/thirty,
		/obj/item/stack/rods/lava/thirty
		/obj/item/extinguisher/mini,
		/obj/item/extinguisher/mini,
	)
	crate_name = "Lava Exploration Kit"

/datum/supply_pack/exploration/mining
	name = "Ice Exploration Kit"
	desc = "Contains two pickaxes, winter clothes, and goggles to protect eyes from the cold"
	cost = 1500
	contains = list(
		/obj/item/pickaxe/mini,
		/obj/item/pickaxe/mini,
		/obj/item/clothing/glasses/cold,
		/obj/item/clothing/glasses/cold,
		/obj/item/clothing/glasses/cold,
		/obj/item/clothing/glasses/cold,
		/obj/item/clothing/shoes/winterboot
		/obj/item/clothing/shoes/winterboot
		/obj/item/clothing/shoes/winterboot
		/obj/item/clothing/shoes/winterboot
	)
	crate_name = "Ice Exploration Kit"

/datum/supply_pack/exploration/jungle
	name = "Jungle Exploration Kit"
	desc = "Contains hatchets, picks, and antivenom, great for dense jungles!"
	cost = 750
	contains = list(
		/obj/item/pickaxe/mini,
		/obj/item/pickaxe/mini,
		/obj/item/storage/pill_bottle/charcoal,
		/obj/item/storage/pill_bottle/charcoal,
		/obj/item/hatchet,
		/obj/item/hatchet,
	)
	crate_name = "Jungle Exploration Kit"

/datum/supply_pack/exploration/beach
	name = "Beach Kit"
	desc = "Shorts, picks, and (low quality) sunglasses, perfect for the beach!"
	cost = 500
	contains = list(
		/obj/item/pickaxe/mini,
		/obj/item/pickaxe/mini,
		/obj/item/clothing/under/shorts/black,
		/obj/item/clothing/under/shorts/blue,
		/obj/item/clothing/under/shorts/green,
		/obj/item/clothing/under/shorts/grey,
		/obj/item/clothing/under/shorts/purple,
		/obj/item/clothing/under/shorts/red,
		/obj/item/clothing/glasses/cheapsuns,
		/obj/item/clothing/glasses/cheapsuns,
		/obj/item/clothing/glasses/cheapsuns,
		/obj/item/clothing/glasses/cheapsuns,
		/obj/item/clothing/glasses/cheapsuns,
		/obj/item/clothing/glasses/cheapsuns,
	)
