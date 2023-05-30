///SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import {ITimelockController} from "@proposal-types/ITimelockController.sol";
import {TimelockProposal} from "@proposal-types/TimelockProposal.sol";
import {IAddresses} from "../IAddresses.sol";
import {IERC20} from "@interface/IERC20.sol";

/*
VIP15 withdraws all Volt from the PSMs
*/

contract vip15 is TimelockProposal {
    string public name = "VIP15";

    function deploy(IAddresses addresses) public pure {}

    function afterDeploy(IAddresses addresses, address deployer) public pure {}

    function build(IAddresses addresses) public {
        //// ------- withdraw volt from psms -------
    
        _pushTimelockAction(
            addresses.mainnet("PCV_GUARDIAN"),
            abi.encodeWithSignature(
                "withdrawAllERC20ToSafeAddress(address,address)",
                addresses.mainnet("VOLT_DAI_PSM"),
                addresses.mainnet("VOLT")
            ),
            "Withdraw all VOLT from DAI PSM"
        );
    
        _pushTimelockAction(
            addresses.mainnet("PCV_GUARDIAN"),
            abi.encodeWithSignature(
                "withdrawAllERC20ToSafeAddress(address,address)",
                addresses.mainnet("VOLT_USDC_PSM"),
                addresses.mainnet("VOLT")
            ),
            "Withdraw all VOLT from USDC PSM"
        );
    }

    function run(IAddresses addresses, address /* deployer*/) public {
        _simulateTimelockActions(
            addresses.mainnet("TIMELOCK_CONTROLLER"), /// timelockAddress
            addresses.mainnet("GOVERNOR"), /// proposerAddress
            addresses.mainnet("GOVERNOR") /// executorAddress
        );
    }

    function teardown(IAddresses addresses, address deployer) public pure {}

    //// post proposal validation
    function validate(IAddresses addresses, address /* deployer*/) public {
        ITimelockController tc = ITimelockController(payable(addresses.mainnet("TIMELOCK_CONTROLLER")));
        IERC20 volt = IERC20(addresses.mainnet("VOLT"));

        assertEq(volt.balanceOf(addresses.mainnet("VOLT_DAI_PSM")), 0);
        assertEq(volt.balanceOf(addresses.mainnet("VOLT_USDC_PSM")), 0);

        //// timelock roles
        assertTrue(
            tc.hasRole(
                keccak256("PROPOSER_ROLE"),
                addresses.mainnet("GOVERNOR")
            )
        );
        assertTrue(
            tc.hasRole(
                keccak256("CANCELLER_ROLE"),
                addresses.mainnet("GOVERNOR")
            )
        );

        //// ensure msig can still propose to the timelock after the proposal
        {
            bytes memory data = "";
            bytes32 predecessor = bytes32(0);
            bytes32 salt = bytes32(
                keccak256(abi.encodePacked(int256(123456789)))
            );
            uint256 ethSendAmount = 100 ether;
            uint256 delay = tc.getMinDelay();

            vm.deal(address(tc), ethSendAmount);
            vm.startPrank(addresses.mainnet("GOVERNOR"));
            tc.schedule(
                addresses.mainnet("GOVERNOR"),
                ethSendAmount,
                data,
                predecessor,
                salt,
                delay
            );
            vm.warp(block.timestamp + delay);
            tc.execute(
                addresses.mainnet("GOVERNOR"),
                ethSendAmount,
                data,
                predecessor,
                salt
            );
            vm.stopPrank();
        }
    }
}
