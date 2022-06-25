// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;


import "../token/IERC20.sol";

abstract contract DataUtils {

    struct returnVal {
        string valType;
        bytes returnValue;
    }

    function returnDataToString(bytes memory data) internal pure returns (string memory) {
        if (data.length >= 64) {
            return abi.decode(data, (string));
        } else if (data.length == 32) {
            uint8 i = 0;
            while (i < 32 && data[i] != 0) {
                i++;
            }
            bytes memory bytesArray = new bytes(i);
            for (i = 0; i < 32 && data[i] != 0; i++) {
                bytesArray[i] = data[i];
            }
            return string(bytesArray);
        } else {
            return "???";
        }
    }

    function stringToSignature(string memory str) internal returns (bytes4) {
        return bytes4(keccak256(abi.encode(str)));
    }

    function callExternalFunctionOnIERC20ForBOOL(IERC20 token, bytes4 sig) internal returns (bool) {
        (bool success,) = address(token).staticcall((abi.encodeWithSelector(sig)));
        return success;
    }

    function callExternalFunctionOnIERC20ForSTRING(IERC20 token, bytes4 sig) internal returns (string memory) {
        (bool success, bytes memory data) = address(token).staticcall((abi.encodeWithSelector(sig)));
        return success ? returnDataToString(data) : "???";
    }

    function callExternalFunctionOnIERC20ForBYTES(IERC20 token, bytes4 sig) internal returns (bytes memory) {
        (bool success, bytes memory data) = address(token).staticcall((abi.encodeWithSelector(sig)));
        return success ? data : abi.encode("???");
    }

    function callExternalFunctionOnIERC20ForUINT8(IERC20 token, bytes4 sig) internal returns (uint8) {
        (bool success, bytes memory data) = address(token).staticcall((abi.encodeWithSelector(sig)));
        return success && data.length == 32 ? abi.decode(data, (uint8)) : uint8(0);
    }

    function callExternalFunctionOnIERC20ForUINT256(IERC20 token, bytes4 sig) internal returns (uint256) {
        (bool success, bytes memory data) = address(token).staticcall((abi.encodeWithSelector(sig)));
        return success && data.length == 32 ? abi.decode(data, (uint256)) : uint256(0);
    }

    function callExternalFunctionOnIERC20ForADDRESS(IERC20 token, bytes4 sig) internal returns (address) {
        (bool success, bytes memory data) = address(token).staticcall((abi.encodeWithSelector(sig)));
        return success && data.length == 32 ? abi.decode(data, (address)) : address(uint160(0));
    }

    function callExternalFunctionOnIERC20WithPARAM(IERC20 token, string memory paramType, bytes memory param, string memory returnType, bytes4 sig) internal returns (string memory, bytes32, address, uint256) {

        bytes32 pt = keccak256(abi.encode(paramType));

        if (pt == keccak256(abi.encode("uint256"))) {
            uint256 arg = toUint256(param);
        }

        if (pt == keccak256(abi.encode("bytes32"))) {
            bytes32 arg = toBytes32(param);
        }

        if (pt == keccak256(abi.encode("address"))) {
            address arg = toAddress(param);
        }
        (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(sig, abi.encode(param)));
        returnVal memory rv = returnVal(returnType, data);
        (string memory _s, bytes32 _b, address _a, uint256 _u) = sendReturn(rv);
        return (_s, _b, _a, _u);
    }


    function toUint256(bytes memory param) internal returns (uint256) {
        return abi.decode(param, (uint256));
    }

    function toBytes32(bytes memory param) internal returns (bytes32) {
        return abi.decode(param, (bytes32));
    }

    function toAddress(bytes memory param) internal returns (address) {

        return address(abi.decode(param, (uint160)));
    }

    function sendReturn(returnVal memory rv) internal returns (string memory, bytes32, address, uint256){
        bytes32 vt = keccak256(abi.encodePacked(rv.valType));
        if (vt == keccak256("error")) revert();
        if (vt == keccak256("string")) {
            (string memory _s, bytes32 _b, address _a, uint256 _u) = (abi.decode(rv.returnValue, (string)), keccak256(abi.encode(0)), address(uint160(0)), 0);
            return (_s, _b, _a, _u);
        }
        if (vt == keccak256("bytes32")) {
            (string memory _s, bytes32 _b, address _a, uint256 _u) = (abi.decode(abi.encode(""), (string)), abi.decode(rv.returnValue, (bytes32)), address(uint160(0)), 0);
            return (_s, _b, _a, _u);
        }
        if (vt == keccak256("address")) {
            (string memory _s, bytes32 _b, address _a, uint256 _u) = (abi.decode(abi.encode(""), (string)), keccak256(abi.encode(0)), abi.decode(rv.returnValue, (address)), 0);
            return (_s, _b, _a, _u);
        }
        if (vt == keccak256("uint256")) {
            (string memory _s, bytes32 _b, address _a, uint256 _u) = (abi.decode(abi.encode(""), (string)), keccak256(abi.encode(0)), address(uint160(0)), abi.decode(rv.returnValue, (uint256)));
            return (_s, _b, _a, _u);
        }
        revert();
    }


}