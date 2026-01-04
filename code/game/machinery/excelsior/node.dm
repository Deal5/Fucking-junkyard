var/list/global/excelsior_nodes = list()

/obj/machinery/node
	name = "Excelsior \"Tochka\" node"
	icon = 'icons/obj/machines/excelsior/redirector.dmi'
	desc = "A retranslator node that amplifies signal from the teleporter"
	icon_state = "redirector_finished"
	density = TRUE
	circuit = /obj/item/electronics/circuitboard/excelsior_node
	health = 300
	shipside_only = TRUE
	var/list/obj/machinery/linked = list()
	var/list/obj/machinery/node/neighbours = list()
	var/obj/machinery/centor/core

/obj/machinery/node/Initialize(mapload, d)
	. = ..()
	excelsior_nodes.Add(src)
	search_for_machines()
	search_for_nodes()
	if(excelsior_centor)
		var/obj/machinery/centor/C = excelsior_centor
		C.load_network()
	update_icon()

/obj/machinery/node/Destroy()
	. = ..()
	excelsior_nodes.Remove(src)
	for(var/obj/machinery/machine in linked)
		SEND_SIGNAL(machine, COMSIG_EX_CONNECT)
	for(var/obj/machinery/node/N in neighbours)
		N.disconnect(src, TRUE)
	if(core)
		core.load_network()

/obj/machinery/node/update_icon()
	. = ..()
	if(!core)
		icon_state = "redirector_bent"
	else
		icon_state = "redirector_finished"

/obj/machinery/node/attack_hand(mob/user)
	. = ..()
	to_chat(user, "Linked machinery:")
	for(var/obj/machinery/machine in linked)
		to_chat(user, machine.name)
	to_chat(user, "Linked nodes:")
	for(var/obj/machinery/machine in neighbours)
		to_chat(user, "[machine.name] [dist3D(src, machine)]m away")

/obj/machinery/node/proc/search_for_machines()
	for(var/obj/machinery/machine in orange(EX_NODE_DISTANCE))
		SEND_SIGNAL(machine, COMSIG_EX_CONNECT)

/obj/machinery/node/proc/search_for_nodes()
	for(var/obj/machinery/node/N in excelsior_nodes)
		if(dist3D(src, N) <= EX_NODE_DISTANCE && N != src)
			connect(N, TRUE)
			N.connect(src, TRUE)
			if(N.core)
				src.spread_signal(N.core)

/obj/machinery/node/proc/connect(var/obj/machinery/M, var/is_node = FALSE)
	if(is_node)
		if(!neighbours.Find(M))
			neighbours.Add(M)
	else
		if(!linked.Find(M))
			linked.Add(M)

/obj/machinery/node/proc/disconnect(var/obj/machinery/M, var/is_node = FALSE)
	if(is_node)
		if(neighbours.Find(M))
			neighbours.Remove(M)
	else
		if(linked.Find(M))
			linked.Remove(M)

/obj/machinery/node/proc/spread_signal(var/center)
	if(core)
		return
	core = center
	core.antennas_to_heaven.Add(src)
	update_icon()
	for(var/obj/machinery/node/N in neighbours)
		N.spread_signal(center)

