/obj/item/ego_weapon/lamp
	name = "lamp"
	desc = "Big Bird's eyes gained another in number for every creature it saved. \
	On this weapon, the radiant pride is apparent."
	special = "This weapon attacks all non-humans in an AOE. \
			This weapon deals double damage on direct attack."
	icon_state = "lamp"
	force = 25
	attack_speed = 1.3
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("slams", "attacks")
	attack_verb_simple = list("slam", "attack")
	hitsound = 'sound/weapons/ego/hammer.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/lamp/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return FALSE
	. = ..()
	for(var/mob/living/L in view(1, M))
		var/aoe = 25
		var/userjust = (get_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		aoe*=justicemod
		if(L == user || ishuman(L))
			continue
		L.apply_damage(aoe, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(L))


/obj/item/ego_weapon/despair
	name = "sword sharpened with tears"
	desc = "A sword suitable for swift thrusts. \
	Even someone unskilled in dueling can rapidly puncture an enemy using this E.G.O with remarkable agility."
	special = "This weapon has a combo system. To turn off this combo system, use in hand. \
			This weapon has a fast attack speed"
	icon_state = "despair"
	force = 20
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("stabs", "attacks", "slashes")
	attack_verb_simple = list("stab", "attack", "slash")
	hitsound = 'sound/weapons/ego/rapier1.ogg'
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)
	var/combo = 0
	var/combo_time
	var/combo_wait = 10
	var/combo_on = TRUE

/obj/item/ego_weapon/despair/attack_self(mob/user)
	..()
	if(combo_on)
		to_chat(user,"<span class='warning'>You swap your grip, and will no longer perform a finisher.</span>")
		combo_on = FALSE
		return
	if(!combo_on)
		to_chat(user,"<span class='warning'>You swap your grip, and will now perform a finisher.</span>")
		combo_on =TRUE
		return

//This is like an anime character attacking like 4 times with the 4th one as a finisher attack.
/obj/item/ego_weapon/despair/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time || !combo_on)	//or you can turn if off I guess
		combo = 0
	combo_time = world.time + combo_wait
	if(combo==4)
		combo = 0
		user.changeNext_move(CLICK_CD_MELEE * 2)
		force *= 5	// Should actually keep up with normal damage.
		playsound(src, 'sound/weapons/fwoosh.ogg', 300, FALSE, 9)
		to_chat(user,"<span class='warning'>You are offbalance, you take a moment to reset your stance.</span>")
	else
		user.changeNext_move(CLICK_CD_MELEE * 0.4)
	..()
	combo += 1
	force = initial(force)

/obj/item/ego_weapon/totalitarianism
	name = "totalitarianism"
	desc = "When one is oppressed, sometimes they try to break free."
	special = "Use in hand to unlock it's full power."
	icon_state = "totalitarianism"
	force = 80
	attack_speed = 3
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleaves", "cuts")
	hitsound = 'sound/weapons/ego/hammer.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)
	var/charged = FALSE

/obj/item/ego_weapon/totalitarianism/attack(mob/living/M, mob/living/user)
	..()
	force = 80
	charged = FALSE

/obj/item/ego_weapon/totalitarianism/attack_self(mob/user)
	if(do_after(user, 12, src))
		charged = TRUE
		force = 120	//FULL POWER
		to_chat(user,"<span class='warning'>You put your strength behind this attack.</span>")

/obj/item/ego_weapon/oppression
	name = "oppression"
	desc = "Even light forms of contraint can be considered totalitarianism"
	special = "This weapon builds up charge on every hit. Use the weapon in hand to charge the blade."
	icon_state = "oppression"
	force = 13
	attack_speed = 0.3
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleaves", "cuts")
	hitsound = 'sound/weapons/slash.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)
	var/charged = FALSE
	var/meter = 0
	var/meter_counter = 1

/obj/item/ego_weapon/oppression/attack_self(mob/user)
	if (!charged)
		charged = TRUE
		to_chat(user,"<span class='warning'>You focus your energy, adding [meter] damage to your next attack.</span>")
		force += meter
		meter = 0

/obj/item/ego_weapon/oppression/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	meter += meter_counter
	meter_counter += 1

	meter = min(meter, 60)
	..()
	if(charged == TRUE)
		charged = FALSE
		force = 15
		meter_counter = 0

/obj/item/ego_weapon/remorse
	name = "remorse"
	desc = "A hammer and nail, unwieldy and impractical against most. \
	Any crack, no matter how small, will be pried open by this E.G.O."
	special = "This weapon hits slower than usual."
	icon_state = "remorse"
	special = "Use this weapon in hand to change it's mode. \
		The Nail mode marks targets for death. \
		The Hammer mode deals bonus damage to all marked."
	force = 30	//Does more damage later.
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("Smashes", "Pierces", "Cracks")
	attack_verb_simple = list("Smash", "Pierce", "Crack")
	hitsound = 'sound/weapons/ego/remorse.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
	var/list/targets = list()
	var/ranged_damage = 60	//Fuckload of white on ability. Be careful!
	var/mode = FALSE		//False for nail, true for hammer

