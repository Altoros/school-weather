const log = (data) => {
  if (data === 'eth_getFilterChanges') return;

  console.log(data);
};

const logger = {
  log: (data) => {
    log(data);
  },
};

module.exports = logger;
