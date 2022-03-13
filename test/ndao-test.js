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
    });

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

describe("NDAO Vesting Contract Testing", async function(){
    let Aragorn, Bilbo, Cersei, Daenerys, Elijah, Ferb, Gandalf, ndao, anyx, vesting, multisig;
    beforeEach("Pre-requisites", async function(){
        [Aragorn, Bilbo, Cersei, Daenerys, Elijah, Ferb, Gandalf] = await ethers.getSigners();
        const testCoin = await ethers.getContractFactory("testAnyx");
        const Ndao = await ethers.getContractFactory("testNDAO");
        const coreTeam = await ethers.getContractFactory("testNDAOVesting");
        const community = await ethers.getContractFactory("testDAOMultisig");
        anyx = await testCoin.deploy();
        ndao = await Ndao.deploy();
        vesting = await coreTeam.deploy(ndao.address, [Aragorn.address, Bilbo.address, Cersei.address], [Daenerys.address, Elijah.address]
            , Ferb.address, Gandalf.address);
        multisig = await community.deploy(["0xA7c059141A9197f07a045fE48103D23E9795925E", "0xDbb02C8B9B2D262aA3ED84Cf37DD050C4AD211d1", "0x098f899C222C1C2fB33552862A882fDeAb25a196",
            "0x0F06707E5E4f7329d2497121d536479c3c4F1129", "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4"]);
        await ndao.connect(Aragorn).setCoreTeam(vesting.address);
        await ndao.connect(Aragorn).initialMinter();
    });

    it('Test 1: Advisors and Auditors can claim monthly', async function(){
        await expect(vesting.connect(Aragorn).claimAdvisorAndAuditorMonthlyRemuneration())
            .to.be.revertedWith('Salary not unlocked for the next month');
        setTimeout(function () {
            console.log('The code went to sleep for', 10)
        }, 10);
        function timeout(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
        await timeout(10*1000)
        await vesting.connect(Aragorn).claimAdvisorAndAuditorMonthlyRemuneration();
        expect(BigNumber.from(await ndao.balanceOf(Daenerys.address)).toString()).to.equal(ethers.utils.parseEther('100000'));
        expect(BigNumber.from(await ndao.balanceOf(Elijah.address)).toString()).to.equal(ethers.utils.parseEther('100000'));
        await expect(vesting.connect(Gandalf).claimAdvisorAndAuditorMonthlyRemuneration())
            .to.be.revertedWith('Salary not unlocked for the next month');
    });

    it('Test 2: Owners and Devs can claim monthly', async function(){
        await expect(vesting.connect(Ferb).claimDevsAndOwnerMonthlyRemuneration())
            .to.be.revertedWith('Salary not unlocked for the next month');
        setTimeout(function () {
            console.log('The code went to sleep for', 20)
        }, 20);
        function timeout(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
        await timeout(20*1000);
        await vesting.connect(Aragorn).claimDevsAndOwnerMonthlyRemuneration();
        expect(BigNumber.from(await ndao.balanceOf(Cersei.address)).toString()).to.equal(ethers.utils.parseEther('10000'));
        expect(BigNumber.from(await ndao.balanceOf(Aragorn.address)).toString()).to.equal(ethers.utils.parseEther('10000'));
        expect(BigNumber.from(await ndao.balanceOf(Bilbo.address)).toString()).to.equal(ethers.utils.parseEther('10000'));
        expect(BigNumber.from(await ndao.balanceOf(Ferb.address)).toString()).to.equal(ethers.utils.parseEther('20000'));
        expect(BigNumber.from(await ndao.balanceOf(Gandalf.address)).toString()).to.equal(ethers.utils.parseEther('33000'));
        await vesting.connect(Aragorn).claimDevsAndOwnerMonthlyRemuneration();
        expect(BigNumber.from(await ndao.balanceOf(Aragorn.address)).toString()).to.equal(ethers.utils.parseEther('20000'));
        expect(BigNumber.from(await ndao.balanceOf(Bilbo.address)).toString()).to.equal(ethers.utils.parseEther('20000'));
        expect(BigNumber.from(await ndao.balanceOf(Cersei.address)).toString()).to.equal(ethers.utils.parseEther('20000'));
        expect(BigNumber.from(await ndao.balanceOf(Ferb.address)).toString()).to.equal(ethers.utils.parseEther('40000'));
        expect(BigNumber.from(await ndao.balanceOf(Gandalf.address)).toString()).to.equal(ethers.utils.parseEther('66000'));
    });

    it('Test 3: Claiming Reward after 2 years and only once.', async function(){
        await expect(vesting.connect(Ferb).claimFinalReward())
            .to.be.revertedWith('Reward can be claimed after 2 years only');
        setTimeout(function () {
            console.log('The code went to sleep for', 30)
        }, 30);
        function timeout(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
        await timeout(30*1000);
        await vesting.connect(Aragorn).claimFinalReward();
        expect(BigNumber.from(await ndao.balanceOf(Cersei.address)).toString()).to.equal(ethers.utils.parseEther('200000'));
        expect(BigNumber.from(await ndao.balanceOf(Aragorn.address)).toString()).to.equal(ethers.utils.parseEther('200000'));
        expect(BigNumber.from(await ndao.balanceOf(Bilbo.address)).toString()).to.equal(ethers.utils.parseEther('200000'));
        expect(BigNumber.from(await ndao.balanceOf(Ferb.address)).toString()).to.equal(ethers.utils.parseEther('400000'));
        expect(BigNumber.from(await ndao.balanceOf(Gandalf.address)).toString()).to.equal(ethers.utils.parseEther('1000000'));
        await expect(vesting.connect(Ferb).claimFinalReward())
            .to.be.revertedWith('Final Reward already claimed');
    });

    it('Test 4: Nobody can claim reward after respective Remuneration period.', async function(){
        setTimeout(function () {
            console.log('The code went to sleep for', 30)
        }, 30);
        function timeout(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
        await timeout(30*1000);
        await vesting.connect(Aragorn).claimAdvisorAndAuditorMonthlyRemuneration();
        await vesting.connect(Aragorn).claimAdvisorAndAuditorMonthlyRemuneration();
        await expect(vesting.connect(Aragorn).claimAdvisorAndAuditorMonthlyRemuneration())
            .to.be.revertedWith('Remuneration period over');
    });

    it('Test 5: Withdraw Funds from Vesting', async function(){
        await vesting.connect(Aragorn).withdrawFunds(Bilbo.address);
        console.log(BigNumber.from(await ndao.balanceOf(Bilbo.address)).toString());
    });

});