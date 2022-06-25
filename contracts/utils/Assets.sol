// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

library LibAssets {

    struct Asset {
        AssetType assetType;
        bytes4 typeId;
        address assetAddress;
        uint256 tokenID;
        uint256 regID;
    }

    enum AssetType {
        NATIVE,
        TOKEN,
        NFT_LIKE,
        NFT_GALLERY_LIKE,
        PAIR,
        ORACLE
    }

}