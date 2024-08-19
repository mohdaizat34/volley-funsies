action_status = ""

print("Mechanic")
hook.Remove( "Tick", "KeyDown_Testis", function() end)
hook.Remove( "Tick", "KeyDown_Tests", function() end) 
hook.Remove( "Tick", "KeyDown_Toss", function() end)
hook.Remove("PlayerButtonDown","miya_serve",function(ply,button) end) 
hook.Remove( "Tick", "Kage_toss", function() end) 
hook.Remove( "Tick", "Kage_toss2", function() end) 
hook.Remove( "Tick", "KeyDown_Toss2", function() end)

local MainFrame2 = vgui.Create("DFrame")  
MainFrame2:SetSize(1366,768)
MainFrame2:SetTitle("This gamemode is created by Hope")
MainFrame2:SetVisible(false) 
MainFrame2:SetBackgroundBlur( false )
MainFrame2:ShowCloseButton(false)  
MainFrame2:Center()
MainFrame2.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end

local TopPanel = vgui.Create( "DPanel", MainFrame2 )       
TopPanel:Dock(TOP) 
TopPanel:SetSize(200,100)       
TopPanel.Paint = function( self, w, h )    
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end

local FillPanel = vgui.Create( "DPanel", MainFrame2 )       
FillPanel:Dock(FILL)
FillPanel:SetSize(1366,1366)   
FillPanel.Paint = function( self, w, h )    
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end

local LeftPanel = vgui.Create( "DScrollPanel", MainFrame2 )       
LeftPanel:Dock(LEFT)
LeftPanel:SetSize(500,0)   
LeftPanel.Paint = function( self, w, h )    
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end

local RightPanel = vgui.Create( "DScrollPanel", MainFrame2 )       
RightPanel:Dock(RIGHT)
RightPanel:SetSize(500,0)   
RightPanel.Paint = function( self, w, h )    
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end

local BottomPanel = vgui.Create( "DPanel", MainFrame2 )       
BottomPanel:Dock(BOTTOM)
BottomPanel:SetSize(1366,100)   
BottomPanel.Paint = function( self, w, h )    
draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,0) ) -- Draw a black box instead of the frame
end

local DProgress = vgui.Create( "DProgress",BottomPanel )
DProgress:Dock(TOP)
DProgress:SetSize( 400, 30 )
DProgress:SetFraction( 0 )
--DProgress:SetVisible(false)

local ball_detect = vgui.Create( "DButton", BottomPanel ) 
ball_detect:Dock(TOP)  
ball_detect:SetText("")
ball_detect:SetTextColor(Color(0,0,0))     
ball_detect:SetSize(64, 64)  
ball_detect:DockMargin( 0, 5 , 0, 0 )         
ball_detect:SetFont("tiny") 
ball_detect.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too 	
	draw.RoundedBox( 255, 0, 0, w, h, Color( 0,0,0,0) )
end
 
pos1 = Vector(1419.853394, 1000.308411, -165.108414)
pos2 = Vector(602.493164, 319.357361, 398.086914)
-- Calculate the mirrored positions for the right side with reduced width
pos3 = Vector(pos1.x, -pos1.y, pos1.z)
pos4 = Vector(pos2.x,319.357361, pos2.z)


position = ""


function BlockSendToServer(powertype)  
	if ply:GetPos():WithinAABox( pos1, pos2 ) then
		position = "left"
	else 
		position = "right"
	end 
	net.Start("block_power")
	net.WriteString(position)
	net.WriteString(powertype)
	net.SendToServer()
end


----------//spike mechanics//-------------------------

function SpikePower(setForce,spikepower)
	ply = LocalPlayer() 
	powerbar = 0  
	power = 0 
	jumpcount = 0 
	buttonpress = 0 
	local ent =  ents.FindByClass( "prop_physics*" )

	--spikepower = 0 
	--jumpcount = 0 
	buttonpressrec = 0 
	local ply = LocalPlayer() 
	local release_ball_spike = false 

	hook.Add( "Tick", "KeyDown_Spike", function()
		if !ply:IsOnGround()  then
			if release_ball_spike == false then 
				if (input.IsButtonDown(MOUSE_LEFT)) then
					release_ball_spike = false
					action_status = "SPIKING"
					-- detect ball when hold button
					local ent =  ents.FindByClass( "prop_physics*" )
					for k, v in pairs( ent ) do    
						physObj = ent[k]:GetPhysicsObject()

						
						if LocalPlayer():GetPos():DistToSqr( ent[k]:GetPos() ) < 115*115 then
							ply:ConCommand("pac_event spike") 
							surface.PlaySound("spike.mp3")
							
							release_ball_spike = true
							if set_power_level_spike == power_level_spike[1] then
								SpikeSendToServer("weak",spikepower,ent[k],ent[k]:GetPos(),allow_spike_assist)
								
								--// START ADD VELOCITY TO FAKE BALL //-----------
								if LocalPlayer():Ping() > 120 then 
									local fake_ball = ClientsideModel(ent[k]:GetModel()) 
									fake_ball:SetRenderMode(RENDERMODE_TRANSALPHA)
									fake_ball:SetColor(Color(255, 255, 255, 70))  -- 50% transparency
									fake_ball:SetPos(ent[k]:GetPos())
									fake_ball:PhysicsInit(SOLID_VPHYSICS)  -- Initialize physics
									-- Define the function to apply a downward force to the ball
									local phys = fake_ball:GetPhysicsObject()
									phys:SetMass(50000)
									phys:EnableDrag(true)
									phys:SetDamping( 2.1, 45 )
									phys:SetVelocity(LocalPlayer():GetAimVector() * spikepower)

									
									-- Remove the clone and text after some time
									timer.Simple(0.7, function()
										if IsValid(fake_ball) then
											fake_ball:Remove()
										end
									end)
								end 
								-- END FAKE BALL VELOCITY -------------------------

								-- Function to check if the entity's physics object is on the ground
								function IsEntityOnGround(entity)
									-- Get the position of the entity
									local posBall = entity:GetPos()
									
									-- Trace a line downward to check for ground collision
									local traceBall = util.TraceLine({
										start = posBall,
										endpos = posBall - Vector(0, 0, 23), -- Adjust the length based on your needs
										mask = MASK_OPAQUE
									})
									
									-- Return true if the trace hits the ground, false otherwise
									return traceBall.Hit
								end



								-- Function to check if the entity's physics object is on the ground and create a ground marker if so
								function BallGroundCheck() 
									-- Usage example
									if IsEntityOnGround(ent[k]) then
										
										hook.Remove("Think", "BallChecker") -- Remove the hook as it's no longer needed
										net.Start("BallHitGround")
										net.WriteVector(ent[k]:GetPos())
										net.WriteEntity(ent[k])
										net.SendToServer()
										--CreateGroundMarker(ent[k]:GetPos()) -- Create a ground marker at the position of the entity
									else
										hook.Add("Think", "BallChecker", BallGroundCheck) -- Add the hook to keep checking
									end
								end 

								-- Start checking if the ball is on the ground
								BallGroundCheck()

							else 


								SpikeSendToServer("strong",spikepower,ent[k],ent[k]:GetPos(),allow_spike_assist) 

								--// START ADD VELOCITY TO FAKE BALL //-----------
								if LocalPlayer():Ping() > 120 then 
									local fake_ball = ClientsideModel(ent[k]:GetModel()) 
									fake_ball:SetRenderMode(RENDERMODE_TRANSALPHA)
									fake_ball:SetColor(Color(255, 255, 255, 70))  -- 50% transparency
									fake_ball:SetPos(ent[k]:GetPos())
									fake_ball:PhysicsInit(SOLID_VPHYSICS)  -- Initialize physics
									-- Define the function to apply a downward force to the ball
									local phys = fake_ball:GetPhysicsObject()
									phys:SetMass(50000)
									phys:EnableDrag(true)
									phys:SetDamping( 2.1, 45 )
									phys:SetVelocity(LocalPlayer():GetAimVector() * spikepower)

									
									-- Remove the clone and text after some time
									timer.Simple(0.6, function()
										if IsValid(fake_ball) then
											fake_ball:Remove()
										end
									end)
								end 
								-- END FAKE BALL VELOCITY -------------------------
								-- Function to check if the entity's physics object is on the ground
								function IsEntityOnGround(entity)
									-- Get the position of the entity
									local posBall = entity:GetPos()
									
									-- Trace a line downward to check for ground collision
									local traceBall = util.TraceLine({
										start = posBall,
										endpos = posBall - Vector(0, 0, 23), -- Adjust the length based on your needs
										mask = MASK_OPAQUE
									})
									
									-- Return true if the trace hits the ground, false otherwise
									return traceBall.Hit
								end



								-- Function to check if the entity's physics object is on the ground and create a ground marker if so
								function BallGroundCheck() 
									-- Usage example
									if IsEntityOnGround(ent[k]) then
										hook.Remove("Think", "BallChecker") -- Remove the hook as it's no longer needed
										net.Start("BallHitGround")
										net.WriteVector(ent[k]:GetPos())
										net.WriteEntity(ent[k])
										net.SendToServer()
										--CreateGroundMarker(ent[k]:GetPos()) -- Create a ground marker at the position of the entity
									else
										hook.Add("Think", "BallChecker", BallGroundCheck) -- Add the hook to keep checking
									end
								end 

								-- Start checking if the ball is on the ground
								BallGroundCheck()
							end 
							timer.Simple(1,function() release_ball_spike = false end)
						end	
					end	
				else 
					action_status = ""
				end 
			else 
				
			
			end 
		end
	end) 
