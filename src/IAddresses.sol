// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

interface IAddresses {

    /// function that takes a contract name as input and returns the contract's address.
    /// @param name of contract
    function mainnet(string memory name) external view returns (address);
    
    /// A function that takes a contract name and its address as inputs
    /// and adds the contract to the mainnet mapping. This function is
    /// intended to be called during the deploy stage of a proposal.
    /// @param name of contract
    /// @param addr address of contract
    function addMainnet(string memory name, address addr) external;

    /// clears the recorded addresses added using the addMainnet method.
    /// This function only deletes the array, preserving the data stored
    /// in the mainnet mapping.
    function resetRecordingAddresses() external;

    /// returns all the contract names and addresses added using
    /// the addMainnet method. It returns two arrays:
    /// one for the contract names and one for the contract addresses.
    function getRecordedAddresses()
        external
        view
        returns (string[] memory names, address[] memory addresses);   
}