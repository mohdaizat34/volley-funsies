--ability 
util.AddNetworkString("kage_toss_ability")
util.AddNetworkString("check_miya_position")
util.AddNetworkString("miya_ability")
util.AddNetworkString("yama_ability")
util.AddNetworkString("revertspeed") 
util.AddNetworkString("bokuto_cut") 
util.AddNetworkString("hoshiumi_jump")
--basic  
util.AddNetworkString("spiker_feint")
util.AddNetworkString("basic_serve")
util.AddNetworkString("spike_power_hinata")
util.AddNetworkString("fake_spike")
util.AddNetworkString("receive_power") 
util.AddNetworkString("block_power")
util.AddNetworkString("toss_power") 
util.AddNetworkString("dive_power") 
util.AddNetworkString("ref")
util.AddNetworkString("predictBall")
util.AddNetworkString("graphicprediction")
util.AddNetworkString("stopMomentum")

util.AddNetworkString("create_wall")
util.AddNetworkString("topDownView")

--lag compensate 
util.AddNetworkString("illusion_effect") 
--ball detector
util.AddNetworkString("BallHitGroundClient")
util.AddNetworkString("BallHitGround") 
-- collide 
util.AddNetworkString("get_collide_info")  
util.AddNetworkString("PrintEveryone")  

hook.Add("PlayerInitialSpawn","test",function(ply)
	ply:SetCollisionGroup( COLLISION_GROUP_WORLD)
end)

hook.Add("PlayerSpawn","test",function(ply)
	ply:SetCollisionGroup( COLLISION_GROUP_WORLD)
end)


net.Receive("get_collide_info",function(bits,ply)
	local ent1 = net.ReadEntity() 
	local ent2 = net.ReadEntity() 

	print("ENTITY COLLIDE NAME ----------------------")
	print(ent1:GetName())
	print(ent2:GetName())

	if ent1:GetClass() == "prop_physics" then 
		ent1:GetPhysicsObject():SetMaterial("dirt")
		print("yeah ent1 is the ball")
		if ent2:GetName() == "kabe" then
			PrintMessage(HUD_PRINTTALK, "BLOCK HIT!")
			PrintMessage(HUD_PRINTCENTER, "BLOCK HIT!")
		end 
	elseif ent2:GetClass() == "prop_physics" then 
		ent2:GetPhysicsObject():SetMaterial("dirt")
		print("yeah ent2 is the ball")
		if ent1:GetName() == "kabe" then
			PrintMessage(HUD_PRINTTALK, "BLOCK HIT!")
			PrintMessage(HUD_PRINTCENTER, "BLOCK HIT!")
		end 
	else 

	end 


	-- if ent2:GetName() == "kabe" then 
	-- 	PrintMessage(HUD_PRINTTALK, "BLOCK HIT!")
	-- 	PrintMessage(HUD_PRINTCENTER, "BLOCK HIT!")
	-- 	net.Start("PrintEveryone")
	-- 	net.WriteString("BLOCK HIT!")
	-- 	net.Broadcast() 
	-- end 

end) 

net.Receive("BallHitGround",function(bits,ply)
	local ballPos = net.ReadVector() 
	local ballEnt = net.ReadEntity() 

	ballEnt:SetElasticity(0.3) -- 1 means maximum bounciness, 0 means no bounce
	ballEnt:GetPhysicsObject():SetMaterial("dirt")
	EmitSound( "ballimpact2.wav", ballPos, 0, CHAN_AUTO, 1, 75, 0, 100 )
	
	net.Start("BallHitGroundClient")
	net.WriteVector(ballPos)
	net.WriteEntity(ballEnt)
	net.Broadcast() 
end) 


ball_status = ""
one_time_message = ""
isReceived = false 
isSpiked = false 