end 	

--- WHEN BLOCKED ------------------------------------------------------------

net.Receive("PrintEveryone",function(bits,ply)
	local getMessage = net.ReadString() 

	draw.DrawText(getMessage, "CloseCaption_BoldItalic", ScrW()/2.09, ScrH()/5.54, Color(255, 0, 0))
	timer.Simple(2,function() 
		getMessage = "" 
	end)
end) 

--- Cool Effects SPIKE -----------------------------------------------------


function LastSpikeClient(playerNick,ball,ballPos,playerEnt) 
	
	function GetHeightInCm(vec)
		local units = vec.z
		local cm = units * 1.9
		local roundedCm = math.Round(cm)  -- Round to the nearest whole number
		return roundedCm
	end
	

	local clone = ClientsideModel(ball:GetModel())  
	
	clone:SetPos(ballPos)  -- Set the position of the clone to the player's position
	clone:SetAngles(ball:GetAngles())  -- Set the angles of the clone to the player's angles

	-- Make the clone translucent
	clone:SetRenderMode(RENDERMODE_TRANSALPHA)
	clone:SetColor(Color(255, 255, 255, 70))  -- 50% transparency
	local heightInCm = GetHeightInCm(ballPos)
	-- Add standing 3D2D text above the clone
	hook.Add("PostDrawOpaqueRenderables", "DrawPlayerSpikeText", function()
		if IsValid(clone) then
			local pos = clone:GetPos() + Vector(0, 0, 30) -- Adjust the height of the text
			local ang = LocalPlayer():EyeAngles()
			ang:RotateAroundAxis(ang:Forward(), 90)
			ang:RotateAroundAxis(ang:Right(), 90)
			if playerEnt:Ping() > 100 then
				cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.5) -- Adjust the scale (0.1)
					draw.DrawText("Relocate for "..playerNick.." "..heightInCm.."cm | "..playerEnt:Ping().."ping", "Trebuchet24", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
				cam.End3D2D()
			else 
				cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.5) -- Adjust the scale (0.1)
					draw.DrawText(playerNick.." Spiked Here "..heightInCm.."cm", "Trebuchet24", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
				cam.End3D2D()
			end 
		end
	end)

	-- Remove the clone and text after some time
	timer.Simple(5, function()
		if IsValid(clone) then
			clone:Remove()
			hook.Remove("PostDrawOpaqueRenderables", "DrawPlayerSpikeText")
		end
	end)
end 

local clones = ClientsideModel("models/pejal_models/volleyball/mikasa.mdl") 
-- Function to create a visual marker at the position of the entity
function CreateGroundMarker(pos,ball)
	 
	local x = Vector(5, 5, 5)

	-- Define the hook to draw the box and text
	hook.Add("PostDrawTranslucentRenderables", "BoxWithText", function()
		
		clones:SetPos(pos)  -- Set the position of the clone to the player's position
		//clone:SetAngles(ball:GetAngles())  -- Set the angles of the clone to the player's angles
	
		-- Make the clone translucent
		clones:SetRenderMode(RENDERMODE_TRANSALPHA)
		clones:SetColor(Color(255, 255, 255, 150))  -- 50% transparency

		cam.IgnoreZ(false) -- disables previous call

		-- Draw text above the box using cam.Start3D2D
		local text = "Ball Mark Check"
		local textPos = pos + Vector(0, 0, 5 + 5) -- Adjust the vertical offset
		local textFont = "DermaDefault" -- Adjust the font as needed
		local textScale = 0.4 -- Adjust the scale of the text
		local textCol = Color(255, 255, 255) -- Adjust the color of the text

		-- Set up the 3D2D rendering with a 90-degree rotation around the X-axis
		cam.Start3D2D(textPos, Angle(0, 0, 0), textScale)
		draw.SimpleText(text, textFont, 0, 0, textCol, TEXT_ALIGN_CENTER)
		cam.End3D2D()
		
	end)
end

