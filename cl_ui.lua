-- Define a custom font with a larger size
surface.CreateFont("LargeCharacterTitle", {
    font = "Trebuchet24", -- Font name
    size = 48,            -- Font size (change as needed)
    weight = 700          -- Font weight (optional)
})

-- Initialize the list of characters
local characters = {"Hinata Shoyo", "Kageyama Tobio", "Sakusa Kiyoomi", "Kotaro Bokuto", "Tetsuro Kuro","Atsumu Miya", "Ushijima Wakatoshi",
"Yamaguchi Tadashi", "Tsukishima Kei","Hoshiumi Korai","Kenma Kozume"}

-- Map each character to its image path and size (width, height)
local characterImages = {
    ["Hinata Shoyo"] = {path = "materials/character/hinanew.png", size = {425, 587}},
    ["Kageyama Tobio"] = {path = "materials/character/kagenew2.png", size = {467, 534}},
    ["Sakusa Kiyoomi"] = {path = "materials/character/sakusanew.png", size = {656, 380}},
    ["Kotaro Bokuto"] = {path = "materials/character/bokutonew.png", size = {446, 559}},
    ["Tetsuro Kuro"] = {path = "materials/character/kuronew.png", size = {420, 594}},
    ["Atsumu Miya"] = {path = "materials/character/miyanew.png", size = {389, 641}},
    ["Ushijima Wakatoshi"] = {path = "materials/character/ushijimanew.png", size = {420, 594}},
    ["Yamaguchi Tadashi"] = {path = "materials/character/yamanew.png", size = {420, 594}},
    ["Tsukishima Kei"] = {path = "materials/character/tsukinew.png", size = {420, 594}},
    ["Hoshiumi Korai"] = {path = "materials/character/korainew.png", size = {420, 594}},
    ["Kenma Kozume"] = {path = "materials/character/kenmanew.png", size = {420, 594}},
}

local selectedCharacterIndex = 1

