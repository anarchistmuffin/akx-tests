// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

interface IRegistry {

    function _register(bytes4 interfaceId, address contractAddress) external returns (uint256 id);

    function _deregister(uint256 rid, bytes4 interfaceId) external;



}