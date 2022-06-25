// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/PullPayment.sol";

contract BaseNative is Initializable, ERC20, PullPayment {
    bytes4 public constant interfaceId = 0xc00be48e;

    address public owner;
    uint256 public _totalSupply;

    using SafeERC20 for IERC20;

    constructor(string memory _name, string memory _symbol, address payable _beneficiary) ERC20(_name, _symbol) PullPayment() {

    }

    function initialize(address _owner, address _mintTo, uint8 _decimals, uint256 _supply) public initializer {

        owner = _owner;
        _decimals = _decimals;
        _totalSupply = _supply;
        _mint(_mintTo, totalSupply());

    }

    function transferSafe(address _to, uint256 amount) public  payable {
        return IERC20(address(this)).safeTransfer(_to, amount);

    }

    function transferSafeFrom(address _from, address _to, uint256 amount) public payable {
        return IERC20(address(this)).safeTransferFrom(_from, _to, amount);
    }

    function withdraw(uint256 amount, address payable beneficiary) public virtual {
        withdrawPayments(beneficiary);
    }

    function _mint(address account, uint256 amount) internal virtual override(ERC20) {
        super._mint(account, amount);
    }


    function _burn(address account, uint256 amount) internal virtual override(ERC20) {
        super._burn(account, amount);
    }

    receive() external payable {}


}