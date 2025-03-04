#define STATUS_EFFECT_ASPIRATION /datum/status_effect/aspiration
/obj/structure/toolabnormality/aspiration
	name = "heart of aspiration"
	desc = "A giant red heart."
	icon_state = "heart"
	var/list/active_users = list()

/obj/structure/toolabnormality/aspiration/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!do_after(user, 6))
		return
	if(user in active_users)
		active_users -= user
		user.remove_status_effect(STATUS_EFFECT_ASPIRATION)
		to_chat(user, "<span class='userdanger'>You feel your heart slow again.</span>")
		user.cut_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects32x48.dmi', "heart", -MUTATIONS_LAYER))
	else
		active_users += user
		user.apply_status_effect(STATUS_EFFECT_ASPIRATION)
		to_chat(user, "<span class='userdanger'>You feel your blood pumping faster.</span>")
		user.add_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects32x48.dmi', "heart", -MUTATIONS_LAYER))

// Status Effect
/datum/status_effect/aspiration
	id = "heart_aspiration"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null

/datum/status_effect/aspiration/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 10)
		H.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 10)

/datum/status_effect/aspiration/tick()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjustBruteLoss(1) // Your health slowly ticks down
	H.adjustSanityLoss(1) // Your health slowly ticks down

/datum/status_effect/aspiration/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -10)
		H.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -10)

#undef STATUS_EFFECT_ASPIRATION
