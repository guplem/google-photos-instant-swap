# Instant Swap for Google Photos

A Chrome extension for the Google Photos website. It removes the slide between photos.

Google Photos slides one photo out while the next slides in. When you press the arrow keys fast, the two photos overlap and you cannot compare them. This extension removes the slide, so each press shows one clean photo.

That is the whole extension. It stores nothing about your photos, it opens nothing, and it clicks nothing.

## Install

The extension is not on the Chrome Web Store. Load it from this folder.

1. Download or clone this repository.
2. Open `chrome://extensions` in Chrome.
3. Turn on **Developer mode**, at the top right.
4. Click **Load unpacked**.
5. Select the folder that holds `manifest.json`.

Chrome keeps the extension until you remove it. To update it, pull the new code and click the reload arrow on the extension card.

## Use

It works at once. Open any photo and press the left and right arrow keys.

If the slide is still there, open the options page and turn on **Also shorten JavaScript animations**. Then reload the Google Photos tab. That setting is off by default because it touches every animation on the page, not only the photo swap.

## Options

Click the extension icon in the Chrome toolbar.

| Setting                                 | What it does                                                                       |
| --------------------------------------- | ---------------------------------------------------------------------------------- |
| Swap photos instantly                   | Turns the extension on or off.                                                     |
| What to shorten                         | `CSS transitions only` is safe. `Transitions and keyframe animations` is stronger. |
| Tell the page you prefer reduced motion | Makes the site think you asked for less motion. Needs a page reload.               |
| Also shorten JavaScript animations      | Last resort for a slide that survives the CSS settings. Needs a page reload.       |

## Troubleshooting

### The photos still slide

Work through the settings in this order, and reload the Google Photos tab after each change.

1. Set **What to shorten** to `Transitions and keyframe animations`. This covers a slide built with a CSS `@keyframes` animation.
2. Turn on **Tell the page you prefer reduced motion**. Google Photos asks the browser whether you want less motion and picks a shorter animation when you do. This setting makes the page believe you did.
3. Turn on **Also shorten JavaScript animations**. Google Photos can drive the slide from JavaScript, through the Web Animations API, which ignores every CSS rule. This setting shortens those animations too.

The last two settings only take full effect from the next page load, because the page may already hold the answer it got the first time it asked.

### The old photo stays on screen

Report it as a bug. The extension shortens every animation to one millisecond, never to zero, exactly to avoid this: a duration of zero cancels the animation, and Google Photos removes the outgoing photo only when the animation reports that it ended.

### Something else on the page looks broken

Turn **What to shorten** back to `CSS transitions only`, and turn off **Also shorten JavaScript animations**. Those two settings apply to every animation on the page, not only the photo swap. The default settings only touch CSS transitions and are safe.

## Privacy

Everything stays in your browser.

- The extension runs only on `https://photos.google.com`.
- Settings live in Chrome's sync storage, so they follow your Chrome profile.
- The extension reads nothing about your photos and stores nothing about them.
- The extension sends no network requests of its own and contacts no server.

## Limits

- The extension shortens animations. It cannot change a layout choice Google Photos makes, and it cannot make a photo load faster.
- **Also shorten JavaScript animations** applies to every animation the page starts that way, so a menu or a dialog can also lose its motion.
- Google Photos changes its page without notice. This extension matches no class name and no button name, so it is much less likely to break than an extension that reads the page.

## Develop

```bash
npm install
npm run check
```

`npm install` also installs the git hooks, through lefthook. From then on, every commit runs the format check and the type check first.

`npm run check` runs the three checks in order: Prettier, the TypeScript type checker, and the unit tests. It is the same command the GitHub Actions job runs on every pull request.

The code is plain JavaScript with JSDoc types, so there is no build step: the folder you edit is the folder Chrome loads. Edit a file, press the reload arrow on the extension card, then reload the Google Photos tab.

To redraw the icons, run:

```bash
powershell -ExecutionPolicy Bypass -File scripts/makeIcons.ps1
```

## Publish

The extension is submitted to the Chrome Web Store, and it waits for the review. `store/storeListing.md` holds every
text and answer the submission needs, and `PRIVACY.md` is the privacy policy the listing links to.

To build the ZIP you upload, run:

```bash
powershell -ExecutionPolicy Bypass -File scripts/packageExtension.ps1
```

It writes `dist/instant-swap-for-google-photos-<version>.zip` with only the files Chrome runs: `manifest.json`, `src/`,
`options/`, and `icons/`.

To redraw the 440x280 promo image of the listing, run:

```bash
powershell -ExecutionPolicy Bypass -File scripts/makePromoTile.ps1
```

To redraw the three 1280x800 store screenshots, run:

```bash
powershell -ExecutionPolicy Bypass -File scripts/makeStoreScreenshots.ps1
```

It needs Chrome. It renders the real options page, and the two explainer images in `store/screenshotSources/`.

## See also

Three sister extensions for the same website:

- [google-photos-auto-save-check](https://github.com/guplem/google-photos-auto-save-check) marks the photos of a shared album that are not in your library yet. It was in the same extension as this one until they were split apart.
- [google-photos-auto-fav](https://github.com/guplem/google-photos-auto-fav) marks a list of photos as favourites.
- [google-photos-auto-date](https://github.com/guplem/google-photos-auto-date) fixes the date, the time and the timezone of a list of photos.

## Credits

The structure and the tooling come from [google-photos-compare-and-save](https://github.com/guplem/google-photos-compare-and-save), which held this feature and the save check together.

## Licence

MIT. See `LICENSE`.
