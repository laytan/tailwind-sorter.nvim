const { createContext } = require("tailwindcss/lib/lib/setupContextUtils.js");
const resolveConfig = require("tailwindcss/resolveConfig.js");
const { default: resolveConfigPath } = require("tailwindcss/lib/util/resolveConfigPath.js");

const configPath = resolveConfigPath();
const config = configPath ? require(configPath) : {};
const ctx = createContext(resolveConfig(config));

const texts = JSON.parse(process.argv[2]);
const replacements = texts.map(sortClasses);
console.log(JSON.stringify(replacements));

function sortClasses(classStr: string): string {
  if (typeof classStr !== "string" || classStr === "") {
    return classStr;
  }

  // Ignore class attributes containing `{{`, to match Prettier behaviour:
  // https://github.com/prettier/prettier/blob/main/src/language-html/embed.js#L83-L88
  if (classStr.includes("{{")) {
    return classStr;
  }

  let result = "";
  const parts = classStr.split(/(\s+)/);
  let classes = parts.filter((_, i) => i % 2 === 0);
  const whitespace = parts.filter((_, i) => i % 2 !== 0);

  if (classes[classes.length - 1] === "") {
    classes.pop();
  }

  classes = sortClassList(classes);

  for (let i = 0; i < classes.length; i++) {
    result += `${classes[i]}${whitespace[i] ?? ""}`;
  }

  return result;
}

function bigSign(bigIntValue: bigint): number {
  return Number(bigIntValue > 0n) - Number(bigIntValue < 0n);
}

function sortClassList(classList: string[]): string[] {
  const classNamesWithOrder = ctx.getClassOrder(classList);

  return classNamesWithOrder
    .sort(([, a]: [string, bigint], [, z]: [string, bigint]) => {
      if (a === z) return 0;
      if (a === null) return -1;
      if (z === null) return 1;
      return bigSign(a - z);
    })
    .map(([className]: [string, bigint]) => className);
}
