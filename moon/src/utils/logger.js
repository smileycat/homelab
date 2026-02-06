const chalk = initChalk();

function initChalk() {
  const dict = {};
  const reset = "\x1b[0m";
  const colors = [
    { color: "blue", code: "\x1b[34m" },
    { color: "green", code: "\x1b[32m" },
    { color: "red", code: "\x1b[31m" },
    { color: "yellow", code: "\x1b[33m" },
  ];

  colors.forEach((c) => {
    dict[c.color] = (str) => c.code + str + reset;
  });
  return dict;
}

function info(message) {
  console.log(`${new Date().toLocaleString()} ${chalk.green(message)}`);
}

function error(message) {
  console.error(`${new Date().toLocaleString()} ${chalk.red(message)}`);
}

export default {
  info,
  error,
};
