`testrpc --gasLimit '0x64B540'`

`cd external ethereum-bridge`

`npm i`

`node bridge -H localhost:8545 -a 1 --dev`

`truffle console`

`compile --all`

`migrate --reset`

`Bets.at('<address>').addBet('1.4', {value: web3.toWei(0.01)})`
