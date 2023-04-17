pragma solidity 0.8.13;

import {IPegStabilityModule} from "@interface/IPegStabilityModule.sol";
import {PostProposalCheck} from "./PostProposalCheck.sol";
import {TestProposals} from "../TestProposals.sol";
import {Proposal} from "@proposal-types/Proposal.sol";
import {vip15} from "./vip15.sol";

/*
How to use:
forge test --fork-url $ETH_RPC_URL --match-contract Vip15PostProposalCheck -vvv
*/

contract Vip15PostProposalCheck is PostProposalCheck {
    function _addProposals(TestProposals proposals) internal override {
        vip15 vip = new vip15();
        proposals.addProposal(Proposal(address(vip)));

        /// add additional proposals here if multiple proposals are
        /// submitted in parallel or are in flight at the same time
    }

    function testPsmMintFailsDai() public {
        IPegStabilityModule psm = IPegStabilityModule(addresses.mainnet("VOLT_DAI_PSM"));

        vm.expectRevert("PegStabilityModule: Minting paused");
        psm.mint(address(this), 0, 0);
    }
    
    function testPsmMintFailsUsdc() public {
        IPegStabilityModule psm = IPegStabilityModule(addresses.mainnet("VOLT_USDC_PSM"));

        vm.expectRevert("PegStabilityModule: Minting paused");
        psm.mint(address(this), 0, 0);
    }
}
