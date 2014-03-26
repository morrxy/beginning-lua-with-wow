local function showTooltip(self, linkData)
  local linkType = string.split(":", linkData)
  if linkType == "item"
  or linkType == "spell"
  or linkType == "enchant"
  or linkType == "quest"
  or linkType == "talent"
  or linkType == "glyph"
  or linkType == "unit"
  or linkType == "achievement" then
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    GameTooltip:SetHyperlink(linkData)
    GameTooltip:Show()
  end
end

local function hideTooltip(...)
  GameTooltip:Hide()
end

local function setOrHookHandler(frame, script, func)
  if frame:GetScript(script) then
    frame:HookScript(script, func)
  else
    frame:SetScript(script, func)
  end
end

for i = 1, NUM_CHAT_WINDOWS do
  local frame = getglobal("ChatFrame" .. i)
  if frame then
    setOrHookHandler(frame, "OnHyperLinkEnter", showTooltip)
    setOrHookHandler(frame, "OnHyperLinkLeave", hideTooltip)
  end
end