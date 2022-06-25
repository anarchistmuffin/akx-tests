// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "../storage/ACLStorage.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/beacon/IBeaconUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
//import "./LabzToken.sol";
import "../Proxy/SafeTokenProxy.sol";

contract LabzTokenControllerLogicBeaconProxy is
Initializable,
IBeaconUpgradeable,
SafeTokenProxy

{

    address public _acl;
    address public _underlyingToken;

    function initialize(
        address _aclImplementation,
        address _token
    ) public initializer {

        _acl = _aclImplementation;
        _underlyingToken = _token;

    }

    function name() public returns (string memory) {
        return sName(IERC20(_underlyingToken));
    }

    function symbol() public returns (string memory) {
        return sSymbol(IERC20(_underlyingToken));
    }

    function decimals() public returns (uint8) {
        return sDecimals(IERC20(_underlyingToken));
    }

    function totalSupply() public returns (uint256) {
        return sTotalSupply(IERC20(_underlyingToken));
    }

    function getUnderlyingToken()
    public
    view
    returns (address)
    {
        return _underlyingToken;
    }



    /**
     * @dev Must return an address that can be used as a delegate call target.
	 *
	 * {BeaconProxy} will check that this address is a contract.
	 */

    /**
   * @dev Must return an address that can be used as a delegate call target.
	 *
	 * {BeaconProxy} will check that this address is a contract.
	 */
    function implementation() public view override returns (address) {
        return getUnderlyingToken();
    }
}
