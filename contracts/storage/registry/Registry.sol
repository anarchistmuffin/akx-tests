// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "./IRegistry.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract Registry is IRegistry, Ownable {

    bytes32 public INTERNAL_REGISTRY_SLOT;

    using Counters for Counters.Counter;

    Counters.Counter private _index;

    mapping(bytes4 => mapping(address => bool)) private _entries;
    mapping(bytes4 => bool) private _supportedInterfaceIds;
    mapping(bytes4 => address) private _contracts;
    mapping(uint256 => mapping(bytes4 => address)) private _indexedInterfacesToContracts;
    mapping(uint256 => bytes4) private _indexedInterfaces;
    mapping(bytes4 => uint256) _allIds;
    mapping(uint256 => bool) _idExists;
    uint256[] _ids;




    uint internal _setupped;

    constructor(bytes32 rID) {
        INTERNAL_REGISTRY_SLOT = rID;
        _setup();
    }

    function _setup() setupable private {
        initIndex();
        _setupped = 1;
    }

    function _register(bytes4 interfaceId, address contractAddress) public onlyOwner isSetupped returns (uint256) {
        require(_supportedInterfaceIds[interfaceId] != true, "REGISTRY: already registered");

        _supportedInterfaceIds[interfaceId] = true;
        _contracts[interfaceId] = contractAddress;
        _entries[interfaceId][contractAddress] = true;
        uint id = _index.current();
        _ids.push(id);
        _indexedInterfaces[id] = interfaceId;
        _allIds[interfaceId] = id;
        _indexedInterfacesToContracts[id][interfaceId] = contractAddress;
        _idExists[id] = true;
        return id;
    }

    function initIndex() internal {
        _index.increment();
    }

    function _deregister(uint256 rid, bytes4 interfaceId) public onlyOwner isSetupped isRegistered(rid, interfaceId) {
delete _supportedInterfaceIds[interfaceId];
address _c = _contracts[interfaceId];
delete _entries[interfaceId][_c];
        delete _contracts[interfaceId];
delete _allIds[interfaceId];
delete _indexedInterfaces[rid];
delete _indexedInterfacesToContracts[rid][interfaceId];
delete _idExists[rid];
delete _allIds[interfaceId];
}

function getRegitryItemByRid(uint256 _rid) public view virtual returns(bytes4) {
require(_idExists[_rid] == true, "Registry: Item not found");
return _indexedInterfaces[_rid];
}


modifier setupable() {
require(_setupped != 1, "REGISTRY: setup already done");
_;
}

modifier isSetupped() {
require(_setupped == 1, "REGISTRY: setup needed");
_;
}

modifier isRegistered(uint256 rId, bytes4 iid) {
require(_indexedInterfaces[rId] == iid, "REGISTRY: not registered");
    _;
}

modifier isNotRegistered(uint256 rId, bytes4 iid) {
require(_indexedInterfaces[rId] != iid, "REGISTRY: already registered");
    _;
}

}