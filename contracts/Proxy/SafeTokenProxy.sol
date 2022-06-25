// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "../utils/DataUtils.sol";
import "../utils/SafeVars.sol";

abstract contract SafeTokenProxy is DataUtils {

    address private _tokenAddress;
    uint internal _valueId;


    function sName(IERC20 _token) public returns (string memory) {
        return callExternalFunctionOnIERC20ForSTRING(_token, SafeVars.SAFE_ERC20_NAME_SIG);
    }

    function sSymbol(IERC20 _token) public returns (string memory) {
        return callExternalFunctionOnIERC20ForSTRING(_token, SafeVars.SAFE_ERC20_SYMBOL_SIG);
    }

    function sDecimals(IERC20 _token) public returns (uint8) {
        return callExternalFunctionOnIERC20ForUINT8(_token, SafeVars.SAFE_ERC20_DECIMALS_SIG);
    }

    function sTotalSupply(IERC20 _token) public returns (uint256) {
        return callExternalFunctionOnIERC20ForUINT256(_token, SafeVars.SAFE_ERC20_TOTALSUPPLY);
    }

    function sBalanceOf(IERC20 _token, address _to) public returns (uint256) {
        (,,,uint256 _v) = callExternalFunctionOnIERC20WithPARAM(_token, "address", abi.encode(_to), "uint256", SafeVars.SAFE_ERC20_BALANCE_OF);
        return _v;
    }


}