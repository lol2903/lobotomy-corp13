/mob/living/simple_animal/hostile/abnormality/crumbling_armor
	name = "Crumbling Armor"
	desc = "A thoroughly aged suit of samurai style armor with a V shaped crest on the helmet. It appears desuetude."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "crumbling"
	maxHealth = 600
	health = 600
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 50, 55, 55, 60),
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = list(60, 60, 65, 65, 70)
			)
	work_damage_amount = 4
	work_damage_type = PALE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/daredevil,
		/datum/ego_datum/armor/daredevil
		)
	gift_type = null
	gift_chance = 100
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY
	var/buff_icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/Initialize(mapload)
	. = ..()
	// Megalovania?
	if (prob(1))
		icon_state = "megalovania"

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/proc/Cut_Head(datum/source, datum/abnormality/datum_sent, mob/living/carbon/human/user, work_type)
	SIGNAL_HANDLER
	if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/courage) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/recklessCourage) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/recklessFoolish) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/foolish) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase1) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase2) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase3) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase4))
		if (work_type != ABNORMALITY_WORK_ATTACHMENT)
			return
		var/obj/item/bodypart/head/head = user.get_bodypart("head")
		//Thanks Red Queen
		if(!istype(head))
			return FALSE
		if(!isnull(user.ego_gift_list[HAT]) && istype(user.ego_gift_list[HAT], /datum/ego_gifts))
			var/datum/ego_gifts/removed_gift = user.ego_gift_list[HAT]
			removed_gift.Remove(user)
			//user.ego_gift_list[HAT].Remove(user)
		head.dismember()
		user.adjustBruteLoss(500)
		return TRUE
	UnregisterSignal(user, COMSIG_WORK_STARTED)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if (get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 40)
		var/obj/item/bodypart/head/head = user.get_bodypart("head")
		//Thanks Red Queen
		if(!istype(head))
			return
		head.dismember()
		user.adjustBruteLoss(500)
		return
	if(user.stat != DEAD && work_type == ABNORMALITY_WORK_REPRESSION)
		if (src.icon_state == "megalovania")
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase1)) // From Courage to Recklessness
				playsound(get_turf(user), 'sound/abnormalities/crumbling/megalovania.ogg', 50, 0, 2)
				var/datum/ego_gifts/phase2/CAEG = new
				CAEG.datum_reference = datum_reference
				user.Apply_Gift(CAEG)
				to_chat(user, "<span class='userdanger'>How much more will it take?</span>")
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase2)) // From Recklessness to Foolishness
				playsound(get_turf(user), 'sound/abnormalities/crumbling/megalovania.ogg', 50, 0, 2)
				var/datum/ego_gifts/phase3/CAEG = new
				CAEG.datum_reference = datum_reference
				user.Apply_Gift(CAEG)
				to_chat(user, "<span class='userdanger'>You need more strength!</span>")
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase3)) // From Foolishness to Suicidal
				playsound(get_turf(user), 'sound/abnormalities/crumbling/megalovania.ogg', 50, 0, 2)
				var/datum/ego_gifts/phase4/CAEG = new
				CAEG.datum_reference = datum_reference
				user.Apply_Gift(CAEG)
				to_chat(user, "<span class='userdanger'>DETERMINATION.</span>")
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase4)) // You can progress no further down this fool-hardy path
				return
			playsound(get_turf(user), 'sound/abnormalities/crumbling/megalovania.ogg', 50, 0, 2)
			var/datum/ego_gifts/phase1/CAEG = new
			CAEG.datum_reference = datum_reference
			user.Apply_Gift(CAEG)
			RegisterSignal(user, COMSIG_WORK_STARTED, .proc/Cut_Head)
			to_chat(user, "<span class='userdanger'>Just a drop of blood is what it takes...</span>")
		else
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/courage)) // From Courage to Recklessness
				playsound(get_turf(user), 'sound/machines/clockcult/stargazer_activate.ogg', 50, 0, 2)
				var/datum/ego_gifts/recklessCourage/CAEG = new
				CAEG.datum_reference = datum_reference
				user.Apply_Gift(CAEG)
				to_chat(user, "<span class='userdanger'>Your muscles flex with strength!</span>")
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/recklessCourage)) // From Recklessness to Foolishness
				playsound(get_turf(user), 'sound/machines/clockcult/stargazer_activate.ogg', 50, 0, 2)
				var/datum/ego_gifts/recklessFoolish/CAEG = new
				CAEG.datum_reference = datum_reference
				user.Apply_Gift(CAEG)
				to_chat(user, "<span class='userdanger'>You feel like you could take on the world!</span>")
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/recklessFoolish)) // From Foolishness to Suicidal
				playsound(get_turf(user), 'sound/machines/clockcult/stargazer_activate.ogg', 50, 0, 2)
				var/datum/ego_gifts/foolish/CAEG = new
				CAEG.datum_reference = datum_reference
				user.Apply_Gift(CAEG)
				to_chat(user, "<span class='userdanger'>You are a God among men!</span>")
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/foolish)) // You can progress no further down this fool-hardy path
				return
			playsound(get_turf(user), 'sound/machines/clockcult/stargazer_activate.ogg', 50, 0, 2)
			var/datum/ego_gifts/courage/CAEG = new
			CAEG.datum_reference = datum_reference
			user.Apply_Gift(CAEG)
			RegisterSignal(user, COMSIG_WORK_STARTED, .proc/Cut_Head)
			to_chat(user, "<span class='userdanger'>A strange power flows through you!</span>")
	return

/datum/ego_gifts/courage
	name = "Inspired Courage"
	icon_state = "courage"
	justice_bonus = 10
	slot = HAT
/datum/ego_gifts/recklessCourage
	name = "Reckless Courage"
	icon_state = "recklessFirst"
	fortitude_bonus = -5
	justice_bonus = 10
	slot = HAT
/datum/ego_gifts/recklessFoolish
	name = "Reckless Foolishness"
	icon_state = "recklessSecond"
	fortitude_bonus = -10
	justice_bonus = 15
	slot = HAT
/datum/ego_gifts/foolish
	name = "Reckless Foolishness"
	icon_state = "foolish"
	fortitude_bonus = -20
	justice_bonus = 20
	slot = HAT
/datum/ego_gifts/phase1
	name = "Lv 4"
	icon_state = "phase1"
	justice_bonus = 10
	slot = HAT
/datum/ego_gifts/phase2
	name = "Lv 10"
	icon_state = "phase2"
	fortitude_bonus = -5
	justice_bonus = 10
	slot = HAT
/datum/ego_gifts/phase3
	name = "Lv 15"
	icon_state = "phase3"
	fortitude_bonus = -10
	justice_bonus = 15
	slot = HAT
/datum/ego_gifts/phase4
	name = "Lv 19"
	icon_state = "phase4"
	fortitude_bonus = -20
	justice_bonus = 20
	slot = HAT
