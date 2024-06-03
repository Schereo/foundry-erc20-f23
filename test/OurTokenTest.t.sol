// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {

    uint256 private constant INITIAL_BALANCE = 100 ether;

    OurToken private token;
    DeployOurToken private deployer;

    address private bob = makeAddr("bob");
    address private alice = makeAddr("alice");

    function setUp() public {
        deployer = new DeployOurToken();
        token = deployer.run(); 

        vm.prank(msg.sender);
        token.transfer(bob, INITIAL_BALANCE);
        vm.prank(msg.sender);
        token.transfer(alice, INITIAL_BALANCE);

    }

    function testBobBalance() public view {
        assertEq(token.balanceOf(bob), INITIAL_BALANCE);
    }

    function testAllowances() public {
        uint256 initalAllowance = 100000;
        vm.prank(bob);
        token.approve(alice, initalAllowance);

        vm.prank(alice);
        token.transferFrom(bob, alice, initalAllowance);

        assertEq(token.balanceOf(bob), INITIAL_BALANCE - initalAllowance);
        assertEq(token.balanceOf(alice), INITIAL_BALANCE + initalAllowance);
    }
}