-- mark effect 
net.Receive("BallHitGroundClient", function(bits, ply)
	local ballPos = net.ReadVector() 
	local ballEnt = net.ReadEntity() 
	
	--print("Bro ?")
	CreateGroundMarker(ballPos,ballEnt)
end) 

-- illusion effect 
net.Receive("illusion_effect", function(bits, ply)
	local playerNick = net.ReadString() 
	local ballEnt = net.ReadEntity() 
	local ballPos = net.ReadVector() 
	local playerEnt = net.ReadEntity() 
	
	ballEnt:SetNoDraw(false)
	//LastSpikeClient(playerNick,ballEnt,ballPos,playerEnt)
end) 

function SpikeSendToServer(powertype,spikepower,entity,entityPos,allow_spike_assist)  
	if ply:GetPos():WithinAABox( pos1, pos2 ) then
		position = "left"
	else 
		position = "right"
	end 
	net.Start("spike_power_hinata")
	net.WriteString(position)
	net.WriteString(powertype)
	net.WriteInt(spikepower,32)
	net.WriteString(character)
	net.WriteEntity(entity)
	net.WriteVector(entityPos)
	net.WriteBool(allow_spike_assist)
	net.SendToServer()
end 
----------//spike END mechanics//-------------------------

--- RECEIVE MECHANICS START --------------------------------

function ReceiveSendToServer(powertype,ent,allow_old_mechanic)  
	if ply:GetPos():WithinAABox( pos1, pos2 ) then
		position = "left"
		ply:ConCommand("pac_event receive")
		print("on left side ")
		--ply:ConCommand("pac_event receive")
		-- local ball_pos_x = ent:GetPos().x
		-- local player_pos_x = LocalPlayer():GetPos().x
		-- local player_orientation = ply:GetAngles().y  -- Get player's Y-angle (0° to 360°)

		-- -- Convert player_orientation to a range of 0° to 360° (if needed)
		-- player_orientation = player_orientation % 360

		-- -- Define angle ranges for left, forward, and right orientations
		-- local left_angle_range = 180 - 45  -- 135° to 225°
		-- local right_angle_range = 45       -- 0° to 45° and 315° to 360°

		-- -- Determine if the ball is more to the right or left
		-- local is_ball_on_right = false
		-- if player_orientation >= left_angle_range and player_orientation <= right_angle_range then
		-- 	-- Player is facing forward or slightly to the right
		-- 	is_ball_on_right = ball_pos_x > player_pos_x
		-- else
		-- 	-- Player is facing left or significantly to the right
		-- 	is_ball_on_right = ball_pos_x < player_pos_x
		-- end

		-- -- Play animation based on ball position
		-- if is_ball_on_right and position == "left" then
		-- 	print("right")
		-- 	ply:ConCommand("pac_event receiveright")
		-- 	-- Play animation: receive right
		-- else
		-- 	print("left")
		-- 	-- Play animation: receive left
		-- 	ply:ConCommand("pac_event receiveleft")
		-- end

	else
		print("on right side ")
		position = "right"
		ply:ConCommand("pac_event receive")
		--ply:ConCommand("pac_event receive")
		-- local ball_pos_x = ent:GetPos().x
		-- local player_pos_x = LocalPlayer():GetPos().x
		-- local player_orientation = ply:GetAngles().y  -- Get player's Y-angle (0° to 360°)

		-- -- Convert player_orientation to a range of 0° to 360° (if needed)
		-- player_orientation = player_orientation % 360

		-- -- Define angle ranges for left, forward, and right orientations
		-- local left_angle_range = 180 - 45  -- 135° to 225°
		-- local right_angle_range = 45       -- 0° to 45° and 315° to 360°

		-- -- Determine if the ball is more to the right or left
		-- local is_ball_on_right = false
		-- if player_orientation >= left_angle_range and player_orientation <= right_angle_range then
		-- 	-- Player is facing forward or slightly to the right
		-- 	is_ball_on_right = ball_pos_x > player_pos_x
		-- else
		-- 	-- Player is facing left or significantly to the right
		-- 	is_ball_on_right = ball_pos_x < player_pos_x
		-- end

		-- -- Play animation based on ball position
		-- if is_ball_on_right and position == "right" then
		-- 	print("left")
		-- 	ply:ConCommand("pac_event receiveleft")
		-- 	-- Play animation: receive right
		-- else
		-- 	print("right")
		-- 	ply:ConCommand("pac_event receiveright")
		-- end
	end 
	
	if powertype == "feint" then 
		//play feint animation
		ply:ConCommand("pac_event spike")
	end 

	net.Start("receive_power")
	net.WriteString(position)
	net.WriteString(powertype)
	net.WriteEntity(ent)
	net.WriteBool(allow_receive_assist)
	net.WriteVector(ent:GetPos())
	net.WriteBool(allow_old_mechanic)
	net.WriteString(character)
	net.SendToServer()
end 

function TossSendToServer(powertype,frontback)  
	if ply:GetPos():WithinAABox( pos1, pos2 ) then
		position = "left"
	else 
		position = "right"
	end 
	net.Start("toss_power")
	net.WriteString(position)
	net.WriteString(powertype)
	net.WriteString(frontback)
	net.WriteBool(allow_set_assist)
	net.SendToServer()
end



-- local shouldOccur3 = true  
-- local delay3 = 1 
-- local meg_cd2=1 

-- function DiveSendToServer(powertype)  
-- 	if ply:GetPos():WithinAABox( pos1, pos2 ) then
-- 		position = "left"
-- 	else 
-- 		position = "right"
-- 	end 
-- 	if shouldOccur3 then 
-- 		meg_cd = 64 
-- 		net.Start("dive_power")
-- 		net.WriteString(position)
-- 		net.WriteString(powertype)
-- 		net.SendToServer()

-- 		timer.Create("stopmovement",1,1,function() 

-- 			net.Start("revertspeed")
-- 			net.WriteString("libero")
-- 			net.SendToServer()
-- 		end)

-- 		ply:PrintMessage( HUD_PRINTTALK, "You used your ability" )
-- 		shouldOccur3 = false   
-- 		timer.Create("meg_cd2",1,1,function() meg_cd2=meg_cd2-1  end) 
-- 		timer.Simple( delay3, function() shouldOccur3 = true end )
-- 	else

-- 	end     
-- end 


miya_pos1 = Vector(1300.494019, -261.572266, -119.701813) 
miya_pos2 = Vector(670.607239, -30.208231, 199.167160) 
miya_pos3 = Vector( 676.425293 ,888.083191, -108.272842) 
miya_pos4 = Vector(1375.196899, 661.645447, 262.988831)  
function BasicServe() 

	hook.Remove("PlayerButtonDown","basic_serve2",function(ply,button) end) 

	hook.Add("PlayerButtonDown","basic_serve2",function(ply,button)

		if button == MOUSE_RIGHT then 
			if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
				net.Start("basic_serve")
				net.SendToServer()
				BasicServe()
			else 
				hook.Remove("PlayerButtonDown","basic_serve2",function() end)
				chat.AddText("Not in area to use serve.")
				BasicServe()
			end 
		end 
	end) 	
