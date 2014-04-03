local currentItem
local bids = {}
local prefix = "[SimpleDKP]"  -- prefix for chat messages

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

        end
      end
  end


end



