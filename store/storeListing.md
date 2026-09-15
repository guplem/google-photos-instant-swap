# Chrome Web Store listing

Copy each block below into the matching field of the
[Developer Dashboard](https://chrome.google.com/webstore/devconsole). Keep this file and the dashboard equal: when you
change a text here, change it in the dashboard too.

## Item name

```
Instant Swap for Google Photos
```

The brand does not come first, because Chrome Web Store policy limits a name that suggests Google made the extension.

The dashboard does not hold this text. It shows it as `Title from package`, and it reads it from the `name` field in
`manifest.json`.

## Short description

The dashboard does not hold this text either. It shows it as `Summary from package`, and it reads it from the
`description` field in `manifest.json`. To change it, change the manifest, build the ZIP again, and upload the new
package.

```
Removes the slide between photos on the Google Photos website, so each arrow key press shows one clean photo.
```

## Detailed description

```
Google Photos slides one photo out while the next photo slides in. When you press the arrow keys fast, the two photos
overlap and you cannot compare them.

Instant Swap removes that slide. Each arrow key press shows one clean photo, so you can flick back and forth between two
photos and see the difference.

WHAT IT DOES
- Shortens the slide between photos to one millisecond.
- Works with the left and right arrow keys, and with the on-screen arrows.
- Adds an options page, so you can make the change stronger or turn it off.

WHAT IT DOES NOT DO
- It reads nothing about your photos.
- It clicks nothing on the page for you.
- It sends no data anywhere. There is no server, no account, and no tracking.

OPTIONS
- Swap photos instantly: turns the extension on or off.
- What to shorten: CSS transitions only (the safe default), or transitions and keyframe animations.
- Tell the page you prefer reduced motion: makes the site pick its shorter animation.
- Also shorten JavaScript animations: the last resort for a slide that survives the other settings.

The last two options apply from the next page load, so reload the Google Photos tab after you change them.

WHY IT RARELY BREAKS
The extension matches no button and no class name on the page. It only shortens animation timing. Google Photos changes
its page often, and most extensions break when it does. This one has almost nothing to break.

The code is open source: https://github.com/guplem/google-photos-instant-swap
```

## Category

`Functionality and UI`, in the group Make Chrome yours. The extension changes how a website interface behaves, so that
group fits it. The Chrome Web Store removed the `Photos` category, so the dashboard does not offer it. The closest second
choice is `Workflow and planning`.

Do not pick `Accessibility`. The single purpose text says that the extension helps a user compare two photos, and a
reviewer checks that the category and the single purpose agree.

## Language

English.

## Support and homepage URL

```
https://github.com/guplem/google-photos-instant-swap
```

## Privacy policy URL

```
https://github.com/guplem/google-photos-instant-swap/blob/main/PRIVACY.md
```

Open the URL in a browser before you paste it. The review fails if the page does not load.

## Privacy tab answers

### Single purpose

```
This extension shortens the slide animation between photos on the Google Photos website, so the next photo appears at
once and the user can compare two photos.
```

### Permission justification: storage

```
The extension saves the user's own settings, so the options page keeps its values between sessions. It stores four
boolean and text settings and nothing else.
```

### Permission justification: host permission for https://photos.google.com/*

```
The extension changes animation timing on the Google Photos website only. It must run on that site to apply its CSS and
to shorten the animations the page starts.
```

### Data usage

Tick nothing in the data collection list. This extension collects no user data at all. Then tick the three certification
boxes:

- I do not sell or transfer user data to third parties, outside of the approved use cases.
- I do not use or transfer user data for purposes that are unrelated to my item's single purpose.
- I do not use or transfer user data to determine creditworthiness or for lending purposes.

## Images

Every image below is in the repository. Run `powershell -ExecutionPolicy Bypass -File scripts/makeStoreScreenshots.ps1`
to draw the screenshots again after a change to the options page or to the texts.

| Asset        | Size     | Where it is                                      |
| ------------ | -------- | ------------------------------------------------ |
| Store icon   | 128x128  | `icons/icon128.png`                              |
| Promo tile   | 440x280  | `store/promoTileSmall440x280.png`                |
| Screenshot 1 | 1280x800 | `store/screenshots/screenshot1WhatItChanges.png` |
| Screenshot 2 | 1280x800 | `store/screenshots/screenshot2OptionsPage.png`   |
| Screenshot 3 | 1280x800 | `store/screenshots/screenshot3Privacy.png`       |

Upload them in that order. The dashboard shows the first one first.

### Why two of them are diagrams

A still image cannot show a missing animation, so screenshot 1 and screenshot 3 explain the change with drawings, and
each drawing says on the image that it is a diagram. Screenshot 2 is the real options page, rendered by Chrome from
`options/optionsPage.html`.

### Optional: add a real capture of Google Photos

A real capture makes the listing stronger, and only you can take one. Nobody must build a copy of the Google Photos
interface for a screenshot: that is both a trademark problem and a reason for rejection.

1. Open `chrome://extensions`, turn on Developer mode, and load this folder with **Load unpacked**.
2. Open [photos.google.com](https://photos.google.com) and open a photo that **you own**. No other people's faces, no
   email addresses, no file names you do not want to share.
3. Press `F12` to open DevTools, click the device toolbar icon, and set a custom size of 1280x800.
4. Open the DevTools three dot menu and choose **Capture screenshot**.

## Distribution

- Visibility: `Public`. The user chose it for the first submission, on 15 September 2026.
- Countries: all.
