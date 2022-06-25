// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "./DataUtils.sol";

library SafeVars {

    /*

    {
  BALANCE_OF: '0x9b96eece',
  DECIMALS: '0x313ce567',
  NAME: '0x06fdde03',
  SYMBOL: '0x95d89b41',
  TOTAL_SUPPLY: '0x54c6862b',
  TRANSFER: '0xa9059cbb',
  TRANSFER_FROM: '0x23b872dd'
}

    */

    bytes4 public constant SAFE_ERC20_SYMBOL_SIG = 0x95d89b41;
    bytes4 public constant SAFE_ERC20_NAME_SIG = 0x06fdde03;
    bytes4 public constant SAFE_ERC20_DECIMALS_SIG = 0x313ce567;
    bytes4 public constant SAFE_ERC20_BALANCE_OF = 0x9b96eece;
    bytes4 public constant SAFE_ERC20_TOTALSUPPLY = 0x54c6862b;
    bytes4 public constant SAFE_ERC20_TRANSFER = 0xa9059cbb;
    bytes4 public constant SAFE_ERC20_TRANSFER_FROM = 0x23b872dd;


}