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



