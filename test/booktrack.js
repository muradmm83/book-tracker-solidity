const BookTrack = artifacts.require('BookTrack');

contract('BookTrack', accounts => {
    const owner = accounts[0]; // the owner of contract has all roles

    const oneEther = web3.utils.toWei('1', 'ether');
    const twoEthers = web3.utils.toWei('2', 'ether');

    const state = {
        Written: 1,
        Reviewed: 2,
        Bought: 3,
        Sold: 4,
        Published: 5
    };

    it('Write a book', async () => {
        const instance = await BookTrack.deployed();

        await instance.addBook('Solidity Basics', oneEther, { from: owner });

        const info = await instance.getBookInfo.call(1);

        assert(info.state, state.Written, 'book state should be written');
    });

    it('Does not allow sell', async () => {
        let shouldFail = false;

        try {
            const instance = await BookTrack.deployed();

            await instance.sellBook(1, { from: owner });
        } catch {
            shouldFail = true;
        }

        assert(shouldFail, true, 'should fail due to incorrect previous state');
    })

    it('Review a book', async () => {
        const instance = await BookTrack.deployed();

        await instance.reviewBook(1, { from: owner });

        const info = await instance.getBookInfo.call(1);

        assert(info.state, state.Reviewed, 'book state should be written');
    });

    it('Buy a book', async () => {
        const instance = await BookTrack.deployed();

        await instance.buyBook(1, { from: owner, value: twoEthers });

        const info = await instance.getBookInfo.call(1);

        assert(info.state, state.Bought, 'book state should be written');
    });

    it('Sell a book', async () => {
        const instance = await BookTrack.deployed();

        await instance.sellBook(1, { from: owner });

        const info = await instance.getBookInfo.call(1);

        assert(info.state, state.Sold, 'book state should be written');
    });

    it('Publish a book', async () => {
        const instance = await BookTrack.deployed();

        await instance.publishBook(1, { from: owner });

        const info = await instance.getBookInfo.call(1);

        assert(info.state, state.Sold, 'book state should be written');
    });
});