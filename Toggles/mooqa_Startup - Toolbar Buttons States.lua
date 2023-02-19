-- SETUP:    
-- 1. Add this script's id to __startup.lua file 
-- 2. INSERT ACTION IDs HERE:
SOLO_ID = ''
ARM_ID = ''
-------- EXAMPLE: SOLO_ID = '_RS8057b8981a857ce5cfadefbdad36e6da27cdc3b0'--------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------



      section = 'MOOQA_TOGGLES'
      
      
      keys = {
      
      'SOLO',
      'ARM'
      
      }
      
      toggles = {
      
      solo = reaper.NamedCommandLookup (SOLO_ID),
      arm  = reaper.NamedCommandLookup (ARM_ID)
      
      }

      
      function msg(param)
        reaper.ShowConsoleMsg(tostring(param).."\n")
      end
      
      for k,v in pairs (keys) do
      
        name = string.lower(v)
        cmd = toggles[name]
        sec = 0
  
        extstate, __ = reaper.GetExtState( section, v )
       
       
        if extstate == '1' then
           reaper.SetToggleCommandState(sec,cmd,1)
           reaper.RefreshToolbar2(sec,cmd)
        elseif extstate == '0' then
           reaper.SetToggleCommandState(sec,cmd,0)
           reaper.RefreshToolbar2(sec,cmd)
        elseif extstate == '' then
           reaper.SetToggleCommandState(sec,cmd,0)
           reaper.RefreshToolbar2(sec,cmd)
        end
      end
