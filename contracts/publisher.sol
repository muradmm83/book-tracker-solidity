pragma solidity ^0.5.0;

import "./roles.sol";

contract Publisher {
    using Roles for Roles.Role;

    Roles.Role private publishers;

    constructor() public {
        publishers.add(msg.sender);
    }

    modifier onlyPublisher() {
        require(publishers.has(msg.sender), "Only publisher can do this");
        _;
    }

    function addPublisher(address account) public onlyPublisher {
        publishers.add(account);
    }

    function removePublisher() public {
        publishers.remove(msg.sender);
    }
}