local cooldown = false
net.Receive("create_wall",function(bits,ply)
	local blocker = ents.Create( "prop_dynamic" )
	local blockerMedium = ents.Create( "prop_dynamic" )
	local blockerTsuki = ents.Create( "prop_dynamic" )
	local blockerKuro = ents.Create( "prop_dynamic" )

	local position = net.ReadString()  
	local tsuki_direction = net.ReadString() 
	local character = net.ReadString() 
	local default_block = net.ReadBool() 

	print("char:"..character)
    blocker:SetModel( "models/props/court/blockpanel_s.mdl" )
	blockerMedium:SetModel( "models/props/court/blockpanel_medium.mdl" ) 
	blockerTsuki:SetModel( "models/props/court/blockpanel_m.mdl" )
	blockerKuro:SetModel( "models/props/court/blockpanel_medium.mdl" )
    -- blocker2:SetModel( "models/props_debris/metal_panel01a.mdl" )
    -- tsukiBlock:SetModel( "models/props_debris/metal_panel01a.mdl" )


	-- -- debug 
	-- local blocker4 = ents.Create( "prop_dynamic" ) 
	-- blocker4:SetModel( "models/props/court/blockpanel_s.mdl" ) 
	-- blocker:SetMaterial( "models/wireframe" )
	-- blocker4:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	-- blocker4:SetPos( Vector(ply:GetPos().x+33,ply:GetPos().y-33,ply:GetPos().z+100) )
	-- blocker4:SetAngles(Angle(-15, 90, 0))
	-- blocker4:SetSolid(SOLID_VPHYSICS)
	-- blocker4:SetName("kabe")
	-- blocker4:Spawn()
	


	
	-- Set collision group for the blockers
	blocker:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	blockerMedium:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	blockerTsuki:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	blockerKuro:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	
----------DEFAULT (Q) BLOCK ------------------------------------------------------------------------
	local forward = ply:GetForward()
	local blockerPosition = ply:GetPos() + forward * 50 -- Adjust the distance as needed
	blockerPosition.z = blockerPosition.z + 100 -- Adjust the height as needed

	
	
	//KURO BLOCK -------------------------------------------------------------------------------
	local right = ply:GetRight()  -- Get the right vector based on the player's angles

	local distanceForward = 50  -- Adjust the distance forward as needed
	local distanceRight = 55    -- Adjust the distance to the right or left as needed
	local heightOffset = 95     -- Adjust the height as needed
	
	local blockerPositionKuroRight = ply:GetPos() + ply:GetForward() * distanceForward + right * distanceRight
	blockerPositionKuroRight.z = blockerPositionKuroRight.z + 100 -- Adjust the height as needed

	local blockerPositionKuroLeft = ply:GetPos() + ply:GetForward() * distanceForward - right * distanceRight
	blockerPositionKuroLeft.z = blockerPositionKuroLeft.z + 100 -- Adjust the height as needed

	local angleKuro = ply:GetAngles()
    angleKuro.p = angleKuro.p - 15 -- Set pitch (up/down tilt) to 45 degrees
    angleKuro.y = angleKuro.y + 180 
    angleKuro.r = 5-- Set roll (side tilt) to 45 degrees

	//-----------------------------------------------------------

	local angle = forward:Angle()
	angle.p = angle.p - 15 -- Tilt up by 15 degrees
	angle.y = angle.y + 180 -- Rotate by 180 degrees along the Y-axis

	--if default_block == true then 
	if position == "left" then 
		if character == "tsukishima" then 
			blockerTsuki:SetMaterial( "models/wireframe" )
			blockerTsuki:SetPos(blockerPosition)
			blockerTsuki:SetAngles(angle) -- Set the angles based on the player's forward vector
			blockerTsuki:SetSolid(SOLID_VPHYSICS)
			blockerTsuki:Spawn()
			blockerTsuki:SetNoDraw(false)
			cooldown = true 
		elseif character == "kuro" then
			if tsuki_direction == "block_right" then 
				angleKuro.r = -5 -- Set roll (side tilt) to 45 degrees
				blocker:SetMaterial( "models/wireframe" )
				blocker:SetPos(blockerPositionKuroRight)
				blocker:SetAngles(angleKuro) -- Set the angles based on the player's forward vector
				blocker:SetSolid(SOLID_VPHYSICS)
				blocker:Spawn()
				blocker:SetNoDraw(false)
				cooldown = true 
			elseif tsuki_direction == "block_left" then  
				angleKuro.r = 5
				blockerKuro:SetMaterial( "models/wireframe" )
				blockerKuro:SetPos(blockerPositionKuroLeft)
				blockerKuro:SetAngles(angleKuro) -- Set the angles based on the player's forward vector
				blockerKuro:SetSolid(SOLID_VPHYSICS)
				blockerKuro:Spawn()
				blockerKuro:SetNoDraw(false)
				cooldown = true 
			else 
				blocker:SetMaterial( "models/wireframe" )
				blocker:SetPos(blockerPosition)
				blocker:SetAngles(angle) -- Set the angles based on the player's forward vector
				blocker:SetSolid(SOLID_VPHYSICS)
				blocker:Spawn()
				blocker:SetNoDraw(false)
			cooldown = true 
			end 
		else 
			blocker:SetMaterial( "models/wireframe" )
			blocker:SetPos(blockerPosition)
			blocker:SetAngles(angle) -- Set the angles based on the player's forward vector
			blocker:SetSolid(SOLID_VPHYSICS)
			blocker:Spawn()
			blocker:SetNoDraw(false)
			cooldown = true 
		end 
	else 
		if character == "tsukishima" then 
			blockerTsuki:SetMaterial( "models/wireframe" )
			blockerTsuki:SetPos(blockerPosition)
			blockerTsuki:SetAngles(angle) -- Set the angles based on the player's forward vector
			blockerTsuki:SetSolid(SOLID_VPHYSICS)
			blockerTsuki:Spawn()
			blockerTsuki:SetNoDraw(false)
			cooldown = true 
		elseif character == "kuro" then 
			if tsuki_direction == "block_right" then 
				angleKuro.r = -5
				blockerKuro:SetMaterial( "models/wireframe" )
				blockerKuro:SetPos(blockerPositionKuroRight)
				blockerKuro:SetAngles(angleKuro) -- Set the angles based on the player's forward vector
				blockerKuro:SetSolid(SOLID_VPHYSICS)
				blockerKuro:Spawn()
				blockerKuro:SetNoDraw(false)
				cooldown = true 
			elseif tsuki_direction == "block_left" then 
				angleKuro.r = 5 
				blockerKuro:SetMaterial( "models/wireframe" )
				blockerKuro:SetPos(blockerPositionKuroLeft)
				blockerKuro:SetAngles(angleKuro) -- Set the angles based on the player's forward vector
				blockerKuro:SetSolid(SOLID_VPHYSICS)
				blockerKuro:Spawn()
				blockerKuro:SetNoDraw(false)
				cooldown = true 
			else 
				blocker:SetMaterial( "models/wireframe" )
				blocker:SetPos(blockerPosition)
				blocker:SetAngles(angle) -- Set the angles based on the player's forward vector
				blocker:SetSolid(SOLID_VPHYSICS)
				blocker:Spawn()
				blocker:SetNoDraw(false)
				cooldown = true 
			end 
		else 
			blocker:SetMaterial( "models/wireframe" )
			blocker:SetPos(blockerPosition)
			blocker:SetAngles(angle) -- Set the angles based on the player's forward vector
			blocker:SetSolid(SOLID_VPHYSICS)
			blocker:Spawn()
			blocker:SetNoDraw(false)
			cooldown = true 
		end 
	end 
	timer.Simple( 1.2, function() cooldown = false  blockerTsuki:Remove() blockerKuro:Remove()  blocker:Remove() blockerMedium:Remove() end )

end)



net.Receive("topDownView",function(bits,ply)
 	mode = net.ReadString() 

 	if mode == "enable" then 
 		local viewcontrol = ents.FindByName('viewcontrol') 
        for j = 1, #viewcontrol do viewcontrol[j]:Fire('Enable', 1) end
 	else
 		local viewcontrol = ents.FindByName('viewcontrol')  
  		for j = 1, #viewcontrol do viewcontrol[j]:Fire('Disable', 1) end
 	end 
end)




 --------------------SPIKE MECHANICS-------------------------------------
net.Receive ("spike_power_hinata" , function(bits , ply )
	local position = net.ReadString()
	local power = net.ReadString()
	local spikepower = net.ReadInt(32)
	local character = net.ReadString() 
	local entityBall = net.ReadEntity()
	local entityPosVect = net.ReadVector() 
	local allow_spike_assist = net.ReadBool()
	    
	local ent =  ents.FindByClass( "prop_physics*" )

	ply:ConCommand("pac_event spike")   
	
	ply:SetCollisionGroup( COLLISION_GROUP_WORLD)


	if power == "weak" then 
		SpikePosition(entityBall,ply,position,700,0,entityPosVect,allow_spike_assist)  
	else 
		
		if character == "ushijima" then 
			--game.SetTimeScale( 0.1 )
			SpikePosition(entityBall,ply,position,spikepower,0,entityPosVect,allow_spike_assist) 
		else 
			SpikePosition(entityBall,ply,position,spikepower,0,entityPosVect,allow_spike_assist)
		end  
	end 
	
end)

net.Receive ("fake_spike" , function(bits , ply )
	ply:ConCommand("pac_event spike")
end) 


randomSoundBokuto = {"boku/spike2.mp3","boku/bokutospike2.mp3"}
randomSoundHinata = {"hina/hinataspike2.mp3","hina/hinataspike3.mp3"}
randomSoundKorai = {"korai/hoshiumispike1.wav","korai/hoshiumispike2.wav"} 
		
