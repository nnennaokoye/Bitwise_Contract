// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../src/SignatureToken.sol";

contract SignatureTokenTest is Test {
    SignatureToken token;
    address public validSigner = address( 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
    address public invalidSigner = address(0xa0Ee7A142d267C1f36714E4a8F75612F20a79720); 
    uint256 public mintAmount = 1000;

    // Private keys for valid and invalid signers
    uint256 private validPrivateKey =  0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 private invalidPrivateKey = 0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6;

    function setUp() public {
        token = new SignatureToken();
    }

    function testMintWithValidSignature() public {
        // Create a message hash
        bytes32 message = keccak256(abi.encodePacked(validSigner, mintAmount));
        message = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", message));
        
        // Sign the message with the validSigner using valid private key
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(validPrivateKey, message);
        bytes memory signature = abi.encodePacked(r, s, v);
        
        // Mint tokens with the valid signature
        token.mintWithSignature(validSigner, mintAmount, signature);

        // Check the balance of validSigner
        uint256 balance = token.balanceOf(validSigner);
        assertEq(balance, mintAmount, "Valid signer should mint tokens");
    }

    function testRevertMintWithInvalidSignature() public {
        // Create a message hash for the validSigner
        bytes32 message = keccak256(abi.encodePacked(validSigner, mintAmount));
        message = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", message));
        
        // Sign the message with the invalidSigner (using the invalid private key)
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(invalidPrivateKey, message);  
        bytes memory signature = abi.encodePacked(r, s, v);
        
        // Expect revert with the "NOMINT" error
        vm.expectRevert("NOMINT");
        token.mintWithSignature(validSigner, mintAmount, signature);
    }
}
