GLOBAL_LIST_INIT(unspawned_sales, list(
	/obj/structure/pe_sales/w_corp,
	/obj/structure/pe_sales/r_corp,
	/obj/structure/pe_sales/k_corp,
	/obj/structure/pe_sales/s_corp,
	/obj/structure/pe_sales/n_corp,
	/obj/structure/pe_sales/limbus,
	/obj/structure/pe_sales/zwei,
	/obj/structure/pe_sales/seven,
	/obj/structure/pe_sales/leaflet,

))

/obj/effect/landmark/salesspawn
	name = "sales machine spawner"
	desc = "This is weird. Please inform a coder that you have this. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"

/obj/effect/landmark/salesspawn/Initialize()
	..()
	if(!LAZYLEN(GLOB.unspawned_sales)) // You shouldn't ever need this but I mean go on I guess
		return
	var/obj/structure/pe_sales/spawning = pick(GLOB.unspawned_sales)
	GLOB.unspawned_sales -= spawning
	new spawning(get_turf(src))