function SpikePosition(v,ply,position,power,arc,entityPosVect,allow_spike_assist)  
	
	v:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR) 
	local desiredZ = ply:GetPos().z - 10
	
	if position == "left" then 
		print("The ball is at pos 3 and 4:") 
		print(v:GetPos():WithinAABox( pos3, pos4 ))

		if v:GetPos():WithinAABox( pos3, pos4 ) then
			ply:ChatPrint("Can't spike ball over other team area!") 
		else 
			ball_status = "spike" 
			if power == 400 then 

			else 

			end 

			if isSpiked == false then 
				isSpiked = true 
				timer.Simple(1,function() isSpiked=false end)
					if ply:Ping() > 0 and allow_spike_assist == true then 
						v:SetPos(entityPosVect) -- Adjust the Z coordinate as needed
						--PrintMessage(HUD_PRINTTALK, ply:Nick().." is having high ping, high spike assist activated for this player.")
					else
						--v:SetPos(ply:GetPos() + Vector(0, 0, 90)) -- Adjust the Z coordinate as needed
						--PrintMessage(HUD_PRINTTALK, ply:Nick().." is having high ping, spike assist activated for this player.")
					end 
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * power)
					v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
					v:GetPhysicsObject():AddAngleVelocity(Vector(3000,0,0)) 

					-- Make the ball bouncy
					print("Material:")
					print(v:GetPhysicsObject():GetMaterial())
				
					v:GetPhysicsObject():SetMaterial("gmod_bouncy") -- Set the material to a bouncy material
					
					



					-- re appear ball for laggers issue 
					net.Start("illusion_effect")
					net.WriteString(ply:Nick())
					net.WriteEntity(v)
					net.WriteVector(entityPosVect)
					net.WriteEntity(ply)
					net.Broadcast()
					--end ---------------------


					-- Define the function to apply a downward force to the ball
					local function ApplyDownwardForce()
						local downwardForce = Vector(0, 0, -1600)  -- Adjust the force as needed
						v:GetPhysicsObject():ApplyForceCenter(downwardForce)
					end
					
					-- Set a timer to apply the downward force after 0.5 seconds
					timer.Simple(0.2, function()
						ApplyDownwardForce()
					end)

				--end 

				if power > 2500 then //ushijima
					ply:EmitSound("ushi/ushijimaspike2.wav", 70, 100, 1, CHAN_AUTO ) 
						SafeRemoveEntity( trail )	
						trail = util.SpriteTrail( v, 0, Color( 217, 72, 214,300 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/physbeam" )
					print( trail )
				elseif power == 1150 then //hinata
					local hinataSound = table.Random(randomSoundHinata)
					ply:EmitSound(hinataSound, 70, 100, 1, CHAN_AUTO ) 
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color( 255, 132, 0,300 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/physbeam" )
				elseif power == 1800 then //bokuto
					local bokutoSound = table.Random(randomSoundBokuto)
					ply:EmitSound(bokutoSound, 70, 100, 1, CHAN_AUTO ) 
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color(161, 161, 161,300 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/physbeam" )
				elseif power == 1300 then //korai
					local koraiSound = table.Random(randomSoundKorai)
					ply:EmitSound(koraiSound, 70, 100, 1, CHAN_AUTO ) 
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color(161, 161, 161,300 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/physbeam" )
				elseif power == 1200 then //kuro 
					-- local koraiSound = table.Random(randomSoundKorai)
					-- ply:EmitSound(koraiSound, 70, 100, 1, CHAN_AUTO ) 
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color(255, 65, 65), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/physbeam" )
				end
			end
		end 
	else  
		if v:GetPos():WithinAABox( pos1, pos2 ) then
			ply:ChatPrint("Can't spike ball over other team area!")

		else 
			ball_status = "spike" 
			if power == 400 then 

			else 
				--ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO ) 
			end
			if isSpiked == false then 
				isSpiked = true 
				timer.Simple(1,function() isSpiked=false end)
				if ply:Ping() > 0 and allow_spike_assist == true then 
					ply:SetCollisionGroup( COLLISION_GROUP_WORLD)
					v:SetPos(entityPosVect) -- Adjust the Z coordinate as needed
					--PrintMessage(HUD_PRINTTALK, ply:Nick().." is having high ping, high spike assist activated for this player.")
				else
					--v:SetPos(ply:GetPos() + Vector(0, 0, 90)) -- Adjust the Z coordinate as needed
					--PrintMessage(HUD_PRINTTALK, ply:Nick().." is having high ping, spike assist activated for this player.")
				end 
				-- Calculate the forward vector of the player's view

				print("right")

				local aimVector = ply:GetAimVector()

				-- Determine the power of the hit (you might need to adjust this value)


				-- Set the initial velocity of the volleyball object in the direction the player is aiming
				v:GetPhysicsObject():SetVelocity(aimVector * power)
				v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
				v:GetPhysicsObject():AddAngleVelocity(Vector(3000,0,0)) 
				-- Make the ball bouncy
				-- print("Material:")
				-- print(v:GetPhysicsObject():GetMaterial())
				v:SetElasticity(0) -- 1 means maximum bounciness, 0 means no bounce
				v:GetPhysicsObject():SetMaterial("gmod_bouncy") -- Set the material to a bouncy material

				-- Define the function to apply a downward force to the ball
				local function ApplyDownwardForce()
					local downwardForce = Vector(0, 0, -1500)  -- Adjust the force as needed
					v:GetPhysicsObject():ApplyForceCenter(downwardForce)
				end

				-- Set a timer to apply the downward force after 0.5 seconds
				timer.Simple(0.2, function()
					ApplyDownwardForce()
				end)

				net.Start("illusion_effect")
				net.WriteString(ply:Nick())
				net.WriteEntity(v)
				net.WriteVector(entityPosVect)
				net.WriteEntity(ply)
				net.Broadcast()

				if power > 2500 then //ushijima
					ply:EmitSound("ushi/ushijimaspike2.wav", 70, 100, 1, CHAN_AUTO ) 
						SafeRemoveEntity( trail )	
						trail = util.SpriteTrail( v, 0, Color( 217, 72, 214,300 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/physbeam" )
					print( trail )
				elseif power == 1150 then //hinata
					local hinataSound = table.Random(randomSoundHinata)
					ply:EmitSound(hinataSound, 70, 100, 1, CHAN_AUTO ) 
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color( 255, 132, 0,300 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/physbeam" )
				elseif power == 1800 then //bokuto
					local bokutoSound = table.Random(randomSoundBokuto)
					ply:EmitSound(bokutoSound, 70, 100, 1, CHAN_AUTO ) 
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color(161, 161, 161,300 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/physbeam" )
				elseif power == 1300 then //korai
					local koraiSound = table.Random(randomSoundKorai)
					ply:EmitSound(koraiSound, 70, 100, 1, CHAN_AUTO ) 
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color(161, 161, 161,300 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/physbeam" )
				elseif power == 1200 then //kuro 
					-- local koraiSound = table.Random(randomSoundKorai)
					-- ply:EmitSound(koraiSound, 70, 100, 1, CHAN_AUTO ) 
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color(255, 65, 65), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/physbeam" )
				end
			end
		end 
	end  
end  
 --------------------SPIKE end MECHANICS-------------------------------------
 
 function BlockPosition(v,ply,position,power,arc) 

	if position == "left" then 
	

		--[[v:GetPhysicsObject():SetVelocity(ply:GetForward() * power + Vector(0,0,arc))    -- standard 470 arc   110 power  
		ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO ) 
		ply:ConCommand("pac_event block")]]
		if v:GetPos():WithinAABox( pos3, pos4 ) then
			ply:ChatPrint("Can't receive ball over other team area!")
		else  
			v:GetPhysicsObject():SetVelocity(ply:GetForward() * power + Vector(0,0,arc))    -- standard 470 arc   110 power  
			ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO ) 
			ply:ConCommand("pac_event block")
	--ply:SetVelocity( ply:GetAimVector() * 1000 )  
		end 
	else
		if v:GetPos():WithinAABox( pos1, pos2 ) then
			ply:ChatPrint("Can't receive ball over other team area!")
		else 
			v:GetPhysicsObject():SetVelocity(ply:GetForward() * power + Vector(0,0,arc))      
			ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO ) 
			ply:ConCommand("pac_event block")
		end 

	end
end 

 function DivePosition(v,ply,position,power,arc) 

	if position == "left" then 
		if v:GetPos():WithinAABox( pos3, pos4 ) then
			ply:ChatPrint("Can't receive ball over other team area!")
		else  
			v:GetPhysicsObject():SetVelocity(ply:GetForward() * power + Vector(0,0,arc))    -- standard 470 arc   110 power  
			ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO ) 
			--ply:ConCommand("pac_event block")
	--ply:SetVelocity( ply:GetAimVector() * 1000 )  
		end 
	else
		if v:GetPos():WithinAABox( pos1, pos2 ) then
			ply:ChatPrint("Can't receive ball over other team area!")
		else 
			v:GetPhysicsObject():SetVelocity(ply:GetForward() * power + Vector(0,0,arc))      
			ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO ) 
			--ply:ConCommand("pac_event block")
	--ply:SetVelocity( ply:GetAimVector() * 1000 )  
		end 
	end
end 

function ReceivePosition(v,vPos,ply,position,power,arc,allow_receive_assist,allow_old_receive) 

	//reposition the ball
	local offsetInFront = ply:GetForward() * 10
	local newPosition = ply:GetPos() + offsetInFront
    newPosition.z = ply:GetPos().z + 50

	if allow_old_receive == false then 
		if position == "left" then 
			if v:GetPos():WithinAABox( pos3, pos4 ) then
				ply:ChatPrint("Can't receive ball over other team area! code 2")
			else  
				ball_status = "receive"  

				if arc < 300 then //if power is feint basically 
					// to prevent receive quickly
					if isSpiked == true then
						// kalau member spike, dia x boleh feint
					else
						ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
						v:GetPhysicsObject():SetVelocity(ply:GetForward() * power + Vector(0,0,arc))    -- standard 470 arc   110 power 
						v:SetPos(vPos)
						print("ini 1")
					end 
				else 
					// to prevent receive quickly 
					if isReceived == false then 
						isReceived = true 
						timer.Simple(0.5,function() isReceived = false end)	
						ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO )
						v:GetPhysicsObject():SetVelocity(ply:GetForward() * power + Vector(0,0,arc))    -- standard 470 arc   110 power 
							
						if allow_receive_assist == true then 
							v:SetPos(newPosition) -- Adjust the Z coordinate as needed
						end 
					end 
				end 
			end 
		else
			if v:GetPos():WithinAABox( pos1, pos2 ) then
				ply:ChatPrint("Can't receive ball over other team area! code 1")
			else 
				ball_status = "receive"  

				if arc < 300 then //if power is feint basically 
					// to prevent receive quickly
					if isSpiked == true then
						// kalau member spike, dia x boleh feint
					else
		
						ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
						v:GetPhysicsObject():SetVelocity(ply:GetForward() * power + Vector(0,0,arc))    -- standard 470 arc   110 power 
						v:SetPos(vPos)
						print("ini 1")
					end 
				else 
					// to prevent receive quickly 
					if isReceived == false then 
						isReceived = true 
						timer.Simple(0.5,function() isReceived=false end)
						ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO )
						v:GetPhysicsObject():SetVelocity(ply:GetForward() * power + Vector(0,0,arc))    -- standard 470 arc   110 power 	
						if allow_receive_assist == true then 
							v:SetPos(newPosition) -- Adjust the Z coordinate as needed
						end 
					end 
				end 
			end  
		end
	else //if old receive allowed (1.0 receive)
		if position == "left" then 
			if v:GetPos():WithinAABox( pos3, pos4 ) then
				ply:ChatPrint("Can't receive ball over other team area!")
			else  
				ball_status = "receive"  
				local ent =  ents.FindByClass( "prop_physics*" )
				for k, v in pairs( ent ) do    
					if ply:GetPos():DistToSqr( v:GetPos() ) < 105*105 then     
						ball_status = "receive"  

						if arc < 300 then //if power is feint basically 
							// to prevent receive quickly
							if isSpiked == true then
								// kalau member spike, dia x boleh feint
							else
								ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
								v:GetPhysicsObject():SetVelocity(ply:GetForward() * power + Vector(0,0,arc))    -- standard 470 arc   110 power 
								v:SetPos(vPos)
							end 
						else 
							// to prevent receive quickly 
							if isReceived == false then 
								isReceived = true 
								timer.Simple(0.5,function() isReceived = false end)	
								ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO )
								v:GetPhysicsObject():SetVelocity(ply:GetForward() * power + Vector(0,0,arc))    -- standard 470 arc   110 power 
				
								if allow_receive_assist == true then 
									v:SetPos(ply:GetPos() + Vector(0, 0, 50)) -- Adjust the Z coordinate as needed
								end 
							end 
						end 
					end 
				end 
			end 
		else
			if v:GetPos():WithinAABox( pos1, pos2 ) then
				ply:ChatPrint("Can't receive ball over other team area!")
			else 
				ball_status = "receive" 
				local ent =  ents.FindByClass( "prop_physics*" )
				for k, v in pairs( ent ) do    
					if ply:GetPos():DistToSqr( v:GetPos() ) < 105*105 then   
						ball_status = "receive"  

						if arc < 300 then //if power is feint basically 
							// to prevent receive quickly
							if isSpiked == true then
								// kalau member spike, dia x boleh feint
							else
				
								ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
								v:GetPhysicsObject():SetVelocity(ply:GetForward() * power + Vector(0,0,arc))    -- standard 470 arc   110 power 
								v:SetPos(vPos)
								print("ini 1")
							end 
						else 
							// to prevent receive quickly 
							if isReceived == false then 
								isReceived = true 
								timer.Simple(0.5,function() isReceived = false end)	
								ply:EmitSound("receive.mp3", 70, 100, 1, CHAN_AUTO )
								v:GetPhysicsObject():SetVelocity(ply:GetForward() * power + Vector(0,0,arc))    -- standard 470 arc   110 power 
								
								if allow_receive_assist == true then 
									v:SetPos(ply:GetPos() + Vector(0, 0, 50)) -- Adjust the Z coordinate as needed
								end 
							end 
						end 
					end 
				end 
			end 
		end
	end 
end 


function TossPosition(v,ply,position,power,arc,frontback,allow_set_assist) 

	SafeRemoveEntity( trail )	
	trail = util.SpriteTrail( v, 0, Color(102, 102, 102,800 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/plasma" )


	if frontback == "front" then 
		ply:ConCommand("pac_event jumptoss")
		ply:ConCommand("pac_event toss")


		if position == "left" then 
			if v:GetPos():WithinAABox( pos3, pos4 ) then
				ply:ChatPrint("Can't set ball over other team area!")
			else  
				ball_status = "set" 
				if allow_set_assist == true then 
					v:SetPos(ply:GetPos() + Vector(0, 0, 100))
				end 
				v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
				v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
				--[[timer.Create("serveking",0.1,1,function()      
					v:GetPhysicsObject():SetVelocity(ply:GetForward() *1000 + Vector(0,0,arc))           
				end)]]
				ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
				ply:ConCommand("pac_event jumpset")
				ply:ConCommand("pac_event set")
		--ply:SetVelocity( ply:GetAimVector() * 1000 )  
			end 
		else
			if v:GetPos():WithinAABox( pos1, pos2 ) then
				ply:ChatPrint("Can't set ball over other team area!")
			else 
				ball_status = "set"
				if allow_set_assist == true then 
					v:SetPos(ply:GetPos() + Vector(0, 0, 100))
				end 
				v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc))
				v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))    
				--[[timer.Create("serveking",0.1,1,function()      
					v:GetPhysicsObject():SetVelocity(ply:GetForward() * 400 + Vector(0,0,arc))           
				end)   ]]  
				ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
				ply:ConCommand("pac_event jumpset")
				ply:ConCommand("pac_event set")

		--ply:SetVelocity( ply:GetAimVector() * 1000 )  
			end 
		end
	else //backtoss

		if position == "left" then 
			if v:GetPos():WithinAABox( pos3, pos4 ) then
				ply:ChatPrint("Can't set ball over other team area!")
			else  
				ball_status = "set"
				if allow_set_assist == true then 
					v:SetPos(ply:GetPos() + Vector(0, 0, 100))
				end 
				v:GetPhysicsObject():SetVelocity(ply:GetForward() *power + Vector(0,0,arc)) 
				v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
				--[[timer.Create("serveking",0.1,1,function()      
					v:GetPhysicsObject():SetVelocity(ply:GetForward() *1000 + Vector(0,0,arc))           
				end)]]
				ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
				ply:ConCommand("pac_event jumpbackset")
				ply:ConCommand("pac_event backset")
		--ply:SetVelocity( ply:GetAimVector() * 1000 )  
			end 
		else
			if v:GetPos():WithinAABox( pos1, pos2 ) then
				ply:ChatPrint("Can't set ball over other team area!")

			else 
				ball_status = "set"
				if allow_set_assist == true then 
					v:SetPos(ply:GetPos() + Vector(0, 0, 100))
				end 
				v:GetPhysicsObject():SetVelocity(ply:GetForward() *power + Vector(0,0,arc))  
				v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))  
				--[[timer.Create("serveking",0.1,1,function()      
					v:GetPhysicsObject():SetVelocity(ply:GetForward() * 400 + Vector(0,0,arc))           
				end)   ]]  
				ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
				ply:ConCommand("pac_event jumpbackset")
				ply:ConCommand("pac_event backset")
		--ply:SetVelocity( ply:GetAimVector() * 1000 )  
			end 
		end
	end 
