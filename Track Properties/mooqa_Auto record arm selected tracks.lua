
    local ProjState2;
    local function ChangesInProject();
        local ret;
        local ProjState = reaper.GetProjectStateChangeCount(0);
        if not ProjState2 or ProjState2 ~= ProjState then ret = true end;
        ProjState2 = ProjState;
        return ret == true;
    end;
    --=========================================

    --=========================================
    local function loop();
        local ProjStt = ChangesInProject();
        if ProjStt then;
            local countTrack = reaper.CountTracks(0);
            for i = 1, countTrack do;
                local track = reaper.GetTrack(0,i-1);
                local Arm = reaper.GetMediaTrackInfo_Value(track,"I_RECARM");
                local sel = reaper.IsTrackSelected(track);
                local vis = reaper.IsTrackVisible( track, false )
                
                if vis and sel == true then;
                    if Arm == 0 then;
                        reaper.SetMediaTrackInfo_Value(track,"I_RECARM",1);
                    end;
                else;
                    if vis and Arm > 0 then;
                        reaper.SetMediaTrackInfo_Value(track,"I_RECARM",0);
                    end;
                end;
                
            end;
        end;
        reaper.defer(loop);
    end;
    --=========================================


    --=========================================
    local function SetToggleButtonOnOff(numb);
        local value,ScriptWay,sec,cmd,mod,res,val = reaper.get_action_context();
        reaper.SetToggleCommandState(sec,cmd,numb or 0);
        reaper.Main_OnCommand(reaper.NamedCommandLookup('_XENAKIOS_SELTRAX_RECUNARMED'), 0)
        reaper.RefreshToolbar2(sec,cmd);
    end;
    --=========================================


    reaper.defer(loop);
    SetToggleButtonOnOff(1);
    reaper.atexit(SetToggleButtonOnOff);



