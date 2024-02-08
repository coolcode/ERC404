// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Test } from "forge-std/Test.sol";
import { ERC404 } from "src/ERC404.sol";
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
        assertEq(token.balanceOf(alice), 0.5e18, "Alice's balance should be 0.5");
        assertEq(token.minted(), 0, "The number of NFT should be 0");
    }

    function testTransferOne() public {
        vm.prank(owner);
        token.transfer(alice, 1e18);
        assertEq(token.balanceOf(alice), 1e18, "Alice's balance should be 1");
        assertEq(token.minted(), 1, "The number of NFT should be 1");
        assertEq(token.ownerOf(1), alice, "The owner of #1 NFT should be Alice");
    }

    function testTransferOneHalf() public {
        vm.prank(owner);
        token.transfer(alice, 1.5e18);
        assertEq(token.balanceOf(alice), 1.5e18, "Alice's balance should be 1.5");
        assertEq(token.minted(), 1, "The number of NFT should be 1");
        assertEq(token.ownerOf(1), alice, "The owner of #1 nft should be Alice");
    }

    function testTransferTen() public {
        vm.prank(owner);
        token.transfer(alice, 10e18);
        assertEq(token.balanceOf(alice), 10e18, "Alice's balance should be 10");
        assertEq(token.minted(), 10, "The number of NFT should be 10");
        assertEq(token.ownerOf(10), alice, "The owner of #10 nft should be Alice");

        vm.prank(alice);
        token.transfer(bob, 2e18); // send 2*10^18 PANDORA to Bob, mint 2 new NFTs to Bob and burn Alice's last 2 NFTs
        assertEq(token.balanceOf(alice), 8e18, "Alice's balance should be 8 after sending 2 to Bob");
        assertEq(token.balanceOf(bob), 2e18, "Bob's balance");
        assertEq(token.minted(), 12, "The number of NFT is 10");
        assertEq(token.ownerOf(12), bob, "The owner of #10 nft should be Bob");
    }

    function testTransferRevert() public {
        vm.expectRevert();
        vm.prank(alice); // Alice has no token
        token.transfer(bob, 1e18);
    }

    function testTransferEmit() public {
        vm.expectEmit(true, true, true, false);
        emit ERC404.ERC20Transfer(owner, alice, 1e18);
        emit ERC404.Transfer(owner, alice, 1);

        vm.prank(owner);
        token.transfer(alice, 1e18);
    }
}
