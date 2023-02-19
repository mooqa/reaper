
    section = "MOOQA_TOGGLES"
    key =  "SOLO"
   

    local value,ScriptWay,sec,cmd,mod,res,val = reaper.get_action_context()
    
    reaper.Undo_BeginBlock() 
    reaper.PreventUIRefresh(1)  
    
    extstate = reaper.GetExtState( section, key )  
    state = reaper.GetToggleCommandStateEx( sec, cmd )


    function SetButtonState(numb)
        local value,ScriptWay,sec,cmd,mod,res,val = reaper.get_action_context();
        reaper.SetToggleCommandState(sec,cmd,numb or 0)
        reaper.RefreshToolbar2(sec,cmd)
    end
    
    
    if extstate == '0' then SetButtonState(0)
    elseif extstate == '1' then SetButtonState(1)
    elseif extstate == '' then 
        reaper.SetExtState( section, key, 1, true )
        SetButtonState(1)
    end
    

  
    
if state == 0 then 

  reaper.SetExtState( section, key, 1, true )
  SetButtonState(1)
  reaper.TrackList_AdjustWindows(true)

  
  
elseif state == 1 then
  
  reaper.SetExtState( section, key, 0, true )
  SetButtonState(0)
  reaper.TrackList_AdjustWindows(true)
  
end
  
  reaper.PreventUIRefresh(-1) 
  
  reaper.UpdateArrange()
  reaper.Undo_EndBlock('Toggle exclusive solo', -1)
