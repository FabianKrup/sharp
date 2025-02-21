const sharp = require("sharp");
const { exec } = require("child_process");
const fs = require("fs");
const path = require("path");

const inputPath = path.resolve(process.cwd(), "image.heif");
const outputPath = path.resolve(process.cwd(), "output.png");

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

  exec("which vips", (error, stdout, stderr) => {
    if (error) {
      console.error("vips not found in PATH");
    } else {
      console.log("vips location:", stdout);
    }
  });

  exec(
    `vips copy "${inputPath}" "${outputPath}"`,
    {
      env: {
        ...process.env,
        PATH: "/usr/local/bin:" + process.env.PATH,
        LD_LIBRARY_PATH: "/usr/local/lib:" + process.env.LD_LIBRARY_PATH,
      },
    },
    (error, stdout, stderr) => {
      if (error) {
        console.error(`Error: ${error.message}`);
        return;
      }
      if (stderr) {
        console.error(`Stderr: ${stderr}`);
        return;
      }
      console.log(`Stdout: ${stdout}`);
    }
  );

  try {
    await image.toFormat("png").toFile("output-sharp.png");
    console.log("Conversion successful using sharp");
  } catch (err) {
    console.error("Sharp conversion error:", err);
  }
}

main();
