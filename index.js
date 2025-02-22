const fs = require("fs");
const { execSync } = require("child_process");

fs.stat("image.heif", (err, stats) => {
  if (err) {
    console.error("image.heif not found:", err);
  } else {
    console.log("image.heif size:", stats.size);
  }
});

async function main() {
  // vips version
  console.log("vips version:", execSync("vips -v").toString());

  // small timeouts
  await new Promise((resolve) => setTimeout(resolve, 5000));

  try {
    execSync(`vips copy image.heif output-vips.png`);

    console.log("Conversion successful using vips CLI");
  } catch (err) {
    console.error("Vips attempt failed:", err);
  }

  try {
    const sharp = require("sharp");

    //const inputFileBuffer = fs.readFileSync("image.heif");
    //const image = sharp(inputFileBuffer);
    const image = sharp("image.heif");
    await image.png().toFile("output-sharp.png");

    console.log("Conversion successful using sharp");
  } catch (err) {
    console.error("Sharp conversion error:", err);
  }
}

main();
