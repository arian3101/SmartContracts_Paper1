pragma solidity ^0.8.0;

contract Regfun_m {
    mapping(string => string) verificationTable;
    event ComputationResultAdded(string indexed identity, bytes32 s4, bytes32 s2, string responseValue);

    // Add data to the verification table
    function addToVerificationTable(string memory identity, string memory responseValue) public {
        verificationTable[identity] = responseValue;
    }

    function isIdentityVerified(string memory identity) public view returns (bool) {
        return bytes(verificationTable[identity]).length > 0;
    }
    function generateRandomNumber() internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.number, block.coinbase, block.gaslimit))) % 1000;
    }
    function concatenateStrings(string memory a, string memory b, string memory c) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b, c));
    }
    function xorBytes(bytes memory b1, bytes memory b2) internal pure returns (bytes32) {
        require(b1.length == b2.length, "Bytes must have equal length for XOR");
        bytes32 result;
        for (uint256 i = 0; i < b1.length; i++) {
            result |= bytes32(b1[i]) ^ bytes32(b2[i]) >> (i * 8);
        }

        return result;
    }
    function calculateHash(string memory value) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(value));
    }
    // Add to a new block of the blockchain
    function performComputation(string memory identity, string memory password) public {
        require(isIdentityVerified(identity), "Identity not verified in the verification table");
        uint256 randomNumber = generateRandomNumber();
        string memory responseValue = verificationTable[identity];
        string memory s0 = concatenateStrings(identity, uint2str(randomNumber), responseValue);

        bytes32 s1 = calculateHash(s0);

        bytes memory passwordBytes = bytes(password);
        bytes32 s2 = xorBytes(bytes(s0), passwordBytes);
        string memory s3 = concatenateStrings(responseValue, uint2str(randomNumber), "");
        bytes32 s4 = s1 ^ (keccak256(abi.encodePacked(identity)));
        emit ComputationResultAdded(identity, s4, s2, responseValue,challenge);
    }
    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = uint8(48 + _i % 10);
            bstr[k] = bytes1(temp);
            _i /= 10;
        }
        return string(bstr);
    }
}
