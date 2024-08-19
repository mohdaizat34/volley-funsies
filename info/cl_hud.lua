
local control_panel_open = true 

local MainFrame = vgui.Create("DFrame")
MainFrame:SetSize(ScrW()/8, ScrH()/2.4)
MainFrame:SetPos(ScrW()/1.17, ScrH()/14.4)
MainFrame:SetTitle("Controls (Press F3 to hide)")
MainFrame:SetVisible(true)  
MainFrame:SetBackgroundBlur( true )
MainFrame:ShowCloseButton(false)
MainFrame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,150) ) -- Draw a black box instead of the frame
end

local start_button = vgui.Create( "DLabel", MainFrame ) 
start_button:Dock(TOP)  
start_button:SetText("[SPACEBAR] - Jump")
start_button:SetTextColor(Color(255,255,255))     
start_button:SetSize(50, 30)  
start_button:DockMargin( 0, 5 , 0, 0 )   
start_button:SetFont("CenterPrintText") 
start_button.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 	
	draw.RoundedBox( 255, 0, 0, w, h, Color( 0,0,0,0) )
end

local start_button = vgui.Create( "DLabel", MainFrame ) 
start_button:Dock(TOP)  
start_button:SetText("[KEY_1] - Set Spike Power")
start_button:SetTextColor(Color(255,255,255))     
start_button:SetSize(50, 30)  
start_button:DockMargin( 0, 5 , 0, 0 )   
start_button:SetFont("CenterPrintText") 
start_button.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 	
	draw.RoundedBox( 255, 0, 0, w, h, Color( 0,0,0,0) )
end

local start_button = vgui.Create( "DLabel", MainFrame ) 
start_button:Dock(TOP)  
start_button:SetText("[KEY_2] - Set Receive Power")
start_button:SetTextColor(Color(255,255,255))     
start_button:SetSize(50, 30)  
start_button:DockMargin( 0, 5 , 0, 0 )   
start_button:SetFont("CenterPrintText") 
start_button.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 	
	draw.RoundedBox( 255, 0, 0, w, h, Color( 0,0,0,0) )
end

local start_button = vgui.Create( "DLabel", MainFrame ) 
start_button:Dock(TOP) 
start_button:SetWrap(true) 
start_button:SetText("[KEY_V (hold)] - Receive (On Ground)")
start_button:SetTextColor(Color(255,255,255))     
start_button:SetSize(50, 30)  
start_button:DockMargin( 0, 5 , 0, 0 )   
start_button:SetFont("CenterPrintText") 
start_button.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 	
	draw.RoundedBox( 255, 0, 0, w, h, Color( 0,0,0,0) )
end

local start_button = vgui.Create( "DLabel", MainFrame ) 
start_button:Dock(TOP) 
start_button:SetWrap(true)
start_button:SetText("[MOUSE_LEFT (hold)] - Spike (Off Ground)")
start_button:SetTextColor(Color(255,255,255))     
start_button:SetSize(50, 30)  
start_button:DockMargin( 0, 15 , 0, 0 )   
start_button:SetFont("CenterPrintText") 
start_button.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 	
	draw.RoundedBox( 255, 0, 0, w, h, Color( 0,0,0,0) )
end

local start_button = vgui.Create( "DLabel", MainFrame ) 
start_button:Dock(TOP) 
start_button:SetWrap(true)
start_button:SetText("[MOUSE_RIGHT (Behind serve line)] - Basic Serve")
start_button:SetTextColor(Color(255,255,255))     
start_button:SetSize(50, 30)  
start_button:DockMargin( 0, 15 , 0, 0 )   
start_button:SetFont("CenterPrintText") 
start_button.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 	
	draw.RoundedBox( 255, 0, 0, w, h, Color( 0,0,0,0) )
end

local start_button = vgui.Create( "DLabel", MainFrame ) 
start_button:Dock(TOP) 
start_button:SetWrap(true)
start_button:SetText("[F1] - Character Controls")
start_button:SetTextColor(Color(255,255,255))     
start_button:SetSize(50, 30)  
start_button:DockMargin( 0, 5 , 0, 0 )      
start_button:SetFont("CenterPrintText") 
start_button.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 	
	draw.RoundedBox( 255, 0, 0, w, h, Color( 0,0,0,0) )
end

