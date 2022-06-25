// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "../utils/IERC165.sol";
import "../utils/Assets.sol";

interface IAsset {
    function create(LibAssets.AssetType, bytes calldata _data) external returns (address);

    function isAsset(address) external returns (bool);

    function isNative(address) external returns (bool);

    function isToken(address) external returns (bool);

    function isNftLike(address) external returns (bool);

    function isNftGalleryLike(address) external returns (bool);

    function isPair(address) external returns (bool);

    function isOracle(address) external returns (bool);

    function initialize(address, bytes calldata) external;

}