/obj/item/ego_weapon/remorse/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return

	if(!mode)
		if(!(M in targets))
			targets+= M

	if(mode)
		if(M in targets)
			playsound(M, 'sound/weapons/slice.ogg', 100, FALSE, 4)
			M.apply_damage(ranged_damage, WHITE_DAMAGE, null, M.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
			new /obj/effect/temp_visual/remorse(get_turf(M))
			targets -= M
	..()

/obj/item/ego_weapon/remorse/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(mode)	//Turn to nail
		mode = FALSE
		to_chat(user,"<span class='warning'>You swap to nail mode, clearing all marks.</span>")
		targets = list()
		return

	if(!mode)	//Turn to hammer
		mode = TRUE
		to_chat(user,"<span class='warning'>You swap to hammer mode.</span>")
		return

/obj/item/ego_weapon/mini/crimson
	name = "crimson claw"
	desc = "It's more important to deliver a decisive strike in blind hatred without hesitation than to hold on to insecure courage."
	special = "Use it in hand to activate ranged attack."
	icon_state = "crimsonclaw"
	special = "This weapon hits faster than usual."
	force = 18
	attack_speed = 0.5
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	hitsound = 'sound/abnormalities/redhood/attack_1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

	var/combo = 1
	var/combo_time
	var/combo_wait = 20
	// "Throwing" attack
	var/special_attack = FALSE
	var/special_damage = 100
	var/special_cooldown
	var/special_cooldown_time = 8 SECONDS
	var/special_checks_faction = FALSE

/obj/item/ego_weapon/mini/crimson/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time)
		combo = 1
	combo_time = world.time + combo_wait
	switch(combo)
		if(2)
			hitsound = 'sound/abnormalities/redhood/attack_2.ogg'
		if(3)
			hitsound = 'sound/abnormalities/redhood/attack_3.ogg'
		else
			hitsound = 'sound/abnormalities/redhood/attack_1.ogg'
	force *= (1 + (combo * 0.15))
	user.changeNext_move(CLICK_CD_MELEE * (1 + (combo * 0.2)))
	if(combo >= 3)
		combo = 0
	..()
	combo += 1
	force = initial(force)

/obj/item/ego_weapon/mini/crimson/attack_self(mob/living/user)
	if(!CanUseEgo(user))
		return
	if(special_cooldown > world.time)
		return
	special_attack = !special_attack
	if(special_attack)
		to_chat(user, "<span class='notice'>You prepare to throw [src].</span>")
	else
		to_chat(user, "<span class='notice'>You decide to not throw [src], for now.</span>")

/obj/item/ego_weapon/mini/crimson/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user))
		return
	if(special_cooldown > world.time)
		return
	if(!special_attack)
		return
	special_attack = FALSE
	special_cooldown = world.time + special_cooldown_time
	var/turf/target_turf = get_ranged_target_turf_direct(user, A, 8)
	var/list/turfs_to_hit = list()
	for(var/turf/T in getline(user, target_turf))
		if(T.density)
			break
		if(locate(/obj/machinery/door) in T)
			continue
		turfs_to_hit += T
	if(!LAZYLEN(turfs_to_hit))
		return
	playsound(user, 'sound/abnormalities/redhood/throw.ogg', 75, TRUE, 3)
	user.visible_message("<span class='warning'>[user] throws [src] towards [A]!</span>")
	var/dealing_damage = special_damage // Damage reduces a little with each mob hit
	for(var/i = 1 to turfs_to_hit.len) // Basically, I copied my code from helper's realized ability. Yep.
		var/turf/open/T = turfs_to_hit[i]
		if(!istype(T))
			continue
		// Effects
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(T, src)
		var/matrix/M = matrix(D.transform)
		M.Turn(45 * i)
		D.transform = M
		D.alpha = min(150 + i*15, 255)
		animate(D, alpha = 0, time = 2 + i*2)
		// Actual damage
		for(var/obj/structure/window/W in T)
			W.obj_destruction("[src.name]")
		for(var/mob/living/L in T)
			if(L == user)
				continue
			if(special_checks_faction && user.faction_check_mob(L))
				continue
			to_chat(L, "<span class='userdanger'>You are hit by [src]!</span>")
			L.apply_damage(dealing_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))
			dealing_damage = max(dealing_damage * 0.9, special_damage * 0.3)

/obj/item/ego_weapon/thirteen
	name = "for whom the bell tolls"
	desc = "There is nothing else than now. There is neither yesterday, certainly, nor is there any tomorrow."
	special = "This weapon deals an absurd amount of damage on the 13th hit."
	icon_state = "thirteen"
	force = 30
	damtype = PALE_DAMAGE
	armortype = PALE_DAMAGE
	attack_verb_continuous = list("cuts", "attacks", "slashes")
	attack_verb_simple = list("cut", "attack", "slash")
	hitsound = 'sound/weapons/rapierhit.ogg'
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)
	var/combo = 0
	var/combo_time
	var/combo_wait = 3 SECONDS

//On the 13th hit, Deals user justice x 2
/obj/item/ego_weapon/thirteen/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time)
		combo = 0
	combo_time = world.time + combo_wait
	if(combo >= 13)
		combo = 0
		force = get_attribute_level(user, JUSTICE_ATTRIBUTE)
		new /obj/effect/temp_visual/thirteen(get_turf(M))
		playsound(src, 'sound/weapons/ego/price_of_silence.ogg', 25, FALSE, 9)
	..()
	combo += 1
	force = initial(force)


