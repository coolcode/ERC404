// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Test } from "forge-std/Test.sol";
import { Pandora } from "src/Pandora.sol";

contract PandoraTest is Test {
    Pandora token;
    address owner = address(0x1);

    function setUp() public {
        token = new Pandora(owner);
    }

    function testMetadata() public {
        assertEq(token.name(), "Pandora", "wrong name");
        assertEq(token.symbol(), "PANDORA", "wrong symbol");
        assertEq(token.decimals(), 18, "wrong decimals");
        assertEq(token.totalSupply(), 10000 * 1e18, "wrong total supply");
        assertEq(token.owner(), owner, "wrong owner");
    }

    function testFoo(uint256 x) public {
        vm.assume(x < type(uint128).max);
        assertEq(x + x, x * 2);
    }
}
