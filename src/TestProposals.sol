pragma solidity =0.8.13;

import {console} from "@forge-std/console.sol";
import {Test} from "@forge-std/Test.sol";

import {Proposal} from "@proposal-types/Proposal.sol";
import {IAddresses} from "./IAddresses.sol";

contract TestProposals is Test {
    IAddresses public addresses;
    Proposal[] public proposals;
    uint256 public numProposals;
    bool public DEBUG;
    bool public DO_DEPLOY;
    bool public DO_AFTER_DEPLOY;
    bool public DO_BUILD;
    bool public DO_RUN;
    bool public DO_TEARDOWN;
    bool public DO_VALIDATE;

    /// set the address object during construction
    /// this allows child classes to inject the addresses
    /// used during the proposal
    constructor(IAddresses _addresses) {
        addresses = _addresses;
    }

    /// @notice add proposals to be tested
    function addProposal(Proposal proposal) external {
        proposals.push(proposal);

        numProposals = proposals.length;
    }

    function setUp() public {
        DEBUG = vm.envOr("DEBUG", true);
        DO_DEPLOY = vm.envOr("DO_DEPLOY", true);
        DO_AFTER_DEPLOY = vm.envOr("DO_AFTER_DEPLOY", true);
        DO_BUILD = vm.envOr("DO_BUILD", true);
        DO_RUN = vm.envOr("DO_RUN", true);
        DO_TEARDOWN = vm.envOr("DO_TEARDOWN", true);
        DO_VALIDATE = vm.envOr("DO_VALIDATE", true);
    }

    function setDebug(bool value) public {
        DEBUG = value;
        for (uint256 i = 0; i < proposals.length; i++) {
            proposals[i].setDebug(value);
        }
    }

    function testProposals()
        public
        returns (uint256[] memory postProposalVmSnapshots)
    {
        if (DEBUG) {
            console.log(
                "TestProposals: running",
                proposals.length,
                "proposals."
            );
        }
        postProposalVmSnapshots = new uint256[](proposals.length);
        for (uint256 i = 0; i < proposals.length; i++) {
            string memory name = proposals[i].name();

            // Deploy step
            if (DO_DEPLOY) {
                if (DEBUG) {
                    console.log("Proposal", name, "deploy()");
                    addresses.resetRecordingAddresses();
                }
                proposals[i].deploy(addresses);
                if (DEBUG) {
                    (
                        string[] memory recordedNames,
                        address[] memory recordedAddresses
                    ) = addresses.getRecordedAddresses();
                    for (uint256 j = 0; j < recordedNames.length; j++) {
                        console.log(
                            "  Deployed",
                            recordedAddresses[j],
                            recordedNames[j]
                        );
                    }
                }
            }

            // After-deploy step
            if (DO_AFTER_DEPLOY) {
                if (DEBUG) console.log("Proposal", name, "afterDeploy()");
                proposals[i].afterDeploy(addresses, address(proposals[i]));
            }

            // Build proposal step
            if (DO_BUILD) {
                if (DEBUG) console.log("Proposal", name, "build()");
                proposals[i].build(addresses);
            }

            // Run proposal step
            if (DO_RUN) {
                if (DEBUG) console.log("Proposal", name, "run()");
                proposals[i].run(addresses, address(proposals[i]));
            }

            // Teardown step
            if (DO_TEARDOWN) {
                if (DEBUG) console.log("Proposal", name, "teardown()");
                proposals[i].teardown(addresses, address(proposals[i]));
            }

            // Validate step
            if (DO_VALIDATE) {
                if (DEBUG) console.log("Proposal", name, "validate()");
                proposals[i].validate(addresses, address(proposals[i]));
            }

            if (DEBUG) console.log("Proposal", name, "done.");

            postProposalVmSnapshots[i] = vm.snapshot();
        }

        return postProposalVmSnapshots;
    }
}
