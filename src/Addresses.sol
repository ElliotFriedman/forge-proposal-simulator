// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity =0.8.13;

import {Test} from "@forge-std/Test.sol";
import {IAddresses} from "./IAddresses.sol";

contract Addresses is IAddresses, Test {
    mapping(string => address) private _mainnet;

    struct RecordedAddress {
        string name;
        address addr;
    }

    /// @notice recorded addresses is a list of addresses
    /// created during the `deploy` stage of a proposal
    RecordedAddress[] private recordedAddresses;

    /// add all pre-existing smart contracts to the
    /// `_mainnet` mapping using the `_addMainnet` function
    constructor() {
        /// example
        /// _addMainnet("V1_CORE", 0xEC7AD284f7Ad256b64c6E69b84Eb0F48f42e8196);
    }

    /// @notice only call this function during setup, not during deploy stage of a proposal
    /// @param name of the contract
    /// @param addr address of the contract
    function _addMainnet(string memory name, address addr) internal {
        _mainnet[name] = addr;
        vm.label(addr, name);
    }
    
    /// getter function to return the contract address given a contract name
    /// @param name of the contract
    function mainnet(string memory name) public view returns (address) {
        return _mainnet[name];
    }

    /// @notice call this function only during the deploy stage of a proposal
    /// @param name of the contract
    /// @param addr address of the contract
    function addMainnet(string memory name, address addr) public {
        _addMainnet(name, addr);

        recordedAddresses.push(RecordedAddress({name: name, addr: addr}));
    }

    /// @notice clear all recorded addresses that were added using the addMainnet method
    /// only deletes the array, data stored in the mapping is preserved
    function resetRecordingAddresses() external {
        delete recordedAddresses;
    }

    /// @notice return all addresses and names of contracts that were deployed using the
    /// addMainnet method
    function getRecordedAddresses()
        external
        view
        returns (string[] memory names, address[] memory addresses)
    {
        names = new string[](recordedAddresses.length);
        addresses = new address[](recordedAddresses.length);
        for (uint256 i = 0; i < recordedAddresses.length; i++) {
            names[i] = recordedAddresses[i].name;
            addresses[i] = recordedAddresses[i].addr;
        }
    }
}
