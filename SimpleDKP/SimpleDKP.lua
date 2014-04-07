local currentItem
local bids = {}
local prefix = "[SimpleDKP]"  -- prefix for chat messages

-- SimpleTimingLib_Schedule(8, print, "working")

-- default values for saved variables/options
SimpleDKP_Channel = "GUILD" -- the chat channel to use
SimpleDKP_AuctionTime = 30  -- the time (in seconds) for an auction
SimpleDKP_MinBid = 15 -- the minimun amout of DKP you have to bid
SimpleDKP_ACL = {} -- the access control list

local startAuction, endAuction, placeBid, cancelAuction, onEvent

do
  local auctionAlreadyRunning = "There is already an auction running! (on %s)"
  local startingAuction = prefix .. "Starting auction for item %s, please place your bids by whisper me. Remaining time: %d seconds."
  local auctionProgress = prefix .. "Time remaining for %s: %d seconds."

  function startAuction(item, starter)
    if currentItem then
      local msg = auctionAlreadyRunning:format(currentItem)
      if starter then
        SendChatMessage(msg, "WHISPER", nil, starter)
      else
        print(msg)
      end
    else
      currentItem = item

      SendChatMessage(startingAuction:format(item, SimpleDKP_AuctionTime), SimpleDKP_Channel)

      if SimpleDKP_AuctionTime > 30 then
        SimpleTimingLib_Schedule(SimpleDKP_AuctionTime - 30, SendChatMessage, auctionProgress:format(item, 30), SimpleDKP_Channel)
      end

      if SimpleDKP_AuctionTime > 15 then
        SimpleTimingLib_Schedule(SimpleDKP_AuctionTime - 15, SendChatMessage, auctionProgress:format(item, 15), SimpleDKP_Channel)
      end

      if SimpleDKP_AuctionTime > 5 then
        SimpleTimingLib_Schedule(SimpleDKP_AuctionTime - 5, SendChatMessage, auctionProgress:format(item, 5), SimpleDKP_Channel)
      end

      SimpleTimingLib_Schedule(SimpleDKP_AuctionTime, endAuction)
    end
  end
end