/obj/item/ego_weapon/stem
	name = "green stem"
	desc = "All personnel involved in the equipment's production wore heavy protection to prevent them from being influenced by the entity."
	special = "Wielding this weapon grants an immunity to the slowing effects of the princess's vines. \
				Use in hand to channel a vine burst."
	icon_state = "green_stem"
	force = 32 //original 8-16
	reach = 2		//Has 2 Square Reach.
	attack_speed = 1.2
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	equip_sound = 'sound/creatures/venus_trap_hit.ogg'
	pickup_sound = 'sound/creatures/venus_trap_hurt.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 80
							)
	var/vine_cooldown

/obj/item/ego_weapon/stem/Initialize(mob/user)
	.=..()
	vine_cooldown = world.time

/obj/item/ego_weapon/stem/attack_self(mob/living/user)
	. = ..()
	if(!CanUseEgo(user))
		return
	if(vine_cooldown <= world.time)
		user.visible_message("<span class='notice'>[user] stabs [src] into the ground.</span>", "<span class='nicegreen'>You stab your [src] into the ground.</span>")
		var/mob/living/carbon/human/L = user
		L.adjustSanityLoss(30)
		if(!locate(/obj/structure/apple_vine) in get_turf(user))
			L.visible_message("<span class='notice'>Wilted stems grow from [src].</span>")
			new /obj/structure/apple_vine(get_turf(user))
			return

		var/affected_mobs = 0
		for(var/i = 1 to 6)
			var/channel_level = (3 SECONDS) / i //Burst is 3 + 1.5 + 1 + 0.75 + 0.6 + 0.2 seconds for a total of 60-90 damage over a period of 7.05 seconds if you allow it to finish.
			vine_cooldown = world.time + channel_level + (1 SECONDS)
			if(!do_after(user, channel_level, target = user))
				to_chat(user, "<span class='warning'>Your vineburst is interrupted.</span>")
				break
			for(var/mob/living/C in oview(3, get_turf(src)))
				var/vine_damage = 10
				if(user.sanityhealth <= (user.maxSanity * 0.3))
					vine_damage *= 1.5
				else if(user.faction_check_mob(C))
					continue
				new /obj/effect/temp_visual/vinespike(get_turf(C))
				C.apply_damage(vine_damage, BLACK_DAMAGE, null, C.run_armor_check(null, BLACK_DAMAGE), spread_damage = FALSE)
				affected_mobs += 1
			playsound(loc, 'sound/creatures/venus_trap_hurt.ogg', min(75, affected_mobs * 15), TRUE, round( affected_mobs * 0.5))
		vine_cooldown = world.time + (3 SECONDS)

/obj/item/ego_weapon/ebony_stem
	name = "ebony stem"
	desc = "An apple does not culminate when it ripens to bright red; \
	only when the apple shrivels up and attracts lowly creatures."
	special = "This weapon has a ranged attack."
	icon_state = "ebony_stem"
	force = 35
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("admonishes", "rectifies", "conquers")
	attack_verb_simple = list("admonish", "rectify", "conquer")
	hitsound = 'sound/weapons/ego/rapier2.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
	var/ranged_cooldown
	var/ranged_cooldown_time = 1.2 SECONDS
	var/ranged_damage = 60

/obj/effect/temp_visual/thornspike
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "thornspike"
	duration = 10

/obj/item/ego_weapon/ebony_stem/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(ranged_cooldown > world.time)
		to_chat(user, "<span class='warning'>Your ranged attack is still recharging!")
		return
	if(!CanUseEgo(user))
		return
	var/turf/target_turf = get_turf(A)
	if(!istype(target_turf))
		return
	if((get_dist(user, target_turf) < 2) || (get_dist(user, target_turf) > 10))
		return
	..()
	ranged_cooldown = world.time + ranged_cooldown_time
	if(do_after(user, 5))
		playsound(target_turf, 'sound/abnormalities/ebonyqueen/attack.ogg', 50, TRUE)
		for(var/turf/open/T in range(target_turf, 1))
			new /obj/effect/temp_visual/thornspike(T)
			for(var/mob/living/L in T.contents)
				L.apply_damage(ranged_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)

/obj/item/ego_weapon/wings // Is this overcomplicated? Yes. But I'm finally happy with what I want to make of this weapon.
	name = "torn off wings"
	desc = "He stopped, gave a deep sigh, quickly tore from his shoulders the ribbon Marie had tied around him, \
		pressed it to his lips, put it on as a token, and, bravely brandishing his bare sword, \
		jumped as nimbly as a bird over the ledge of the cabinet to the floor."
	special = "This weapon has a unique combo system and attacks twice per click.\n \
		Press Z to do a spinning attack, and click on a distant target to dash towards them in a cardinal direction."
	icon_state = "wings"
	force = 10
	attack_speed = 0.6
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("slashes", "claws")
	attack_verb_simple = list("slashes", "claws")
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60
							)
	var/hit_count = 0
	var/max_count = 16
	var/special_cost = 4
	var/special_force = 20
	var/special_combo = 0
	var/special_combo_mult = 0.2
	var/decay_time = 3 SECONDS
	var/combo_hold
	var/special_combo_hold
	var/special_cooldown = 3
	var/specialing = FALSE
	var/list/hit_turfs = list()

