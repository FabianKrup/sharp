const fs = require("fs");

async function main() {
  try {
    const sharp = require("sharp");

    const inputFileBuffer = fs.readFileSync("image.heif");
    const image = sharp(inputFileBuffer);
    await image.png().toFile("output-sharp.png");

    console.log("Conversion successful using sharp");
  } catch (err) {
    console.error("Sharp conversion error:", err);
  }
}

main();
