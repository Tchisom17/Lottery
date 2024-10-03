// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Lottery {
   // declare entities: admin,participants and winner
   address public admin;
   address payable[] public participants;
   address payable public winner;

   mapping(address => bool) isParticipating; 
   
   uint public participationFee = 1 ether;

   error OnlyAdminHasAccess();
   error AlreadyParticipating();

   constructor() {
        admin = msg.sender;
   }

   modifier onlyOwner() {
        if (admin != msg.sender) {
            revert OnlyAdminHasAccess();
        }
        _;
   }

   modifier alreadyParticipating() {
        if (isParticipating[msg.sender]) {
            revert AlreadyParticipating();
        }
        _;
   }

   function random() internal view returns(uint256) {
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, participants.length)));
   }

   function participate() external alreadyParticipating payable {
        require(msg.value == participationFee, "Please pay the required participation fee!");
        participants.push(payable(msg.sender));
        isParticipating[msg.sender] = true;
   }

   function getContractBalance() public view onlyOwner returns(uint256) {
        return address(this).balance;
   }

//    function oonlyOwner() private view {
//         if (admin != msg.sender) {
//             revert OnlyAdminHasAccess();
//         }
//    }

    function pickWinner() external onlyOwner {
        // oonlyOwner();
        require(participants.length > 2, "participants must be more than two");

        uint randNum = random();
        uint index = randNum % (participants.length);

        winner = participants[index];
        winner.transfer(getContractBalance());
        participants = new address payable[](0); // this will initialize the participants array back to 0
    }

    function getAllParticipants() external view returns(address payable[] memory) {
        return participants;
    }
}