/obj/item/ego_weapon/wings/attack(mob/living/M, mob/living/user) // This part's simple, basically Oppression but with decay.
	if(!CanUseEgo(user))
		return
	if(world.time > combo_hold) // Your combo ended.
		hit_count = 0
	if(max_count > hit_count)
		hit_count++
	else if(prob(10))
		to_chat(user, "<span class='notice'>[src]' feathers bristle!</span>") // "Hey dumbass, you can stop smacking them now"
	combo_hold = world.time + decay_time
	..()
	INVOKE_ASYNC(src, .proc/SecondSwing, M, user)
	return

/obj/item/ego_weapon/wings/attack_self(mob/user)
	. = ..()
	if(world.time > combo_hold && hit_count > 0)
		to_chat(user, "<span class='notice'>[src]' feathers fall still...</span>") // Notify you the combo's over
		hit_count = 0
	if(!(special_cost > hit_count) && !(specialing))
		specialing = TRUE
		combo_hold = world.time + decay_time
		hit_count -= special_cost
		if(special_combo < 4) // Special combo goes up to 5.
			special_combo++
		else if(prob(20)) // If your special combo is at max, you get some glory.
			user.visible_message("<span class='notice'>[user] is moving like the wind!</span>")
		Pirouette(user)
		specialing = FALSE

/obj/item/ego_weapon/wings/afterattack(atom/A, mob/living/user, params) // Time for the ANIME BLADE DASH ATTACK
	if(world.time > combo_hold && hit_count > 0)
		to_chat(user, "<span class='notice'>[src]' feathers fall still...</span>")
		hit_count = 0
		return
	if(special_cost > hit_count || !CanUseEgo(user) || get_dist(get_turf(A), get_turf(user)) < 2 || specialing)
		return
	var/aim_dir = get_cardinal_dir(get_turf(user), get_turf(A)) // You can only anime dash in a cardinal direction.
	if(CheckPath(user, aim_dir))
		to_chat(user,"<span class='notice'>You need more room to do that!</span>")
	else
		user.visible_message("<span class='notice'>[user] lunges forward, [src] dancing in their grasp!</span>") // ANIME AS FUCK
		playsound(src, hitsound, 75, FALSE, 4) // Might need a punchier sound, but none come to mind.
		hit_count -= special_cost
		combo_hold = world.time + decay_time // Specials continue the regular AND special combo.
		if(special_combo_hold > world.time)
			if(special_combo < 4)
				special_combo++
			else if(prob(20))
				user.visible_message("<span class='notice'>[user] is moving like the wind!</span>")
		else
			special_combo = 1
		special_combo_hold = world.time + decay_time
		hit_turfs = list() // Clear the list of turfs we hit last time
		specialing = TRUE
		addtimer(CALLBACK(src, .proc/ResetSpecial), special_cooldown)// Engage special cooldown
		Leap(user, aim_dir, 0)
	return

