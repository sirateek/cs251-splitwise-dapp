// SPDX-License-Identifier: UNLICENSED

// DO NOT MODIFY BELOW THIS
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract Splitwise {
    // DO NOT MODIFY ABOVE THIS

    // ADD YOUR CONTRACT CODE BELOW
    address public owner;
    mapping(address => bool) public participant;
    address[] public participantList;
    mapping(address => OwingData[]) public owing;

    struct OwingData {
        uint amount;
        address owingAddress;
    }

    constructor() {
        owner = msg.sender;
    }

    function addOwingData(
        OwingData[] storage input,
        address dest,
        uint amount
    ) private {
        for (uint i = 0; i < input.length; i++) {
            OwingData storage focusedData = input[i];
            if (focusedData.owingAddress == dest) {
                focusedData.amount += amount;
                return;
            }
        }

        OwingData memory newOwingData;
        newOwingData.owingAddress = dest;
        newOwingData.amount = amount;
        input.push(newOwingData);
    }

    function setParticipant(address input) private {
        if (participant[input]) {
            return;
        }
        participant[input] = true;
        participantList.push(input);
    }

    function getParticipant() public view returns (address[] memory) {
        return participantList;
    }

    function getAllOwingData(
        address input
    ) public view returns (OwingData[] memory) {
        return owing[input];
    }

    function iou(address owingAddress, uint amount) public {
        require(msg.sender != owingAddress, "You can't owe yourself!");
        setParticipant(msg.sender);
        setParticipant(owingAddress);

        OwingData[] storage owingData = owing[msg.sender];
        addOwingData(owingData, owingAddress, amount);
        owing[msg.sender] = owingData;
    }
}
