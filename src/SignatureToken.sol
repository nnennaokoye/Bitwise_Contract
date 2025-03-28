// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";


contract SignatureToken is ERC20 ("",""){

    function mintWithSignature(address y, uint256 amount, bytes memory signature) public {
        cverify(y, amount, signature);
        _mint(y, amount);
    }

    function cverify(address x, uint256 y, bytes memory sig) internal pure {
        bytes32 h = keccak256(abi.encodePacked(x, y));
        h = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", h)
        );
        if (ECDSA.recover(h, sig) != x) revert("NOMINT");
    }
}