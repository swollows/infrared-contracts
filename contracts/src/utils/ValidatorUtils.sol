// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library ValidatorUtils {
    /**
     * @notice Generates a key for validator enumerable set using keccak256 hash of pubKey bytes
     */
    function hash(bytes memory _pub) internal pure returns (bytes32) {
        return keccak256(_pub);
    }

    /**
     * Transform an address into bytes for the credentials appending the 0x01 prefix.
     * @param addr The address to transform.
     * @return The credentials.
     */
    function cred(address addr) internal pure returns (bytes memory) {
        // 1 byte prefix + 11 bytes padding + 20 bytes address = 32 bytes.
        return abi.encodePacked(bytes1(0x01), bytes11(0x0), addr);
    }
}
