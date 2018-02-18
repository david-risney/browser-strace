browser-strace
================

Logging DOM calls in and DOM callbacks out in the browser - like strace but for the browser.

Plan
====

- [ ] Shimming and logging functions
  - [X] Shim functions
  - [X] Shim getters and setters
  - [X] Shim callbacks
  - [ ] Configurable destination - default console
  - [ ] Configurable content - function, duration, s tack, asyc caller id
- [ ] webidl parser
  - [ ] webidl grammar for PEG.js parser generator
  - [ ] parsed webidl to shim calls
- [ ] browser extensions
  - [ ] Edge extension
  - [ ] Chrome extension
  - [ ] Inject shims to start of every page
  - [ ] Pause button
  - [ ] Regex to filter shimmed functions
  - [ ] Checkbox for stacks
