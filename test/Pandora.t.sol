// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Test } from "forge-std/Test.sol";
import { Pandora } from "src/Pandora.sol";

contract PandoraTest is Test {
    Pandora token;
    address owner = address(0x1);
    address alice = address(0xa);
    address bob = address(0xb);

    function setUp() public {
        deal(owner, 1 ether);
        deal(alice, 1 ether);
        deal(bob, 1 ether);
        token = new Pandora(owner);
    }

    function testMetadata() public {
        assertEq(token.name(), "Pandora", "wrong name");
        assertEq(token.symbol(), "PANDORA", "wrong symbol");
        assertEq(token.decimals(), 18, "wrong decimals");
        assertEq(token.totalSupply(), 10000 * 1e18, "wrong total supply");
        assertEq(token.owner(), owner, "wrong owner");
        assertEq(token.balanceOf(owner), 10000 * 1e18, "wrong owner's balance");
    }

    function testTransferHalf() public {
        vm.prank(owner);
        token.transfer(alice, 0.5e18);
        assertEq(token.balanceOf(alice), 0.5e18, "Alice's balance");
    }

    function testTransferOne() public {
        vm.prank(owner);
        token.transfer(alice, 1e18);
        assertEq(token.balanceOf(alice), 1e18, "Alice's balance");
        assertEq(token.minted(), 1, "The number of NFT is 1");
        assertEq(token.ownerOf(1), alice, "The owner of #1 NFT should be Alice");
    }

    function testTransferOneHalf() public {
        vm.prank(owner);
        token.transfer(alice, 1.5e18);
        assertEq(token.balanceOf(alice), 1.5e18, "Alice's balance");
        assertEq(token.minted(), 1, "The number of NFT is 1");
        assertEq(token.ownerOf(1), alice, "The owner of #1 nft should be Alice");
    }

    function testTransferTen() public {
        vm.prank(owner);
        token.transfer(alice, 10e18);
        assertEq(token.balanceOf(alice), 10e18, "Alice's balance");
        assertEq(token.minted(), 10, "The number of NFT is 10");
        assertEq(token.ownerOf(10), alice, "The owner of #10 nft should be Alice");
    }
}
