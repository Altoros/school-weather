#!/usr/bin/env node

const TestRPC = require('ethereumjs-testrpc');
const logger = require('./logger');

const options = {
  port: 8545,
  logger: {
    log: logger.log,
  },
  gasLimit: '0x64B540',
};

TestRPC
  .server(options)
  .listen(options.port, (err, state) => {
    if (err) console.log(err);
  });
