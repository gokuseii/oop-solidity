const hre = require("hardhat");

async function main() {
    const SimpleToken = await hre.ethers.getContractFactory("SimpleToken");
    const simpleToken = await SimpleToken.deploy("SimpleToken", "ST");
    await simpleToken.deployed();

    const ContractsHaterToken = await hre.ethers.getContractFactory("ContractsHaterToken");
    const contractsHaterToken = await ContractsHaterToken.deploy("ContractsHaterToken", "CHT");
    await contractsHaterToken.deployed();

    const MrGreedyToken = await hre.ethers.getContractFactory("MrGreedyToken");
    const mrGreedyToken = await MrGreedyToken.deploy("MrGreedyToken", "MRG");
    await mrGreedyToken.deployed();

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
