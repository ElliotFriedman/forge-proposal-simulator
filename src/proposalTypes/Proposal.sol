pragma solidity =0.8.13;

import {Test} from "@forge-std/Test.sol";
import {IProposal} from "./IProposal.sol";

abstract contract Proposal is IProposal, Test {
    bool public DEBUG = true;
    uint256 public EXPECT_PCV_CHANGE = 0.003e18;
    bool public SKIP_PSM_ORACLE_TEST = false;

    function setDebug(bool value) external {
        DEBUG = value;
    }
}
