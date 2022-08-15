const {assert} = require('chai');

const KryptoBird = artifacts.require('./KryptoBird.test.js');

//check for chai
require('chai')
.use(require('chai-as-promised'))
.should()

contract('KryptoBird', (accounts) => {
    let contract 
    //testing container - describe

    describe('deployment', async()=> {
        //test samples with writing it

        it('deploys successfuly', async() => {
            contract = await KryptoBird.deployed()
            const address = contract.address;
            assert.notEqual(address, '');
            assert.notEqual(address, 0x0);
            assert.notEqual(address, null);
            assert.notEqual(address, undefined);
        })
    })
})