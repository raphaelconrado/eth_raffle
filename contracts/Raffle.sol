// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Raffle {
    address public raffleOwner;
    uint256 public totalPrize;
    uint public totalTickets;
    mapping(uint => address) public raffle_ticket;

    constructor(uint _totalTickets) {
        raffleOwner = msg.sender;
        totalTickets = _totalTickets;
    }

    function buyTicket(uint ticket) public payable {
        require(msg.value > 100000000000000, "You need pay a least 0.0001 ETH");
        totalPrize += msg.value;
        raffle_ticket[ticket] = msg.sender;
    }

    function setWinner() public {
        require(totalPrize > 0, "need a prize to set a winner");
        require(msg.sender == raffleOwner, "you need be the Owner");
        uint ticketWinner = uint(
            keccak256(abi.encodePacked(block.timestamp, msg.sender, totalPrize))
        ) % totalTickets;
        address payable winner = payable(raffle_ticket[ticketWinner]);
        winner.transfer(totalPrize);
    }
}
