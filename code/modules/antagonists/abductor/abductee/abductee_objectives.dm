/datum/objective/abductee
	completed = 1

/datum/objective/abductee/random

/datum/objective/abductee/random/New()
	explanation_text = pick(world.file2list("string/abductee_objectives.txt"))

/datum/objective/abductee/steal
	explanation_text = "Steal all"

/datum/objective/abductee/steal/New()
	var/target = pick(list("pets","lights","monkeys","fruits","shoes","bars of soap", "weapons", "computers", "organs"))
	explanation_text+=" [target]."

/datum/objective/abductee/paint
	explanation_text = "The universe is hideous. You must color it all"

/datum/objective/abductee/paint/New()
	var/color = pick(list("red", "blue", "green", "yellow", "orange", "purple", "black", "in rainbows", "in blood"))
	explanation_text+= " [color]!"

/datum/objective/abductee/speech
	explanation_text = "Your brain is broken... you can only communicate in"

/datum/objective/abductee/speech/New()
	var/style = pick(list("pantomime", "rhyme", "haiku", "extended metaphors", "riddles", "extremely literal terms", "sound effects", "military jargon", "three word sentences"))
	explanation_text+= " [style]."

/datum/objective/abductee/capture
	explanation_text = "Capture someone."

/datum/objective/abductee/calling/New()
	var/mob/dead/D = pick(GLOB.dead_mob_list)
	if(D)
		explanation_text = "You know that [D] has perished. Hold a seance to call [D.p_them()] from the spirit realm."

/datum/objective/abductee/forbiddennumber

/datum/objective/abductee/forbiddennumber/New()
	var/number = rand(2,10)
	explanation_text = "Ignore anything in a set of [number], they don't exist."
