local tasks = {}

function SimpleTimingLib_Schedule(time, func, ...)
  local t = {...}
  t.func = func
  t.time = GetTime() + time
  table.insert(tasks, t)
end

local function onUpdate()
  for i = #tasks, 1, -1 do
    local val = tasks[i]
    if val and val.time <= GetTime() then
      table.remove(tasks, i)
      val.func(unpack(val))
    end
  end
end

local frame = CreateFrame("Frame")
frame:SetScript("OnUpdate", onUpdate)

function SimpleTimingLib_Unschedule(func, ...)
  for i = #tasks, 1, -1 do
    local val = tasks[i]
    if val.func == func then
      local matches = true
      for i = 1, select("#", ...) do
        if select(i, ...) ~= val[i] then
          matches = false
          break
        end
      end
      if matches then
        table.remove(tasks, i)
      end
    end
  end
end


