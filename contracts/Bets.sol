pragma solidity ^0.4.19;

import "../oraclize/oraclizeAPI_0.5.sol";
import "../stringutils/strings.sol";
import 'zeppelin-solidity/contracts/lifecycle/Destructible.sol';


contract Bets is usingOraclize, Destructible {
  using strings for *;

  struct Bet {
    uint total;
    mapping(address => string) temperatures;
    address[] addresses;
  }

  mapping(uint => Bet) public bets;
  mapping(bytes32 => uint) public queryIds;

  address[] private winners;

  event LogBetCallback(bytes32 queryId);
  event LogNewBet(bytes32 queryId);
  event LogUint(bytes32 title, uint);

  OraclizeAddrResolverI public OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);

  function() public payable {

  }

  function __callback(bytes32 queryId, string response) public {
    require(msg.sender == oraclize_cbAddress());

    uint timestamp = queryIds[queryId];
    winners = new address[](0);
    for (uint i = 0; i < bets[timestamp].addresses.length; i++) {
      address currentAddress = bets[timestamp].addresses[i];
      string memory temperature = bets[timestamp].temperatures[currentAddress];
      bool isWinner = response.toSlice().startsWith(temperature.toSlice());
      if (isWinner) {
        winners.push(currentAddress);
      }
    }
    if (winners.length > 0) {
      LogUint("Total", bets[timestamp].total);
      LogUint("Winners", winners.length);
      uint sumToTransfer = bets[timestamp].total / winners.length;
      LogUint("Prize", sumToTransfer);
      for (uint j = 0; j < winners.length; j++) {
        winners[j].transfer(sumToTransfer);
      }
    }
    LogBetCallback(queryId);
  }

  function addBet(string temperature, uint timestamp) public payable {
    require(block.timestamp + 1 days < timestamp);

    if (bets[timestamp].total > 0) {
      bets[timestamp].total += msg.value;
      bets[timestamp].temperatures[msg.sender] = temperature;
      bool isPresent = false;
      for (uint i = 0; i < bets[timestamp].addresses.length; i++) {
        if (bets[timestamp].addresses[i] == msg.sender) {
          isPresent = true;
          break;
        }
      }
      if (!isPresent) bets[timestamp].addresses.push(msg.sender);
    } else {
      bets[timestamp] = Bet({
        total : msg.value,
        addresses : new address[](0)
        });
      bets[timestamp].temperatures[msg.sender] = temperature;
      bets[timestamp].addresses.push(msg.sender);

      var url = "json(https://www.metaweather.com/api/location/834463).consolidated_weather.0.the_temp";
      bytes32 queryId = oraclize_query(timestamp, "URL", url);
      queryIds[queryId] = timestamp;
      LogNewBet(queryId);
    }
  }
}
