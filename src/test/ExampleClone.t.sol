// SPDX-License-Identifier: BSD
pragma solidity ^0.8.4;

/* solhint-disable func-name-mixedcase */

import "forge-std/test.sol";
import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";

import {ExampleClone} from "../ExampleClone.sol";
import {ExampleCloneFactory} from "../ExampleCloneFactory.sol";

contract ExampleCloneTest is Test {
    using SafeTransferLib for address;

    event ReceiveETH(uint256 amount);

    ExampleClone internal clone;
    ExampleCloneFactory internal factory;

    function setUp() public {
        ExampleClone implementation = new ExampleClone();
        factory = new ExampleCloneFactory(implementation);
        clone = factory.createClone(address(this), type(uint256).max, 8008, 69);
    }

    /// -----------------------------------------------------------------------
    /// Gas benchmarking
    /// -----------------------------------------------------------------------

    function testGas_param1() public view {
        clone.param1();
    }

    function testGas_param2() public view {
        clone.param2();
    }

    function testGas_param3() public view {
        clone.param3();
    }

    function testGas_param4() public view {
        clone.param4();
    }

    /// -----------------------------------------------------------------------
    /// Correctness tests
    /// -----------------------------------------------------------------------

    function testCan_receiveETH(uint96 deposit) public {
        address(clone).safeTransferETH(deposit);
        assertEq(address(clone).balance, deposit);
    }

    function testCan_emitOnReceiveETH(uint96 deposit) public {
        vm.expectEmit(true, true, true, true);
        emit ReceiveETH(deposit);

        address(clone).safeTransferETH(deposit);
    }

    function testCan_receiveETHTransfer(uint96 deposit) public {
        payable(address(clone)).transfer(deposit);
        assertEq(address(clone).balance, deposit);
    }
}
