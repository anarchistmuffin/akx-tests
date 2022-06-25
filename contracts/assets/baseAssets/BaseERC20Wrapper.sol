// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20SnapshotUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20WrapperUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PullPaymentUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";

contract BaseERC20Wrapper is Initializable, ERC20WrapperUpgradeable, ERC20SnapshotUpgradeable, ERC20PermitUpgradeable, PullPaymentUpgradeable {
    bytes4 public constant interfaceId = 0x49b8ea9c;

    string public _prefix = "ak";


    using SafeERC20Upgradeable for IERC20Upgradeable;

    function initialize(string memory prefix, address _token, address payable _beneficiary) public initializer {

            _prefix = prefix;


        __ERC20Wrapper_init(IERC20Upgradeable(_token));
        __ERC20Snapshot_init();
        __ERC20_init(string(abi.encode(_prefix, ERC20Upgradeable(_token).name())), string(abi.encode(_prefix, ERC20Upgradeable(_token).symbol())));
        __ERC20Permit_init(string(abi.encode(_prefix, ERC20Upgradeable(_token).name())));
        __PullPayment_init();

    }

    function decimals() public view virtual override(ERC20Upgradeable,ERC20WrapperUpgradeable) returns(uint8) {
        return 18;
    }

    function transferSafe(address _to, uint256 amount) public payable  {
        IERC20Upgradeable(address(this)).safeTransfer(_to, amount);
    }

    function transferSafeFrom(address _from, address _to, uint256 amount) public payable  {
        IERC20Upgradeable(address(this)).safeTransferFrom(_from, _to, amount);
    }

    function withdraw(uint256 amount, address payable beneficiary) public virtual {
        super.withdrawPayments(beneficiary);
    }

    function _mint(address account, uint256 amount) internal virtual override {
        super._mint(account, amount);
    }


    function _burn(address account, uint256 amount) internal virtual override {
        super._burn(account, amount);
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override(ERC20Upgradeable) {
        super._afterTokenTransfer(from, to, amount);

    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override(ERC20Upgradeable, ERC20SnapshotUpgradeable) {
        super._beforeTokenTransfer(from, to, amount);

    }

    receive() external payable {}


}