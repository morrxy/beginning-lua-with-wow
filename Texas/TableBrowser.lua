local MAX_TABLES = 8 -- maximum number of entries that can be displayed

do
  local entry = CreateFrame("Button", "$parentEntry1", Poker_TableBrowserTableList, "Poker_TableBrowserEntry")
  entry:SetID(1)
  entry:SetPoint("TOPLEFT", 4, -28)

  for i = 2, MAX_TABLES do
    local entry = CreateFrame("Button", "$parentEntry"..i, Poker_TableBrowserTableList, "Poker_TableBrowserEntry")
    entry:SetID(i)
    entry:SetPoint("TOP", "$parentEntry"..(i - 1), "BOTTOM")
  end
end

-- I think this line is wrong, it should not exist because it overwrite
-- the frame Poker_TableBrowser created in TableBrowser.xml
-- so I comment it out
-- Poker_TableBrowser = {}  --  this table stores all functions

Poker_TableBrowser.Tables = {}  --  all available poker talbes

function Poker_TableBrowser.Update()
  for i = 1, MAX_TABLES do
    local entry = Poker_TableBrowser.Tables[i]
    local frame = getglobal("Poker_TableBrowserTableListEntry"..i)
    if entry then
      frame:Show()
      getglobal(frame:GetName().."Name"):SetText(entry[1])
      getglobal(frame:GetName().."Host"):SetText(entry[2])
      getglobal(frame:GetName().."Players"):SetText(entry[3].."/"..entry[4])
      getglobal(frame:GetName().."Blinds"):SetText(entry[5].."/"..entry[6])
      if entry.isSelected then
        getglobal(frame:GetName().."BG"):Show()
      else
        getglobal(frame:GetName().."BG"):Hide()
      end
    else
      frame:Hide()
    end
  end
end

for i = 1, MAX_TABLES do
  table.insert(Poker_TableBrowser.Tables, {
    "Test Table "..i,
    "Host "..(MAX_TABLES - i),
    i % 3 + 1,  -- just dummy values
    10,
    i * 10,
    i * 20
  })
end

Poker_TableBrowser.Update()

do

  local currSort = 1
  local currOrder = "asc"

  function Poker_TableBrowser.sortTables(id)
    if currSort == id then
      if currOrder == "desc" then
        currOrder = "asc"
      else
        currOrder = "desc"
      end
    elseif id then
      currSort = id
      currOrder = "asc"
    end

    table.sort(Poker_TableBrowser.Tables, function(v1, v2)
      if currOrder == "desc" then
        return v1[currSort] > v2[currSort]
      else
        return v1[currSort] < v2[currSort]
      end
    end)

    Poker_TableBrowser.Update()
  end

end

do

  local selection = nil

  function Poker_TableBrowser.JoinSelectedTable()
    if not selection then
      return
    end
    print(string.format("Joining %s's table %s", selection[2], selection[1]))
  end

  function Poker_TableBrowser.SelectEntry(id)
    if selection then
      for i = 1, MAX_TABLES do
        getglobal("Poker_TableBrowserTableListEntry"..i.."BG"):Hide()
      end
      selection.isSelected = nil
    end
    selection = Poker_TableBrowser.Tables[id]
    selection.isSelected = true
  end

  function Poker_TableBrowser.IsSelected(id)
    return Poker_TableBrowser.Tables[id] == selection
  end

end