end 
---------------------------------------------------------------------
 
-- CHAR ABILITIES 
-- Kageyama
function KageTossPosition(v,ply,position,power,arc,frontback,timestop,tosstype,allow_set_assist)  
	ply:ConCommand("pac_event toss") 
	ply:ConCommand("pac_event jumptoss") 
	print(allow_set_assist)
	SafeRemoveEntity( trail )	
	trail = util.SpriteTrail( v, 0, Color(255, 0, 0,1000 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/plasma" )


	if tosstype == "king" then 
		if frontback == "front" then 
			SafeRemoveEntity( trail )	
			trail = util.SpriteTrail( v, 0, Color(255, 0, 0,1000 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/plasma" )
			if position == "left" then 
				if v:GetPos():WithinAABox( pos3, pos4 ) then
					ply:ChatPrint("Can't set ball over other team area!")
				else  
					ball_status = "set"
					if allow_set_assist == true then 
						v:SetPos(ply:GetPos() + Vector(0, 0, 100))
					end 
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
					v:GetPhysicsObject():AddAngleVelocity(Vector(0,2000,0)) 
					timer.Create("serveking",timestop,1,function() 
						if isSpiked == true then
							//if player spike before it king toss stop then cancel the stop motion.
						else
							v:GetPhysicsObject():SetVelocity(ply:GetForward() *50 + Vector(0,0,arc))  
						end      
					end)
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			else
				if v:GetPos():WithinAABox( pos1, pos2 ) then
					ply:ChatPrint("Can't set ball over other team area!")
				else  
					ball_status = "set"
					if allow_set_assist == true then 
						v:SetPos(ply:GetPos() + Vector(0, 0, 100))
					end
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
					v:GetPhysicsObject():AddAngleVelocity(Vector(0,2000,0)) 
					timer.Create("serveking",timestop,1,function() 
						if isSpiked == true then
							//if player spike before it king toss stop then cancel the stop motion.
						else
							v:GetPhysicsObject():SetVelocity(ply:GetForward() *50 + Vector(0,0,arc))  
						end         
					end)
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			end
		else 
			SafeRemoveEntity( trail )	
			trail = util.SpriteTrail( v, 0, Color(255, 0, 0,1000 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/plasma" )

			if position == "right" then 
				if v:GetPos():WithinAABox( pos1, pos2 ) then 
					ply:ChatPrint("Can't set ball over other team area!")
				else 
					ball_status = "set" 
					if allow_set_assist == true then 
						v:SetPos(ply:GetPos() + Vector(0, 0, 100))
					end
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
					v:GetPhysicsObject():AddAngleVelocity(Vector(0,2000,0)) 
					timer.Create("serveking",timestop,1,function() 
						--v:SetPos(ply:GetPos() + Vector(0, 0, 100))     
						v:GetPhysicsObject():SetVelocity(ply:GetForward() *50 + Vector(0,0,arc))        
					end)
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			else
				if v:GetPos():WithinAABox( pos1, pos2 ) then
					ply:ChatPrint("Can't set ball over other team area!")
				else  
					ball_status = "set"
					if allow_set_assist == true then 
						v:SetPos(ply:GetPos() + Vector(0, 0, 100))
					end
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
					v:GetPhysicsObject():AddAngleVelocity(Vector(0,2000,0)) 
					timer.Create("serveking",timestop,1,function() 
						--v:SetPos(ply:GetPos() + Vector(0, 0, 100))     
						v:GetPhysicsObject():SetVelocity(ply:GetForward() *50 + Vector(0,0,arc))         
					end)
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			end
		end 
	else 
		if frontback == "front" then 
			if position == "left" then 
				if v:GetPos():WithinAABox( pos3, pos4 ) then
					ply:ChatPrint("Can't set ball over other team area!")
					print(tosstype)
				else  
					ball_status = "set"
					if allow_set_assist == true then 
						v:SetPos(ply:GetPos() + Vector(0, 0, 100))
					end
					
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			else
				if v:GetPos():WithinAABox( pos1, pos2 ) then
					ply:ChatPrint("Can't set ball over other team area!")
				else  
					ball_status = "set"
					if allow_set_assist == true then 
						v:SetPos(ply:GetPos() + Vector(0, 0, 100))
					end
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			end
		else 
			if position == "right" then 
				if v:GetPos():WithinAABox( pos1, pos2 ) then 
					ply:ChatPrint("Can't set ball over other team area! haha")
				else  
					ball_status = "set"
					if allow_set_assist == true then 
						v:SetPos(ply:GetPos() + Vector(0, 0, 100))
					end
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
					
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			else
				if v:GetPos():WithinAABox( pos3, pos4 ) then
					ply:ChatPrint("Can't set ball over other team area! huhu")
				else  
					ball_status = "set"
					if allow_set_assist == true then 
						v:SetPos(ply:GetPos() + Vector(0, 0, 100))
					end
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() *power + Vector(0,0,arc)) 
					v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
					
					ply:EmitSound("toss2.mp3", 70, 100, 1, CHAN_AUTO )
			--ply:SetVelocity( ply:GetAimVector() * 1000 )  
				end 
			end
		end 
	end 
end 

net.Receive ("kage_toss_ability" , function(bits , ply )
	local position = net.ReadString()
	local power = net.ReadString()
	local frontback = net.ReadString() 
	local tosstype = net.ReadString() 
	local allow_set_assist = net.ReadBool() 
	 local ent =  ents.FindByClass( "prop_physics*" )

	

	for k, v in pairs( ent ) do    
		

		if tosstype == "king" then 
			if frontback == "front" then 
				ply:ConCommand("pac_event jumpset")
				if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then     
					ply:SetLagCompensated(true)
					ply:LagCompensation( true ) 
					--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
					--if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then  
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color(255, 84, 84,800 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/plasma" ) 
					v:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR)
					--v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800) 
					if isSpiked != true then 
						if power == "weak" then 
							KageTossPosition(v,ply,position,350,0,frontback,0.3,tosstype, allow_set_assist)
						elseif power == "medium" then 
							KageTossPosition(v,ply,position,480,0,frontback,0.4,tosstype, allow_set_assist)
						else 
							KageTossPosition(v,ply,position,540,0,frontback,0.6,tosstype, allow_set_assist)
						end 
					end
				end  
			else 
				if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then     
					ply:SetLagCompensated(true)
					ply:LagCompensation( true ) 
					--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
					--if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then 
						SafeRemoveEntity( trail )	
						trail = util.SpriteTrail( v, 0, Color(255, 84, 84,800 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/plasma" )  
						v:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR)
					if isSpiked != true then 
						if power == "weak" then 
							KageTossPosition(v,ply,position,-110,0,frontback,tosstype,allow_set_assist)
						elseif power == "medium" then 
							KageTossPosition(v,ply,position,-110,0,frontback,tosstype,allow_set_assist) 
						else 
							KageTossPosition(v,ply,position,-220,0,frontback,tosstype,allow_set_assist)
						end 
					end
				end  
			end  
		else 
			if frontback == "front" then 
				ply:ConCommand("pac_event jumpset")
				if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then     
					ply:SetLagCompensated(true)
					ply:LagCompensation( true ) 
					--v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
					--if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then 
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color(255, 84, 84,800 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/plasma" )  
					if isSpiked != true then 
						if power == "weak" then 
							KageTossPosition(v,ply,position,350,0,frontback,0.3,tosstype,allow_set_assist)
						elseif power == "medium" then 
							KageTossPosition(v,ply,position,480,0,frontback,0.4,tosstype,allow_set_assist)
						else 
							KageTossPosition(v,ply,position,600,0,frontback,0.6,tosstype,allow_set_assist)
						end 
					end  
				end  
			else 
				print("Back shoot toss")
				//back shoot toss 
				ply:ConCommand("pac_event backset")
                ply:ConCommand("pac_event jumpbackset")
				if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then     
					ply:SetLagCompensated(true)
					ply:LagCompensation( true ) 
					SafeRemoveEntity( trail )	
					trail = util.SpriteTrail( v, 0, Color(255, 84, 84,800 ), false, 15, 1, 0.3, 1 / ( 15 + 1 ) * 0.5, "trails/plasma" ) 
					if isSpiked != true then 
						if power == "shoot" then 
							KageTossPosition(v,ply,position,-600,180,frontback,0.3,tosstype,allow_set_assist)
						end 
					end
				end  
			end  
		end 
	end
end) 






-- MIYA---------------------------------------------------------------------------------------------------
net.Receive ("check_miya_position" , function(bits , ply )
	for k,v in pairs(player.GetAll()) do 
	--ply:EmitSound("miya/miya_theme2.mp3", 80, 100, 1, CHAN_AUTO ) 
		--v:ChatPrint("Get Ready! Miya is serving..")
	end 
end) 
 

net.Receive ("miya_ability" , function(bits , ply )
	local servetype = net.ReadString() 
	local character = net.ReadString() 
	local ent =  ents.FindByClass( "prop_physics*" )
	
	if servetype == "tossup" then 
		for k, v in pairs( ent ) do   
			if ply:GetPos():DistToSqr( v:GetPos() ) < 150*150 then     
				--if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then 
					v:GetPhysicsObject():SetVelocity(ply:GetForward() * 20 + Vector(0,0,700))
					v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
					v:GetPhysicsObject():AddAngleVelocity(Vector(2000,0,0))
					ply:EmitSound("tossup.mp3", 70, 100, 1, CHAN_AUTO )
				--end
			end   
		end 
	else 
		ply:ConCommand("pac_event spike") 
		for k, v in pairs( ent ) do   
			if ply:GetPos():DistToSqr( v:GetPos() ) < 150*150 then 

				v:GetPhysicsObject():SetMaterial("gmod_bouncy") -- Set the material to a bouncy material
				v:GetPhysicsObject():SetAngles(Angle(0, 0, 0))
				v:GetPhysicsObject():AddAngleVelocity(Vector(5000,0,0))
				timer.Simple(1,function() 
					v:GetPhysicsObject():SetMaterial("dirt") -- Set the material to a bouncy material
				end)
				--if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then 
				if character == "miya" then
					v:SetPos(ply:GetPos() + Vector(0, 0, 100))
					v:GetPhysicsObject():SetVelocity(ply:GetForward() * 1600 + Vector(0,0,30)) 
					
					-- Define the function to apply a downward force to the ball
					local function ApplyDownwardForce()
						local downwardForce = Vector(0, 0, -11000)  -- Adjust the force as needed
						v:GetPhysicsObject():ApplyForceCenter(downwardForce)
					end

					-- Set a timer to apply the downward force after 0.5 seconds
					timer.Simple(0.3, function()
						ApplyDownwardForce()
						ply:EmitSound("miya/miya_spike3.mp3", 70, 100, 1, CHAN_AUTO )  
						ply:ConCommand("pac_event spike")
					end)

				elseif character == "korai" then 
					v:GetPhysicsObject():SetVelocity(ply:GetForward() * 1200 + Vector(0,0,50)) 

					-- Define the function to apply a downward force to the ball
					local function ApplyDownwardForce()
						local downwardForce = Vector(0, 0, -7500)  -- Adjust the force as needed
						v:GetPhysicsObject():ApplyForceCenter(downwardForce)
					end

					-- Set a timer to apply the downward force after 0.5 seconds
					timer.Simple(0.3, function()
						ApplyDownwardForce()
						ply:EmitSound("korai/hoshiumispike2.wav", 70, 100, 1, CHAN_AUTO )  
						ply:ConCommand("pac_event spike")
					end)
				end 
				--end
			end   
		end 
	end 
end) 

--bokuto 
net.Receive ("bokuto_cut" , function(bits , ply )
	local position = net.ReadString()
	local direction = net.ReadString() 
	local power = net.ReadString() 
	local v = net.ReadEntity() 
	local entityPosVect = net.ReadVector() 

	local ent =  ents.FindByClass( "prop_physics*" )


		v:GetPhysicsObject():SetMaterial("gmod_bouncy") -- Set the material to a bouncy material
		ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO ) 
		--if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then 

		v:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR)

		timer.Create("collide",2,1,function() 
			v:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR)
		end)

		v:SetPos(Vector(entityPosVect))
		
		if position == "left" then  
			if v:GetPos():WithinAABox( pos3, pos4 ) then
				ply:ChatPrint("Can't spike ball over other team area!") 
			else  
				ball_status = "spike"
				if direction == "right" then 
					ply:EmitSound("boku/bokutospike2.mp3", 70, 100, 1, CHAN_AUTO )
					v:SetPos(entityPosVect)
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 800  + Vector(900,0,-150)) 
				else 
					ply:EmitSound("boku/bokutospike2.mp3", 70, 100, 1, CHAN_AUTO )  
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 800  + Vector(-900,0,-150))
				end   
			end 
		else  
			if v:GetPos():WithinAABox( pos1, pos2 ) then
				ply:ChatPrint("Can't spike ball over other team area!")

			else 
				if direction == "left" then 
					ply:EmitSound("boku/bokutospike2.mp3", 70, 100, 1, CHAN_AUTO ) 
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 800  + Vector(900,0,-150)) 
				else 
					ply:EmitSound("boku/bokutospike2.mp3", 70, 100, 1, CHAN_AUTO )  
					v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 800  + Vector(-900,0,-150))
				end 
			end 
		end 

