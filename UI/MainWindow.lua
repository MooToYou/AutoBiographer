local function AutoBiographer_InitializeMainWindow()
  --parent frame 
  local frame = CreateFrame("Frame", "AutoBiographerMain", UIParent, "BasicFrameTemplateWithInset") 
  frame:SetSize(800, 600) 
  frame:SetPoint("CENTER") 
  
  frame:SetScript("OnHide", 
    function(self)
      self:Clear()
    end
  )
  
  frame.Title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  frame.Title:SetPoint("LEFT", frame.TitleBg, "LEFT", 5, 0);
  frame.Title:SetText("AutoBiographer Main Window")
  
   --scrollframe 
  frame.Scrollframe = CreateFrame("ScrollFrame", nil, frame) 
  frame.Scrollframe:SetPoint("TOPLEFT", 10, -25) 
  frame.Scrollframe:SetPoint("BOTTOMRIGHT", -10, 10) 

  --scrollbar 
  frame.Scrollframe.Scrollbar = CreateFrame("Slider", nil, frame.Scrollframe, "UIPanelScrollBarTemplate") 
  frame.Scrollframe.Scrollbar:SetPoint("TOPLEFT", frame, "TOPRIGHT", -25, -45) 
  frame.Scrollframe.Scrollbar:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", -25, 22)
  frame.Scrollframe.Scrollbar:SetMinMaxValues(1, 250) 
  frame.Scrollframe.Scrollbar:SetValueStep(1) 
  frame.Scrollframe.Scrollbar.scrollStep = 1 
  frame.Scrollframe.Scrollbar:SetValue(0) 
  frame.Scrollframe.Scrollbar:SetWidth(16) 
  frame.Scrollframe.Scrollbar:SetScript("OnValueChanged",
    function (self, value) 
      self:GetParent():SetVerticalScroll(value) 
    end
  )
  
  frame.Clear = function(self)
    if (self.Scrollframe.Content) then
      self.Scrollframe.Content:Hide()
      self.Scrollframe.Content = nil
    end
  end  
  
  frame.Toggle = function(self)
    if (self:IsVisible()) then
      self:Hide()
    else
      self:Update()
      self:Show()
    end
  end
  
  frame:Hide()
  return frame
end

AutoBiographer_DebugWindow = nil
AutoBiographer_EventWindow = nil
AutoBiographer_MainWindow = AutoBiographer_InitializeMainWindow()

local Controller = AutoBiographer_Controller

function Toggle_DebugWindow()
  if (not AutoBiographer_DebugWindow) then
  
    local debugLogs = Controller:GetLogs()
    
    --parent frames
    local parentFame = CreateFrame("Frame", "", AutoBiographer_MainWindow)
    parentFame:SetSize(750, 585) 
    parentFame:SetPoint("CENTER") 
    
    local frame = CreateFrame("Frame", "AutoBiographerDebug", parentFame, "BasicFrameTemplate") 
    frame:SetSize(750, 585) 
    frame:SetPoint("CENTER") 
    
    frame:SetScript("OnHide", 
      function(self)
        AutoBiographer_DebugWindow = nil 
      end
    )

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("LEFT", frame.TitleBg, "LEFT", 5, 0);
    frame.title:SetText("AutoBiographer Debug Window")
    
    --scrollframe 
    local scrollframe = CreateFrame("ScrollFrame", nil, frame) 
    scrollframe:SetPoint("TOPLEFT", 10, -25) 
    scrollframe:SetPoint("BOTTOMRIGHT", -10, 10) 

    --scrollbar 
    local scrollbar = CreateFrame("Slider", nil, scrollframe, "UIPanelScrollBarTemplate") 
    scrollbar:SetPoint("TOPLEFT", frame, "TOPRIGHT", -25, -40) 
    scrollbar:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", -25, 22)
    scrollbar:SetMinMaxValues(1, 1)
    scrollbar:SetValueStep(1) 
    scrollbar.scrollStep = 1 
    scrollbar:SetValue(0) 
    scrollbar:SetWidth(16) 
    scrollbar:SetScript("OnValueChanged",
      function (self, value) 
        self:GetParent():SetVerticalScroll(value) 
      end
    )
    local scrollbg = scrollbar:CreateTexture(nil, "BACKGROUND") 
    scrollbg:SetAllPoints(scrollbar) 
    scrollbg:SetTexture(0, 0, 0, 0.4) 
    frame.scrollbar = scrollbar 

    --content frame 
    local content = CreateFrame("Frame", nil, scrollframe) 
    content:SetSize(1, 1) 
    
    --texts
    local index = 0
    for i = debugLogs.LastIndex, debugLogs.FirstIndex, -1 do
      local font = "GameFontWhite"
      if (debugLogs[i].Level == AutoBiographerEnum.LogLevel.Verbose) then font = "GameFontDisable"
      elseif (debugLogs[i].Level == AutoBiographerEnum.LogLevel.Debug) then font = "GameFontDisable"
      elseif (debugLogs[i].Level == AutoBiographerEnum.LogLevel.Information) then font = "GameFontWhite"
      elseif (debugLogs[i].Level == AutoBiographerEnum.LogLevel.Warning) then font = "GameFontNormal"
      elseif (debugLogs[i].Level == AutoBiographerEnum.LogLevel.Error) then font = "GameFontRed"
      elseif (debugLogs[i].Level == AutoBiographerEnum.LogLevel.Fatal) then font = "GameFontRed"
      end
      
      local text = content:CreateFontString(nil, "OVERLAY", font)
      text:SetPoint("TOPLEFT", 5, -15 * index) 
      text:SetText(debugLogs[i].Text)
      index = index + 1
    end
    
    local scrollbarMaxValue = (index * 15) - scrollframe:GetHeight();
    if (scrollbarMaxValue <= 0) then scrollbarMaxValue = 1 end
    scrollbar:SetMinMaxValues(1, scrollbarMaxValue)
    
    scrollframe.content = content
    scrollframe:SetScrollChild(content)
    
    frame.LogsUpdated = function () return end
    
    AutoBiographer_DebugWindow = frame
  else
    AutoBiographer_DebugWindow:Hide()
    AutoBiographer_DebugWindow = nil
  end
