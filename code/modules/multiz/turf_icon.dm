/turf/open
	is_transparent = TRUE

/turf/space
	is_transparent = TRUE

/turf/open/update_icon(var/update_neighbors, var/roundstart_update = FALSE)
	if (SSticker.current_state != GAME_STATE_PLAYING)
		return

	if (roundstart_update)
		if (_initialized_transparency)
			return
		var/turf/testBelow = SSmapping.GetBelow(src)
		if (testBelow && testBelow.is_transparent && !testBelow._initialized_transparency)
			return //turf below will update this one

	var/turf/below = SSmapping.GetBelow(src)
	if (!below || istype(below, /turf/space))
		ChangeTurf(/turf/space)
		return

	vis_contents.Cut()
	if (below)
		vis_contents.Add(below)

	updateFallability()

	_initialized_transparency = TRUE
	update_openspace() //propagate update upwards

/turf/space/update_icon(var/update_neighbors, var/roundstart_update = FALSE)
	if (SSticker.current_state < GAME_STATE_PLAYING)
		return

	if (roundstart_update)
		if (_initialized_transparency)
			return
		var/turf/testBelow = SSmapping.GetBelow(src)
		if (testBelow && testBelow.is_transparent && !testBelow._initialized_transparency)
			return //turf below will update this one

	overlays.Cut()
	var/turf/below = SSmapping.GetBelow(src)
	if (istype(below, /turf/open))
		ChangeTurf(/turf/open)
		return

	vis_contents.Cut()
	if (below)
		vis_contents.Add(below)

	_initialized_transparency = TRUE
	update_openspace()

/hook/roundstart/proc/init_openspace()
	for (var/turf/T in turfs)
		if (T.is_transparent)
			T.update_icon(null, TRUE)
	return TRUE

/atom/proc/update_openspace()
	var/turf/T = SSmapping.GetAbove(src)
	if (T && T.is_transparent)
		T.update_icon()