/obj/item/ego_weapon/wings/proc/Pirouette(mob/living/user)
	user.visible_message("<span class='notice'>[user] whirls in place, [src] flicking out at enemies!</span>") // You cool looking bitch
	playsound(src, hitsound, 75, FALSE, 4)
	for(var/turf/T in orange(1, user)) // Most of this code was jacked from Harvest tbh
		new /obj/effect/temp_visual/smash_effect(T)
	var/aoe = special_force * (1 + special_combo_mult * special_combo)
	var/userjust = (get_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust/100
	aoe*=justicemod
	for(var/mob/living/L in range(1, user))
		if(L == user) // Might remove FF immunity sometime
			continue
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(!H.sanity_lost)
				continue
		L.apply_damage(aoe, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
		L.visible_message("<span class='danger'>[user] slices [L]!</span>")

/obj/item/ego_weapon/wings/proc/Leap(mob/living/user, dir = SOUTH, times_ran = 3)
	user.forceMove(get_step(get_turf(user), dir))
	var/end_leap = FALSE
	if(times_ran > 2)
		end_leap = TRUE
	if(CheckPath(user, dir)) // If we have something ahead of us, yes, but we're ALSO going to attack around us
		to_chat(user,"<span class='notice'>You cut your leap short!</span>")
		for(var/turf/T in orange(1, user)) // I hate having to use this code twice but it's TWO LINES and I don't need to use callbacks with it so it's not getting a proc
			hit_turfs |= T
		end_leap = TRUE
	if(end_leap)
		for(var/turf/T in hit_turfs) // Once again mostly jacked from harvest, but modified to work with hit_turfs instead of an on-the-spot orange
			new /obj/effect/temp_visual/smash_effect(T)
			for(var/mob/living/L in T.contents)
				var/aoe = special_force * 1 + (special_combo_mult * special_combo)
				var/userjust = (get_attribute_level(user, JUSTICE_ATTRIBUTE))
				var/justicemod = 1 + userjust/100
				aoe*=justicemod
				if(L == user)
					continue
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					if(!H.sanity_lost)
						continue
				L.apply_damage(aoe, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
				L.visible_message("<span class='danger'>[user] evicerates [L]!</span>")
		return
	for(var/turf/T in orange(1, user))
		hit_turfs |= T
	addtimer(CALLBACK(src, .proc/Leap, user, dir, times_ran + 1), 0.1)

/obj/item/ego_weapon/wings/proc/CheckPath(mob/living/user, dir = SOUTH)
	var/list/immediate_path = list() // Looks two tiles ahead for anything dense; the leap attack must move you at least one tile and will stop one tile short of a dense one
	immediate_path |= get_step(get_turf(user), dir)
	immediate_path |= get_step(immediate_path[1], dir)
	var/fail_charge = FALSE
	for(var/turf/T in immediate_path)
		if(T.density)
			fail_charge = TRUE
		for(var/obj/machinery/door/D in T.contents)
			if(D.density)
				fail_charge = TRUE
		for(var/obj/structure/window/W in T.contents)
			fail_charge = TRUE
	return fail_charge

/obj/item/ego_weapon/wings/proc/SecondSwing(mob/living/M, mob/living/user)
	sleep(CLICK_CD_MELEE*attack_speed*0.5+1)
	if(get_dist(M, user) > 1)
		return
	if(force && HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, "<span class='warning'>You don't want to harm other living beings!</span>")
		return
	if(max_count > hit_count)
		hit_count++
	else if(prob(10))
		to_chat(user, "<span class='notice'>[src]' feathers bristle!</span>") // "Hey dumbass, you can stop smacking them now"
	combo_hold = world.time + decay_time
	playsound(loc, hitsound, get_clamped_volume(), TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
	user.do_attack_animation(M)
	M.attacked_by(src, user)

	log_combat(user, M, "attacked", src.name, "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")

/obj/item/ego_weapon/wings/proc/ResetSpecial()
	specialing = FALSE

/obj/item/ego_weapon/mini/mirth
	name = "mirth"
	desc = "A round of applause, for the clowns who joined us for tonight’s show!"
	special = "This weapon can be paired with its sister blade."
	icon_state = "mirth"
	force = 15
	attack_speed = 0.5
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("cuts", "attacks", "slashes")
	attack_verb_simple = list("cut", "attack", "slash")
	hitsound = 'sound/weapons/ego/sword1.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60
							)

	var/combo_on = TRUE
	var/sound = FALSE
	var/dash_cooldown
	var/dash_cooldown_time = 4 SECONDS
	var/dash_range = 6

//Switch between weapons every hit, or don't
/obj/item/ego_weapon/mini/mirth/attack_self(mob/user)
	..()
	if(combo_on)
		to_chat(user,"<span class='warning'>You swap your grip, and will no longer fight with two weapons.</span>")
		combo_on = FALSE
		return
	if(!combo_on)
		to_chat(user,"<span class='warning'>You swap your grip, and will now fight with two weapons.</span>")
		combo_on =TRUE
		return

/obj/item/ego_weapon/mini/mirth/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	var/combo = FALSE
	force = 15
	hitsound = 'sound/weapons/ego/sword1.ogg'
	var/mob/living/carbon/human/myman = user
	var/obj/item/ego_weapon/mini/malice/Y = myman.get_inactive_held_item()
	if(istype(Y) && combo_on) //dual wielding? if so...
		combo = TRUE //hits twice, you're spending as much PE as you would getting an ALEPH anyways
		if(sound)
			hitsound = 'sound/weapons/ego/sword2.ogg'
			sound = FALSE
		else
			sound = TRUE
	..()
	if(combo)
		for(var/damage_type in list(RED_DAMAGE))
			damtype = damage_type
			armortype = damage_type
			M.attacked_by(src, user)
		damtype = initial(damtype)
		armortype = initial(armortype)

/obj/item/ego_weapon/mini/mirth/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user))
		return
	if(!isliving(A))
		return
	if(dash_cooldown > world.time)
		to_chat(user, "<span class='warning'>Your dash is still recharging!")
		return
	if((get_dist(user, A) < 2) || (!(can_see(user, A, dash_range))))
		return
	..()
	dash_cooldown = world.time + dash_cooldown_time
	for(var/i in 2 to get_dist(user, A))
		step_towards(user,A)
	if((get_dist(user, A) < 2))
		A.attackby(src,user)
	playsound(src, 'sound/weapons/fwoosh.ogg', 300, FALSE, 9)
	to_chat(user, "<span class='warning'>You dash to [A]!")

/obj/item/ego_weapon/mini/malice
	name = "malice"
	desc = "Seeing that I wasn't amused, it took out another tool. \
	I thought it was a tool. Just that moment."
	special = "This weapon can be paired with its sister blade."
	icon_state = "malice"
	force = 15
	attack_speed = 0.5
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("cuts", "attacks", "slashes")
	attack_verb_simple = list("cut", "attack", "slash")
	hitsound = 'sound/weapons/ego/sword2.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60
							)

	var/combo_on = TRUE
	var/sound = FALSE
	var/dash_cooldown
	var/dash_cooldown_time = 4 SECONDS
	var/dash_range = 6

/obj/item/ego_weapon/mini/malice/attack_self(mob/user)
	..()
	if(combo_on)
		to_chat(user,"<span class='warning'>You swap your grip, and will no longer fight with two weapons.</span>")
		combo_on = FALSE
		return
	if(!combo_on)
		to_chat(user,"<span class='warning'>You swap your grip, and will now fight with two weapons.</span>")
		combo_on =TRUE
		return

