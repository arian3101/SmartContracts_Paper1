const web3 = require('web3');

const contractAddress = 'YOUR_CONTRACT_ADDRESS';
const contractAbi = [ /* Your contract ABI here */ ];
const contractInstance = new web3.eth.Contract(contractAbi, contractAddress);

const identity = 'YourIdentity';
const response = 'YourResponse';
const randomNonce = 123; // Example randomNonce
const timestamp = 1630100600; // Example timestamp
const R1 = '0x...'; // Replace with the actual value of R1
const R2 = '0x...'; // Replace with the actual value of R2
const challenge = 'YourChallenge';

// Encode the string arguments properly using abi.encodePacked
const encodedIdentity = web3.utils.asciiToHex(identity);
const encodedResponse = web3.utils.asciiToHex(response);
const encodedChallenge = web3.utils.asciiToHex(challenge);

// Call the verifyAndCalculateR4 function with the correctly encoded arguments
contractInstance.methods.verifyAndCalculateR4(
    encodedIdentity,
    encodedResponse,
    randomNonce,
    timestamp,
    R1,
    R2,
    encodedChallenge
).call((err, result) => {
    if (err) {
        console.error('Error:', err.message);
    } else {
        console.log('R4:', result);
    }
});