end) 

-- yamaguchi 
net.Receive ("yama_ability" , function(bits , ply )
	local servetype = net.ReadString() 
	local ent =  ents.FindByClass( "prop_physics*" )
	local randomdrop = {0.3,0.4,0.5,0.6} 
	local leftright = {250,-250} 
	local random = table.Random(randomdrop)
	local randompower = {200,200}
	local randomstop = {400,10}

	if servetype == "tossup" then 
		for k, v in pairs( ent ) do   
			if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then     
				--if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then 
					v:GetPhysicsObject():SetVelocity(ply:GetForward() * 20 + Vector(0,0,600)) 
					ply:EmitSound("tossup.mp3", 70, 100, 1, CHAN_AUTO )
				--end
			end    
		end 
	else 
		for k, v in pairs( ent ) do   
			if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then     
				ply:EmitSound("yama/yamaserve.mp3", 70, 100, 1, CHAN_AUTO )
				v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 200 + Vector(0,0,0))  
				timer.Create("slowdown",0.2,1,function() v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 400 + Vector(0,0,150))  end) 

				timer.Create("slowdown",0.2,1,function() v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 400 + Vector(60,0,50))  
					timer.Create("slowdown",0.2,1,function() v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 400 + Vector(-60,0,-50)) 
						timer.Create("slowdown",0.2,1,function() v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 400 + Vector(60,0,100))
							timer.Create("slowdown",0.2,1,function() v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * 400 + Vector(-60,0,50))  
								timer.Create("slowdown",table.Random(randomdrop),1,function() v:GetPhysicsObject():SetVelocity(ply:GetAimVector() * table.Random(randomstop) + Vector(table.Random(leftright),0,-300))  end)
							end)
						end)
					end)
				end)		
			end   
		end 
	end 
