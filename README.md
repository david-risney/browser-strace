browser-strace
================

Logging DOM calls in and DOM callbacks out in the browser - like strace but for the browser.

Plan
====

- [ ] Shimming and logging functions
  - [ ] Configurable destination - default console
  - [ ] Configurable content - function, duration, stack, logical async stack
- [ ] webidl parser
  - [ ] webidl grammar for PEG.js parser generator
  - [ ] parsed webidl to shim calls
- [ ] browser extensions
  - [ ] Edge extension
  - [ ] Chrome extension
  - [ ] Inject shims to start of every page