-- Function to create the character selection menu
local function CreateCharacterSelectMenu()
    -- Create the main frame
    local frame = vgui.Create("DFrame")
    frame:SetTitle("Character Selection")
    frame:SetSize(ScrW(), ScrH())
    frame:Center()
    frame:ShowCloseButton(true)
    frame:MakePopup()
    frame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
        draw.RoundedBox( 0, 0, 0, w, h, Color( 255,255,255,0) ) -- Draw a black box instead of the frame
    end
    
    function frame:Init() 
        self.startTime = SysTime() 
    end    
    function frame:Paint() 
        Derma_DrawBackgroundBlur( self, self.startTime ) 
    end

    -- Create the panel to display the selected character's image
    local charPanel = vgui.Create("DPanel", frame)
    charPanel:SetSize(ScrW(), ScrH() * 0.6)
    charPanel:SetPos(0, ScrH() * 0.2)
    charPanel:SetBackgroundColor(Color(50, 50, 50, 200)) 

    local background_image = vgui.Create("DImage", charPanel) 
	background_image:SetSize(ScrW(),ScrH())
	background_image:SetImage("materials/court.png") 
	background_image:SetImageColor(Color(255, 255, 255,80))

    -- Label to show the character's name at the top
    local charLabel = vgui.Create("DLabel", frame)
    charLabel:SetFont("LargeCharacterTitle")
    charLabel:SetText(characters[selectedCharacterIndex])
    charLabel:SetTextColor(Color(255, 255, 255))
    charLabel:SizeToContents()
    charLabel:SetPos((ScrW() - charLabel:GetWide()) / 2, ScrH() * 0.05) 

    -- Image to display the selected character
    local hinata = vgui.Create("DImage", charPanel)
    hinata:SetSize(100, 100) -- Start with a small size
    hinata:SetPos((charPanel:GetWide() - hinata:GetWide()) / 2, (charPanel:GetTall() - hinata:GetTall()) / 2)
    hinata:SetAlpha(0) -- Start with the image hidden

    -- Function to animate the image pop-up
    local function AnimateImagePopUp()
        local charData = characterImages[characters[selectedCharacterIndex]]
        
        -- Set new image path
        hinata:SetImage(charData.path)
        
        -- Initialize with a small size
        local initialSize = 300
        hinata:SetSize(initialSize, initialSize)
        hinata:SetPos((charPanel:GetWide() - initialSize) / 2, (charPanel:GetTall() - initialSize) / 2) -- Center the small image
        hinata:SetAlpha(0) -- Start with transparent

        -- Animation parameters
        local targetWidth, targetHeight = charData.size[1], charData.size[2]
        local scaleUp = 0
        local fadeIn = 0
        
        -- Timer for animation
        timer.Create("ImagePopUp", 0.01, 100, function()
            scaleUp = scaleUp + 20
            fadeIn = fadeIn + 10
            
            -- Calculate new size
            local newWidth = math.min(initialSize + scaleUp, targetWidth)
            local newHeight = math.min(initialSize + scaleUp, targetHeight)
            
            -- Set new size and position
            hinata:SetSize(newWidth, newHeight)
            hinata:SetPos((charPanel:GetWide() - newWidth) / 2, (charPanel:GetTall() - newHeight) / 2)
            
            -- Set alpha for fade-in
            hinata:SetAlpha(math.min(fadeIn, 255))
            
            -- End animation when the image reaches its final size and fully visible
            if newWidth >= targetWidth and newHeight >= targetHeight and fadeIn >= 255 then
                timer.Remove("ImagePopUp")
            end
        end)
    end


   -- Function to update the character label and image with animation
    local function UpdateCharacterDisplay()
        charLabel:SetText(characters[selectedCharacterIndex])
        charLabel:SizeToContents()
        charLabel:SetPos((ScrW() - charLabel:GetWide()) / 2, ScrH() * 0.05)
        
        -- Start the pop-up animation
        AnimateImagePopUp()
    end


    -- Initialize the display with the first character
    UpdateCharacterDisplay()

    -- Calculate positions for balanced Next and Back buttons
    local buttonYPos = ScrH() * 0.4 -- Vertical position of the buttons
    local buttonWidth, buttonHeight = 100, 100 -- Size of the buttons
    local buttonOffset = ScrW() * 0.3 -- Offset from the center

    -- Create the Back arrow button
    local backButton = vgui.Create("DButton", frame)
    backButton:SetText("←")
    backButton:SetFont("Trebuchet24")
    backButton:SetSize(buttonWidth, buttonHeight)
    backButton:SetPos((ScrW() / 2) - buttonOffset - (buttonWidth / 2), buttonYPos) -- Centered and balanced
    backButton.Paint = function(self, w, h)
        -- Set the background color to translucent black
        surface.SetDrawColor(0, 0, 0, 150)
        surface.DrawRect(0, 0, w, h)

        -- Draw the arrow icon in blue
        surface.SetDrawColor(0, 0, 255)
        surface.SetFont("Trebuchet24")
        local textWidth, textHeight = surface.GetTextSize("←")
        surface.SetTextPos((w - textWidth) / 2, (h - textHeight) / 2)
        surface.DrawText("←")
    end
    backButton.DoClick = function()
        selectedCharacterIndex = (selectedCharacterIndex - 2) % #characters + 1
        UpdateCharacterDisplay()
    end

    -- Create the Next arrow button
    local nextButton = vgui.Create("DButton", frame)
    nextButton:SetText("→")
    nextButton:SetFont("Trebuchet24")
    nextButton:SetSize(buttonWidth, buttonHeight)
    nextButton:SetPos((ScrW() / 2) + buttonOffset - (buttonWidth / 2), buttonYPos) -- Centered and balanced
    nextButton.Paint = function(self, w, h)
        -- Set the background color to translucent black
        surface.SetDrawColor(0, 0, 0, 150)
        surface.DrawRect(0, 0, w, h)

        -- Draw the arrow icon in blue
        surface.SetDrawColor(0, 0, 255)
        surface.SetFont("Trebuchet24")
        local textWidth, textHeight = surface.GetTextSize("→")
        surface.SetTextPos((w - textWidth) / 2, (h - textHeight) / 2)
        surface.DrawText("→")
    end
    nextButton.DoClick = function()
        selectedCharacterIndex = (selectedCharacterIndex % #characters) + 1
        UpdateCharacterDisplay()
    end

end

-- Open the character selection menu
concommand.Add("open_char_select", CreateCharacterSelectMenu)
