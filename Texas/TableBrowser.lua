local MAX_TABLES = 8 -- maximum number of entries that can be displayed

do
  local entry = CreateFrame("Button", "$parentEntry1", Poker_TableBrowserTablelist, "Poker_TableBrowserEntry")
  entry:SetID(1)
  entry:SetPoint("TOPLEFT", 4, -28)

  for i = 2, MAX_TABLES do
    local entry = CreateFrame("Button", "$parentEntry"..i, Poker_TableBrowserTablelist, "Poker_TableBrowserEntry")
    entry:SetID(i)
    entry:SetPoint("TOP", "$parentEntry"..(i - 1), "BOTTOM")
  end
end