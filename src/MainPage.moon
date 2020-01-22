class MainPage extends Page
	new: =>
		@keybinds =
			[options.keybind_crop]: self\crop
			[options.keybind_seta]: self\setStartTime
			[options.keybind_setb]: self\setEndTime
			[options.keybind_options]: self\changeOptions
			[options.keybind_preview]: self\preview
			[options.keybind_encode]: self\encode
			[options.keybind_cancel]: self\hide
		@startTime = -1
		@endTime = -1
		@region = Region!

	setStartTime: =>
		@startTime = mp.get_property_number("time-pos")
		if @visible
			self\clear!
			self\draw!

	setEndTime: =>
		@endTime = mp.get_property_number("time-pos")
		if @visible
			self\clear!
			self\draw!
			if options.setb
				self\encode!

	
	setupStartAndEndTimes: =>
		if mp.get_property_native("duration")
			-- Note: there exists an option called rebase-start-time, which, when set to no,
			-- could cause the beginning of the video to not be at 0. Not sure how this
			-- would affect this code.
			@startTime = 0
			@endTime = mp.get_property_native("duration")
		else
			@startTime = -1
			@endTime = -1
		
		if @visible
			self\clear!
			self\draw!

	prepare: =>
		if options.seta
			self\setStartTime!

	draw: =>
		window_w, window_h = mp.get_osd_size()
		ass = assdraw.ass_new()
		ass\new_event()
		self\setup_text(ass)
		ass\append("#{bold('WebM maker')}\\N\\N")
		ass\append("#{bold( "#{options.display_crop}" .. ':')} crop\\N")
		ass\append("#{bold( "#{options.display_seta}" .. ':' )} set start time (current is #{seconds_to_time_string(@startTime)})\\N")
		ass\append("#{bold( "#{options.display_setb}" .. ':' )} set end time (current is #{seconds_to_time_string(@endTime)})\\N")
		ass\append("#{bold( "#{options.display_options}" .. ':')} change encode options\\N")
		ass\append("#{bold( "#{options.display_preview}" .. ':')} preview\\N")
		ass\append("#{bold( "#{options.display_encode}" .. ':')} encode\\N\\N")
		ass\append("#{bold( "#{options.display_cancel}" .. ':')} close\\N")
		mp.set_osd_ass(window_w, window_h, ass.text)

	onUpdateCropRegion: (updated, newRegion) =>
		if updated
			@region = newRegion
		self\show!

	crop: =>
		self\hide!
		cropPage = CropPage(self\onUpdateCropRegion, @region)
		cropPage\show!

	onOptionsChanged: (updated) =>
		self\show!

	changeOptions: =>
		self\hide!
		encodeOptsPage = EncodeOptionsPage(self\onOptionsChanged)
		encodeOptsPage\show!

	onPreviewEnded: =>
		self\show!

	preview: =>
		self\hide!
		previewPage = PreviewPage(self\onPreviewEnded, @region, @startTime, @endTime)
		previewPage\show!

	encode: =>
		self\hide!
		if @startTime < 0
			message("No start time, aborting")
			return
		if @endTime < 0
			message("No end time, aborting")
			return
		if @startTime >= @endTime
			message("Start time is ahead of end time, aborting")
			return
		encode(@region, @startTime, @endTime)
