// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AuctionPlatform {
    
    // Define the structure for an auction
    struct Auction {
        uint256 auctionID;   
        string description; // Description of the auction
        uint256 startTime;  // Start time of the auction
        uint256 endTime;     // End time of the auction
        uint256 minBidValue; // Starting bid value for the auction
        address auctionOwner;  // Address of the Auction Owner
        bool isOpen;
    }
    
    // Define the structure for a bid
    struct Bid {
        uint256 auctionID; // datatype for the structure
        uint256 bidValue;  // datatype for the structure
        address bidder;    // datatype for the structure
        bool isWinningBid; // datatype for the structure
    }
    
    // Define storage variables
    mapping (uint256 => Auction) public auctions;
    mapping (uint256 => Bid[]) public auctionBids;
    mapping (address => Bid[]) public userBids;
    uint256 public auctionCounter;
    
    // Create a new auction
    function createAuction(string memory _description, uint256 _startTime, uint256 _endTime, uint256 _minBidValue) public {
        require(_startTime < _endTime, "End time must be after start time.");
        auctions[auctionCounter] = Auction(auctionCounter, _description, _startTime, _endTime, _minBidValue, msg.sender, true);
        auctionCounter++;
    }
    
    // Place a bid on an active auction
    function placeBid(uint256 _auctionID, uint256 _bidValue) public {
        Auction storage auction = auctions[_auctionID];
        require(auction.isOpen, "Auction is not open.");
        require(_bidValue >= auction.minBidValue, "Bid value must be greater than or equal to the minimum bid value.");
        Bid[] storage bids = auctionBids[_auctionID];
        bids.push(Bid(_auctionID, _bidValue, msg.sender, false));
        userBids[msg.sender].push(Bid(_auctionID, _bidValue, msg.sender, false));
    }
    
    // Get all bids for a specific auction
    function getAuctionBids(uint256 _auctionID) public view returns (Bid[] memory) {
        return auctionBids[_auctionID];
    }
    
    // Get all auctions where a user has placed a bid
    function getUserBids() public view returns (Bid[] memory) {
        return userBids[msg.sender];
    }
    
    // Close an auction by marking a winning bid
    function closeAuction(uint256 _auctionID, uint256 _winningBidIndex) public {
        Auction storage auction = auctions[_auctionID];
        require(msg.sender == auction.auctionOwner, "Only the auction owner can close the auction.");
        require(auction.isOpen, "Auction is already closed.");
        Bid[] storage bids = auctionBids[_auctionID];
        Bid storage winningBid = bids[_winningBidIndex];
        winningBid.isWinningBid = true;
        auction.isOpen = false;
    }
    
    // Get all open auctions
    function getOpenAuctions() public view returns (Auction[] memory) {
        Auction[] memory openAuctions = new Auction[](auctionCounter);
        uint256 numOpenAuctions = 0;
        for (uint256 i = 0; i < auctionCounter; i++) {
            Auction storage auction = auctions[i];
            if (auction.isOpen) {
                openAuctions[numOpenAuctions] = auction;
                numOpenAuctions++;
            }
        }
        assembly {
            mstore(openAuctions, numOpenAuctions)
        }
        return openAuctions;
    }
    
    // Get all closed auctions
    function getClosedAuctions() public view returns (Auction[] memory) {
    }
}