/obj/item/ego_weapon/mini/malice/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	var/combo = FALSE
	force = 15
	hitsound = 'sound/weapons/ego/sword2.ogg'
	var/mob/living/carbon/human/myman = user
	var/obj/item/ego_weapon/mini/mirth/Y = myman.get_inactive_held_item()
	if(istype(Y) && combo_on)
		combo = TRUE //hits twice, you're spending as much PE as you would getting an ALEPH anyways
		if(sound)
			hitsound = 'sound/weapons/ego/sword1.ogg'
			sound = FALSE
		else
			sound = TRUE
	..()
	if(combo)
		for(var/damage_type in list(WHITE_DAMAGE))
			damtype = damage_type
			armortype = damage_type
			M.attacked_by(src, user)
		damtype = initial(damtype)
		armortype = initial(armortype)

/obj/item/ego_weapon/mini/malice/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user))
		return
	if(!isliving(A))
		return
	if(dash_cooldown > world.time)
		to_chat(user, "<span class='warning'>Your dash is still recharging!")
		return
	if((get_dist(user, A) < 2) || (!(can_see(user, A, dash_range))))
		return
	..()
	dash_cooldown = world.time + dash_cooldown_time
	for(var/i in 2 to get_dist(user, A))
		step_towards(user,A)
	if((get_dist(user, A) < 2))
		A.attackby(src,user)
	playsound(src, 'sound/weapons/fwoosh.ogg', 300, FALSE, 9)
	to_chat(user, "<span class='warning'>You dash to [A]!")

/obj/item/ego_weapon/shield/swan
	name = "swan"
	desc = "Believing that it would turn white, the black swan wanted to lift the curse by weaving together nettles.\
	All that was left is a worn parasol it once treasured."
	special = "This weapon functions as a shield when opened."
	icon_state = "swan_closed"
	force = 17
	attack_speed = 0.5
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/slashmiss.ogg'
	reductions = list(70, 50, 70, 40)
	projectile_block_cooldown = 1 SECONDS
	block_duration = 3 SECONDS
	block_cooldown = 3 SECONDS
	block_sound = 'sound/weapons/ego/clash1.ogg'
	projectile_block_message = "You swat the projectile out of the air!"
	block_cooldown_message = "You rearm your E.G.O."
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)
	var/close_cooldown
	var/close_cooldown_time = 3 SECONDS

/obj/item/ego_weapon/shield/swan/attack_self(mob/user)
	if(close_cooldown > world.time) //prevents shield usage with no DPS loss
		to_chat(user,"<span class='warning'>You cannot use this again so soon!</span>")
		return
	if(icon_state == "swan")
		icon_state = "swan_closed"
		to_chat(user,"<span class='nicegreen'>You close the umbrella.</span>")
		return
	if(icon_state == "swan_closed" && do_after(user, 4, src))
		icon_state = "swan"
		close_cooldown = world.time + close_cooldown_time
		..()

/obj/item/ego_weapon/shield/swan/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(icon_state == "swan")
		attack_speed = 1.5
	else
		attack_speed = 0.5
	. = ..()
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored && icon_state == "swan")
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)


/obj/item/ego_weapon/moonlight
	name = "moonlight"
	desc = "The serpentine ornament is loyal to the original owner’s taste. The snake’s open mouth represents the endless yearning for music."
	special = "Use this weapon in hand to heal the sanity of those around you."
	icon_state = "moonlight"
	force = 32					//One of the best support weapons. Does HE damage in it's stead.
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("beats", "jabs")
	attack_verb_simple = list("beat", "jab")
	var/inuse
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/moonlight/attack_self(mob/user)
	. = ..()
	if(!CanUseEgo(user))
		return

	if(inuse)
		return
	inuse = TRUE
	if(do_after(user, 30))	//3 seconds for a big heal.
		playsound(src, 'sound/magic/staff_healing.ogg', 200, FALSE, 9)
		for(var/mob/living/carbon/human/L in range(5, get_turf(user)))
			L.adjustSanityLoss(-10)
	inuse = FALSE


/obj/item/ego_weapon/heaven
	name = "heaven"
	desc = "As it spreads its wings for an old god, a heaven just for you burrows its way."
	icon_state = "heaven"
	force = 40
	reach = 2		//Has 2 Square Reach.
	throwforce = 80		//It costs like 50 PE I guess you can go nuts
	throw_speed = 5
	throw_range = 7
	attack_speed = 1.2
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)


/obj/item/ego_weapon/spore
	name = "spore"
	desc = "A spear covered in spores and affection. \
	It lights the employee's heart, shines like a star, and steadily tames them."
	special = "Upon hit the targets WHITE vulnerability is increased by 0.2."
	icon_state = "spore"
	force = 30		//Quite low as WAW coz the armor rend effect
	reach = 2		//Has 2 Square Reach.
	attack_speed = 1.2
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/spore/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	. = ..()
	if(isliving(target))
		var/mob/living/simple_animal/M = target
		if(!ishuman(M) && !M.has_status_effect(/datum/status_effect/rendWhiteArmor))
			new /obj/effect/temp_visual/cult/sparks(get_turf(M))
			M.apply_status_effect(/datum/status_effect/rendWhiteArmor)

/datum/status_effect/rendWhiteArmor
	id = "rend white armor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 50 //5 seconds since it's melee-ish
	alert_type = null
	var/original_armor

