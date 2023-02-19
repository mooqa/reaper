-- SETUP:
--------------------------INSERT ACTION ID HERE:---------------------------------

ACTION_ID = ''

-------- EXAMPLE: ACTION_ID = '_RS8057b8981a857ce5cfadefbdad36e6da27cdc3b0'------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end


toggle = reaper.NamedCommandLookup(ACTION_ID)
state = reaper.GetToggleCommandState(toggle)

   reaper.Undo_BeginBlock()
   reaper.PreventUIRefresh(1)

if state == 0 then
   reaper.Main_OnCommand(9,0) -- record arm selected tracks
   reaper.Undo_EndBlock('Toggle record arm for selected tracks', -1)
else
   
 local countTrack = reaper.CountTracks(0);
            for i = 1, countTrack do;
                local track = reaper.GetTrack(0,i-1);
                local Arm = reaper.GetMediaTrackInfo_Value(track,"I_RECARM");
                local sel = reaper.IsTrackSelected(track);
                local vis = reaper.IsTrackVisible( track, false )
                
            if vis == true then;
               if sel == true then
                    if Arm == 0 then;
                        reaper.SetMediaTrackInfo_Value(track,"I_RECARM",1);
                    end
                    if Arm > 0 then;
                        reaper.SetMediaTrackInfo_Value(track,"I_RECARM",0);
                    end
                else
                    reaper.SetMediaTrackInfo_Value(track,"I_RECARM",0);
                end
                
                
            end
            end
   reaper.PreventUIRefresh(-1)
   reaper.Undo_EndBlock('Toggle exclusive record arm for selected tracks', -1)
end

