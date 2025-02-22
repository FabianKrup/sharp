const sharp = require("sharp");
const fs = require("fs");
const path = require("path");

const inputPath = path.resolve(process.cwd(), "image.heif");

fs.stat(inputPath, (err, stats) => {
  if (err) {
    console.error("image.heif not found:", err);
  } else {
    console.log("image.heif size:", stats.size);
  }
});

const image = sharp(inputPath);

async function main() {
  console.log("Environment variables:");
  console.log("PATH:", process.env.PATH);
  console.log("LD_LIBRARY_PATH:", process.env.LD_LIBRARY_PATH);
  console.log("Current working directory:", process.cwd());

  try {
    await image.toFormat("png").toFile("/output/output-sharp.png");
    console.log("Conversion successful using sharp");
  } catch (err) {
    console.error("Sharp conversion error:", err);
  }
}

main();
