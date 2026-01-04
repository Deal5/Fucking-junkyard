

/obj/machinery/emplacement
	name = "Excelsior emplacement"
	icon = 'icons/obj/machines/excelsior/emplacement.dmi'
	desc = "An emplacement tile"
	icon_state = "pol"
	density = FALSE
	health = 300
	shipside_only = TRUE
	var/obj/machinery/node/my_node

/obj/machinery/emplacement/Initialize(mapload, d)
	. = ..()
	RegisterSignal(src, COMSIG_EX_CONNECT, PROC_REF(search_for_node))
	search_for_node()

/obj/machinery/emplacement/Destroy()
	. = ..()
	UnregisterSignal(src, COMSIG_EX_CONNECT)
	if(my_node)
		my_node.disconnect(src)

/obj/machinery/emplacement/update_icon()
	..()
	if(my_node)
		icon_state = "[initial(icon_state)]_on"
	else
		icon_state = initial(icon_state)

/obj/machinery/emplacement/proc/search_for_node()
	var/obj/machinery/node/closest
	var/closest_dist = EX_NODE_DISTANCE + 1
	for (var/obj/machinery/node/node in excelsior_nodes)
		if(get_dist(src, node) < closest_dist)
			closest = node
			closest_dist = dist3D(src, closest)
	if(closest)
		closest.connect(src)
		my_node = closest
		update_icon()
		return TRUE
	else
		my_node = null
		update_icon()
		return FALSE