end  



--ABILITY 

function KageSendToServer(powertype,frontback,tosstype)  
	if ply:GetPos():WithinAABox( pos1, pos2 ) then
		position = "left"
	else 
		position = "right"
	end 
	net.Start("kage_toss_ability")
	net.WriteString(position)
	net.WriteString(powertype)
	net.WriteString(frontback)
	net.WriteString(tosstype)
	net.WriteBool(allow_set_assist)
	net.SendToServer()
end 

function KageQuickToss(setForce)
	powertossbarkage2 = 0  
	powertosskage2 = 0 
	buttonpresstosskage2 = 0

	powertossbarkage3 = 0  
	powertosskage3 = 0 
	buttonpresstosskage3 = 0

	hook.Add( "Tick", "Kage_toss2", function()
		if (input.IsButtonDown(MOUSE_MIDDLE)) then
			if set_power_level_toss == power_level_toss[1] then
				buttonpresstosskage2 = 1 
				MainFrame2:SetVisible(true)
				powertosskage2 = powertosskage2 + 1 
				powertossbarkage2 = powertossbarkage2 + 0.04 


				DProgress:SetFraction( powertossbarkage2 )
			else // back shoot toss
				buttonpresstosskage3 = 1 
				MainFrame2:SetVisible(true)
				powertosskage3 = powertosskage3 + 1 
				powertossbarkage3 = powertossbarkage3 + 0.04 


				DProgress:SetFraction( powertossbarkage3 )
			end

		else 
			if set_power_level_toss == power_level_toss[1] then
				if buttonpresstosskage2 == 0 then 

				elseif buttonpresstosskage2 == 1 then 
					buttonpresstosskage2 = 0 
					MainFrame2:SetVisible(false)
					if powertosskage2 <= setForce then 
					
						KageSendToServer("weak","front","quick")
						chat.AddText("Short Toss!")
						powertosskage2 = 0
						powertossbarkage2 = 0 
						DProgress:SetFraction( powertossbarkage2 )  
						print( "reset" )

					elseif powertosskage2 < 20 then 
						KageSendToServer("medium","front","quick")
						chat.AddText("Medium Toss!")
						powertosskage2 = 0  
						powertossbarkage2 = 0 
						DProgress:SetFraction( powertossbarkage2 ) 
						print( "reset" )

					else 
						KageSendToServer("high","front","quick")
						chat.AddText("Power Toss!")
						powertosskage2 = 0  
						powertossbarkage2 = 0 
						DProgress:SetFraction( powertossbarkage2 ) 
						print( "reset" )
					end 

					powertosskage2 = 0
					powertossbarkage2 = 0 
					DProgress:SetFraction( powertossbarkage2 )  
				end 
			else //back shoot toss
				if buttonpresstosskage3 == 0 then 

				elseif buttonpresstosskage3 == 1 then 
					MainFrame2:SetVisible(false)
					buttonpresstosskage3 = 0 
					KageSendToServer("shoot","back","quick")
					chat.AddText("Back Shoot Toss!")
				end 
			end 
		end 
	end)
end 

function KageFrontToss(setForce)
	powertossbarkage = 0  
	powertosskage = 0 
	buttonpresstosskage = 0  

	powertossbarkage2 = 0  
	powertosskage2 = 0 
	buttonpresstosskage2 = 0

	hook.Add( "Tick", "Kage_toss", function()
		
		local keySetting 
		if allow_left_assist == false then
			keySetting = KEY_R
		else 
			keySetting = KEY_LBRACKET
		end

		if (input.IsButtonDown(keySetting)) then
			buttonpresstosskage = 1 
			MainFrame2:SetVisible(true)
			powertosskage = powertosskage + 1 
			powertossbarkage = powertossbarkage + 0.04  
			DProgress:SetFraction( powertossbarkage )


		else 
			if buttonpresstosskage == 0 then 

			elseif buttonpresstosskage == 1 then 
				buttonpresstosskage = 0 
				MainFrame2:SetVisible(false)
				if powertosskage <= setForce then 
				
					KageSendToServer("weak","front","king")
					chat.AddText("Short Toss!")
					powertosskage = 0
					powertossbarkage = 0 
					DProgress:SetFraction( powertossbarkage )  
					print( "reset" )

				elseif powertosskage < 20 then 
					KageSendToServer("medium","front","king")
					chat.AddText("Medium Toss!")
					powertosskage = 0  
					powertossbarkage = 0 
					DProgress:SetFraction( powertossbarkage ) 
					print( "reset" )

				else 
					KageSendToServer("high","front","king")
					chat.AddText("Power Toss!")
					powertosskage = 0  
					powertossbarkage = 0 
					DProgress:SetFraction( powertossbarkage ) 
					print( "reset" )
				end  
				powertosskage = 0
				powertossbarkage = 0 
				DProgress:SetFraction( powertossbarkage )  
			end 
		end 
	end)

end 

function CutSendToServer(direction,power)  
	if ply:GetPos():WithinAABox( pos1, pos2 ) then
		position = "left"
	else 
		position = "right"
	end 
	net.Start("bokuto_cut")
	net.WriteString(position)
	net.WriteString(direction)
	net.WriteString(power)
	net.SendToServer()
end

