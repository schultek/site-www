import {UserConfig} from '@11ty/eleventy';
import { execSync } from "node:child_process";
import { mkdirSync, writeFileSync } from "node:fs";

export function registerShortcodes(eleventyConfig: UserConfig): void {
  _setupMedia(eleventyConfig);
  _setupJaspr(eleventyConfig);
}

function _setupMedia(eleventyConfig: UserConfig): void {
  eleventyConfig.addShortcode('ytEmbed', function (id: string, title: string, type = 'video', fullWidth = false) {
    let embedTypePath = '';
    if (type === 'playlist') {
      embedTypePath = 'playlist?list=';
    } else if (type === 'series') {
      embedTypePath = 'videoseries?list=';
    }

    return `<iframe ${fullWidth ? 'class="full-width"' : 'width="560" height="315"'} 
        src="https://www.youtube.com/embed/${embedTypePath}${id}" title="${title}" frameborder="0" 
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
        allowfullscreen loading="lazy"></iframe><br>
        <p><a href="https://www.youtube.com/watch/${id}" target="_blank" rel="noopener" title="Open '${title}' video in new tab">${title}</a></p>`;
  });

  eleventyConfig.addPairedShortcode('videoWrapper', function (content: string, intro = '') {
    let wrapperMarkup = '<div class="video-wrapper">';
    if (intro && intro !== '') {
      wrapperMarkup += `<span class="video-intro">${intro}</span>`;
    }

    wrapperMarkup += content;
    wrapperMarkup += '</div>';
    return wrapperMarkup;
  });
}

function _setupJaspr(eleventyConfig: UserConfig): void {
  eleventyConfig.addShortcode(
    "component",
    function (name: string, ...args: string[]) {
      var runner = ".dart_tool/11ty/" + name + "_runner.dart";

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

      var result = execSync(`dart run ${runner} ${args.join(" ")}`, {
        encoding: "utf-8",
      });

      return result;
    }
  );
}