local start_button = vgui.Create( "DLabel", MainFrame ) 
start_button:Dock(TOP) 
start_button:SetWrap(true)
start_button:SetText("[E] - Pickup ball")
start_button:SetTextColor(Color(255,255,255))     
start_button:SetSize(50, 30)  
start_button:DockMargin( 0, 5 , 0, 0 )   
start_button:SetFont("CenterPrintText") 
start_button.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 	
	draw.RoundedBox( 255, 0, 0, w, h, Color( 0,0,0,0) )
end

local start_button = vgui.Create( "DLabel", MainFrame ) 
start_button:Dock(TOP) 
start_button:SetWrap(true)
start_button:SetText("[KEY_K / KEY_L] - Taunt/Cheer")
start_button:SetTextColor(Color(255,255,255))     
start_button:SetSize(50, 30)  
start_button:DockMargin( 0, 5 , 0, 0 )   
start_button:SetFont("CenterPrintText") 
start_button.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 	
	draw.RoundedBox( 255, 0, 0, w, h, Color( 0,0,0,0) )
end

local start_button = vgui.Create( "DLabel", MainFrame ) 
start_button:Dock(TOP) 
start_button:SetWrap(true)
start_button:SetText("[KEY_M] - Change Character/Switch Team")
start_button:SetTextColor(Color(255,255,255))     
start_button:SetSize(50, 30)  
start_button:DockMargin( 0, 5 , 0, 0 )   
start_button:SetFont("CenterPrintText") 
start_button.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 	
	draw.RoundedBox( 255, 0, 0, w, h, Color( 0,0,0,0) )
end

local start_button = vgui.Create( "DLabel", MainFrame ) 
start_button:Dock(TOP) 
start_button:SetWrap(true)
start_button:SetText("[KEY_B] - Communication")
start_button:SetTextColor(Color(255,255,255))     
start_button:SetSize(50, 30)  
start_button:DockMargin( 0, 5 , 0, 0 )   
start_button:SetFont("CenterPrintText") 
start_button.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 	
	draw.RoundedBox( 255, 0, 0, w, h, Color( 0,0,0,0) )
end

hook.Add("PlayerButtonDown", "Hide Control Panel", function(ply, button)
    if button == KEY_F3 then 
        -- Check if enough time has passed since the last action
        if not control_panel_cooldown or control_panel_cooldown < CurTime() then
            -- Toggle the control panel state
            control_panel_open = not control_panel_open

            -- Set the visibility of the MainFrame accordingly
            MainFrame:SetVisible(control_panel_open)

            -- Set the cooldown time (1 second delay before next action can be triggered)
            control_panel_cooldown = CurTime() + 0.5
        end
    end 
end)



power_level_receive = {"Low","High"}
power_level_spike = {"Low","High"}
power_level_toss = {"Front","Back"}

set_power_level_receive = power_level_receive[1] -- Default power level for "Receive" mode
set_power_level_spike = power_level_spike[1] -- Default power level for "Spike" mode
set_power_level_toss = power_level_toss[1] -- Default power level for "Spike" mode

local receive_texture = Material("hud/pass.png")
local spike_texture = Material("hud/spike.png")
local set_texture = Material("hud/set.png")

