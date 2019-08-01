pragma solidity ^0.5.0;

import "./roles.sol";

contract Author {
    using Roles for Roles.Role;

    Roles.Role private authors;

    constructor() public {
        authors.add(msg.sender);
    }

    modifier onlyAuthor() {
        require(authors.has(msg.sender), "Only author can do this");
        _;
    }

    function addAuthor(address account) public onlyAuthor {
        authors.add(account);
    }

    function removeAuthor() public {
        authors.remove(msg.sender);
    }
}