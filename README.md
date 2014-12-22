javascript-deprecation-verifier
================

Static analysis for JavaScript using deprecated APIs.

Plan
====

1. javascript-deprecation-verifier.ts - TypeScript node.js program that takes JavaScript files and deprecation annotated TypeScript declaration files and reports deprecation errors.
	a. Normal .d.ts files but with deprecation annotation comments.
	b. Deprecation annotation comments come just after the type in a declaration.
	c. For example: function foo() : void /* <deprecated>Use bar instead.</deprecated> */;
2. *.d.ts - Built-in deprecation annotated TypeScript declaration files:
	a. Windows Store application for JavaScript in Window 10 DOM with deprecation annotations for previous Windows Store application platforms.
	b. Latest Internet Explorer DOM with deprecation annotations for previous Internet Explorer.
	c. Subset of DOM APIs common to latest Chrome, Firefox, Internet Explorer, & Safari with deprecation annotations for DOM APIs not available in all browsers.
3. webidl-to-deprecation-typescript-declaration.ts - TypeScript node.js program that takes webidl files to generate 2.a/b and 2.c
	a. Webidl grammar for parser generator. Previous Antlr version has JavaScript as a compilation target.
	b. Version mode takes a series of old webidl files and a series of new webidl files producing a .d.ts file containing union of all types and marking deprecated those things only in old webidl.
	c. Cross platform mode takes a list of named lists of webidl files and prodces a .d.ts file containing union of all types and marking as deprecated anything not appearing in all webidls.
