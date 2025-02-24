const fs = require("fs");
const sharp = require("sharp");

async function main() {
  try {
    const inputFileBuffer = fs.readFileSync("image.heif");
    const image = sharp(inputFileBuffer);
    await image.png().toFile("/app/output/output-sharp.png");

    console.log("Conversion successful using sharp");
  } catch (err) {
    console.error("Sharp conversion error:", err);
  }
}

main();