end

function Toggle_EventWindow()
  if (not AutoBiographer_EventWindow) then
  
    local events = Controller:GetEvents()
    
    --parent frames
    local parentFame = CreateFrame("Frame", "", AutoBiographer_MainWindow)
    parentFame:SetSize(750, 585) 
    parentFame:SetPoint("CENTER") 
    
    local frame = CreateFrame("Frame", "AutoBiographerEvent", parentFame, "BasicFrameTemplate")
    frame:SetSize(750, 585) 
    frame:SetPoint("CENTER") 
    
    frame:SetScript("OnHide", 
      function(self)
        AutoBiographer_EventWindow = nil 
      end
    )

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("LEFT", frame.TitleBg, "LEFT", 5, 0);
    frame.title:SetText("AutoBiographer Event Window")
    
    local subFrame = CreateFrame("Frame", "AutoBiographerEvent", frame)
    subFrame:SetPoint("TOPLEFT", 10, -25) 
    subFrame:SetPoint("BOTTOMRIGHT", -10, 10) 
    
    subFrame.RepopulateContent = function(self)
      Toggle_EventWindow()
      Toggle_EventWindow()
    end
    
    -- Filter Check Boxes
    local fsBossKill = subFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fsBossKill:SetPoint("CENTER", subFrame, "TOP", -275, -15)
    fsBossKill:SetText("Boss\nKill")
    local cbBossKill= CreateFrame("CheckButton", nil, subFrame, "UICheckButtonTemplate") 
    cbBossKill:SetPoint("CENTER", subFrame, "TOP", -275, -40)
    cbBossKill:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.BossKill])
    cbBossKill:SetScript("OnClick", function(self, event, arg1)
      AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.BossKill] = self:GetChecked()
      subFrame:RepopulateContent()
    end)
    
    local fsFirstAcquiredItem = subFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fsFirstAcquiredItem:SetPoint("CENTER", subFrame, "TOP", -225, -15) 
    fsFirstAcquiredItem:SetText("First\nItem")
    local cbFirstAcquiredItem = CreateFrame("CheckButton", nil, subFrame, "UICheckButtonTemplate") 
    cbFirstAcquiredItem:SetPoint("CENTER", subFrame, "TOP", -225, -40)
    cbFirstAcquiredItem:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.FirstAcquiredItem])
    cbFirstAcquiredItem:SetScript("OnClick", function(self, event, arg1)
      AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.FirstAcquiredItem] = self:GetChecked()
      subFrame:RepopulateContent()
    end)
    
    local fsFirstKill = subFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fsFirstKill:SetPoint("CENTER", subFrame, "TOP", -175, -15)
    fsFirstKill:SetText("First\nKill")
    local cbFirstKill = CreateFrame("CheckButton", nil, subFrame, "UICheckButtonTemplate") 
    cbFirstKill:SetPoint("CENTER", subFrame, "TOP", -175, -40)
    cbFirstKill:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.FirstKill])
    cbFirstKill:SetScript("OnClick", function(self, event, arg1)
      AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.FirstKill] = self:GetChecked()
      subFrame:RepopulateContent()
    end)
    
    local fsGuild = subFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fsGuild:SetPoint("CENTER", subFrame, "TOP", -125, -15)
    fsGuild:SetText("Guild")
    local cbGuild = CreateFrame("CheckButton", nil, subFrame, "UICheckButtonTemplate") 
    cbGuild:SetPoint("CENTER", subFrame, "TOP", -125, -40)
    cbGuild:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.GuildJoined])
    cbGuild:SetScript("OnClick", function(self, event, arg1)
      AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.GuildJoined] = self:GetChecked()
      AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.GuildLeft] = self:GetChecked()
      AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.GuildRankChanged] = self:GetChecked()
      subFrame:RepopulateContent()
    end)
    
    local fsLevelUp = subFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fsLevelUp:SetPoint("CENTER", subFrame, "TOP", -75, -15)
    fsLevelUp:SetText("Level\nUp")
    local cbLevelUp= CreateFrame("CheckButton", nil, subFrame, "UICheckButtonTemplate") 
    cbLevelUp:SetPoint("CENTER", subFrame, "TOP", -75, -40)
    cbLevelUp:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.LevelUp])
    cbLevelUp:SetScript("OnClick", function(self, event, arg1)
      AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.LevelUp] = self:GetChecked()
      subFrame:RepopulateContent()
    end)
    
    local fsPlayerDeath = subFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fsPlayerDeath:SetPoint("CENTER", subFrame, "TOP", -25, -15)
    fsPlayerDeath:SetText("Player\nDeath")
    local cbPlayerDeath = CreateFrame("CheckButton", nil, subFrame, "UICheckButtonTemplate") 
    cbPlayerDeath:SetPoint("CENTER", subFrame, "TOP", -25, -40)
    cbPlayerDeath:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.PlayerDeath])
    cbPlayerDeath:SetScript("OnClick", function(self, event, arg1)
      AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.PlayerDeath] = self:GetChecked()
      subFrame:RepopulateContent()
    end)
    
    local fsQuestTurnIn = subFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fsQuestTurnIn:SetPoint("CENTER", subFrame, "TOP", 25, -15)
    fsQuestTurnIn:SetText("Quest")
    local cbQuestTurnIn = CreateFrame("CheckButton", nil, subFrame, "UICheckButtonTemplate") 
    cbQuestTurnIn:SetPoint("CENTER", subFrame, "TOP", 25, -40)
    cbQuestTurnIn:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.QuestTurnIn])
    cbQuestTurnIn:SetScript("OnClick", function(self, event, arg1)
      AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.QuestTurnIn] = self:GetChecked()
      subFrame:RepopulateContent()
    end)
    
    local fsReputationLevelChanged = subFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fsReputationLevelChanged:SetPoint("CENTER", subFrame, "TOP", 75, -15)
    fsReputationLevelChanged:SetText("Rep\nChanged")
    local cbReputationLevelChanged= CreateFrame("CheckButton", nil, subFrame, "UICheckButtonTemplate") 
    cbReputationLevelChanged:SetPoint("CENTER", subFrame, "TOP", 75, -40)
    cbReputationLevelChanged:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.ReputationLevelChanged])
    cbReputationLevelChanged:SetScript("OnClick", function(self, event, arg1)
      AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.ReputationLevelChanged] = self:GetChecked()
      subFrame:RepopulateContent()
    end)
    
    local fsSkillMilestone = subFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fsSkillMilestone:SetPoint("CENTER", subFrame, "TOP", 125, -15)
    fsSkillMilestone:SetText("Skill")
    local cbSkillMilestone = CreateFrame("CheckButton", nil, subFrame, "UICheckButtonTemplate") 
    cbSkillMilestone:SetPoint("CENTER", subFrame, "TOP", 125, -40)
    cbSkillMilestone:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.SkillMilestone])
    cbSkillMilestone:SetScript("OnClick", function(self, event, arg1)
      AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.SkillMilestone] = self:GetChecked()
      subFrame:RepopulateContent()
    end)
    
    local fsSpellLearned = subFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fsSpellLearned:SetPoint("CENTER", subFrame, "TOP", 175, -15)
    fsSpellLearned:SetText("Spell")
    local cbSpellLearned= CreateFrame("CheckButton", nil, subFrame, "UICheckButtonTemplate") 
    cbSpellLearned:SetPoint("CENTER", subFrame, "TOP", 175, -40)
    cbSpellLearned:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.SpellLearned])
    cbSpellLearned:SetScript("OnClick", function(self, event, arg1)
      AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.SpellLearned] = self:GetChecked()
      subFrame:RepopulateContent()
    end)
    
    local fsSubZoneFirstVisit = subFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fsSubZoneFirstVisit:SetPoint("CENTER", subFrame, "TOP", 225, -15)
    fsSubZoneFirstVisit:SetText("Sub\nZone")
    local cbSubZoneFirstVisit = CreateFrame("CheckButton", nil, subFrame, "UICheckButtonTemplate") 
    cbSubZoneFirstVisit:SetPoint("CENTER", subFrame, "TOP", 225, -40)
    cbSubZoneFirstVisit:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.SubZoneFirstVisit])
    cbSubZoneFirstVisit:SetScript("OnClick", function(self, event, arg1)
      AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.SubZoneFirstVisit] = self:GetChecked()
      subFrame:RepopulateContent()
    end)
    
    local fsZoneFirstVisit = subFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fsZoneFirstVisit:SetPoint("CENTER", subFrame, "TOP", 275, -15)
    fsZoneFirstVisit:SetText("Zone")
    local cbZoneFirstVisit = CreateFrame("CheckButton", nil, subFrame, "UICheckButtonTemplate") 
    cbZoneFirstVisit:SetPoint("CENTER", subFrame, "TOP", 275, -40)
    cbZoneFirstVisit:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.ZoneFirstVisit])
    cbZoneFirstVisit:SetScript("OnClick", function(self, event, arg1)
      AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.ZoneFirstVisit] = self:GetChecked()
      subFrame:RepopulateContent()
    end)
    
    --scrollframe 
    local scrollframe = CreateFrame("ScrollFrame", nil, subFrame) 
    scrollframe:SetPoint("TOPLEFT", 10, -65) 
    scrollframe:SetPoint("BOTTOMRIGHT", -10, 10) 

    --scrollbar 
    local scrollbar = CreateFrame("Slider", nil, scrollframe, "UIPanelScrollBarTemplate") 
    scrollbar:SetPoint("TOPLEFT", subFrame, "TOPRIGHT", -15, -17) 
    scrollbar:SetPoint("BOTTOMLEFT", subFrame, "BOTTOMRIGHT", -15, 12)
    scrollbar:SetMinMaxValues(1, 1)
    scrollbar:SetValueStep(1) 
    scrollbar.scrollStep = 1 
    scrollbar:SetValue(0) 
    scrollbar:SetWidth(16) 
    scrollbar:SetScript("OnValueChanged",
      function (self, value) 
        self:GetParent():SetVerticalScroll(value) 
      end
    ) 
    local scrollbg = scrollbar:CreateTexture(nil, "BACKGROUND") 
    scrollbg:SetAllPoints(scrollbar) 
    scrollbg:SetTexture(0, 0, 0, 0.4) 
    frame.scrollbar = scrollbar 
    
    --content frame 
    local content = CreateFrame("Frame", nil, scrollframe) 
    content:SetSize(1, 1) 
    
    --texts
    local index = 0
    for i = #events, 1, -1 do
      if (AutoBiographer_Settings.EventDisplayFilters[events[i].SubType]) then
        local text = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        text:SetPoint("TOPLEFT", 5, -15 * index) 
        text:SetText(Controller:GetEventString(events[i]))--text:SetText(events[i])
        index = index + 1
      end
    end
    
    local scrollbarMaxValue = (index * 15) - scrollframe:GetHeight();
    if (scrollbarMaxValue <= 0) then scrollbarMaxValue = 1 end
    scrollbar:SetMinMaxValues(1, scrollbarMaxValue)
    
    scrollframe.content = content
    scrollframe:SetScrollChild(content)
    
    AutoBiographer_EventWindow = frame
  else
    AutoBiographer_EventWindow:Hide()
    AutoBiographer_EventWindow = nil
  end
