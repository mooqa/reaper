-- @description Add Razor Edit on selected tracks within Region bounds under mouse or edit cursor (keep other RE areas)
-- @author amagalma
-- @version 1.00
-- @link https://forum.cockos.com/showthread.php?t=262254
-- @donation https://www.paypal.me/amagalma
-- @about
--   Adds Razor edits on the selected tracks within the Region that is under the mouse cursor or the edit cursor.
--   Keeps all other razor edit areas.

function print(msg) reaper.ShowConsoleMsg(tostring(msg) .. '\n') end

local position = reaper.BR_PositionAtMouseCursor(true)
_, segment, _ = reaper.BR_GetMouseCursorContext()
if position == -1 then position = reaper.GetCursorPosition() end
local _, regionidx = reaper.GetLastMarkerAndCurRegion( 0, position )
local track_cnt = reaper.CountSelectedTracks( 0 )
if regionidx == -1 or track_cnt == 0 then return reaper.defer(function() end) end

reaper.Undo_BeginBlock()

local _, _, rgnpos, rgnend = reaper.EnumProjectMarkers( regionidx )
reaper.PreventUIRefresh( 1 )
if segment == "track" then
  for tr = 0, track_cnt-1 do
    local track = reaper.GetSelectedTrack( 0, tr )
    local t, t_cnt = {[1] = string.format('%f %f ""', rgnpos, rgnend )}, 1
    for en = 0, reaper.CountTrackEnvelopes( track )-1 do
      local envelope = reaper.GetTrackEnvelope( track, en )
      local _, chunk = reaper.GetEnvelopeStateChunk( envelope, "", false )
      if chunk:match("VIS (1)") == "1" then -- env visible
        local _, guid = reaper.GetSetEnvelopeInfo_String( envelope, "GUID", "", false )
          t_cnt = t_cnt + 1
          t[t_cnt] = string.format('%f %f "%s"', rgnpos, rgnend, guid )
        end
    end
    local _, existing = reaper.GetSetMediaTrackInfo_String( track, "P_RAZOREDITS", "", false )
    reaper.GetSetMediaTrackInfo_String( track, "P_RAZOREDITS", existing .. " " .. table.concat(t, " "), true )
  end
elseif segment == "envelope" then 
  for tr = 0, track_cnt-1 do
    local track = reaper.GetSelectedTrack( 0, tr )
    local t, t_cnt = {[1] = string.format('%f %f ""', rgnpos, rgnend )}, 1
    for en = 0, reaper.CountTrackEnvelopes( track )-1 do
      local envelope = reaper.GetTrackEnvelope( track, en )
      local _, chunk = reaper.GetEnvelopeStateChunk( envelope, "", false )
      if chunk:match("VIS (1)") == "1" then -- env visible
        local _, guid = reaper.GetSetEnvelopeInfo_String( envelope, "GUID", "", false )
          t_cnt = t_cnt + 1
          t[t_cnt] = string.format('%f %f "%s"', rgnpos, rgnend, guid )
        end
    end
    local _, existing = reaper.GetSetMediaTrackInfo_String( track, "P_RAZOREDITS", "", false )
    print(table.concat(t, " "))
    reaper.GetSetMediaTrackInfo_String( track, "P_RAZOREDITS", existing .. " " .. table.concat(t, " "), true )
  end
end
reaper.PreventUIRefresh( -1 )
reaper.UpdateArrange()

reaper.Undo_EndBlock( "Create Region Razor edits on selected tracks", 1 )
