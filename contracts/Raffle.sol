// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Raffle {
    address public raffleOwner;
    uint256 public totalPrize;
    uint256 public totalTickets;
    mapping(uint256 => address) public raffle_ticket;

    constructor(uint256 _totalTickets) {
        raffleOwner = msg.sender;
        totalTickets = _totalTickets;
    }

    function buyTicket(uint256 ticket) public payable {
        require(msg.value > 100000000000000, "You need pay a least 0.0001 ETH");
        totalPrize += msg.value;
        raffle_ticket[ticket] = msg.sender;
    }

    function setWinner() public {
        require(totalPrize > 0, "need a prize to set a winner");
        require(msg.sender == raffleOwner, "you need be the Owner");
        uint256 ticketWinner = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender, totalPrize))
        ) % totalTickets;
        address payable winner = payable(raffle_ticket[ticketWinner]);
        winner.transfer(totalPrize);
    }
}
