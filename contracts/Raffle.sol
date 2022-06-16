// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Strings.sol";

contract Raffle {
    address public raffleOwner;
    uint256 public totalPrize;
    uint256 public totalTickets;
    uint256 public ticket_price;
    mapping(uint => address) public raffle_ticket;
    uint256 randNonce = 0;

    constructor(uint256 _totalTickets, uint256 _ticketPrice) {
        raffleOwner = msg.sender;
        totalTickets = _totalTickets;
        ticket_price = _ticketPrice;
    }

    function setTicketPrice(uint256 newPrice) public {
        require(msg.sender == raffleOwner, "you need be the Owner");
        ticket_price = newPrice;
    }

    function buyTicket(uint ticket) public payable {
        // require(msg.value != ticket_price, "You need pay a least");
        totalPrize += msg.value;
        raffle_ticket[ticket] = msg.sender;
    }

    // Defining a function to generate
    // a random number
    function randMod(uint256 _modulus) internal returns (uint256) {
        // increase nonce
        randNonce++;
        return
            uint256(
                keccak256(
                    abi.encodePacked(block.timestamp, msg.sender, randNonce)
                )
            ) % _modulus;
    }

    function setWinner() public {
        require(totalPrize > 0, "need a prize to set a winner");
        require(msg.sender == raffleOwner, "you need be the Owner");
        uint ticketWinner = randMod(totalTickets);
        address payable winner = payable(raffle_ticket[ticketWinner]);
        require(raffle_ticket[ticketWinner] == address(0), "Winner is a empty ticket");
        winner.transfer(totalPrize);
        totalPrize=0;
    }
}