end

function AutoBiographer_MainWindow:Update()
  --content frame 
  local content = CreateFrame("Frame", nil, AutoBiographer_MainWindow.Scrollframe) 
  content:SetSize(775, 600)
  content:SetPoint("TOPLEFT", AutoBiographer_MainWindow.Scrollframe, "TOPRIGHT", 0, 0) 
  content:SetPoint("BOTTOMLEFT", AutoBiographer_MainWindow.Scrollframe, "BOTTOMRIGHT", 0, 0)
  
  -- Buttons
  local eventsBtn = CreateFrame("Button", nil, content, "UIPanelButtonTemplate");
  eventsBtn:SetPoint("CENTER", content, "TOP", -225, -25);
  eventsBtn:SetSize(140, 40);
  eventsBtn:SetText("Events");
  eventsBtn:SetNormalFontObject("GameFontNormalLarge");
  eventsBtn:SetHighlightFontObject("GameFontHighlightLarge");
  eventsBtn:SetScript("OnClick", 
    function(self)
      Toggle_EventWindow()
    end
  )
  
  local optionsBtn = CreateFrame("Button", nil, content, "UIPanelButtonTemplate");
  optionsBtn:SetPoint("CENTER", content, "TOP", -75, -25);
  optionsBtn:SetSize(140, 40);
  optionsBtn:SetText("Options");
  optionsBtn:SetNormalFontObject("GameFontNormalLarge");
  optionsBtn:SetHighlightFontObject("GameFontHighlightLarge");
  optionsBtn:SetScript("OnClick", 
    function(self)
      InterfaceOptionsFrame_OpenToCategory(AutoBiographer_OptionWindow) -- Call this twice because it won't always work correcly if just called once.
      InterfaceOptionsFrame_OpenToCategory(AutoBiographer_OptionWindow)
      AutoBiographer_MainWindow:Hide()
    end
  )
  
  local debugBtn = CreateFrame("Button", nil, content, "UIPanelButtonTemplate");
  debugBtn:SetPoint("CENTER", content, "TOP", 75, -25);
  debugBtn:SetSize(140, 40);
  debugBtn:SetText("Debug");
  debugBtn:SetNormalFontObject("GameFontNormalLarge");
  debugBtn:SetHighlightFontObject("GameFontHighlightLarge");
  debugBtn:SetScript("OnClick", 
    function(self)
      Toggle_DebugWindow()
    end
  )
  
  local closeBtn = CreateFrame("Button", nil, content, "UIPanelButtonTemplate");
  closeBtn:SetPoint("CENTER", content, "TOP", 225, -25)
  closeBtn:SetSize(140, 40);
  closeBtn:SetText("Close");
  closeBtn:SetNormalFontObject("GameFontNormalLarge");
  closeBtn:SetHighlightFontObject("GameFontHighlightLarge");
  closeBtn:SetScript("OnClick", 
    function(self)
      AutoBiographer_MainWindow:Hide()
    end
  )
  
  -- Dropdown
  local dropdown = CreateFrame("Frame", "WPDemoDropDown", content, "UIDropDownMenuTemplate")
  dropdown:SetSize(100, 25)
  dropdown:SetPoint("LEFT", content, "TOP", -dropdown:GetWidth(), -65)
  
  if (not self.DropdownText) then self.DropdownText = "Total" end
  if (not self.DisplayMaxLevel) then self.DisplayMaxLevel = 9999 end
  if (not self.DisplayMinLevel) then self.DisplayMinLevel = 1 end
  UIDropDownMenu_SetText(dropdown, self.DropdownText)
  
  local dropdownOnClick = function(self, arg1, arg2, checked)
    AutoBiographer_MainWindow.DropdownText = self.value
    
    if (not arg1) then
      AutoBiographer_MainWindow.DisplayMaxLevel = 9999
      AutoBiographer_MainWindow.DisplayMinLevel = 1
    else
      AutoBiographer_MainWindow.DisplayMaxLevel = arg1
      AutoBiographer_MainWindow.DisplayMinLevel = arg1
    end
    
    AutoBiographer_MainWindow:Clear()
    AutoBiographer_MainWindow:Update()
  end
  
  UIDropDownMenu_Initialize(dropdown, function(self, level, menuList)
   local info = UIDropDownMenu_CreateInfo()
   info.func = dropdownOnClick
   
   info.text, info.arg1 = "Total", nil
   UIDropDownMenu_AddButton(info)
   
   for k,v in pairs(HelperFunctions.GetKeysFromTableReverse(Controller.CharacterData.Levels)) do
     info.text, info.arg1 = "Level " .. v, v
     UIDropDownMenu_AddButton(info)
   end
  end)
  
  -- Header Stuff
  if (self.DisplayMinLevel == self.DisplayMaxLevel and Controller.CharacterData.Levels[self.DisplayMinLevel].TimePlayedThisLevel) then
    local timePlayedThisLevelFS = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    timePlayedThisLevelFS:SetPoint("LEFT", content, "TOP", 50, -65)
    timePlayedThisLevelFS:SetText("Time played this level: " .. HelperFunctions.SecondsToTimeString(Controller.CharacterData.Levels[self.DisplayMinLevel].TimePlayedThisLevel))
  end
  
  -- Damage
  local damageHeaderFs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  damageHeaderFs:SetPoint("TOPLEFT", 10, -75)
  damageHeaderFs:SetText("Damage")
  
  local damageDealtAmount, damageDealtOver = Controller:GetDamageOrHealing(AutoBiographerEnum.DamageOrHealingCategory.DamageDealt, self.DisplayMinLevel, self.DisplayMaxLevel)
  local petDamageDealtAmount, petDamageDealtOver = Controller:GetDamageOrHealing(AutoBiographerEnum.DamageOrHealingCategory.PetDamageDealt, self.DisplayMinLevel, self.DisplayMaxLevel)
  local damageDealtText = "Damage Dealt: " .. tostring(damageDealtAmount) .. " (" .. tostring(damageDealtOver) .. " over)."
  if (petDamageDealtAmount > 0) then damageDealtText = damageDealtText .. " Pet Damage Dealt: " .. tostring(petDamageDealtAmount) .. " (" .. tostring(petDamageDealtOver) .. " over)." end
  local damageDealtFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  damageDealtFs:SetPoint("TOPLEFT", 10, -95)
  damageDealtFs:SetText(damageDealtText)
  
  local damageTakenAmount, damageTakenOver = Controller:GetDamageOrHealing(AutoBiographerEnum.DamageOrHealingCategory.DamageTaken, self.DisplayMinLevel, self.DisplayMaxLevel)
  local petDamageTakenAmount, petDamageTakenOver = Controller:GetDamageOrHealing(AutoBiographerEnum.DamageOrHealingCategory.PetDamageTaken, self.DisplayMinLevel, self.DisplayMaxLevel)
  local damageTakenText = "Damage Taken: " .. tostring(damageTakenAmount) .. " (" .. tostring(damageTakenOver) .. " over)."
  if (petDamageTakenAmount > 0) then damageTakenText = damageTakenText .. " Pet Damage Taken: " .. tostring(petDamageTakenAmount) .. " (" .. tostring(petDamageTakenOver) .. " over)." end
  local damageTakenFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  damageTakenFs:SetPoint("TOPLEFT", 10, -110)
  damageTakenFs:SetText(damageTakenText)
  
  local healingOtherAmount, healingOtherOver = Controller:GetDamageOrHealing(AutoBiographerEnum.DamageOrHealingCategory.HealingDealtToOthers, self.DisplayMinLevel, self.DisplayMaxLevel)
  local healingOtherFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  healingOtherFs:SetPoint("TOPLEFT", 10, -125)
  healingOtherFs:SetText("Healing Dealt to Others: " .. tostring(healingOtherAmount) .. " (" .. tostring(healingOtherOver) .. " over).")
  
  local healingSelfAmount, healingSelfOver = Controller:GetDamageOrHealing(AutoBiographerEnum.DamageOrHealingCategory.HealingDealtToSelf, self.DisplayMinLevel, self.DisplayMaxLevel)
  local healingSelfFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  healingSelfFs:SetPoint("TOPLEFT", 10, -140)
  healingSelfFs:SetText("Healing Dealt to Self: " .. tostring(healingSelfAmount) .. " (" .. tostring(healingSelfOver) .. " over).")
  
  local healingTakenAmount, healingTakenOver = Controller:GetDamageOrHealing(AutoBiographerEnum.DamageOrHealingCategory.HealingTaken, self.DisplayMinLevel, self.DisplayMaxLevel)
  local healingTakenFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  healingTakenFs:SetPoint("TOPLEFT", 10, -155)
  healingTakenFs:SetText("Healing Taken: " .. tostring(healingTakenAmount) .. " (" .. tostring(healingTakenOver) .. " over).")
  
  -- Experience
  local experienceHeaderFs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  experienceHeaderFs:SetPoint("TOPLEFT", 10, -185)
  experienceHeaderFs:SetText("Experience")

  local experienceFromKills = Controller:GetExperienceByExperienceTrackingType(AutoBiographerEnum.ExperienceTrackingType.Kill, self.DisplayMinLevel, self.DisplayMaxLevel)
  local experienceFromKillsFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  experienceFromKillsFs:SetPoint("TOPLEFT", 10, -205)
  experienceFromKillsFs:SetText("Experience From Kills: " .. tostring(experienceFromKills) .. ".")
      
  local experienceFromRestedBonus = Controller:GetExperienceByExperienceTrackingType(AutoBiographerEnum.ExperienceTrackingType.RestedBonus, self.DisplayMinLevel, self.DisplayMaxLevel)
  local experienceFromRestedBonusFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  experienceFromRestedBonusFs:SetPoint("TOPLEFT", 20, -220)
  experienceFromRestedBonusFs:SetText("Experience From Rested Bonus: " .. tostring(experienceFromRestedBonus) .. ".")
  
  local experienceFromGroupBonus = Controller:GetExperienceByExperienceTrackingType(AutoBiographerEnum.ExperienceTrackingType.GroupBonus, self.DisplayMinLevel, self.DisplayMaxLevel)
  local experienceFromGroupBonusFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  experienceFromGroupBonusFs:SetPoint("TOPLEFT", 20, -235)
  experienceFromGroupBonusFs:SetText("Experience From Group Bonus: " .. tostring(experienceFromGroupBonus) .. ".")
  
  local experienceLostToRaidPenalty = Controller:GetExperienceByExperienceTrackingType(AutoBiographerEnum.ExperienceTrackingType.RaidPenalty, self.DisplayMinLevel, self.DisplayMaxLevel)
  local experienceLostToRaidPenaltyFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  experienceLostToRaidPenaltyFs:SetPoint("TOPLEFT", 20, -250)
  experienceLostToRaidPenaltyFs:SetText("Experience Lost To Raid Penalty: " .. tostring(experienceLostToRaidPenalty) .. ".")
  
  local experienceFromQuests = Controller:GetExperienceByExperienceTrackingType(AutoBiographerEnum.ExperienceTrackingType.Quest, self.DisplayMinLevel, self.DisplayMaxLevel)
  local experienceFromQuestsFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  experienceFromQuestsFs:SetPoint("TOPLEFT", 10, -265)
  experienceFromQuestsFs:SetText("Experience From Quests: " .. tostring(experienceFromQuests) .. ".")
  
  local experienceFromDiscovery = Controller:GetExperienceByExperienceTrackingType(AutoBiographerEnum.ExperienceTrackingType.Discovery, self.DisplayMinLevel, self.DisplayMaxLevel)
  local experienceFromDiscoveryFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  experienceFromDiscoveryFs:SetPoint("TOPLEFT", 10, -280)
  experienceFromDiscoveryFs:SetText("Experience From Discovery: " .. tostring(experienceFromDiscovery) .. ".")
  
  -- Items
  local itemsHeaderFs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  itemsHeaderFs:SetPoint("TOPLEFT", 10, -310)
  itemsHeaderFs:SetText("Items")
  
  local itemsCreated = Controller:GetItemCountForAcquisitionMethod(AutoBiographerEnum.AcquisitionMethod.Create, self.DisplayMinLevel, self.DisplayMaxLevel)
  local itemsCreatedFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  itemsCreatedFs:SetPoint("TOPLEFT", 10, -330)
  itemsCreatedFs:SetText("Items Created: " .. tostring(itemsCreated) .. ".")
  
  local itemsLooted = Controller:GetItemCountForAcquisitionMethod(AutoBiographerEnum.AcquisitionMethod.Loot, self.DisplayMinLevel, self.DisplayMaxLevel)
  local itemsLootedFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  itemsLootedFs:SetPoint("TOPLEFT", 10, -345)
  itemsLootedFs:SetText("Items Looted: " .. tostring(itemsLooted) .. ".")
  
  local itemsOther = Controller:GetItemCountForAcquisitionMethod(AutoBiographerEnum.AcquisitionMethod.Other, self.DisplayMinLevel, self.DisplayMaxLevel)
  local itemsOtherFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  itemsOtherFs:SetPoint("TOPLEFT", 10, -360)
  itemsOtherFs:SetText("Other Items Acquired: " .. tostring(itemsOther) .. ".")
  
  -- Kills
  local killsHeaderFs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  killsHeaderFs:SetPoint("TOPLEFT", 10, -390)
  killsHeaderFs:SetText("Kills")
  
  local taggedKillingBlows = Controller:GetTaggedKillingBlows(self.DisplayMinLevel, self.DisplayMaxLevel)
  local taggedKillingBlowsFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  taggedKillingBlowsFs:SetPoint("TOPLEFT", 10, -410)
  taggedKillingBlowsFs:SetText("Tagged Killing Blows: " .. tostring(taggedKillingBlows) .. ".")
  
  local otherTaggedKills = Controller:GetTaggedKills(self.DisplayMinLevel, self.DisplayMaxLevel) - taggedKillingBlows
  local otherTaggedKillsFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  otherTaggedKillsFs:SetPoint("TOPLEFT", 10, -425)
  otherTaggedKillsFs:SetText("Other Tagged Kills: " .. tostring(otherTaggedKills) .. ".")
  
  -- Money
  local moneyHeaderFs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  moneyHeaderFs:SetPoint("TOPLEFT", 10, -455)
  moneyHeaderFs:SetText("Money")
  
  local moneyLooted = Controller:GetMoneyForAcquisitionMethod(AutoBiographerEnum.AcquisitionMethod.Loot, self.DisplayMinLevel, self.DisplayMaxLevel)
  local moneyLootedFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  moneyLootedFs:SetPoint("TOPLEFT", 10, -475)
  moneyLootedFs:SetText("Money Looted: " .. GetCoinText(moneyLooted) .. ".")
  
  local moneyGainedFromQuesting = Controller:GetMoneyForAcquisitionMethod(AutoBiographerEnum.AcquisitionMethod.Quest, self.DisplayMinLevel, self.DisplayMaxLevel)
  local moneyGainedFromQuestingFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  moneyGainedFromQuestingFs:SetPoint("TOPLEFT", 10, -490)
  moneyGainedFromQuestingFs:SetText("Money Gained From Quests: " .. GetCoinText(moneyGainedFromQuesting) .. ".")
  
  local moneyGainedFromOther = Controller:GetTotalMoneyGained(self.DisplayMinLevel, self.DisplayMaxLevel) - moneyLooted - moneyGainedFromQuesting
  if (moneyGainedFromOther < 0) then moneyGainedFromOther = 0 end -- This should not ever happen.
  local moneyOtherFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  moneyOtherFs:SetPoint("TOPLEFT", 10, -505)
  moneyOtherFs:SetText("Money Gained From Other Sources: " .. GetCoinText(moneyGainedFromOther) .. ".")
  
  -- Other Player Stats
  local otherPlayerHeaderFs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  otherPlayerHeaderFs:SetPoint("TOPLEFT", 10, -535)
  otherPlayerHeaderFs:SetText("Other Player")
  
  local duelsWon = Controller:GetOtherPlayerStatByOtherPlayerTrackingType(AutoBiographerEnum.OtherPlayerTrackingType.DuelsLostToPlayer, self.DisplayMinLevel, self.DisplayMaxLevel)
  local duelsWonFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  duelsWonFs:SetPoint("TOPLEFT", 10, -555)
  duelsWonFs:SetText("Duels Won: " .. tostring(duelsWon) .. ".")
  
  local duelsLost = Controller:GetOtherPlayerStatByOtherPlayerTrackingType(AutoBiographerEnum.OtherPlayerTrackingType.DuelsWonAgainstPlayer, self.DisplayMinLevel, self.DisplayMaxLevel)
  local duelsLostFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  duelsLostFs:SetPoint("TOPLEFT", 10, -570)
  duelsLostFs:SetText("Duels Lost: " .. tostring(duelsLost) .. ".")
  
  -- Spells
  local spellsHeaderFs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  spellsHeaderFs:SetPoint("TOPLEFT", 10, -600)
  spellsHeaderFs:SetText("Spells")
  
  local spellsStartedCasting = Controller:GetSpellCountBySpellTrackingType(AutoBiographerEnum.SpellTrackingType.StartedCasting, self.DisplayMinLevel, self.DisplayMaxLevel)
  local spellsStartedCastingFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  spellsStartedCastingFs:SetPoint("TOPLEFT", 10, -620)
  spellsStartedCastingFs:SetText("Spells Started Casting: " .. tostring(spellsStartedCasting) .. ".")
  
  local spellsSuccessfullyCast = Controller:GetSpellCountBySpellTrackingType(AutoBiographerEnum.SpellTrackingType.SuccessfullyCast, self.DisplayMinLevel, self.DisplayMaxLevel)
  local spellsSuccessfullyCastFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  spellsSuccessfullyCastFs:SetPoint("TOPLEFT", 10, -635)
  spellsSuccessfullyCastFs:SetText("Spells Successfully Cast: " .. tostring(spellsSuccessfullyCast) .. ".")
  
  -- Time
  local timeHeaderFs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  timeHeaderFs:SetPoint("TOPLEFT", 10, -665)
  timeHeaderFs:SetText("Time")
  
  local timeSpentAfk = Controller:GetTimeForTimeTrackingType(AutoBiographerEnum.TimeTrackingType.Afk, self.DisplayMinLevel, self.DisplayMaxLevel)
  local timeSpentAfkFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  timeSpentAfkFs:SetPoint("TOPLEFT", 10, -685)
  timeSpentAfkFs:SetText("Time Spent AFK: " .. HelperFunctions.SecondsToTimeString(timeSpentAfk) .. ".")
  
  local timeSpentCasting = Controller:GetTimeForTimeTrackingType(AutoBiographerEnum.TimeTrackingType.Casting, self.DisplayMinLevel, self.DisplayMaxLevel)
  local timeSpentCastingFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  timeSpentCastingFs:SetPoint("TOPLEFT", 10, -700)
  timeSpentCastingFs:SetText("Time Spent Casting: " .. HelperFunctions.SecondsToTimeString(timeSpentCasting) .. ".")
  
  local timeSpentDead = Controller:GetTimeForTimeTrackingType(AutoBiographerEnum.TimeTrackingType.DeadOrGhost, self.DisplayMinLevel, self.DisplayMaxLevel)
  local timeSpentDeadFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  timeSpentDeadFs:SetPoint("TOPLEFT", 10, -715)
  timeSpentDeadFs:SetText("Time Spent Dead: " .. HelperFunctions.SecondsToTimeString(timeSpentDead) .. ".")
  
  local timeSpentInCombat = Controller:GetTimeForTimeTrackingType(AutoBiographerEnum.TimeTrackingType.InCombat, self.DisplayMinLevel, self.DisplayMaxLevel)
  local timeSpentInCombatFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  timeSpentInCombatFs:SetPoint("TOPLEFT", 10, -730)
  timeSpentInCombatFs:SetText("Time Spent in Combat: " .. HelperFunctions.SecondsToTimeString(timeSpentInCombat) .. ".")
  
  local timeSpentInGroup = Controller:GetTimeForTimeTrackingType(AutoBiographerEnum.TimeTrackingType.InParty, self.DisplayMinLevel, self.DisplayMaxLevel)
  local timeSpentInGroupFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  timeSpentInGroupFs:SetPoint("TOPLEFT", 10, -745)
  timeSpentInGroupFs:SetText("Time Spent in Group: " .. HelperFunctions.SecondsToTimeString(timeSpentInGroup) .. ".")
  
  local timeSpentLoggedIn = Controller:GetTimeForTimeTrackingType(AutoBiographerEnum.TimeTrackingType.LoggedIn, self.DisplayMinLevel, self.DisplayMaxLevel)
  local timeSpentLoggedInFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  timeSpentLoggedInFs:SetPoint("TOPLEFT", 10, -760)
  timeSpentLoggedInFs:SetText("Time Spent Logged In: " .. HelperFunctions.SecondsToTimeString(timeSpentLoggedIn) .. ".")
  
  local timeSpentOnTaxi = Controller:GetTimeForTimeTrackingType(AutoBiographerEnum.TimeTrackingType.OnTaxi, self.DisplayMinLevel, self.DisplayMaxLevel)
  local timeSpentOnTaxiFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  timeSpentOnTaxiFs:SetPoint("TOPLEFT", 10, -775)
  timeSpentOnTaxiFs:SetText("Time Spent on Flights: " .. HelperFunctions.SecondsToTimeString(timeSpentOnTaxi) .. ".")
  
  self.Scrollframe.Content = content
  self.Scrollframe:SetScrollChild(content)
end