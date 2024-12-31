import { UserConfig } from "@11ty/eleventy";
import { execSync } from "node:child_process";
import {
  mkdirSync,
  readdirSync,
  readFileSync,
  write,
  writeFileSync,
} from "node:fs";

export function registerShortcodes(eleventyConfig: UserConfig): void {
  _setupMedia(eleventyConfig);
  _setupJaspr(eleventyConfig);
}

function _setupMedia(eleventyConfig: UserConfig): void {
  eleventyConfig.addShortcode(
    "ytEmbed",
    function (id: string, title: string, type = "video", fullWidth = false) {
      let embedTypePath = "";
      if (type === "playlist") {
        embedTypePath = "playlist?list=";
      } else if (type === "series") {
        embedTypePath = "videoseries?list=";
      }

      return `<iframe ${
        fullWidth ? 'class="full-width"' : 'width="560" height="315"'
      } 
        src="https://www.youtube.com/embed/${embedTypePath}${id}" title="${title}" frameborder="0" 
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
        allowfullscreen loading="lazy"></iframe><br>
        <p><a href="https://www.youtube.com/watch/${id}" target="_blank" rel="noopener" title="Open '${title}' video in new tab">${title}</a></p>`;
    }
  );

  eleventyConfig.addPairedShortcode(
    "videoWrapper",
    function (content: string, intro = "") {
      let wrapperMarkup = '<div class="video-wrapper">';
      if (intro && intro !== "") {
        wrapperMarkup += `<span class="video-intro">${intro}</span>`;
      }

      wrapperMarkup += content;
      wrapperMarkup += "</div>";
      return wrapperMarkup;
    }
  );
}

function _setupJaspr(eleventyConfig: UserConfig): void {
  let files = readdirSync("lib/components/");

  for (let file of files) {
    if (!file.endsWith(".dart")) continue;

    let name = file.replace(".dart", "");
    let runner = ".dart_tool/11ty/" + name + "_runner.dart";
    let exe = ".dart_tool/11ty/" + name + "_runner";

    let content = readFileSync("lib/components/" + file, { encoding: "utf-8" });
    if (content.includes("Component build(List<String> args) {")) {
      mkdirSync(".dart_tool/11ty/" + name, { recursive: true });
      writeFileSync(
        runner,
        `
        import 'dart:io';
        import 'package:jaspr/server.dart';
        import 'package:dart_dev/components/${name}.dart' show build;

        void main(List<String> args) async {
          Jaspr.initializeApp(useIsolates: false);
          stdout.writeln(await renderComponent(build(args), standalone: true));
        }
        `
      );
      execSync(`dart compile exe ${runner} -o ${exe}`);

      eleventyConfig.addShortcode(name, function (...args: string[]) {
        let result = execSync(`${exe} ${args.join(" ")}`, {
          encoding: "utf-8",
        });

        return result;
      });
    } else if (
      content.includes("Component build(List<String> args, Component child) {")
    ) {
      mkdirSync(".dart_tool/11ty/" + name, { recursive: true });
      writeFileSync(
        runner,
        `
        import 'dart:io';
        import 'package:jaspr/server.dart';
        import 'package:dart_dev/components/${name}.dart' show build;

        void main(List<String> args) async {
          final content = File(args.first).readAsStringSync();

          Jaspr.initializeApp(useIsolates: false);
          stdout.writeln(await renderComponent(build(args.skip(1).toList(), raw(content)), standalone: true));
        }
        `
      );
      execSync(`dart compile exe ${runner} -o ${exe}`);

      let contentFile = ".dart_tool/11ty/" + name + "_content.txt";

      let results = {};

      eleventyConfig.addPairedShortcode(
        name,
        function (content: string, ...args: string[]) {
          let cacheKey = content + "|" + args.join("|");
          let cached = results[cacheKey];

          if (cached) {
            return cached;
          }

          writeFileSync(contentFile, content);
          console.log("RUN", name, contentFile, args);
          let result = execSync(`${exe} ${contentFile} ${args.join(" ")}`, {
            encoding: "utf-8",
          });

          results[cacheKey] = result;

          return result;
        }
      );
    }
  }
}