end) 
---------------------------------------------------------------------
-- Assuming you're working with a player entity (e.g., a character or player controller)

-- Override the player's jump function
function GM:PlayerCanJump(player)
    -- You can add custom logic here to determine whether the player can jump
    -- For your specific requirement, we'll allow jumping without any extra height
    local canJump = true

    -- Debug: Print whether the player can jump
   // print("Player Can Jump:", canJump)

    return canJump
end





--BASIC REC,SET,SPIKE 

 
net.Receive ("basic_serve" , function(bits , ply )
	local ent =  ents.FindByClass( "prop_physics*" ) 

	for k, v in pairs( ent ) do   
		ply:ConCommand("pac_event serve")
		ply:ConCommand("pac_event spike")
		if ply:GetPos():DistToSqr( v:GetPos() ) < 120*120 then     
			--if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then 
				ply:EmitSound("spike.mp3", 70, 100, 1, CHAN_AUTO )
				v:GetPhysicsObject():SetVelocity(ply:GetForward() * 400 + Vector(0,0,400)) 
			--end
		end   
	end 
end) 



net.Receive ("receive_power" , function(bits , ply )
	local position = net.ReadString()
	local power = net.ReadString()
	local entityBall = net.ReadEntity() 
	local ent =  ents.FindByClass( "prop_physics*" )
	local allow_receive_assist = net.ReadBool() 
	local entBallPos = net.ReadVector() 
	local allow_old_receive = net.ReadBool() 
	local character = net.ReadString() 
	
	if character ~= "kuro" and character ~= "kenma" then
		character = ""
	end
	
	//print("char "..character)

	entityBall:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR) 

	if power == "weak" then 
		ReceivePosition(entityBall,entBallPos,ply,position,110,400,allow_receive_assist,allow_old_receive)
	elseif power == "strong" then 
		ReceivePosition(entityBall,entBallPos,ply,position,140,600,allow_receive_assist,allow_old_receive)
	elseif power == "ultra" and character == "kuro" then 
		ReceivePosition(entityBall,entBallPos,ply,position,100,750,allow_receive_assist,allow_old_receive)
	elseif power == "ultra" and character == "kenma" then 
		ReceivePosition(entityBall,entBallPos,ply,position,100,750,allow_receive_assist,allow_old_receive)
	elseif power == "feint" then 
		ReceivePosition(entityBall,entBallPos,ply,position,200,110,allow_receive_assist,allow_old_receive)
	end 