function MiyaServe()
	 miya_pos1 = Vector(1300.494019, -261.572266, -119.701813) 
	 miya_pos2 = Vector(670.607239, -30.208231, 199.167160) 
	 miya_pos3 = Vector( 676.425293 ,888.083191, -108.272842) 
	 miya_pos4 = Vector(1375.196899, 661.645447, 262.988831) 

	 miya_active = false 


	hook.Add("PlayerButtonDown","miya_serve",function(ply,button)
		

		local keySettingR,keySettingT 

		if allow_left_assist == false then
			keySettingR = KEY_R
			keySettingT = KEY_T
		else 
			keySettingR = KEY_LBRACKET
			keySettingT = KEY_SEMICOLON
		end


		if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
			if button == keySettingR then

				net.Start("check_miya_position")
				net.SendToServer() 
				--chat.AddText(Color(255,0,0),"Miya Serve is active")

				hook.Remove("PlayerButtonDown","miya_serve",function(ply,button) end) 
				--hook.Remove( "Tick", "KeyDown_Toss", function() end )
				hook.Remove( "Tick", "Kage_toss2", function() end)

				hook.Add("PlayerButtonDown","miya_serve2",function(ply,button)
					if button == keySettingR then
						if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
							
							net.Start("miya_ability")
							net.WriteString("tossup")
							net.SendToServer()

						else 
							hook.Remove("PlayerButtonDown","miya_serve2",function() end) 
							MiyaServe()
						end 
					end 

					if button == keySettingT then 
						if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
							if character == "miya" then 
								net.Start("miya_ability")
								net.WriteString("spike")
								net.WriteString("miya")
								net.SendToServer()
							elseif character == "korai" then 
								-- net.Start("miya_ability")
								-- net.WriteString("spike")
								-- net.WriteString("korai")
								-- net.SendToServer()
							end 

							hook.Remove("PlayerButtonDown","miya_serve2",function() end) 
							hook.Remove( "Tick", "KeyDown_Toss", function() end )
							hook.Remove( "Tick", "Kage_toss2", function() end)

							local ent =  ents.FindByClass( "prop_physics*" )
							for k, v in pairs( ent ) do  
								if ply:GetPos():DistToSqr( ent[k]:GetPos() ) < 170*170 then  
									-- END FAKE BALL VELOCITY -------------------------
									-- Function to check if the entity's physics object is on the ground
									function IsEntityOnGround(entity)
										-- Get the position of the entity
										local posBall = entity:GetPos()
										
										-- Trace a line downward to check for ground collision
										local traceBall = util.TraceLine({
											start = posBall,
											endpos = posBall - Vector(0, 0, 25), -- Adjust the length based on your needs
											mask = MASK_OPAQUE
										})
										
										-- Return true if the trace hits the ground, false otherwise
										return traceBall.Hit
									end

										-- Function to check if the entity's physics object is on the ground and create a ground marker if so
									function BallGroundCheck() 
										-- Usage example
										if IsEntityOnGround(ent[k]) then
											hook.Remove("Think", "BallChecker") -- Remove the hook as it's no longer needed
											net.Start("BallHitGround")
											net.WriteVector(ent[k]:GetPos())
											net.WriteEntity(ent[k])
											net.SendToServer()
											--CreateGroundMarker(ent[k]:GetPos()) -- Create a ground marker at the position of the entity
										else
											hook.Add("Think", "BallChecker", BallGroundCheck) -- Add the hook to keep checking
										end
									end 

									-- Start checking if the ball is on the ground
									BallGroundCheck()

								end 
							end 


							MiyaServe()
							timer.Create("re",1,1,function() 
								chat.AddText("Set is now usable")
								TossPower(10)
								if character == "miya" then 
									KageQuickToss(10)
								end 
								timer.Stop("re")
							end) 
						
						else 
							--hook.Remove("PlayerButtonDown","miya_serve2",function() end)
							--TossPower(10)
							--KageQuickToss(10)
							if character == "miya" then 
								net.Start("miya_ability")
								net.WriteString("spike")
								net.WriteString("miya")
								net.SendToServer()
							elseif character == "korai" then 
								-- net.Start("miya_ability")
								-- net.WriteString("spike")
								-- net.WriteString("korai")
								-- net.SendToServer()
							end 

							hook.Remove("PlayerButtonDown","miya_serve2",function() end) 
							hook.Remove( "Tick", "KeyDown_Toss", function() end )
							hook.Remove( "Tick", "Kage_toss2", function() end)
							
							local ent =  ents.FindByClass( "prop_physics*" )
							for k, v in pairs( ent ) do  
								if ply:GetPos():DistToSqr( ent[k]:GetPos() ) < 170*170 then  
									-- END FAKE BALL VELOCITY -------------------------
									-- Function to check if the entity's physics object is on the ground
									function IsEntityOnGround(entity)
										-- Get the position of the entity
										local posBall = entity:GetPos()
										
										-- Trace a line downward to check for ground collision
										local traceBall = util.TraceLine({
											start = posBall,
											endpos = posBall - Vector(0, 0, 25), -- Adjust the length based on your needs
											mask = MASK_OPAQUE
										})
										
										-- Return true if the trace hits the ground, false otherwise
										return traceBall.Hit
									end

									-- Function to check if the entity's physics object is on the ground and create a ground marker if so
									function BallGroundCheck() 
										-- Usage example
										if IsEntityOnGround(ent[k]) then
											hook.Remove("Think", "BallChecker") -- Remove the hook as it's no longer needed
											net.Start("BallHitGround")
											net.WriteVector(ent[k]:GetPos())
											net.WriteEntity(ent[k])
											net.SendToServer()
											--CreateGroundMarker(ent[k]:GetPos()) -- Create a ground marker at the position of the entity
										else
											hook.Add("Think", "BallChecker", BallGroundCheck) -- Add the hook to keep checking
										end
									end 

									-- Start checking if the ball is on the ground
									BallGroundCheck()

								end 
							end 


							MiyaServe()


							hook.Remove("PlayerButtonDown","miya_serve2",function() end)
							MiyaServe()
							TossPower(10)
							if character == "miya" then 
								KageQuickToss(10)
							end 						
						end 
					end 
				end) 
			end 

		else 

		end 


	end)
end 


function BokutoSpike(setForce)
	ply = LocalPlayer() 
	pb_left = 0  
	leftpower = 0 
	leftbuttonpress = 0 

	pb_right = 0  
	rightpower = 0 
	rightbuttonpress = 0 


	
	hook.Add( "Tick", "keydownboku", function()

		local keySettingR,keySettingT 

		if allow_left_assist == false then
			keySettingR = KEY_R
			keySettingT = KEY_T
		else 
			keySettingR = KEY_LBRACKET
			keySettingT = KEY_SEMICOLON
		end


		if (input.IsButtonDown(keySettingR)) then
			leftbuttonpress = 1 
			MainFrame2:SetVisible(true)
			leftpower = leftpower + 1 
			pb_left = pb_left + 0.04 
			DProgress:SetFraction( pb_left )

		else 
			if leftbuttonpress == 0 then 

			elseif leftbuttonpress == 1 then 
				leftbuttonpress = 0 
				MainFrame2:SetVisible(false)
				if leftpower < setForce then 
					CutSendToServer("left","soft")
					leftpower = 0
					pb_left = 0 
					DProgress:SetFraction( pb_left )  

				else 
					CutSendToServer("left","power")
					leftpower = 0  
					pb_left = 0 
					DProgress:SetFraction( pb_left ) 
				end  
				leftpower = 0
				pb_left = 0 
				DProgress:SetFraction( pb_left )  
			end 
		end  


		if (input.IsButtonDown(keySettingT)) then
			rightbuttonpress = 1 
			MainFrame2:SetVisible(true)
			rightpower = rightpower + 1 
			pb_right = pb_right + 0.04 
			DProgress:SetFraction( pb_right )

		else 
			if rightbuttonpress == 0 then 

			elseif rightbuttonpress == 1 then 
				rightbuttonpress = 0 
				MainFrame2:SetVisible(false)
				if rightpower < setForce then 
					CutSendToServer("right","soft")
					rightpower = 0
					pb_right = 0 
					DProgress:SetFraction( pb_right )  

				else 
					CutSendToServer("right","power")
					rightpower = 0  
					pb_right = 0 
					DProgress:SetFraction( pb_right ) 
				end  
				rightpower = 0
				pb_right = 0 
				DProgress:SetFraction( pb_right )  
			end 
		end  
	end) 
