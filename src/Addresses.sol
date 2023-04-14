// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity =0.8.13;

import {Test} from "@forge-std/Test.sol";

contract Addresses is Test {
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

    function _addMainnet(string memory name, address addr) private {
        _mainnet[name] = addr;
        vm.label(addr, name);
    }

    function mainnet(string memory name) public view returns (address) {
        return _mainnet[name];
    }

    function addMainnet(string memory name, address addr) public {
        _addMainnet(name, addr);

        recordedAddresses.push(RecordedAddress({name: name, addr: addr}));
    }

    function resetRecordingAddresses() external {
        delete recordedAddresses;
    }

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
