// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity =0.8.13;

interface IAddresses {
    function mainnet(string memory name) external view returns (address);

    function addMainnet(string memory name, address addr) external;

    function resetRecordingAddresses() external;

    function getRecordedAddresses()
        external
        view
        returns (string[] memory names, address[] memory addresses);   
}