end 

-- yamaguchi 
function YamaguchiServe()
	 miya_pos1 = Vector(1300.494019, -261.572266, -119.701813) 
	 miya_pos2 = Vector(670.607239, -30.208231, 199.167160) 
	 miya_pos3 = Vector( 676.425293 ,888.083191, -108.272842) 
	 miya_pos4 = Vector(1375.196899, 661.645447, 262.988831) 

	 miya_active = false 

	
	 
	hook.Add("PlayerButtonDown","yama_serve",function(ply,button)

		local keySettingR,keySettingT 

		if allow_left_assist == false then
			keySettingR = KEY_R
			keySettingT = KEY_T
		else 
			keySettingR = KEY_LBRACKET
			keySettingT = KEY_SEMICOLON
		end


		if button == keySettingR then
			if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
				--net.Start("check_miya_position")
				--net.SendToServer() 
				chat.AddText(Color(255,0,0),"Wait for 3 seconds to use yamaguchi float serve.")

				hook.Remove("PlayerButtonDown","yama_serve",function(ply,button) end) 
				hook.Remove( "Tick", "KeyDown_Toss", function() end )


				timer.Create("yama_cd",3,1,function() 
					hook.Add("PlayerButtonDown","yama_serve2",function(ply,button)
						if button == keySettingR then
							if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
								net.Start("yama_ability")
								net.WriteString("tossup")
								net.SendToServer()
							else 
								hook.Remove("PlayerButtonDown","yama_serve2",function() end) 
								YamaguchiServe()
							end 
						end 

						if button == keySettingT then 
							if  ply:GetPos():WithinAABox( miya_pos1, miya_pos2 ) or ply:GetPos():WithinAABox( miya_pos3, miya_pos4)  then 
								net.Start("yama_ability")
								net.WriteString("spike")
								net.SendToServer()
								--hook.Remove("PlayerButtonDown","miya_serve2",function() end) 
								YamaguchiServe()
								--TossPower(10)
							else 
								hook.Remove("PlayerButtonDown","yama_serve2",function() end)
								YamaguchiServe() 
								--MiyaServe()
							end 
						end 
					end) 
				end) 
			end 
	
			--hook.Remove("PlayerButtonDown","miya_serve",function(ply,button) end) 

		else 
			--hook.Remove("PlayerButtonDown","miya_serve2",function(ply,button) end) 
		end 


	end)
end 




-- Whenever the player wants to enable jumping (e.g., through a command or other logic):
-- Set jumpDisabled to false
-- Example: jumpDisabled = false




--- receive old mechanic 
-- BASIC 
-- function ReceivePower(setForce)
-- 	ply = LocalPlayer() 
-- 	powerreceivebar = 0  
-- 	powerreceive = 0 
-- 	--jumpcount = 0 
-- 	buttonpressrec = 0 


-- 	hook.Add( "Tick", "KeyDown_Testis", function()

-- 		if (input.IsButtonDown(KEY_V)) then
-- 			buttonpressrec = 1 
-- 			MainFrame2:SetVisible(true)
-- 			powerreceive = powerreceive + 1 
-- 			powerreceivebar = powerreceivebar + 0.04  
-- 			DProgress:SetFraction( powerreceivebar )
-- 			print( "Player is charging receive power! Power: ".. powerreceivebar )

-- 		else 
-- 			if buttonpressrec == 0 then 

-- 			elseif buttonpressrec == 1 then 
-- 				buttonpressrec = 0 
-- 				MainFrame2:SetVisible(false)
-- 				if character == "nishinoya" then 
-- 					if powerreceive < setForce then 
					
-- 						ReceiveSendToServer("weak")
-- 						chat.AddText("Short Receive!")
-- 						powerreceive = 0
-- 						powerreceivebar = 0 
-- 						DProgress:SetFraction( powerreceivebar )  
-- 						print( "reset" )

-- 					elseif powerreceive < 20 then  
-- 						ReceiveSendToServer("strong")
-- 						chat.AddText("Long Receive!")
-- 						powerreceive = 0  
-- 						powerreceivebar = 0 
-- 						DProgress:SetFraction( powerreceivebar ) 
-- 						print( "reset" )
-- 					else 
-- 						ReceiveSendToServer("highball")
-- 						chat.AddText("High ball Receive!")
-- 						powerreceive = 0  
-- 						powerreceivebar = 0 
-- 						DProgress:SetFraction( powerreceivebar ) 
-- 						print( "reset" )
-- 					end   
-- 				else 

-- 					if powerreceive < setForce then 
					
-- 						ReceiveSendToServer("weak")
-- 						chat.AddText("Short Receive!")
-- 						powerreceive = 0
-- 						powerreceivebar = 0 
-- 						DProgress:SetFraction( powerreceivebar )  
-- 						print( "reset" )

-- 					else 
-- 						ReceiveSendToServer("strong")
-- 						chat.AddText("Long Receive!")
-- 						powerreceive = 0  
-- 						powerreceivebar = 0 
-- 						DProgress:SetFraction( powerreceivebar ) 
-- 						print( "reset" )
-- 					end  
-- 				end 

-- 				powerreceive = 0
-- 				powerreceivebar = 0 
-- 				DProgress:SetFraction( powerreceivebar )  
-- 			end 
-- 		end  
-- 	end) 
-- end 

