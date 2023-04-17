/// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.13;

import {Test, console} from "@forge-std/Test.sol";

import {ExampleAddresses} from "./ExampleAddresses.sol";
import {TestProposals} from "../TestProposals.sol";
import {IAddresses} from "../IAddresses.sol";
import {Proposal} from "@proposal-types/Proposal.sol";
import {IERC20} from "@interface/IERC20.sol";

abstract contract PostProposalCheck is Test {
    IAddresses addresses;
    uint256 preProposalsSnapshot;
    uint256 postProposalsSnapshot;

    constructor () {
        /// construct addresses object before snapshotting so rollback
        /// doesn't impact already deployed addresses
        addresses = IAddresses(address(new ExampleAddresses()));
    }

    function setUp() public virtual {
        preProposalsSnapshot = vm.snapshot();
        
        TestProposals proposals = new TestProposals(addresses);
        _addProposals(proposals); /// child contract will add all necessary proposals here
        proposals.setUp();
        proposals.testProposals();
        addresses = proposals.addresses();

        postProposalsSnapshot = vm.snapshot();
    }

    /// @notice all child contracts must implement and override this function
    /// to add their desired proposals.
    function _addProposals(TestProposals proposals) internal virtual;
}