/datum/status_effect/rendWhiteArmor/on_apply()
	. = ..()
	var/mob/living/simple_animal/M = owner
	original_armor = M.damage_coeff[WHITE_DAMAGE]
	if(original_armor > 0)
		M.damage_coeff[WHITE_DAMAGE] = original_armor + 0.2

/datum/status_effect/rendWhiteArmor/on_remove()
	. = ..()
	var/mob/living/simple_animal/M = owner
	if(M.damage_coeff[WHITE_DAMAGE] == original_armor + 0.2)
		M.damage_coeff[WHITE_DAMAGE] = original_armor


/obj/item/ego_weapon/dipsia
	name = "dipsia"
	desc = "The thirst will never truly be quenched."
	special = "This weapon heals you on hit."
	icon_state = "dipsia"
	force = 32
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/pierce_slow.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/dipsia/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	if(!(target.status_flags & GODMODE) && target.stat != DEAD)
		var/heal_amt = force*0.10
		if(isanimal(target))
			var/mob/living/simple_animal/S = target
			if(S.damage_coeff[damtype] > 0)
				heal_amt *= S.damage_coeff[damtype]
			else
				heal_amt = 0
		user.adjustBruteLoss(-heal_amt)
	..()

/obj/item/ego_weapon/shield/pharaoh
	name = "pharaoh"
	desc = "Look on my Works, ye Mighty, and despair!"
	special = "This weapon can remove petrification."
	icon_state = "pharaoh"
	force = 20
	attack_speed = 0.5
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("decimates", "bisects")
	attack_verb_simple = list("decimate", "bisect")
	hitsound = 'sound/weapons/bladeslice.ogg'
	reductions = list(95, 95, 95, 40)
	projectile_block_cooldown = 0.5 SECONDS
	block_duration = 0.5 SECONDS
	block_cooldown = 3 SECONDS
	block_sound = 'sound/weapons/ego/clash1.ogg'
	projectile_block_message ="A God does not fear death!"
	block_message = "You attempt to parry the attack!"
	hit_message = "parries the attack!"
	block_cooldown_message = "You rearm your blade."
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/shield/pharaoh/pre_attack(atom/A, mob/living/user, params)
	if(istype(A,/obj/structure/statue/petrified) && CanUseEgo(user))
		playsound(A, 'sound/effects/break_stone.ogg', rand(10,50), TRUE)
		A.visible_message("<span class='danger'>[A] returns to normal!</span>", "<span class='userdanger'>You break free of the stone!</span>")
		A.Destroy()
		return
	..()

/obj/item/ego_weapon/blind_rage
	name = "Blind Rage"
	desc = "Those who suffer injustice tend to lash out at all those around them."
	icon_state = "blind_rage"
	force = 40
	attack_speed = 1.2
	special = "This weapon possesses a devastating Red AND Black damage AoE. Be careful! \nUse in hand to hold back the AoE!"
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("smashes", "crushes", "flattens")
	attack_verb_simple = list("smash", "crush", "flatten")
	hitsound = 'sound/abnormalities/wrath_servant/big_smash1.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)

	var/aoe_damage = 15
	var/aoe_damage_type = BLACK_DAMAGE
	var/aoe_range = 2
	var/attacks = 0
	var/toggled = FALSE

/obj/item/ego_weapon/blind_rage/attack_self(mob/user)
	toggled = !toggled
	if(toggled)
		to_chat(user, "<span class='warning'>You release the full power of [src].</span>")
	else
		to_chat(user, "<span class='notice'>You begin to hold back [src].</span>")

/obj/item/ego_weapon/blind_rage/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!.)
		return FALSE

	attacks++
	attacks %= 3
	switch(attacks)
		if(0)
			hitsound = 'sound/abnormalities/wrath_servant/big_smash1.ogg'
		if(1)
			hitsound = 'sound/abnormalities/wrath_servant/big_smash2.ogg'
		if(2)
			hitsound = 'sound/abnormalities/wrath_servant/big_smash3.ogg'
	if(!toggled)
		if(prob(10))
			new /obj/effect/gibspawner/generic/silent/wrath_acid(get_turf(M))
		return
	for(var/turf/open/T in range(aoe_range, M))
		var/obj/effect/temp_visual/small_smoke/halfsecond/smonk = new(T)
		smonk.color = COLOR_GREEN
		for(var/mob/living/L in T)
			if(L == user)
				continue
			if(L.stat == DEAD)
				continue
			var/damage = aoe_damage
			var/userjust = (get_attribute_level(user, JUSTICE_ATTRIBUTE))
			var/justicemod = 1 + userjust/100
			damage *= justicemod
			if(attacks == 0)
				damage *= 3
			L.apply_damage(damage, damtype, null, L.run_armor_check(null, damtype), spread_damage = TRUE)
			L.apply_damage(damage, aoe_damage_type, null, L.run_armor_check(null, aoe_damage_type), spread_damage = TRUE)
		if(prob(5))
			new /obj/effect/gibspawner/generic/silent/wrath_acid(T) // The non-damaging one

/obj/item/ego_weapon/blind_rage/get_clamped_volume()
	return 50

