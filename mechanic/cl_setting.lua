-- this will be used in serverside and cl_mechanics.lua 
allow_receive_assist = true 
allow_set_assist = true 
allow_spike_assist = true 
allow_left_assist = false 
allow_old_receive = false 

local frameIsOpen = false 
local PANEL = {}
local function HighlightButton(button,button2,frame)
    frame:Close() 
end

local function OpenMyUI()
    if IsValid(MyUIPanel) then
        MyUIPanel:Show()
    else
        MyUIPanel = vgui.Create("MySimpleUI")
    end
end

hook.Add("PlayerButtonDown", "OpenMyUIOnButtonPress", function(ply, button)
    if button == KEY_N then
        OpenMyUI()
    end
end)

function PANEL:Init()
    self:SetSize(300, 500)
    self:Center()
    self:SetTitle("Choose Preference")
    self:SetVisible(true)
    self:SetDraggable(false)
    self:MakePopup()
    self:ShowCloseButton(true)
    self.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,200) ) -- Draw a black box instead of the frame
    end

   -- Receive--------------------------------------
    local label = vgui.Create("DLabel", self)
    label:SetText("Enable Receive Assist?")
    label:SetPos(50, 30)
    label:SetFont("Trebuchet18")
    label:SetSize(200, 20)

    button_receive_assist_yes = vgui.Create("DButton", self)
    button_receive_assist_yes:SetText("Yes")
    button_receive_assist_yes:SetPos(50, 70)
    button_receive_assist_yes:SetSize(100, 30)
    button_receive_assist_yes.DoClick = function()
        HighlightButton(button_receive_assist_yes,button_receive_assist_no,self)
        allow_receive_assist = true 
        chat.AddText("Setting changed",Color(255,0,0))
    end

    button_receive_assist_no = vgui.Create("DButton", self)
    button_receive_assist_no:SetText("No")
    button_receive_assist_no:SetPos(150, 70)
    button_receive_assist_no:SetSize(100, 30)
    button_receive_assist_no.DoClick = function()
        HighlightButton(button_receive_assist_no,button_receive_assist_yes,self)
        allow_receive_assist = false
    end
    --Receive END ---------------------------------------------------------------


    -- Set Assist-------------------------------------------------------------------
    local label = vgui.Create("DLabel", self)
    label:SetText("Enable Set Assist?")
    label:SetPos(50, 120)
    label:SetSize(200, 20)
    label:SetFont("Trebuchet18")

    button_set_assist_yes = vgui.Create("DButton", self)
    button_set_assist_yes:SetText("Yes")
    button_set_assist_yes:SetPos(50, 160)
    button_set_assist_yes:SetSize(100, 30)
    button_set_assist_yes.DoClick = function()
        HighlightButton(button_set_assist_yes,button_set_assist_no,self)
        chat.AddText(Color(7,226,11),"Setting changed: Set Assist ON")
        allow_set_assist = true 
    end

    button_set_assist_no = vgui.Create("DButton", self)
    button_set_assist_no:SetText("No")
    button_set_assist_no:SetPos(150, 160)
    button_set_assist_no:SetSize(100, 30)
    button_set_assist_no.DoClick = function()
        HighlightButton(button_set_assist_no,button_set_assist_yes,self)
        chat.AddText(Color(255,0,0),"Setting changed: Set Assist OFF")
        allow_set_assist = false 
    end
    -- Set Assist END -------------------------------------------------------------------

    -- Spike Assist-------------------------------------------------------------------
    local label = vgui.Create("DLabel", self)
    label:SetText("Enable Spike Assist? (>120ms only)")
    label:SetPos(50, 210)
    label:SetSize(200, 20)
    label:SetFont("Trebuchet18")

    button_spike_assist_yes = vgui.Create("DButton", self)
    button_spike_assist_yes:SetText("Yes")
    button_spike_assist_yes:SetPos(50, 250)
    button_spike_assist_yes:SetSize(100, 30)
    button_spike_assist_yes.DoClick = function()
        HighlightButton(button_spike_assist_yes,button_spike_assist_no,self)
        chat.AddText(Color(7,226,11),"Setting changed: Spike Assist ON")
        allow_spike_assist = true 
    end

    button_spike_assist_no = vgui.Create("DButton", self)
    button_spike_assist_no:SetText("No")
    button_spike_assist_no:SetPos(150, 250)
    button_spike_assist_no:SetSize(100, 30)
    button_spike_assist_no.DoClick = function()
        -- Handle Option 2 click
        HighlightButton(button_spike_assist_no,button_spike_assist_yes,self)
        chat.AddText(Color(255,0,0),"Setting changed: Spike Assist OFF")
        allow_spike_assist = false 
    end
    -- Spike Assist END -------------------------------------------------------------------

    
    ---- AZERTY KEYBOARD USER ------------------
    local label = vgui.Create("DLabel", self)
    label:SetText("Left Handed User? (AZERTY KEYBOARD)")
    label:SetPos(50, 310)
    label:SetWrap(true)
    label:SetSize(200, 50)
    label:SetFont("Trebuchet18")

    button_left_key_yes = vgui.Create("DButton", self)
    button_left_key_yes:SetText("Yes")
    button_left_key_yes:SetPos(50, 360)
    button_left_key_yes:SetSize(100, 30)
    button_left_key_yes.DoClick = function()
        HighlightButton(button_left_key_no,button_left_key_yes,self)
        chat.AddText(Color(7,226,11),"Setting changed: Left Handed Keys ON")
        allow_left_assist = true 
    end

    button_left_key_no = vgui.Create("DButton", self)
    button_left_key_no:SetText("No")
    button_left_key_no:SetPos(150, 360)
    button_left_key_no:SetSize(100, 30)
    button_left_key_no.DoClick = function()
        -- Handle Option 2 click
        HighlightButton(button_left_key_no,button_left_key_yes,self)
        chat.AddText(Color(255,0,0),"Setting changed: Left Handed Keys OFF")
        allow_left_assist = false 
    end
    -- AZERTY KEYBOARD USER END -------------------------------------------------------------------

    ----Gmod Volleyball 1.0 Receive Mechanic ------------------
    local label = vgui.Create("DLabel", self)
    label:SetText("Enable Gmod Volleyball 1.0 Receive Mechanic?")
    label:SetPos(50, 410)
    label:SetWrap(true)
    label:SetSize(200, 50)
    label:SetFont("Trebuchet18")

    button_old_receive_yes = vgui.Create("DButton", self)
    button_old_receive_yes:SetText("Yes")
    button_old_receive_yes:SetPos(50, 460)
    button_old_receive_yes:SetSize(100, 30)
    button_old_receive_yes.DoClick = function()
        HighlightButton(button_old_receive_no,button_old_receive_yes,self)
        chat.AddText(Color(7,226,11),"Setting changed: Gmod Volleyball 1.0 Receive Mechanic ON")
        allow_old_receive = true 
    end

    button_old_receive_no = vgui.Create("DButton", self)
    button_old_receive_no:SetText("No")
    button_old_receive_no:SetPos(150, 460)
    button_old_receive_no:SetSize(100, 30)
    button_old_receive_no.DoClick = function()
        -- Handle Option 2 click
        HighlightButton(button_old_receive_no,button_old_receive_yes,self)
        chat.AddText(Color(255,0,0),"Setting changed: Gmod Volleyball 1.0 Receive Mechanic OFF")
        allow_old_receive = false
    end
    -- Gmod Volleyball 1.0 Receive Mechanic END -------------------------------------------------------------------
end

vgui.Register("MySimpleUI", PANEL, "DFrame")