hook.Add("HUDPaint", "ModePower", function()
    local leftBoxX = ScrW() / 32
    local leftBoxWidth = ScrW() / 6.86
    local leftTextX = leftBoxX + (leftBoxWidth / 2) - (surface.GetTextSize("Manage Power") / 1.3)
    
    
    -- Draw left box and text
    draw.RoundedBox(4, leftBoxX, ScrH() / 1.23, leftBoxWidth, ScrH() / 6, Color(0, 100, 166, 207))
    draw.DrawText("Manage Power", "ChatFont", leftTextX, ScrH() / 1.23, Color(255, 255, 255))
    

    local rightBoxX = ScrW() / 1.2
    local rightBoxWidth = ScrW() / 6.86
    local rightTextX = rightBoxX + (rightBoxWidth / 2) - (surface.GetTextSize("Manage Set") / 1.3)

    if character == "kageyama" or character == "miya" or character == "kenma" then 
        -- -- Draw right box and text
        draw.RoundedBox(4, rightBoxX, ScrH() / 1.23, rightBoxWidth, ScrH() / 6, Color(0, 100, 166, 207))
        draw.DrawText("Manage Set", "ChatFont", rightTextX, ScrH() / 1.22, Color(255, 255, 255))

         -- Power Level for Toss  mode
        if set_power_level_toss == power_level_toss[1] then
            draw.DrawText(power_level_toss[1], "ChatFont", rightTextX + 50, ScrH() / 1.17, Color(255, 224, 70))
        elseif set_power_level_toss == power_level_toss[2] then
            draw.DrawText(power_level_toss[2], "ChatFont", rightTextX + 50, ScrH() / 1.17, Color(255, 54, 54))
        end
        
        //Shoot Toss 
        local offset = 50
        draw.DrawText("Shoot : ", "ChatFont", rightTextX - offset, ScrH() / 1.17, Color(255, 255, 255))
        
    end 

    if action_status == "RECEIVING" then 
        draw.DrawText(action_status, "ChatFont",ScrW()/2.10, ScrH()/1.29, Color(255, 242, 0))
    elseif action_status == "SPIKING" then 
        draw.DrawText(action_status, "ChatFont",ScrW()/2.10, ScrH()/1.29, Color(255, 242, 0))
    elseif action_status == "You are in service area, Right Click to serve" then 
        draw.DrawText(action_status, "ChatFont",ScrW()/2.5, ScrH()/1.29, Color(255, 187, 0))
    elseif action_status == "JUMP BOOST ACQUIRED!" then 
        draw.DrawText(action_status, "ChatFont",ScrW()/2.3, ScrH()/1.29, Color(0, 255, 102))
    else 
        draw.DrawText("", "Trebuchet24",ScrW()/2.2, ScrH()/1.29, Color(255, 242, 0))
    end 

    -- Power Level for Receive mode
    if set_power_level_receive == power_level_receive[1] then
        draw.DrawText(power_level_receive[1], "Trebuchet24", ScrW() / 10.67, ScrH() / 1.09, Color(255, 224, 70))
    elseif set_power_level_receive == power_level_receive[2] then
        draw.DrawText(power_level_receive[2], "Trebuchet24",  ScrW() / 10.67, ScrH() / 1.09, Color(255, 54, 54))
    end

    -- Power Level for Spike mode
    if set_power_level_spike == power_level_spike[1] then
        draw.DrawText(power_level_spike[1], "Trebuchet24", ScrW() / 10.67, ScrH() / 1.17, Color(255, 224, 70))
    elseif set_power_level_spike == power_level_spike[2] then
        draw.DrawText(power_level_spike[2], "Trebuchet24", ScrW() / 10.67, ScrH() / 1.17, Color(255, 54, 54))
    end



    -- Draw spike icon
    -- draw.DrawText("Spike", "Trebuchet24", ScrW() / 10.67, ScrH() / 1.09, Color(255, 255, 255))
    surface.SetMaterial(receive_texture)
    surface.SetDrawColor(Color(255, 255, 255))
    surface.DrawTexturedRect(ScrW() / 24, ScrH() / 1.1, ScrW() / 32, ScrH() / 18)

    -- -- Draw receive icon on the right side
    -- draw.DrawText("Receive", "Trebuchet24", ScrW() / 1.33 + ScrW() / 6.86, ScrH() / 1.09, Color(255, 255, 255))
    -- surface.SetMaterial(receive_texture)
    -- surface.SetDrawColor(Color(255, 255, 255))
    -- surface.DrawTexturedRect(ScrW() / 1.23 + ScrW() / 24, ScrH() / 1.1, ScrW() / 32, ScrH() / 18)

    surface.SetMaterial(spike_texture)
    surface.SetDrawColor(Color(255, 255, 255))
    surface.DrawTexturedRect(ScrW() / 24, ScrH() / 1.19, ScrW() / 32, ScrH() / 18)



    -- -- Draw power-high texture on the right side
    -- surface.SetMaterial(Material("hud/power-high.png"))
    -- surface.SetDrawColor(Color(255, 255, 255))
    -- surface.DrawTexturedRect(ScrW() / 1.3 + ScrW() / 24 + ScrW() / 32 + 10, ScrH() / 1.19, ScrW() / 32, ScrH() / 18)

    -- End HUD Code
end)


--// Controls to set mode and power //---
-- Variables to track button presses and the time of the last press
local modeButtonPressed = false
local powerButtonPressed = false
local tossButtonPressed = false
local lastModePressTime = 0
local lastPowerPressTime = 0
local lastTossPressTime = 0
local pressDelay = 0.2  -- Adjust this value as needed

