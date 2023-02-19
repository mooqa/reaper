function print(msg) reaper.ShowConsoleMsg(tostring(msg) .. '\n') end


local track_cnt = reaper.CountTracks(0)
if track_cnt == 0 then return reaper.defer(function() end) end

function main()
    local envs, env_cnt = {}, 0

    for tr = 0, track_cnt - 1 do
    local track = reaper.GetTrack(0, tr)
    local _, area = reaper.GetSetMediaTrackInfo_String(track, "P_RAZOREDITS", "", false)
        if area ~= "" then
            local arSt, arEn
            for str in area:gmatch("(%S+)") do
            if not arSt then arSt = str
            elseif not arEn then arEn = str
                else
                    if str ~= '""' then
                    env_cnt = env_cnt + 1
                    envs[env_cnt] = { reaper.GetTrackEnvelopeByChunkName( track, str:sub(2,-1) ),
                                    tonumber(arSt), tonumber(arEn) }
                    end
                    arSt, arEn = nil, nil
                end
            end
        end
    end

    if env_cnt == 0 then return reaper.defer(function() end) end

    for e = 1, env_cnt do
        reaper.DeleteEnvelopePointRange( envs[e][1] , envs[e][2] , envs[e][3]  )
    end

end
reaper.Undo_BeginBlock()
reaper.PreventUIRefresh( 1 )

local window, segment, details = reaper.BR_GetMouseCursorContext()
if segment == 'envelope' then 
  main()
  reaper.Main_OnCommand(42406,0)
else
  reaper.Main_OnCommand(40312,0)
end

reaper.PreventUIRefresh( -1 )
reaper.UpdateArrange()
reaper.Undo_EndBlock( "Remove content or points in razor edit area", 1 )