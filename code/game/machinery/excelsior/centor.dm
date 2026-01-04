var/global/excelsior_centor

/obj/machinery/centor
	name = "Excelsior \"Centor\" node"
	icon = 'icons/obj/machines/excelsior/central.dmi'
	desc = "Central antenna of the Excelsior group connecting far into the Heaven"
	icon_state = "centor"
	density = TRUE
	circuit = /obj/item/electronics/circuitboard/centor
	health = 300
	shipside_only = TRUE
	var/list/obj/machinery/node/antennas_to_heaven = list()

/obj/machinery/centor/Initialize(mapload, d)
	if(excelsior_centor)
		Destroy()
		return
	excelsior_centor = src
	. = ..()
	load_network()

/obj/machinery/centor/Destroy()
	. = ..()
	for(var/obj/machinery/node/node in excelsior_nodes)
		if(dist3D(src, node) <= EX_NODE_DISTANCE)
			node.spread_signal(null)
	excelsior_centor = null

/obj/machinery/centor/attack_hand(mob/user)
	. = ..()
	load_network()

/obj/machinery/centor/proc/load_network()
	antennas_to_heaven = list()
	for(var/obj/machinery/node/node in excelsior_nodes)
		node.core = null
		node.update_icon()
	for(var/obj/machinery/node/node in excelsior_nodes)
		if(dist3D(src, node) <= EX_NODE_DISTANCE)
			node.spread_signal(src)
