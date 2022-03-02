const { expect } = require("chai");
const { ethers } = require("hardhat");
const { BigNumber } = require("ethers");
const {BN,expectEvent,expectRevert, ether} = require('@openzeppelin/test-helpers');
const {address} = require("hardhat/internal/core/config/config-validation");

describe('NDAO ICO Testing', async function(){
    let owner, ico, ndao, anyx;
    beforeEach("Pre-requisites", async function(){
        [owner] = await ethers.getSigners();
        const Ndao = await ethers.getContractFactory("NDAO");
        const testCoin = await ethers.getContractFactory("Anyx");
        const NdaoICO = await ethers.getContractFactory("NDAOICO");
        ndao = await Ndao.deploy();
        anyx = await testCoin.deploy();
        ico = await NdaoICO.deploy(await anyx.address, await ndao.address);
        await anyx.connect(owner).approve(ico.address, ethers.utils.parseEther('100000'));
    })

    it('Test: Buying NDAO tokens', async function(){
        await ico.connect(owner).Invest(5);
    });

});