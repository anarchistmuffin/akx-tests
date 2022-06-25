// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;


import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20SnapshotUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20VotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol";



contract LabzToken is Initializable, ERC20Upgradeable, ERC20PermitUpgradeable, ERC20VotesUpgradeable, ERC20SnapshotUpgradeable {


    string public _name;
    string public _symbol;
    uint8 public _decimals;
    uint256 public _revision;
    uint256 public _totalSupply;


    function initialize(string memory name_, string memory symbol_, uint256 _supply) initializer public {
        _name = name_;
        _symbol = symbol_;

        _decimals = 18;
        _revision = 1;
        __ERC20_init(name_, symbol_);
        __ERC20Permit_init(name_);


        __ERC20Votes_init();
        __ERC20Snapshot_init();

        _mint(msg.sender, _supply);


    }


    function _mint(address account, uint256 amount) internal virtual override(ERC20Upgradeable, ERC20VotesUpgradeable) {
        super._mint(account, amount);
    }


    function _burn(address account, uint256 amount) internal virtual override(ERC20Upgradeable, ERC20VotesUpgradeable) {
        super._burn(account, amount);
    }


    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override(ERC20Upgradeable, ERC20VotesUpgradeable) {
        super._afterTokenTransfer(from, to, amount);

    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override(ERC20Upgradeable, ERC20SnapshotUpgradeable) {
        super._beforeTokenTransfer(from, to, amount);

    }


}