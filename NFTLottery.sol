// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract NFTLottery is VRFConsumerBase {
    IERC721 public nftCollection;
    address[] public participants;
    address public winner;
    bytes32 internal keyHash;
    uint256 internal fee;

    event LotteryEntered(address indexed participant);
    event WinnerSelected(address indexed winner);

    constructor(address _nftAddress, address _vrfCoordinator, address _link, bytes32 _keyHash, uint256 _fee)
        VRFConsumerBase(_vrfCoordinator, _link)
    {
        nftCollection = IERC721(_nftAddress);
        keyHash = _keyHash;
        fee = _fee;
    }

    function enterLottery() public {
        require(nftCollection.balanceOf(msg.sender) > 0, "Must own an NFT to enter");
        participants.push(msg.sender);
        emit LotteryEntered(msg.sender);
    }

    function drawWinner() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK");
        require(participants.length > 0, "No participants in the lottery");
        return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        uint256 winnerIndex = randomness % participants.length;
        winner = participants[winnerIndex];
        emit WinnerSelected(winner);
        participants = new address ; // Reset participants for the next lottery
    }
}