end)


 
net.Receive("toss_power", function(bits, ply)
    local position = net.ReadString()
    local power = net.ReadString()
    local frontback = net.ReadString()
	local allow_set_assist = net.ReadBool()
	
    local ent = ents.FindByClass("prop_physics*")

    for k, v in pairs(ent) do
        if frontback == "front" then
            ply:ConCommand("pac_event set")
            if ply:GetPos():DistToSqr(v:GetPos()) < 120 * 120 then
                ply:ConCommand("pac_event set")
                ply:ConCommand("pac_event jumpset")

                --v:SetVelocity(v:GetForward() * 500 + Vector(0,0,1000)) 
                --if(v:GetName() =='volleyball1' or v:GetName() == 'volleyball2' or v:GetName() == 'volleyball3') then   
                --v:GetPhysicsObject():SetVelocity(ply:GetAimVector()* 800) 
				if isSpiked != true then 
					if isReceived == false then 
						isReceived = true 
						timer.Simple(1,function() isReceived=false end)
						if power == "weak" then
							TossPosition(v, ply, position, 100, 250, frontback,allow_set_assist)
						elseif power == "medium" then
							TossPosition(v, ply, position, 100, 400, frontback,allow_set_assist)
						else
							TossPosition(v, ply, position, 300, 400, frontback,allow_set_assist)
						end
					end 
				end 
            end
        else
            if ply:GetPos():DistToSqr(v:GetPos()) < 120 * 120 then
                ply:ConCommand("pac_event backset")
                ply:ConCommand("pac_event jumpbackset")

				if isSpiked != true then 
					if isReceived == false then 
						isReceived = true
						timer.Simple(1,function() isReceived=false end) 
						if power == "weak" then
							TossPosition(v, ply, position, -110, 330, frontback,allow_set_assist)
						elseif power == "medium" then
							TossPosition(v, ply, position, -110, 450, frontback,allow_set_assist)
						else 
							TossPosition(v, ply, position, -120, 500, frontback,allow_set_assist)
						end
					end
				end 
            end
        end
    end
end)


