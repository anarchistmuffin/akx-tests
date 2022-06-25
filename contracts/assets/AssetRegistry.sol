// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "../storage/registry/Registry.sol";
import "../utils/Assets.sol";

contract AssetRegistry is Registry {


    mapping(bytes4 => mapping(uint256 => mapping(address => bool))) private _assetRegistryEntries;
    mapping(address => bytes4) private _contractToTypeID;
    mapping(address => uint256) private _contractToRegID;
    mapping(bytes4 => mapping(uint256 => address)) private _indexedContractsByType;
    mapping(address => LibAssets.Asset) private _contractToAsset;



    constructor(bytes32 registrySlot) Registry(registrySlot) {

    }

    function registerNewAsset(LibAssets.Asset memory _asset) public onlyOwner {
        uint256 regID = _register(_asset.typeId, _asset.assetAddress);
        _asset.regID = regID;
        _assetRegistryEntries[_asset.typeId][regID][_asset.assetAddress] = true;
        _contractToTypeID[_asset.assetAddress] = _asset.typeId;
        _contractToRegID[_asset.assetAddress] = regID;
        _contractToAsset[_asset.assetAddress] = _asset;
        _indexedContractsByType[_asset.typeId][regID] = _asset.assetAddress;
    }

    function assetIsValid(bytes4 iid, uint256 rid, address _c) public view virtual returns (bool) {
        return _assetRegistryEntries[iid][rid][_c] == true;
    }

    function getAsset(uint256 rId) public view virtual returns (LibAssets.Asset memory) {
        bytes4 Iid = getRegitryItemByRid(rId);
        address cAddr = _indexedContractsByType[Iid][rId];
        return _contractToAsset[cAddr];
    }

    function getAsset(address _c) public view virtual returns (LibAssets.Asset memory) {
        return getAssetFromAddress(_c);
    }

    function getRegId(address _c) public view virtual returns (uint256) {
        return _contractToRegID[_c];
    }

    function getTypeId(address _c) public view virtual returns (bytes4) {
        return _contractToTypeID[_c];
    }

    function getAssetFromAddress(address _c) private view returns (LibAssets.Asset memory) {
        return _contractToAsset[_c];
    }


}
