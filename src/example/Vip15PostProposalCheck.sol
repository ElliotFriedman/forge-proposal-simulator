pragma solidity 0.8.13;

import {PostProposalCheck} from "./PostProposalCheck.sol";
import {TestProposals} from "../TestProposals.sol";
import {Proposal} from "@proposal-types/Proposal.sol";
import {vip15} from "./vip15.sol";

interface IPegStabilityModule {
    function mint(
        address to,
        uint256 amountIn,
        uint256 minAmountOut
    ) external returns (uint256);
}

contract Vip15PostProposalCheck is PostProposalCheck {
    function _addProposals(TestProposals proposals) internal override {
        vip15 vip = new vip15();
        proposals.addProposal(Proposal(address(vip)));
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