//LIBERO ALPHA FEATURE 
-- net.Receive ("dive_power" , function(bits , ply )
-- 	local position = net.ReadString()
-- 	local power = net.ReadString()

-- 	local ent =  ents.FindByClass( "prop_physics*" )

-- 	for k, v in pairs( ent ) do    
-- 		ply:SetWalkSpeed(1)
-- 		ply:SetRunSpeed(1)

-- 		if power == "short" then 

-- 			if ply:GetPos():DistToSqr( v:GetPos() ) < 180*180 then     
-- 				DivePosition(v,ply,position,-100,450,"short")
-- 			end
	
-- 			ply:SetVelocity(ply:GetForward() * 600 ) 
-- 			ply:ConCommand("pac_event diveshort") 
-- 		elseif power == "long" then 

-- 			if ply:GetPos():DistToSqr( v:GetPos() ) < 220*220 then     
-- 				DivePosition(v,ply,position,-100,650,"long")
-- 			end

-- 			ply:SetVelocity(ply:GetForward() * 1200 ) 
-- 			ply:ConCommand("pac_event divelong")
-- 		end 
-- 	end
-- end)

-- -- Receive the "revertspeed" event and update the player's speed based on their class
-- net.Receive("revertspeed", function(bits, ply)
--     local class = net.ReadString()

--     if class == "libero" then
--         ply:SetWalkSpeed(300)
--         ply:SetRunSpeed(340)
--     end
-- end)	

-- Receive the "ref" event and play a sound or execute a command based on the reference
net.Receive("ref", function(bits, ply)
    local ref = net.ReadString()

    if ref == "whistle" then
        ply:EmitSound("whistle.mp3", 70, 100, 1, CHAN_AUTO)
    elseif ref == "agree" then
        ply:ConCommand("act agree")
    else
        ply:ConCommand("act disagree")
    end
end)

net.Receive("hoshiumi_jump", function(bits, ply)
	local status = net.ReadString() 
	local whoami = net.ReadString()

	if status == "boost" then 
		ply:SetJumpPower(korai_boost_jump)
	else 
		ply:SetJumpPower(korai_jump)
	end 
end) 


-- Limit the player's forward momentum when they jump in a direction
hook.Add("SetupMove", "LimitForwardMomentum", function(ply, mv, cmd)
    -- Check if the player is pressing the jump key and moving forward
    if bit.band(cmd:GetButtons(), IN_JUMP) ~= 0 and bit.band(cmd:GetButtons(), IN_FORWARD) ~= 0 then
        local vel = mv:GetVelocity()
        local maxForwardVelocity = 150 -- Adjust as needed

        if vel:Length2D() > maxForwardVelocity then
            local scale = maxForwardVelocity / vel:Length2D()
            vel = vel * scale
            mv:SetVelocity(vel)
        end
    -- Check if the player is pressing the jump key and moving left
    elseif bit.band(cmd:GetButtons(), IN_JUMP) ~= 0 and bit.band(cmd:GetButtons(), IN_MOVELEFT) ~= 0 then
        local vel = mv:GetVelocity()
        local maxLeftVelocity = 270 -- Adjust as needed

        if vel:Length2D() > maxLeftVelocity then
            local scale = maxLeftVelocity / vel:Length2D()
            vel = vel * scale
            mv:SetVelocity(vel)
        end
    -- Check if the player is pressing the jump key and moving right
    elseif bit.band(cmd:GetButtons(), IN_JUMP) ~= 0 and bit.band(cmd:GetButtons(), IN_MOVERIGHT) ~= 0 then
        local vel = mv:GetVelocity()
        local maxRightVelocity = 270 -- Adjust as needed

        if vel:Length2D() > maxRightVelocity then
            local scale = maxRightVelocity / vel:Length2D()
            vel = vel * scale
            mv:SetVelocity(vel)
        end
    -- Check if the player is pressing the jump key and moving backward
    elseif bit.band(cmd:GetButtons(), IN_JUMP) ~= 0 and bit.band(cmd:GetButtons(), IN_BACK) ~= 0 then
        local vel = mv:GetVelocity()
        local maxForwardVelocity = 270 -- Adjust as needed

        if vel:Length2D() > maxForwardVelocity then
            local scale = maxForwardVelocity / vel:Length2D()
            vel = vel * scale
            mv:SetVelocity(vel)
        end
    end
end)




--[[
net.Receive("predictBall",function(bits,ply) 
	local hitpos = net.ReadVector() 
	local mode = net.ReadString() 

	--print(hitpos)

 	for k,v in pairs(player.GetAll()) do 
 		if mode == "add" then 
 			--if v:Nick() == ply:Nick() then 

 			--else 
		 		net.Start("graphicprediction")
		 		net.WriteVector(hitpos)
		 		net.WriteEntity(ply)
		 		net.WriteString(mode)
		 		net.Send(v)
		 end 
	 	--[[else 
	 		net.Start("graphicprediction")
	 		--net.WriteVector(hitpos)
	 		net.WriteString(mode)
	 		net.Send(v)
	 	end  
 	end 
end) ]]

