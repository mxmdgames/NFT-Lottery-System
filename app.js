const contractAddress = 'YOUR_NFT_CONTRACT_ADDRESS'; // Replace with your NFT contract address
const contractABI = NFTContractABI; // Use the ABI you generated

let web3;
let nftContract;
let userAccount;

// Load web3
window.addEventListener('load', async () => {
    if (window.ethereum) {
        web3 = new Web3(window.ethereum);
        try {
            // Request account access if needed
            await window.ethereum.request({ method: 'eth_requestAccounts' });
            // Accounts now exposed
            const accounts = await web3.eth.getAccounts();
            userAccount = accounts[0];
            nftContract = new web3.eth.Contract(contractABI, contractAddress);
        } catch (error) {
            console.error("User denied account access");
        }
    } else {
        console.log('Non-Ethereum browser detected. You should consider trying MetaMask!');
    }
});

// Check NFT ownership function
document.getElementById('checkNFT').addEventListener('click', async () => {
    try {
        const balance = await nftContract.methods.balanceOf(userAccount).call();
        if (balance > 0) {
            document.getElementById('status').innerText = "Ownership verified. Redirecting...";
            // Redirect to the next page
            window.location.href = "nextPage.html"; // Replace with your next page URL
        } else {
            document.getElementById('status').innerText = "You do not own the required NFT.";
        }
    } catch (error) {
        console.error(error);
        document.getElementById('status').innerText = "Error checking ownership.";
    }
});
