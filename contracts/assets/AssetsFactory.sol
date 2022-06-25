// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "../utils/IERC165.sol";
import "./IAsset.sol";
import "../utils/Assets.sol";
import "./AssetRegistry.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "../utils/Assets.sol";


contract AssetsFactory is Initializable, IAsset, IERC165, Ownable {

    /// @dev generated with keccak256("akxlab.asset.native")
    bytes4 public constant ASSET_TYPE_NATIVE = 0xc00be48e;
    /// @dev generated with keccak256("akxlab.asset.token")
    bytes4 public constant ASSET_TYPE_TOKEN = 0x49b8ea9c;
    /// @dev generated with keccak256("akxlab.asset.nft")
    bytes4 public constant ASSET_TYPE_NFT_LIKE = 0xc2bbab49;
    /// @dev generated with keccak256("akxlab.asset.nft.multiple")
    bytes4 public constant ASSET_TYPE_NFT_GALLERY_LIKE = 0x49b8ea9c;
    /// @dev generated with keccak256("akxlab.asset.pair")
    bytes4 public constant ASSET_TYPE_PAIR = 0x845ba6f1;
    /// @dev generated with keccak256("akxlab.asset.oracle")
    bytes4 public constant ASSET_TYPE_ORACLE = 0x49b8ea9c;

    using Counters for Counters.Counter;
    Counters.Counter internal _nonce;

    address internal master;
    address internal _assetRegistry;

    mapping(uint => bytes32) internal _salts;
    mapping(uint => bool) internal _hasSalt;
    mapping(uint => mapping(address => bool)) internal _clones;
    mapping(address => bool) internal _cloneAddresses;


    constructor(address _masterImplementation, address _assetRegistryAddress) {
        _nonce.increment();
        master = _masterImplementation;
        _assetRegistry = _assetRegistryAddress;
    }

    function initialize(address _contract, bytes calldata _date) public initializer {

    }

    function getRegistry() internal returns (AssetRegistry) {
        return AssetRegistry(_assetRegistry);
    }

    function registerNewAsset(LibAssets.AssetType aType, address _assetAddress, bytes4 typeID) internal {
        LibAssets.Asset memory _asset = LibAssets.Asset(aType, typeID, _assetAddress, _nonce.current() - 1, 0);
        getRegistry()._register(typeID, _assetAddress);
    }

    function getSalt(uint nonce) private returns (bytes32) {
        require(_hasSalt[nonce] == true, "ASSET FACTORY: no salt");
        return _salts[nonce];
    }

    function setSalt(address _impl, bytes4 _ASSET_TYPE_ID) internal {

        bytes memory _salt = abi.encode(_impl, _ASSET_TYPE_ID, _nonce.current());
        bytes32 sKeccak = keccak256(_salt);
        require(_hasSalt[_nonce.current()] != true, "ASSET FACTORY: salt not unique");
        _salts[_nonce.current()] = sKeccak;
        _hasSalt[_nonce.current()] = true;
    }

    function getAddress(uint256 nonce) public returns (address) {
        return Clones.predictDeterministicAddress(master, getSalt(nonce));
    }

    function create(LibAssets.AssetType aType, bytes calldata _data) public onlyOwner returns (address) {
        bytes4 AT = getAssetTypeID(aType);
        bytes32 salt = _salts[_nonce.current()];
        Clones.cloneDeterministic(master, salt);
        address addr = getAddress(_nonce.current());
        IAsset(addr).initialize(addr, _data);
        _nonce.increment();
        return addr;
    }

    function getAssetTypeID(LibAssets.AssetType aType) public view onlyOwner returns (bytes4 ASSET_TYPE_ID) {
        if (aType == LibAssets.AssetType.NATIVE) {
            ASSET_TYPE_ID = ASSET_TYPE_NATIVE;
        }
        if (aType == LibAssets.AssetType.TOKEN) {
            ASSET_TYPE_ID = ASSET_TYPE_TOKEN;
        }
        if (aType == LibAssets.AssetType.NFT_LIKE) {
            ASSET_TYPE_ID = ASSET_TYPE_NFT_LIKE;
        }
        if (aType == LibAssets.AssetType.NFT_GALLERY_LIKE) {
            ASSET_TYPE_ID = ASSET_TYPE_NFT_GALLERY_LIKE;
        }
        if (aType == LibAssets.AssetType.PAIR) {
            ASSET_TYPE_ID = ASSET_TYPE_PAIR;
        }
        if (aType == LibAssets.AssetType.ORACLE) {
            ASSET_TYPE_ID = ASSET_TYPE_ORACLE;
        }
        revert("invalid asset type");
    }

    function isAsset(address _contract) external returns (bool) {
        return IERC165(_contract).supportsInterface(getAssetTypeID(LibAssets.AssetType.NATIVE)) || IERC165(_contract).supportsInterface(ASSET_TYPE_TOKEN) ||
        IERC165(_contract).supportsInterface(ASSET_TYPE_NFT_LIKE) || IERC165(_contract).supportsInterface(ASSET_TYPE_NFT_GALLERY_LIKE) || IERC165(_contract).supportsInterface(ASSET_TYPE_PAIR) ||
        IERC165(_contract).supportsInterface(ASSET_TYPE_ORACLE);
    }

    function isNative(address _contract) external returns (bool) {
        return IERC165(_contract).supportsInterface(getAssetTypeID(LibAssets.AssetType.NATIVE));
    }

    function isToken(address _contract) external returns (bool) {
        return IERC165(_contract).supportsInterface(getAssetTypeID(LibAssets.AssetType.TOKEN));
    }

    function isNftLike(address _contract) external returns (bool) {
        return IERC165(_contract).supportsInterface(getAssetTypeID(LibAssets.AssetType.NFT_LIKE));
    }

    function isNftGalleryLike(address _contract) external returns (bool) {
        return IERC165(_contract).supportsInterface(getAssetTypeID(LibAssets.AssetType.NFT_GALLERY_LIKE));
    }

    function isPair(address _contract) external returns (bool) {
        return IERC165(_contract).supportsInterface(getAssetTypeID(LibAssets.AssetType.PAIR));
    }

    function isOracle(address _contract) external returns (bool) {
        return IERC165(_contract).supportsInterface(getAssetTypeID(LibAssets.AssetType.ORACLE));
    }


    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
    return interfaceId == type(IERC165).interfaceId && (
        interfaceId == ASSET_TYPE_NATIVE || interfaceId == ASSET_TYPE_NFT_LIKE || interfaceId == ASSET_TYPE_NFT_GALLERY_LIKE
        || interfaceId == ASSET_TYPE_TOKEN || interfaceId == ASSET_TYPE_PAIR || interfaceId == ASSET_TYPE_ORACLE
    );
    }


}