-- BASIC 
function ReceivePower(setForce)
	ply = LocalPlayer() 
	powerreceivebar = 0  
	powerreceive = 0 
	--jumpcount = 0 
	buttonpressrec = 0 

	local ply = LocalPlayer() 
	local release_ball = false 

	hook.Add( "Tick", "KeyDown_Testis", function()

		local keySetting 
		if allow_left_assist == false then
			keySetting = KEY_V
		else 
			keySetting = KEY_APOSTROPHE
		end

		//if player choose to have 2.0 receive 
		if allow_old_receive == false then 
			if ply:IsOnGround()  then
				if release_ball == false then 
					if (input.IsButtonDown(keySetting)) then
						action_status = "RECEIVING"
						release_ball = false
						-- detect ball when hold button
						local ent =  ents.FindByClass( "prop_physics*" )
						for k, v in pairs( ent ) do    
							
							if LocalPlayer():GetPos():DistToSqr( ent[k]:GetPos() ) < 80*80 then
								

								--print("detect ball")
								release_ball = true
								if set_power_level_receive == power_level_receive[1] then
									ReceiveSendToServer("weak",ent[k],false)
								else 
									ReceiveSendToServer("strong",ent[k],false)
								end 

								timer.Simple(1,function() release_ball = false end)
							end	
						end	
					else 
						--action_status = ""
					end 
				else 

				end 
			else 
				if release_ball == false then 
					if (input.IsButtonDown(keySetting)) then
						action_status = "FEINTING"
						release_ball = false
						-- detect ball when hold button
						local ent =  ents.FindByClass( "prop_physics*" )
						for k, v in pairs( ent ) do    
							
							if LocalPlayer():GetPos():DistToSqr( ent[k]:GetPos() ) < 80*80 then
								release_ball = true
								ReceiveSendToServer("feint",ent[k],false)
								timer.Simple(1,function() release_ball = false end)
							end	
						end	
					end 
				end
			end
		else //if prefer v hold (1.0 mechanic)
			if ply:IsOnGround()  then
				if release_ball == false then 
					if (input.IsButtonDown(keySetting)) then
						buttonpressrec = 1 
						MainFrame2:SetVisible(true)
						powerreceive = powerreceive + 1 
						powerreceivebar = powerreceivebar + 0.10 
						DProgress:SetFraction( powerreceivebar )
						//print( "Player is charging receive power! Power: ".. powerreceivebar )
			
					else 
						if buttonpressrec == 0 then 
			
						elseif buttonpressrec == 1 then 
							buttonpressrec = 0 
							MainFrame2:SetVisible(false)
							local ent =  ents.FindByClass( "prop_physics*" )
							for k, v in pairs( ent ) do    
								release_ball = true
								if powerreceive < setForce then 
								
									ReceiveSendToServer("weak",ent[k],true)
									
									powerreceive = 0
									powerreceivebar = 0 
									DProgress:SetFraction( powerreceivebar )  
									release_ball = false
								else 
									ReceiveSendToServer("strong",ent[k],true)
									
									powerreceive = 0  
									powerreceivebar = 0 
									DProgress:SetFraction( powerreceivebar ) 
									release_ball = false
								end  
							end 
							powerreceive = 0
							powerreceivebar = 0 
							DProgress:SetFraction( powerreceivebar )  

						end 
					end 
				end 
			else 
				if release_ball == false then 
					if (input.IsButtonDown(keySetting)) then
						action_status = "FEINTING"
						release_ball = false
						-- detect ball when hold button
						local ent =  ents.FindByClass( "prop_physics*" )
						for k, v in pairs( ent ) do    
							
							if LocalPlayer():GetPos():DistToSqr( ent[k]:GetPos() ) < 80*80 then
								release_ball = true
								ReceiveSendToServer("feint",ent[k],false)
								timer.Simple(1,function() release_ball = false end)
							end	
						end	
					end 
				end
			end 
		end 
	end) 
end 

function TossPower(setForce)
	ply = LocalPlayer() 
	powertossbar = 0  
	powertoss = 0 
	--jumpcount = 0 
	buttonpresstoss = 0 


	
	hook.Add( "Tick", "KeyDown_Toss", function()
		local keySetting 
		if allow_left_assist == false then
			keySetting = KEY_C
		else 
			keySetting = KEY_SLASH
		end

		if (input.IsButtonDown(keySetting)) then
			buttonpresstoss = 1 
			MainFrame2:SetVisible(true)
			powertoss = powertoss + 1 
			powertossbar = powertossbar + 0.04  
			DProgress:SetFraction( powertossbar )

		else 
			if buttonpresstoss == 0 then 

			elseif buttonpresstoss == 1 then 
				buttonpresstoss = 0 
				MainFrame2:SetVisible(false)
				if powertoss <= setForce then 
				
					TossSendToServer("weak","front")
					powertoss = 0
					powertossbar = 0 
					DProgress:SetFraction( powertossbar )  
					print( "reset" )

				elseif powertoss < 20 then 
					TossSendToServer("medium","front")
					powertoss = 0  
					powertossbar = 0 
					DProgress:SetFraction( powertossbar ) 
					print( "reset" )

				else 
					TossSendToServer("high","front")
					powertoss = 0  
					powertossbar = 0 
					DProgress:SetFraction( powertossbar ) 
					print( "reset" )
				end  
				powertoss = 0
				powertossbar = 0 
				DProgress:SetFraction( powertossbar )  
			end 
		end 
	end) 
end 



function BackTossPower(setForce)
	powertossbar2 = 0  
	powertoss2 = 0 
	--jumpcount = 0 
	buttonpresstoss2 = 0  

	hook.Add( "Tick", "KeyDown_Toss2", function()
		local keySetting 
		if allow_left_assist == false then
			keySetting = KEY_F
		else 
			keySetting = KEY_RBRACKET
		end

		
		if (input.IsButtonDown(keySetting)) then
			buttonpresstoss2 = 1 
			MainFrame2:SetVisible(true)
			powertoss2 = powertoss2 + 1 
			powertossbar2 = powertossbar2 + 0.04  
			DProgress:SetFraction( powertossbar2 )


		else 
			if buttonpresstoss2 == 0 then 

			elseif buttonpresstoss2 == 1 then 
				buttonpresstoss2 = 0 
				MainFrame2:SetVisible(false)
				if powertoss2 <= setForce then 
				
					TossSendToServer("weak","back")
					powertoss2 = 0
					powertossbar2 = 0 
					DProgress:SetFraction( powertossbar2 )  
					print( "reset" )

				elseif powertoss2 < 20 then 
					TossSendToServer("medium","back")
					powertoss2 = 0  
					powertossbar2 = 0 
					DProgress:SetFraction( powertossbar2 ) 
					print( "reset" )

				else 
					TossSendToServer("high","back")
					powertoss2 = 0  
					powertossbar2 = 0 
					DProgress:SetFraction( powertossbar2 ) 
					print( "reset" )
				end  
				powertoss2 = 0
				powertossbar2 = 0 
				DProgress:SetFraction( powertossbar2 )  
			end 
		end 
	end)
end 




default_block = false 
blocking = false  


