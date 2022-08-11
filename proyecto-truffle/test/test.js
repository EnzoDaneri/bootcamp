const customERC20 = artifacts.require("customERC20");

contract("customERC20", accounts => {

    console.log("Accounts", accounts);

    it("name", async() => {
        let instance = await customERC20.deployed();
        let _name = await instance.name.call();
        assert.equal(_name, "Enzo");        
    });

    it("symbol", async() => {
        let instance = await customERC20.deployed();
        let _symbol = await instance.symbol.call();
        assert.equal(_symbol, "ED");
    });

    it("decimals", async() => {
        let instance = await customERC20.deployed();
        let _decimals = await instance.decimals.call();
        assert.equal(_decimals, 18);
    });

    it("newTokens", async () => {
        let instance = await customERC20.deployed();

        let _initial_supply = await instance.totalSupply.call();
        assert.equal(_initial_supply, 0);

        await instance.crearTokens();

        let _supply = await instance.totalSupply();
        assert.equal(_supply, 1000);

        let _balance = await instance.balanceOf.call(accounts[1]);
        assert.equal(_balance, 1000, "Este usuario no tiene este balance");

    });

});