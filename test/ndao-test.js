const { expect } = require("chai");
const { ethers } = require("hardhat");
const { BigNumber } = require("ethers");

describe('NDAO ICO Testing', async function(){
    let owner, ico, ndao, anyx, owner2;
    beforeEach("Pre-requisites", async function(){
        [owner, owner2] = await ethers.getSigners();
        const Ndao = await ethers.getContractFactory("testNDAO");
        const testCoin = await ethers.getContractFactory("testAnyx");
        const NdaoICO = await ethers.getContractFactory("testNDAOICO");
        anyx = await testCoin.deploy();
        ndao = await Ndao.deploy();
        ico = await NdaoICO.deploy(anyx.address, ndao.address);
        await anyx.connect(owner).approve(ico.address,
            ethers.utils.parseEther('1000000000000'));
        await anyx.connect(owner2).approve(ico.address,
            ethers.utils.parseEther('1000000000000'));
        await ndao.connect(owner).setGI(ico.address);
        await ndao.connect(owner).initialMinter();
    })

    it('Test 1: Buying NDAO tokens', async function(){
        ///@dev Here the user wants to buy 0.05 NDAO tokens.
        await ico.connect(owner).Invest(5);
        expect (BigNumber.from(await ndao.balanceOf(owner.address)).toString()).to.equal('50000000000000000');
        expect (BigNumber.from(await anyx.balanceOf(ico.address)).toString()).to.equal('12500');
        await anyx.connect(owner2).mintTestTokens(100);
        await ico.connect(owner2).Invest(8);
        expect (BigNumber.from(await anyx.balanceOf(ico.address)).toString()).to.equal('32500');
    });

    it('Test 2: Extracting Invested Money', async function(){
        await ico.connect(owner).Invest(5);
        await ico.connect(owner).ExtractInvestment(owner2.address, 500);
        expect (BigNumber.from(await anyx.balanceOf(ico.address)).toString()).to.equal('12000');
    });

    it('Test 3: Withdrawing Unsold NDAO tokens', async function(){
        await ico.connect(owner).Invest(7);//17500
        await ico.connect(owner).withdrawUnsoldNDaoTokens(owner.address);
        expect (BigNumber.from(await anyx.balanceOf(owner.address)).toString()).to.equal('999982500');
    });

    it('Test 4: Changing Base Price of NDAO tokens', async function(){
        await ico.connect(owner).Invest(7);
        expect (BigNumber.from(await anyx.balanceOf(ico.address)).toString()).to.equal('17500');
        await ico.connect(owner).changeBasePrice(0.50 *10**6);
        await anyx.connect(owner2).mintTestTokens(100);
        await ico.connect(owner2).Invest(8);
        expect (BigNumber.from(await anyx.balanceOf(ico.address)).toString()).to.equal('57500');
    });
});

