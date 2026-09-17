local extract = {}

-- Packages info for all project tracks into json like data


local function dump(o) -- formats to string
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. ''..k..' : ' .. dump(v) .. ', '
    end
    return s .. '}\n'
  else
    return tostring(o)
  end
end


local function pack_track_info(track) -- packs track info into one table per track
  local pack = {}
  local _, name = reaper.GetTrackName(track)

  -- probably will not need all of these
  
  pack["b_mute"] = reaper.GetMediaTrackInfo_Value(track, "B_MUTE") --  muted
  
  pack["b_phase"] = reaper.GetMediaTrackInfo_Value(track, "B_PHASE") --  track phase inverted
  
  pack["b_recmon_in_effect"] = reaper.GetMediaTrackInfo_Value(track, "B_RECMON_IN_EFFECT") --  record monitoring in effect (current audio-thread playback state, read-only)
  
  pack["ip_tracknumber"] = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER") --  track number 1-based, 0=not found, -1=master track (read-only,returns the int directly)
  
  pack["i_solo"] = reaper.GetMediaTrackInfo_Value(track, "I_SOLO") --  soloed, 0=not soloed, 1=soloed, 2=soloed in place, 5=safe soloed, 6=safe soloed in place
  
  pack["b_solo_defeat"] = reaper.GetMediaTrackInfo_Value(track, "B_SOLO_DEFEAT") --  when set, if anything else is soloed and this track is not muted, this track acts soloed
  
  pack["i_fxen"] = reaper.GetMediaTrackInfo_Value(track, "I_FXEN") --  fx enabled, 0=bypassed, !0=fx active
  
  pack["i_recarm"] = reaper.GetMediaTrackInfo_Value(track, "I_RECARM") --  record armed, 0=not record armed, 1=record armed
  
  pack["i_recinput"] = reaper.GetMediaTrackInfo_Value(track, "I_RECINPUT") --  record input, <0=no input. if 4096 set, input is MIDI and low 5 bits represent channel (0=all, 1-16=only chan), next 6 bits represent physical input (63=all, 62=VKB). If 4096 is not set, low 10 bits (0..1023) are inputstart channel (ReaRoute/Loopback start at 512). If 2048 is set, input is multichannel input (using track channel count), or if 1024 is set, input is stereo input, otherwise input is mono.
  
  pack["i_recmode"] = reaper.GetMediaTrackInfo_Value(track, "I_RECMODE") --  record mode, 0=input, 1=stereo out, 2=none, 3=stereo out w/latency compensation, 4=midi output, 5=mono out, 6=mono out w/ latency compensation, 7=midi overdub, 8=midi replace
  
  pack["i_recmode_flags"] = reaper.GetMediaTrackInfo_Value(track, "I_RECMODE_FLAGS") --  record mode flags, &3=output recording mode (0=post fader, 1=pre-fx, 2=post-fx/pre-fader)
  
  pack["i_recmon"] = reaper.GetMediaTrackInfo_Value(track, "I_RECMON") --  record monitoring, 0=off, 1=normal, 2=not when playing (tape style)
  
  pack["i_recmonitems"] = reaper.GetMediaTrackInfo_Value(track, "I_RECMONITEMS") --  monitor items while recording, 0=off, 1=on
  
  pack["b_auto_recarm"] = reaper.GetMediaTrackInfo_Value(track, "B_AUTO_RECARM") --  automatically set record arm when selected (does not immediatelyaffect recarm state, script should set directly if desired)
  
  pack["i_vumode"] = reaper.GetMediaTrackInfo_Value(track, "I_VUMODE") --  track vu mode, &1
  
  pack["i_automode"] = reaper.GetMediaTrackInfo_Value(track, "I_AUTOMODE") --  track automation mode, 0=trim/off, 1=read, 2=touch, 3=write, 4=latch
  
  pack["i_nchan"] = reaper.GetMediaTrackInfo_Value(track, "I_NCHAN") --  number of track channels, 2-128, even numbers only
  
  pack["i_selected"] = reaper.GetMediaTrackInfo_Value(track, "I_SELECTED") --  track selected, 0=unselected, 1=selected
  
  pack["i_wndh"] = reaper.GetMediaTrackInfo_Value(track, "I_WNDH") --  current TCP height in pixels including envelopes (read-only)
  
  pack["i_tcph"] = reaper.GetMediaTrackInfo_Value(track, "I_TCPH") --  current TCP height in pixels not including envelopes (read-only)
  
  pack["i_tcpy"] = reaper.GetMediaTrackInfo_Value(track, "I_TCPY") --  current TCP Y-position in pixels relative to top of arrange view (read-only)
  
  pack["i_tcpscreeny"] = reaper.GetMediaTrackInfo_Value(track, "I_TCPSCREENY") --  current TCP Y-position in pixels relative to screen (read-only)
  
  pack["i_mcpw"] = reaper.GetMediaTrackInfo_Value(track, "I_MCPW") --  current MCP width in pixels (read-only)
  
  pack["i_mcph"] = reaper.GetMediaTrackInfo_Value(track, "I_MCPH") --  current MCP height in pixels (read-only)
  
  pack["i_mcpx"] = reaper.GetMediaTrackInfo_Value(track, "I_MCPX") --  current MCP X-position in pixels relative to mixer container (read-only)
  
  pack["i_mcpy"] = reaper.GetMediaTrackInfo_Value(track, "I_MCPY") --  current MCP Y-position in pixels relative to mixer container (read-only)
  
  pack["i_mcpscreenx"] = reaper.GetMediaTrackInfo_Value(track, "I_MCPSCREENX") --  current MCP X-position in pixels relative to screen (read-only)
  
  pack["i_folderdepth"] = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH") --  folder depth change, 0=normal, 1=track is a folder parent, -1=track is the last in the innermost folder, -2=track is the last in the innermost and next-innermost folders, etc
  
  pack["i_foldercompact"] = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERCOMPACT") --  folder collapsed state (only valid on folders), 0=normal, 1=collapsed, 2=fully collapsed
  
  pack["i_midihwout"] = reaper.GetMediaTrackInfo_Value(track, "I_MIDIHWOUT") --  track midi hardware output index, <0=disabled, low 5 bits are which channels (0=all, 1-16), next 5 bits are output device index (0-31)
  
  pack["i_midihwout_slot"] = reaper.GetMediaTrackInfo_Value(track, "I_MIDIHWOUT_SLOT") --  hint for slot index for MIDI HW output send, if enabled
  
  pack["i_midi_input_chanmap"] = reaper.GetMediaTrackInfo_Value(track, "I_MIDI_INPUT_CHANMAP") --  -1 maps to source channel, otherwise 1-16 to map to MIDI channel
  
  pack["i_midi_ctl_chan"] = reaper.GetMediaTrackInfo_Value(track, "I_MIDI_CTL_CHAN") --  -1 no link, 0-15 link to MIDI volume/pan on channel, 16 linkto MIDI volume/pan on all channels
  
  pack["i_midi_tracksel_flag"] = reaper.GetMediaTrackInfo_Value(track, "I_MIDI_TRACKSEL_FLAG") --  MIDI editor track list options
  
  pack["i_perfflags"] = reaper.GetMediaTrackInfo_Value(track, "I_PERFFLAGS") --  track performance flags, &1=no media buffering, &2=no anticipative FX
  
  pack["i_customcolor"] = reaper.GetMediaTrackInfo_Value(track, "I_CUSTOMCOLOR") --  custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color
  
  pack["i_heightoverride"] = reaper.GetMediaTrackInfo_Value(track, "I_HEIGHTOVERRIDE") --  custom height override for TCP window, 0 for none, otherwise size in pixels
  
  pack["i_spacer"] = reaper.GetMediaTrackInfo_Value(track, "I_SPACER") --  1=TCP track spacer above this trackB_HEIGHTLOCK 
  
  pack["d_vol"] = reaper.GetMediaTrackInfo_Value(track, "D_VOL") --  trim volume of track, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc
  
  pack["d_pan"] = reaper.GetMediaTrackInfo_Value(track, "D_PAN") --  trim pan of track, -1..1
  
  pack["d_width"] = reaper.GetMediaTrackInfo_Value(track, "D_WIDTH") --  width of track, -1..1
  
  pack["d_dualpanl"] = reaper.GetMediaTrackInfo_Value(track, "D_DUALPANL") --  dualpan position 1, -1..1, only if I_PANMODE==6
  
  pack["d_dualpanr"] = reaper.GetMediaTrackInfo_Value(track, "D_DUALPANR") --  dualpan position 2, -1..1, only if I_PANMODE==6
  
  pack["i_panmode"] = reaper.GetMediaTrackInfo_Value(track, "I_PANMODE") --  pan mode, 0=classic 3.x, 3=new balance, 5=stereo pan, 6=dual pan
  
  pack["d_panlaw"] = reaper.GetMediaTrackInfo_Value(track, "D_PANLAW") --  pan law of track, <0=project default, 0.5=-6dB, 0.707..=-3dB, 1=+0dB, 1.414..=-3dB with gain compensation, 2=-6dB with gain compensation, etc
  
  pack["i_panlaw_flags"] = reaper.GetMediaTrackInfo_Value(track, "I_PANLAW_FLAGS") --  pan law flags, 0=sine taper, 1=hybrid taper with deprecated behavior when gain compensation enabled, 2=linear taper, 3=hybrid taper
  
  pack["p_env:<envchunkname"] = reaper.GetMediaTrackInfo_Value(track, "P_ENV:<envchunkname") -- {GUID... 
  
  pack["b_showinmixer"] = reaper.GetMediaTrackInfo_Value(track, "B_SHOWINMIXER") --  track control panel visible in mixer (do not use on master track)
  
  pack["b_showintcp"] = reaper.GetMediaTrackInfo_Value(track, "B_SHOWINTCP") --  track control panel visible in arrange view (do not use on master track)
  
  pack["b_tcppin"] = reaper.GetMediaTrackInfo_Value(track, "B_TCPPIN") --  track is pinned to top of arrange view
  
  pack["b_mainsend"] = reaper.GetMediaTrackInfo_Value(track, "B_MAINSEND") --  track sends audio to parent
  
  pack["c_mainsend_offs"] = reaper.GetMediaTrackInfo_Value(track, "C_MAINSEND_OFFS") --  channel offset of track send to parent
  
  pack["c_mainsend_nch"] = reaper.GetMediaTrackInfo_Value(track, "C_MAINSEND_NCH") --  channel count of track send to parent (0=use all child track channels, 1=use one channel only)
  
  pack["i_freezecount"] = reaper.GetMediaTrackInfo_Value(track, "I_FREEZECOUNT") --  (read-only) freeze state count
  
  pack["i_freemode"] = reaper.GetMediaTrackInfo_Value(track, "I_FREEMODE") --  1=track free item positioning enabled, 2=track fixed lanes enabled (call UpdateTimeline() after changing)
  
  pack["i_numfixedlanes"] = reaper.GetMediaTrackInfo_Value(track, "I_NUMFIXEDLANES") --  number of track fixed lanes (fine to call with setNewValue, but returned value is read-only)
  
  pack["c_lanescollapsed"] = reaper.GetMediaTrackInfo_Value(track, "C_LANESCOLLAPSED") --  fixed lane collapse state (1=lanes collapsed, 2=track displays as non-fixed-lanes but hidden lanes exist)
  
  pack["c_lanesettings"] = reaper.GetMediaTrackInfo_Value(track, "C_LANESETTINGS") --  fixed lane settings (&1=auto-remove empty lanes at bottom, &2=do not auto-comp new recording, &4=newly recorded lanes play exclusively (else add lanes in layers), &8=big lanes (else small lanes), &16=add new recording at bottom (else record into first available lane), &32=hide lane buttons
  
  pack["c_laneplays:n"] = reaper.GetMediaTrackInfo_Value(track, "C_LANEPLAYS:N") --  char * 
  
  pack["c_alllanesplay"] = reaper.GetMediaTrackInfo_Value(track, "C_ALLLANESPLAY") --  on fixed lane tracks, 0=no lanes play, 1=all lanes play, 2=some lanes play (fine to call with setNewValue 0 or 1, but returned value is read-only)
  
  pack["c_beatattachmode"] = reaper.GetMediaTrackInfo_Value(track, "C_BEATATTACHMODE") --  track timebase, -1=project default, 0=time, 1=beats (position, length, rate), 2=beats (position only)
  
  pack["f_mcp_fxsend_scale"] = reaper.GetMediaTrackInfo_Value(track, "F_MCP_FXSEND_SCALE") --  scale of fx+send area in MCP (0=minimum allowed, 1=maximum allowed)
  
  pack["f_mcp_fxparm_scale"] = reaper.GetMediaTrackInfo_Value(track, "F_MCP_FXPARM_SCALE") --  scale of fx parameter area in MCP (0=minimum allowed, 1=maximum allowed)
  
  pack["f_mcp_sendrgn_scale"] = reaper.GetMediaTrackInfo_Value(track, "F_MCP_SENDRGN_SCALE") --  scale of send area as proportion of the fx+send total area (0=minimum allowed, 1=maximum allowed)
  
  pack["f_tcp_fxparm_scale"] = reaper.GetMediaTrackInfo_Value(track, "F_TCP_FXPARM_SCALE") --  scale of TCP parameter area when TCP FX are embedded (0=min allowed, default, 1=max allowed)
  
  pack["i_play_offset_flag"] = reaper.GetMediaTrackInfo_Value(track, "I_PLAY_OFFSET_FLAG") --  track media playback offset state, &1=bypassed, &2=offset value is measured in samples (otherwise measured in seconds)
  
  pack["d_play_offset"] = reaper.GetMediaTrackInfo_Value(track, "D_PLAY_OFFSET") --  track media playback offset, units depend on I_PLAY_OFFSET_FLAG
  
  pack["p_partrack"] = reaper.GetMediaTrackInfo_Value(track, "P_PARTRACK") --  parent track (read-only)
  
  pack["p_project"] = reaper.GetMediaTrackInfo_Value(track, "P_PROJECT") --  parent project (read-only)
  
  return name, pack
end


function extract.all_track_values()
  
-- local project_path = reaper.GetProjectPath()
--  reaper.ShowConsoleMsg(project_path)
  local track_count = reaper.CountTracks(0)
  local data = {}
  for i = 0, track_count - 1 do
    local track = reaper.GetTrack(0, i)
    local name, track_info = pack_track_info(track)
    -- data = data .. name .. ': ' .. dump(track_info) .. '\n'
    data[name] = track_info
  end

  return data
    
end


return extract

