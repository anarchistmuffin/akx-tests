// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";


contract TokenRouter is Initializable, UUPSUpgradeable, ContextUpgradeable, OwnableUpgradeable {

    bool public isUpgradeable;


    function initialize() initializer public {
        __Ownable_init();
        __TokenRouter_init();
        __UUPSUpgradeable_init();


    }

    function __TokenRouter_init() onlyInitializing public {
        __TokenRouter_init_unchained();
    }

    function __TokenRouter_init_unchained() private {

        isUpgradeable = true;


    }


    function _authorizeUpgrade(address newImplementation) internal virtual onlyOwner onlyUpgradeable override {

    }



    modifier onlyUpgradeable() {
        require(isUpgradeable == true, "contract is not upgradeable");
        _;
    }


}