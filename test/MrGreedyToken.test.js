const { expect } = require("chai");

NAME = "MrGreedyToken"
SYMBOL = "MGT"
DECIMALS = 6

function parseUnits(value) {
  return ethers.utils.parseUnits(value.toString(), DECIMALS);
}

function fmtUnits(value) {
  return ethers.utils.formatUnits(value._hex, DECIMALS);
}

var Factory, factory;
beforeEach(async () => {
  [owner] = await ethers.getSigners();
  Factory = await ethers.getContractFactory("MrGreedyToken");
  factory = await Factory.deploy(NAME, SYMBOL);
  await factory.deployed();
})

describe("MrGreedyToken", function () {
  it("resulting transfer amount", async function () {
    const result1 = await factory.getResultingTransferAmount(parseUnits(15));
    const resultWhenLessFee = await factory.getResultingTransferAmount(parseUnits(5));

    expect(fmtUnits(result1)).to.equal('5.0');
    expect(fmtUnits(resultWhenLessFee)).to.equal('0.0');
  });
});
