#### TestRPC

`npm run testrpc`

#### Bridge

`npm run bridge`

#### Truffle

`truffle console`

`compile --all`

`migrate --reset`

`web3.eth.filter({fromBlock: 0}, console.log)`

`web3.eth.sendTransaction({from: '<contract>', to: '<contract>', value: web3.toWei(1, 'ether')})`

`Bets.at('<contract>').addBet('1.4', <timestamp>, {value: web3.toWei(0.01), from: '<account>'})`

`web3.eth.accounts.map(address => {return {address: address, value: web3.fromWei(web3.eth.getBalance(address)).toString()}})`