hook.Add("PlayerButtonDown","Block",function(ply,button)	

	local keySetting 
	if allow_left_assist == false then
		keySetting = KEY_Q
	else 
		keySetting = KEY_P
	end
	
	if button == keySetting then
		
		if blocking == true then
		
		else 
			ply:ConCommand("pac_event block")
			blocking = true  
			timer.Simple(1,function() blocking = false end)

			default_block = true 
		 
			print("char:"..character)
		
			ply:ConCommand("pac_event block") 
			if !ply:IsOnGround() then 
				if ply:GetPos():WithinAABox( pos1, pos2 ) then 
					net.Start("create_wall")
					net.WriteString("left")
					net.WriteString("block_left")
					net.WriteString(character)
					net.WriteBool(default_block)
					net.SendToServer() 
				elseif ply:GetPos():WithinAABox( pos3, pos4 ) then 
					net.Start("create_wall")
					net.WriteString("right")
					net.WriteString("block_left")
					net.WriteString(character)
					net.WriteBool(default_block)
					net.SendToServer() 
				end 
			end 
		end 
	end 

	-- if character == "kuro" then 
	-- 	if button == KEY_R then  // when kuro lean left
	-- 		if !ply:IsOnGround()  then
	-- 			net.Start("create_wall")
	-- 			net.WriteString("right")
	-- 			net.WriteString("block_left")
	-- 			net.WriteString("kuro")
	-- 			net.WriteBool(default_block)
	-- 			net.SendToServer() 
	-- 		end 
	-- 	elseif button == KEY_T then // when kuro lean right
	-- 		if !ply:IsOnGround()  then
	-- 			net.Start("create_wall")
	-- 			net.WriteString("right")
	-- 			net.WriteString("block_right")
	-- 			net.WriteString("kuro")
	-- 			net.WriteBool(default_block)
	-- 			net.SendToServer() 
	-- 		end 
	-- 	end 
	-- end 
end)

function DivePower(setForce)
	ply = LocalPlayer() 
	pb_dive = 0  
	divepower = 0 
	divebuttonpress = 0 


	
	hook.Add( "Tick", "keydowndive", function()

		if (input.IsButtonDown(KEY_Q)) then
			divebuttonpress = 1 
			MainFrame2:SetVisible(true)
			divepower = divepower + 1 
			pb_dive = pb_dive + 0.04 
			DProgress:SetFraction( pb_dive )
			print( "Player is charging spike power! Power: ".. pb_dive )

		else 
			if divebuttonpress == 0 then 

			elseif divebuttonpress == 1 then 
				divebuttonpress = 0 
				MainFrame2:SetVisible(false)
				if divepower < setForce then 
					DiveSendToServer("short")
					chat.AddText("Short Dive")
					divepower = 0
					pb_dive = 0 
					DProgress:SetFraction( pb_dive )  
					print( "reset" )

				else 
					DiveSendToServer("long")
					chat.AddText("Long Dive")
					divepower = 0  
					pb_dive = 0 
					DProgress:SetFraction( pb_dive ) 
					print( "reset" )
				end  
				divepower = 0
				pb_dive = 0 
				DProgress:SetFraction( pb_dive )  
			end 
		end  
	end) 
end 

activateJumpBoost = false  
activateNoJumpBoost = false 

function KoraiJumpBoost()
	print("Korai Jump Boost activated")
	isRunning = false
	timerName = "RunTimer"
	
	if character == "korai" then 
		hook.Add("Think", "LocalPlayerRunDetection", function()
			local ply = LocalPlayer()
			if IsValid(ply) and ply:Alive() and ply:IsOnGround() then
				velocity = ply:GetVelocity():Length2D() -- Get the 2D velocity length (ignoring vertical component)
				runSpeed = ply:GetRunSpeed()
		
				if velocity > runSpeed * 0.8 then -- You can adjust the threshold as needed
					-- Player is running
					if not isRunning then
						isRunning = true
						timer.Create(timerName, 0.5, 1, function()
							action_status = "JUMP BOOST ACQUIRED!"
							activateJumpBoost = true 

							if activateJumpBoost then 
								
								net.Start("hoshiumi_jump")
								net.WriteString("boost")
								net.WriteString("im korai")
								net.SendToServer()

								hook.Add("PlayerButtonDown","koraiJump",function(ply,button) 
									if button == KEY_SPACE then 
										local randomSoundKoraiJump = {"korai/highjump1.wav","korai/highjump2.wav"} 
										hook.Remove("PlayerButtonDown","koraiJump",function(ply,button) end)
										surface.PlaySound(table.Random(randomSoundKoraiJump), 80, 100, 1, CHAN_AUTO )
									end 
								end)

								
								timer.Simple(0.5,function() activateJumpBoost = false end)
							end
						end)
					end
				else
					-- Player is not running
					if isRunning then
						isRunning = false
						timer.Remove(timerName)
						action_status = ""
						if activateNoJumpBoost == false then 
							activateNoJumpBoost = true  
							net.Start("hoshiumi_jump")
							net.WriteString("noboost")
							net.SendToServer()

							timer.Simple(1,function() activateNoJumpBoost = false end)
						end 
					end
				end
			end
		end)
	else 
		hook.Remove("Think", "LocalPlayerRunDetection", function() end) 
	end 
end 


timer.Simple(2,function() 

	local zoomSpeed = 5 -- Adjust as needed
	local minFOV = 60
	local maxFOV = 140
	local currentFOV = 90 -- Initial FOV (adjust as needed)

	local function SmoothZoom()
		local targetFOV = math.Clamp(currentFOV, minFOV, maxFOV)
		currentFOV = Lerp(FrameTime() * zoomSpeed, currentFOV, targetFOV)
		LocalPlayer():SetFOV(currentFOV, 0.1)
	end

	hook.Add("PlayerButtonDown", "ZoomCharacter", function(ply, button)
		if button == MOUSE_WHEEL_UP then
	
			currentFOV = currentFOV - zoomSpeed
		elseif button == MOUSE_WHEEL_DOWN then

			currentFOV = currentFOV + zoomSpeed
		end
	end)

	hook.Add("Think", "SmoothZoomCharacter", SmoothZoom)
end) 



-------- Nak check postiion player -----------

-- local function IsInside( pos, ent )
-- 	if ( not IsValid( ent ) ) then return false end

-- 	local vmin = ent:OBBMins()
-- 	local vmax = ent:OBBMaxs()
-- 	local vpos = ent:WorldToLocal( pos )



-- 	return vpos:WithinAABox( vmax, vmin )
-- end

 
hook.Add("PlayerButtonDown","checkPosition",function(ply,button)
	if button == KEY_P then
		
		hook.Add("PostDrawTranslucentRenderables", "TestPlayerInBox", function()
			// Check if the player is inside the box
			local col = Color(255, 0, 0)
			// Draw the box
			render.DrawWireframeBox(Vector(0,0,0), Angle(0,0,0), pos1, pos2, col, true)
			render.DrawWireframeBox(Vector(0,0,0), Angle(0,0,0), pos3, pos4, col, true)
		end) 


	end 
end)

-- Client-side script to detect the "R" key press and notify the server

-- hook.Add("Think", "DetectRKeyPress", function()
--     if input.IsKeyDown(KEY_R) then
--         -- Prevent multiple triggers by checking if the key was previously down
--         if not LocalPlayer().keyRWasDown then
--             LocalPlayer().keyRWasDown = true
--             -- Send a net message to the server
--             net.Start("PlayerJumpRequest")
--             net.SendToServer()
--         end
--     else
--         LocalPlayer().keyRWasDown = false
--     end
-- end)


