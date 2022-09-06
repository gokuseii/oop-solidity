const { expect } = require("chai");
const hre = require('hardhat');

var Factory, Factory1, Factory2, factory, factory1, factory2, Validator, validator;
beforeEach(async () => {
  [owner, alice, bob] = await ethers.getSigners();
  Factory = await ethers.getContractFactory("SimpleToken");
  factory = await Factory.deploy("SimpleToken", "ST");
  await factory.deployed();

  Factory1 = await ethers.getContractFactory("ContractsHaterToken");
  factory1 = await Factory1.deploy("ContractsHaterToken", "CHT");
  await factory1.deployed();

  Factory2 = await ethers.getContractFactory("MrGreedyToken");
  factory2 = await Factory2.deploy("MrGreedyToken", "MRG");
  await factory2.deployed();

  Validator = await ethers.getContractFactory("Validator");
  validator = await Validator.deploy()
  await validator.deployed()
})

describe("Validator", function () {
  it("Validate contracts", async function () {
    await factory.transferOwnership(validator.address);
    await factory1.transferOwnership(validator.address);
    await factory2.transferOwnership(validator.address);

    await validator.validate(factory.address, factory1.address, factory2.address)
  });
});
