# Test the logic test-first; leave the browser-facing files to the type check

## Context

The repo mandates red-green TDD. A Chrome extension resists it in one specific place: the code that touches a live browser. Here that is the MAIN world patch, which replaces `window.matchMedia` and `Element.prototype.animate`, and the two thin files that write an attribute or read a form field.

That code cannot be honestly unit tested. A test would have to build a fake browser that this repo itself invented, so it would only assert that the code calls the methods the test told it to call. It would pass while the real Google Photos page had changed, which is the one failure that actually happens here. Judging an animation also needs eyes: "does the swap look instant" is not an assertion.

The rest of the extension is different. Settings validation is a decision, and a wrong value there silently turns the extension off.

## Decision

**Split the code so the decisions are testable, then test all of them test-first.**

- `extensionSettings.js` is pure and fully tested. `normalizeSettings` takes a value and returns a value. `loadSettings` and `saveSettings` take the storage area as an argument, so a test passes an in-memory object.

**Exempt from unit tests:** `mainWorldMotionPatch.js`, `contentEntry.js`, and `optionsPage.js`. Keep them thin. They patch a browser API, write an attribute on `<html>`, or read a form field. They hold no decision. When a bug appears in one of them, move the decision that failed into a pure function and test that, rather than test the file.

**The safety net for the exempt files** is two things. `npm run typecheck` reads every file in the repo under `strict`, so a wrong property name or a null-handling mistake fails the build. One manual run in Chrome covers the rest.

The manual run is short and always the same: load the extension unpacked, open a photo, hold the right arrow key, and confirm that no photo slides and that no photo stays on screen after the next one arrives.

**Rejected alternative:** a headless browser (Puppeteer or Playwright) driving the real Google Photos. It would need a real Google account, it would break whenever Google changed the page, and it cannot run in CI without credentials. The value it adds is exactly the value the manual Chrome run already gives.

**Rejected alternative:** jsdom tests for the MAIN world patch. jsdom would let a test run, but jsdom implements neither CSS transitions nor the Web Animations API, so a green test would prove nothing about a real browser.

## Consequences

**Positive:**

- The suite runs in well under a second, so the pre-commit hook and CI stay fast.
- The type check reads every file, including the exempt ones.

**Trade-offs and follow-up:**

- The file most likely to break is the one with no tests. That is deliberate: the type check and the manual run cover it instead.
- The exemption only holds while the exempt files stay thin. A decision that creeps into one of them is a defect, and the fix is to move it out, not to widen the exemption.
- There is no merge gate for "it still works in Chrome". The PRs here auto-merge on a green check, so any change to an exempt file needs a manual load before it is trusted.
