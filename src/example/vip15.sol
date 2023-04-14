//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity =0.8.13;

import {ITimelockController} from "../proposalTypes/ITimelockController.sol";
import {TimelockProposal} from "../proposalTypes/TimelockProposal.sol";
import {Addresses} from "../Addresses.sol";

/*
VIP15 deprecates the old system and sends all protocol funds to the
multisig, where they will be migrated to the new system.
*/

contract vip15 is TimelockProposal {
    string public name = "VIP15";

    function deploy(Addresses addresses) public pure {}

    function afterDeploy(Addresses addresses, address deployer) public pure {}

    function run(Addresses addresses, address /* deployer*/) public {
        /// ------- poke morpho to update p2p indexes -------

        _pushTimelockAction(
            addresses.mainnet("MORPHO"),
            abi.encodeWithSignature(
                "updateP2PIndexes(address)",
                addresses.mainnet("CDAI")
            ),
            "Accrue interest in Morpho CDAI market"
        );

        /// ------- withdraw funds from morpho -------

        _pushTimelockAction(
            addresses.mainnet("PCV_GUARDIAN"),
            abi.encodeWithSignature(
                "withdrawAllToSafeAddress(address)",
                addresses.mainnet("MORPHO_COMPOUND_DAI_PCV_DEPOSIT")
            ),
            "Withdraw all DAI from Morpho Compound PCV Deposit"
        );

        /// ------- withdraw funds from psms -------

        _pushTimelockAction(
            addresses.mainnet("PCV_GUARDIAN"),
            abi.encodeWithSignature(
                "withdrawAllToSafeAddress(address)",
                addresses.mainnet("VOLT_DAI_PSM")
            ),
            "Withdraw all DAI from PSM"
        );

        _pushTimelockAction(
            addresses.mainnet("PCV_GUARDIAN"),
            abi.encodeWithSignature(
                "withdrawAllToSafeAddress(address)",
                addresses.mainnet("VOLT_USDC_PSM")
            ),
            "Withdraw all USDC from PSM"
        );

        /// ------- withdraw volt from psms -------

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

        /// ------- pause morpho deposits -------

        _pushTimelockAction(
            addresses.mainnet("MORPHO_COMPOUND_USDC_PCV_DEPOSIT"),
            abi.encodeWithSignature("pause()"),
            "Pause USDC Morpho Compound PCV Deposit"
        );

        _pushTimelockAction(
            addresses.mainnet("MORPHO_COMPOUND_DAI_PCV_DEPOSIT"),
            abi.encodeWithSignature("pause()"),
            "Pause USDC Morpho Compound PCV Deposit"
        );

        /// ------- pause psms -------

        _pushTimelockAction(
            addresses.mainnet("VOLT_USDC_PSM"),
            abi.encodeWithSignature("pause()"),
            "Pause USDC PSM"
        );

        _pushTimelockAction(
            addresses.mainnet("VOLT_DAI_PSM"),
            abi.encodeWithSignature("pause()"),
            "Pause DAI PSM"
        );

        /// ------- pause allocator -------

        _pushTimelockAction(
            addresses.mainnet("ERC20ALLOCATOR"),
            abi.encodeWithSignature("pause()"),
            "Pause ERC20 Allocator"
        );

        /// ------- role revoked in core -------

        _pushTimelockAction(
            addresses.mainnet("CORE"),
            abi.encodeWithSignature(
                "revokePCVController(address)",
                addresses.mainnet("MORPHO_COMPOUND_PCV_ROUTER")
            ),
            "Revoke PCV Controller from Morpho Compound PCV Router"
        );

        _pushTimelockAction(
            addresses.mainnet("CORE"),
            abi.encodeWithSignature(
                "revokePCVController(address)",
                addresses.mainnet("ERC20ALLOCATOR")
            ),
            "Revoke PCV Controller from ERC20 Allocator"
        );

        _pushTimelockAction(
            addresses.mainnet("CORE"),
            abi.encodeWithSignature(
                "revokeGovernor(address)",
                addresses.mainnet("GOVERNOR")
            ),
            "Revoke PCV Controller from ERC20 Allocator"
        );

        _pushTimelockAction(
            addresses.mainnet("CORE"),
            abi.encodeWithSignature(
                "revokePCVController(address)",
                addresses.mainnet("PCV_GUARDIAN")
            ),
            "Revoke PCV Controller from PCV_GUARDIAN"
        );

        _pushTimelockAction(
            addresses.mainnet("CORE"),
            abi.encodeWithSignature(
                "revokePCVController(address)",
                addresses.mainnet("GOVERNOR")
            ),
            "Revoke PCV Controller from multisig"
        );

        _pushTimelockAction(
            addresses.mainnet("CORE"),
            abi.encodeWithSignature(
                "revokeGuardian(address)",
                addresses.mainnet("PCV_GUARDIAN")
            ),
            "Revoke Guardian from PCV_GUARDIAN"
        );

        _pushTimelockAction(
            addresses.mainnet("PCV_GUARD_ADMIN"),
            abi.encodeWithSignature(
                "revokePCVGuardRole(address)",
                addresses.mainnet("EOA_1")
            ),
            "Revoke PCV_GUARD from EOA_1"
        );

        _pushTimelockAction(
            addresses.mainnet("PCV_GUARD_ADMIN"),
            abi.encodeWithSignature(
                "revokePCVGuardRole(address)",
                addresses.mainnet("EOA_2")
            ),
            "Revoke PCV_GUARD from EOA_2"
        );

        _pushTimelockAction(
            addresses.mainnet("PCV_GUARD_ADMIN"),
            abi.encodeWithSignature(
                "revokePCVGuardRole(address)",
                addresses.mainnet("EOA_4")
            ),
            "Revoke PCV_GUARD from EOA_4"
        );

        _pushTimelockAction(
            addresses.mainnet("CORE"),
            abi.encodeWithSignature(
                "revokeRole(bytes32,address)",
                keccak256("PCV_GUARD_ADMIN_ROLE"),
                addresses.mainnet("PCV_GUARD_ADMIN")
            ),
            "Revoke PCV Guard Admin from PCV_GUARD_ADMIN"
        );

        /// ------- role revoked in timelock -------

        _pushTimelockAction(
            addresses.mainnet("TIMELOCK_CONTROLLER"),
            abi.encodeWithSignature(
                "revokeRole(bytes32,address)",
                keccak256("PROPOSER_ROLE"),
                addresses.mainnet("EOA_1")
            ),
            "Revoke proposer role from EOA 1"
        );

        _pushTimelockAction(
            addresses.mainnet("TIMELOCK_CONTROLLER"),
            abi.encodeWithSignature(
                "revokeRole(bytes32,address)",
                keccak256("CANCELLER_ROLE"),
                addresses.mainnet("EOA_1")
            ),
            "Revoke canceller role from EOA 1"
        );

        _pushTimelockAction(
            addresses.mainnet("TIMELOCK_CONTROLLER"),
            abi.encodeWithSignature(
                "revokeRole(bytes32,address)",
                keccak256("PROPOSER_ROLE"),
                addresses.mainnet("EOA_2")
            ),
            "Revoke proposer role from EOA 2"
        );

        _pushTimelockAction(
            addresses.mainnet("TIMELOCK_CONTROLLER"),
            abi.encodeWithSignature(
                "revokeRole(bytes32,address)",
                keccak256("CANCELLER_ROLE"),
                addresses.mainnet("EOA_2")
            ),
            "Revoke canceller role from EOA 2"
        );

        _pushTimelockAction(
            addresses.mainnet("TIMELOCK_CONTROLLER"),
            abi.encodeWithSignature(
                "revokeRole(bytes32,address)",
                keccak256("PROPOSER_ROLE"),
                addresses.mainnet("EOA_4")
            ),
            "Revoke proposer role from EOA 4"
        );

        _pushTimelockAction(
            addresses.mainnet("TIMELOCK_CONTROLLER"),
            abi.encodeWithSignature(
                "revokeRole(bytes32,address)",
                keccak256("CANCELLER_ROLE"),
                addresses.mainnet("EOA_4")
            ),
            "Revoke canceller role from EOA 4"
        );

        /// ------- role granted in timelock -------

        _pushTimelockAction(
            addresses.mainnet("TIMELOCK_CONTROLLER"),
            abi.encodeWithSignature(
                "grantRole(bytes32,address)",
                keccak256("PROPOSER_ROLE"),
                addresses.mainnet("GOVERNOR")
            ),
            "Grant proposer role to multisig"
        );

        _pushTimelockAction(
            addresses.mainnet("TIMELOCK_CONTROLLER"),
            abi.encodeWithSignature(
                "grantRole(bytes32,address)",
                keccak256("CANCELLER_ROLE"),
                addresses.mainnet("GOVERNOR")
            ),
            "Grant canceller role to multisig"
        );

        _pushTimelockAction(
            addresses.mainnet("TIMELOCK_CONTROLLER"),
            abi.encodeWithSignature(
                "grantRole(bytes32,address)",
                keccak256("EXECUTOR_ROLE"),
                address(0)
            ),
            "Allow execution by any address"
        );

        /// ------- disconnect psms -------

        _pushTimelockAction(
            addresses.mainnet("ERC20ALLOCATOR"),
            abi.encodeWithSignature(
                "disconnectPSM(address)",
                addresses.mainnet("VOLT_USDC_PSM")
            ),
            "Disconnect old USDC PSM from the ERC20 Allocator"
        );

        _pushTimelockAction(
            addresses.mainnet("ERC20ALLOCATOR"),
            abi.encodeWithSignature(
                "disconnectPSM(address)",
                addresses.mainnet("VOLT_DAI_PSM")
            ),
            "Disconnect old DAI PSM from the ERC20 Allocator"
        );

        _simulateTimelockActions(
            addresses.mainnet("TIMELOCK_CONTROLLER"), // timelockAddress
            addresses.mainnet("GOVERNOR"), // proposerAddress
            addresses.mainnet("GOVERNOR") // executorAddress
        );
    }

    function teardown(Addresses addresses, address deployer) public pure {}

    /// post proposal validation
    function validate(Addresses addresses, address /* deployer*/) public {
        ITimelockController tc = ITimelockController(payable(addresses.mainnet("TIMELOCK_CONTROLLER")));

        /// timelock roles
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
        assertTrue(tc.hasRole(keccak256("EXECUTOR_ROLE"), address(0)));

        /// ensure msig can still propose to the timelock after the proposal
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
