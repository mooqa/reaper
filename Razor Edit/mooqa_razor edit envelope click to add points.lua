function print(msg) reaper.ShowConsoleMsg(tostring(msg) .. '\n') end


samplerate = 44100


-- local function Convert_Env_ValueInValueAndInPercent_SWS(envelope,valPoint,PerVal)
--   local _,_,_,_,_,_,min,max,_,_,faderS = reaper.BR_EnvGetProperties(reaper.BR_EnvAlloc(envelope,true))
--   reaper.BR_EnvFree(reaper.BR_EnvAlloc(envelope,true),true)
--   local interval = (max - min)
--   if PerVal == 0 then return (valPoint-min)/interval*100
--   elseif PerVal == 1 then return (valPoint/100)*interval + min
--   end
-- end



local track_cnt = reaper.CountTracks(0)
if track_cnt == 0 then return reaper.defer(function() end) end

function set_points()

  local envs, env_cnt = {}, 0

  for tr = 0, track_cnt - 1 do
    local track = reaper.GetTrack(0, tr)
    local _, area = reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
    if area ~= "" then
      local arStart, arEnv
      for str in area:gmatch("(%S+)") do
        if not arStart then arStart = str
        elseif not arEnv then arEnv = str
        else
          if str ~= '""' then
            env_cnt = env_cnt + 1
            envs[env_cnt] = { reaper.GetTrackEnvelopeByChunkName( track, str:sub(2,-1) ),
                          tonumber(arStart), tonumber(arEnv) }
          end
          arStart, arEnv = nil, nil
        end
      end
    end
  end

  if env_cnt == 0 then return reaper.defer(function() end) end

  reaper.Undo_BeginBlock()
  reaper.PreventUIRefresh( 1 )

  mouse = reaper.BR_PositionAtMouseCursor( 1 )


  for e = 1, env_cnt do
      local envelope   = envs[e][1]
      local env_start  = envs[e][2]
      local env_end    = envs[e][3]

      -- local ValueInValue = Convert_Env_ValueInValueAndInPercent_SWS(envelope,value,0);

      local _, start_value = reaper.Envelope_Evaluate( envelope, env_start, samplerate, 0 )
      local _, end_value = reaper.Envelope_Evaluate( envelope, env_end, samplerate, 0 )

      reaper.InsertEnvelopePoint( envelope, env_start, start_value, 0, 1, 0, true )
      reaper.InsertEnvelopePoint( envelope, env_start - 0.1, start_value, 0, 1, 0, true )

      -- scaling = reaper.GetEnvelopeScalingMode(envelope)
      -- value = reaper.ScaleToEnvelopeMode(scaling,value_in_value)

      -- reaper.InsertEnvelopePoint( envelope, mouse, value, 0, 1, 0, true )


      reaper.InsertEnvelopePoint( envelope, env_end, end_value, 0, 1, 0, true )
      reaper.InsertEnvelopePoint( envelope, env_end + 0.1, end_value, 0, 1, 0, true )

      reaper.Envelope_SortPoints( envelope )


  end
end

local window, segment, details = reaper.BR_GetMouseCursorContext()
if segment == 'envelope' then 
  set_points()
else
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SMARTSPLIT2'),0)
end

reaper.Main_OnCommand (42406,0)

reaper.PreventUIRefresh( -1 )
reaper.UpdateArrange()

reaper.Undo_EndBlock( "Add points", 1 )