/obj/item/ego_weapon/mini/heart
	name = "bleeding heart"
	desc = "The supplicant will suffer various ordeals in a manner like being put through a trial."
	icon_state = "heart"
	special = "Hit yourself to heal others."
	inhand_icon_state = "bloodbath"
	force = 30
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(FORTITUDE_ATTRIBUTE = 80)

/obj/item/ego_weapon/mini/heart/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	..()
	if(M==user)
		for(var/mob/living/carbon/human/L in livinginrange(10, src))
			if(L==user)
				continue
			L.adjustBruteLoss(-15)
			new /obj/effect/temp_visual/healing(get_turf(L))

/obj/item/ego_weapon/diffraction
	name = "diffraction"
	desc = "Many employees have sustained injuries from erroneous calculation."
	special = "This weapon deals double damage to targets under 20% HP."
	icon_state = "diffraction"
	force = 40
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("slices", "cuts")
	attack_verb_simple = list("slice", "cut")
	hitsound = 'sound/weapons/blade1.ogg'
	attribute_requirements = list(FORTITUDE_ATTRIBUTE = 80)

/obj/item/ego_weapon/diffraction/attack(mob/living/target, mob/living/user)
	if((target.health<=target.maxHealth *0.2) && !(GODMODE in target.status_flags))
		force*=2
	..()
	force = initial(force)

/obj/item/ego_weapon/mini/infinity
	name = "infinity"
	desc = "A giant novelty pen."
	special = "This weapon marks enemies with a random damage type. They take that damage after 5 seconds."
	icon_state = "infinity"
	force = 45		//Does more damage for being harder to use.
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	var/mark_damage
	var/mark_type = RED_DAMAGE

//Replaces the normal attack with a mark
/obj/item/ego_weapon/mini/infinity/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(do_after(user, 4, src))

		target.visible_message("<span class='danger'>[user] markes [target]!</span>", \
						"<span class='userdanger'>[user] marks you!</span>", COMBAT_MESSAGE_RANGE, user)
		to_chat(user, "<span class='danger'>You enscribe a code on [target]!</span>")

		mark_damage = force
		//I gotta grab  justice here
		var/userjust = (get_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		mark_damage *= justicemod

		var/obj/effect/infinity/P = new get_turf(target)
		if(mark_type == RED_DAMAGE)
			P.color = COLOR_RED

		if(mark_type == BLACK_DAMAGE)
			P.color = COLOR_PURPLE

		addtimer(CALLBACK(src, .proc/cast, target, user, mark_type), 5 SECONDS)

		//So you can see what the next mark is.
		mark_type = pick(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE)
		damtype = mark_type

	else
		to_chat(user, "<span class='spider'><b>Your attack was interrupted!</b></span>")
		return

/obj/effect/infinity
	name = "mark"
	icon = 'icons/effects/cult_effects.dmi'
	icon_state = "rune3center"
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/infinity/Initialize()
	..()
	animate(src, alpha = 0, time = 1 SECONDS)
	QDEL_IN(src, 1 SECONDS)

/obj/item/ego_weapon/mini/infinity/proc/cast(mob/living/target, mob/living/user, damage_color)
	target.apply_damage(mark_damage, damage_color, null, target.run_armor_check(null, damage_color), spread_damage = TRUE)		//MASSIVE fuckoff punch
	new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(target), pick(GLOB.alldirs))
	mark_damage = force

/obj/item/ego_weapon/amrita
	name = "amrita"
	desc = "The rings attached to the cane represent the middle way and the Six Paramitas."
	special = "Use this weapon in your hand to damage every non-human within reach."
	icon_state = "amrita"
	force = 40
	reach = 2		//Has 2 Square Reach.
	throw_speed = 5
	throw_range = 7
	attack_speed = 1.3
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("slams", "attacks")
	attack_verb_simple = list("slam", "attack")
	hitsound = 'sound/abnormalities/clouded_monk/monk_attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)
	var/can_spin = TRUE
	var/spinning = FALSE

/obj/item/ego_weapon/amrita/attack(mob/living/target, mob/living/user) //knockback on hit
	if(spinning)
		return FALSE
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)
	..()
	can_spin = FALSE
	addtimer(CALLBACK(src, .proc/spin_reset), 12)

/obj/item/ego_weapon/amrita/proc/spin_reset()
	can_spin = TRUE

/obj/item/ego_weapon/amrita/attack_self(mob/user) //spin attack with knockback
	if(!CanUseEgo(user))
		return
	if(!can_spin)
		to_chat(user,"<span class='warning'>You attacked too recently.</span>")
		return
	if(do_after(user, 13, src))
		var/aoe = force
		var/userjust = (get_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		can_spin = TRUE
		addtimer(CALLBACK(src, .proc/spin_reset), 13)
		playsound(src, 'sound/abnormalities/clouded_monk/monk_bite.ogg', 75, FALSE, 4)
		aoe*=justicemod

		for(var/turf/T in orange(2, user))
			new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in range(2, user)) //knocks enemies away from you
			if(L == user || ishuman(L))
				continue
			L.apply_damage(aoe, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			var/throw_target = get_edge_target_turf(L, get_dir(L, get_step_away(L, src)))
			if(!L.anchored)
				var/whack_speed = (prob(60) ? 1 : 4)
				L.throw_at(throw_target, rand(1, 2), whack_speed, user)
