function print(msg) reaper.ShowConsoleMsg(tostring(msg) .. '\n') end

window, segment, details = reaper.BR_GetMouseCursorContext()

mouse_track = reaper.BR_GetMouseCursorContext_Track()
mouse_pos = reaper.BR_PositionAtMouseCursor(false)

local tab = {}

for i = 0, 10000 do
    msr = reaper.TimeMap_GetMeasureInfo(0, i)
    if msr >= mouse_pos then 
        next_msr = msr; 
        msr = reaper.TimeMap_GetMeasureInfo(0, i-1) 
        tab[1] = msr  
        tab[2] = msr+2
        break 
    end
end

if mouse_track and window == 'arrange' then 
    local _, existing = reaper.GetSetMediaTrackInfo_String( mouse_track, "P_RAZOREDITS", "", false )
    reaper.GetSetMediaTrackInfo_String( mouse_track, "P_RAZOREDITS", existing .. " " .. table.concat(tab, " "), true )
end

reaper.defer(function() end)