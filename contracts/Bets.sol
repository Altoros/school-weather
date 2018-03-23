pragma solidity 0.4.19;

import "../external/oraclize/oraclizeAPI_0.5.sol";
import "../external/stringutils/strings.sol";


contract Bets is usingOraclize {
  using strings for *;

  mapping(bytes32 => string) public bets;

  event LogBetCallback(bytes32 queryId, bool result);
  event LogNewBet(bytes32 queryId, string bet);

  OraclizeAddrResolverI OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);

  function __callback(bytes32 queryId, string response) public {
    require(msg.sender == oraclize_cbAddress());
    bool result = response.toSlice().startsWith(bets[queryId].toSlice());
    LogBetCallback(queryId, result);
  }

  function addBet(string bet) public payable {
    var url = "json(https://www.metaweather.com/api/location/834463).consolidated_weather.0.the_temp";
    bytes32 queryId = oraclize_query(1 days, "URL", url);
    bets[queryId] = bet;
    LogNewBet(queryId, bet);
  }
}