do
  local noBids = prefix .. "No one wants to have %s :("
  local wonItemFor = prefix .. "%s won %s for %d DKP"
  local pleaseRoll = prefix .. "%s bid %d DKP on %s, please roll!"
  local highestBidders = prefix .. "%d. %s bid %d DKP"

  local function sortBids(v1, v2)
    return v1.bid > v2.bid
  end

  function endAuction()
    table.sort(bids, sortBids)

    if #bids == 0 then -- case 1: no bid at all
      SendChatMessage(noBids:format(currentItem), SimpleDKP_Channel)
    elseif #bids == 1 then -- case 2: one bid; the bidder pays the minimun bid
      SendChatMessage(wonItemFor:format(bids[1].name, currentItem, SimpleDKP_MinBid), SimpleDKP_Channel)
      SendChatMessage(highestBidders:format(1, bids[1].name, bids[1].bid), SimpleDKP_Channel)
    elseif bids[1].bid ~= bids[2].bid then -- case 3: highest amount is unique
      SendChatMessage(wonItemFor:format(bids[1].name, currentItem, bids[2].bid + 1), SimpleDKP_Channel)
      for i = 1, math.min(#bids, 3) do -- print the three highest bidders
        SendChatMessage(highestBidders:format(i, bids[i].name, bids[i].bid), SimpleDKP_Channel)
      end
    else -- case 4: more than 1 bid and the highest amount is no unique
      local str = "" -- this string holds all players who bid the same amount
      for i = 1, #bids do -- this loop builds the string
        if bids[i].bid ~= bids[1].bid then -- found a player who bid less --> break
          break
        else -- append the players name to the string
          if bids[i + 2] and bids[i + 2].bid == bids[1].bid then
            str = str .. bids[i].name .. ", " -- use a comma if this is not the last
          else
            str = str .. bids[i].name .. " and " -- this is the last player
          end
        end
      end
      str = str:sub(0, -6) -- cut off the end of the string as the loop generates a
      -- string that is too long
      SendChatMessage(pleaseRoll:format(str, bids[1].bid, currentItem), SimpleDKP_Channel)
    end

    currentItem = nil -- set currentItem to nil as there is no longer an ongonging auction
    table.wipe(bids) -- clear the table that holds the bids
  end
end

do
  local oldBidDetectd = prefix .. "Your old bid was %d DKP, you new bid is %d DKP."
  local bidPlaced = prefix .. "Your bid of %d DKP has been placed!"
  local lowBid = prefix .. "The minimun bid is %d DKP."

  function onEvent(self, event, msg, sender)
    if event == "CHAT_MSG_WHISPER" and currentItem and tonumber(msg) then
      local bid = tonumber(msg)
      if bid < SimpleDKP_MinBid then
        SendChatMessage(lowBid:format(SimpleDKP_MinBid), "WHISPER", nil, sender)
        return
      end
      for i, v in ipairs(bids) do -- check if that player has already bid
        if sender == v.name then
          SendChatMessage(oldBidDetectd:format(v.bid, bid), "WHISPER", nil, sender)
          v.bid = bid
          return
        end
      end
      -- he hasn't bid yet, so create a new entry in bids
      table.insert(bids, {bid = bid, name = sender})
      SendChatMessage(bidPlaced:format(bid), "WHISPER", nil, sender)
    elseif SimpleDKP_ACL[sender] then
      -- not a whisper or a whisper that is not a bid
      -- and the sender has the permission to send commands
      local cmd, arg = msg:match("^!(%w+)%s*(.*)")
      if cmd and cmd:lower() == "auction" and arg then
        startAuction(arg, sender)
      elseif cmd and cmd:lower() == "cancel" then
        cancelAuction(sender)
      end
    end
  end

  local frame = CreateFrame("Frame")
  frame:RegisterEvent("CHAT_MSG_WHISPER")
  frame:RegisterEvent("CHAT_MSG_RAID")
  frame:RegisterEvent("CHAT_MSG_RAID_LEADER")
  frame:RegisterEvent("CHAT_MSG_GUILD")
  frame:RegisterEvent("CHAT_MSG_OFFICER")
  frame:SetScript("onEvent", onEvent)
end

SLASH_SimpleDKP1 = "/simpledkp"
SLASH_SimpleDKP2 = "/sdkp"

do
  local setChannel = "Channel is now \"%s\""
  local setTime = "Time is now %s"
  local setMinBid = "Lowest bid is now %s"
  local addedToACL = "Added %s player(s) to the ACL"
  local removedFromACL = "Removed %s player(s) from the ACL"
  local currChannel = "Channel is currently set to \"%s\""
  local currTime = "Time is currently set to %s"
  local currMinBid = "Lowest ibd is currently set to %s"
  local ACL = "Access Control List:"

  local function addToACL(...) -- adds multiple players to the ACL
    for i = 1, select("#", ...) do -- iterate over the arguments
      SimpleDKP_ACL[select(i, ...)] = true  -- and add all players
    end
    print(addedToACL:format(select("#", ...)))  -- print an info message
  end

  local function removeFromACL(...)  -- removes player(s) from the ACL
    for i = 1, select("#", ...) do -- iterate over the vararg
      SimpleDKP_ACL[select(i, ...)] = nil -- remove the players from the ACL
    end
    print(removedFromACL:format(select("#", ...))) -- print an info message
  end

  SlashCmdList["SimpleDKP"] = function(msg)
    local cmd, arg = string.split(" ", msg) -- split the string
    cmd = cmd:lower() -- the command should not be case-sensitive

    if cmd == "start" and arg then -- /sdkp start item
      startAuction(msg:match("^start%s+(.+)")) -- extract the item link
    elseif cmd == "stop" then -- /sdkp stop
      cancelAuction()
    elseif cmd == "channel" then -- /skdp channel arg
      if arg then -- a new channel was provided
        SimpleDKP_Channel = arg:upper() -- set it to arg
        print(setChannel:format(SimpleDKP_Channel))
      else -- no channel was provided
        print(currChannel:format(SimpleDKP_Channel)) -- print the current one
      end
    elseif cmd == "time" then -- /sdkp time arg
      if arg and tonumber(arg) then -- arg is provided and it is a number
        SimpleDKP_AuctionTime = tonumber(arg) -- set it
        print(setTime:format(SimpleDKP_AuctionTime))
      else -- arg was not provided or it wasn't a number
        print(currTime:format(SimpleDKP_AuctionTime)) -- print error message
      end
    elseif cmd == "minbid" then -- /sdkp minbid arg
      if arg and tonumber(arg) then -- arg is set and a number
        SimpleDKP_MinBid = tonumber(arg) -- set the option
        print(setMinBid:format(SimpleDKP_MinBid))
      else -- arg is not set or not a number
        print(currMinBid:format(SimpleDKP_MinBid)) -- print error message
      end
    elseif cmd == "acl" then -- /skdp acl add/remove player1, player2, ...
      if not arg then -- add/remove not passed
        print(ACL)
        for k, v in pairs(SimpleDKP_ACL) do -- loop over the ACL
          print(k) -- print all entries
        end
      elseif arg:lower() == "add" then -- /skdp add player1, player2, ...
        -- split the string and pass all players to our helper function
        addToACL(select(3, string.split(" ", msg)))
      elseif arg:lower() == "remove" then -- /sdkp remove player1, player2, ...
        removeFromACL(select(3, string.split(" ", msg))) -- split & remove
      end
    end

  end

end

do
  local cancelled = "Auction cancelled by %s"
  function cancelAuction(sender)
    currentItem = nil
    table.wipe(bids)
    SimpleTimingLib_Unschedule(SendChatMessage)
    SimpleTimingLib_Unschedule(endAuction)
    SendChatMessage(cancelled:format(sender or UnitName("player")), SimpleDKP_Channel)
  end
end

local function filterIncoming(self, event, ...)
  local msg = ... -- get the message from the vararg
  -- return true if threre is an ongoing auction and the whisper is a number
  -- followed by all event handler arguments
  return currentItem and tonumber(msg), ...
end

local function filterOutgoing(self, event, ...)
  local msg = ... -- extract the message
  return msg:sub(0, prefix:len()) == prefix, ...
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filterIncoming)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filterOutgoing)