hook.Add("PlayerButtonDown", "setMode", function(ply, button)
    -- Check if the mode button is already pressed or if not enough time has passed since the last press
    if button ~= KEY_2 or CurTime() - lastModePressTime < pressDelay then
        return
    end
    
    -- Update the time of the last press
    lastModePressTime = CurTime()

    if set_power_level_receive == power_level_receive[1] then -- if low
        set_power_level_receive = power_level_receive[2]  -- set high 
        print("power level (Receive): "..set_power_level_receive)
    elseif set_power_level_receive == power_level_receive[2] then  -- if high
        set_power_level_receive = power_level_receive[1] -- set low
        print("power level (Receive): "..set_power_level_receive)
    end 
end)


hook.Add("PlayerButtonUp", "setMode", function(ply, button)
    -- Reset the mode button state when released
    if button == KEY_2 then
        modeButtonPressed = false
    end
end)


hook.Add("PlayerButtonUp", "setMode", function(ply, button)
    -- Reset the mode button state when released
    if button == KEY_2 then
        modeButtonPressed = false
    end
end)

hook.Add("PlayerButtonDown", "setPower", function(ply, button)
    -- Check if the power button is already pressed or if not enough time has passed since the last press
    if button ~= KEY_1 or CurTime() - lastPowerPressTime < pressDelay then
        return
    end
    
    -- Update the time of the last press
    lastPowerPressTime = CurTime()

    -- Your existing code for setting power goes here

    if set_power_level_spike == power_level_spike[1] then -- if low
        set_power_level_spike = power_level_spike[2]  -- set high 
        print("power level (Spike): "..set_power_level_spike)
    elseif set_power_level_spike == power_level_spike[2] then  -- if high
        set_power_level_spike = power_level_spike[1] -- set low
        print("power level (Spike): "..set_power_level_spike)
    end 

end)



hook.Add("PlayerButtonUp", "setPower", function(ply, button)
    -- Reset the power button state when released
    if button == KEY_1 then
        tossButtonPressed = false
    end
end)


hook.Add("PlayerButtonDown", "setToss", function(ply, button)
    -- Check if the power button is already pressed or if not enough time has passed since the last press
    if button ~= KEY_3 or CurTime() - lastTossPressTime < pressDelay then
        return
    end
    
    -- Update the time of the last press
    lastTossPressTime = CurTime()

    -- Your existing code for setting power goes here

    if set_power_level_toss == power_level_toss[1] then -- if low
        set_power_level_toss = power_level_toss[2]  -- set high 
        //print("power level (Spike): "..set_power_level_spike)
    elseif set_power_level_toss == power_level_toss[2] then  -- if high
        set_power_level_toss = power_level_toss[1] -- set low
        //print("power level (Spike): "..set_power_level_spike)
    end 

end)



hook.Add("PlayerButtonUp", "setToss", function(ply, button)
    -- Reset the power button state when released
    if button == KEY_3 then
        tossButtonPressed = false
    end
end)

--// End Controls Mode & Power //-- 


--// Start Serve line detection //-- 
hook.Add("PlayerTick","DetectServeLine",function(ply)
    if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
        action_status = "You are in service area, Right Click to serve"
    else 

    end 
end)
--// End Start Serve line detection //--------------

team.SetUp( 1, "Blue", Color( 71, 255, 227 ) ) 
team.SetUp( 2, "Green", Color( 117, 255, 48) ) 

function DrawAdminIndicator(ply,char)
	local zOffset = 80
	local x = ply:GetPos().x			
	local y = ply:GetPos().y			
	local z = ply:GetPos().z			
	local pos = Vector(x,y,z+zOffset)	
	local pos2d = pos:ToScreen()


    draw.DrawText(ply:Nick(),"Default",pos2d.x,pos2d.y, team.GetColor( ply:Team() ),TEXT_ALIGN_CENTER)

	
	--end
end

function LoopThroughPlayers()
	for k,v in pairs (player.GetAll()) do 
		--if v:IsAdmin() then			
			DrawAdminIndicator(v,character)	
		--end
	end
end
hook.Add("HUDPaint", "LoopThroughPlayers", LoopThroughPlayers)

























