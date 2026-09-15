# Chrome Web Store listing

Copy each block below into the matching field of the
[Developer Dashboard](https://chrome.google.com/webstore/devconsole). Keep this file and the dashboard equal: when you
change a text here, change it in the dashboard too.

## Item name

```
Instant Swap for Google Photos
```

The brand does not come first, because Chrome Web Store policy limits a name that suggests Google made the extension.

## Short description (132 characters maximum)

```
Removes the slide between photos on Google Photos, so every arrow key press shows one clean photo.
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

`Photos`. Second choice: `Workflow & Planning`.

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

| Asset         | Size     | Where it is                       |
| ------------- | -------- | --------------------------------- |
| Store icon    | 128x128  | `icons/icon128.png`               |
| Promo tile    | 440x280  | `store/promoTileSmall440x280.png` |
| Screenshot x2 | 1280x800 | You take these. See below.        |

### How to take the screenshots

The store needs at least one screenshot, and it becomes public.

1. Open `chrome://extensions`, turn on Developer mode, and load this folder with **Load unpacked**.
2. Open [photos.google.com](https://photos.google.com) and open a photo that **you own**. No other people's faces, no
   email addresses, no file names you do not want to share.
3. Press `F12` to open DevTools, click the device toolbar icon, and set a custom size of 1280x800.
4. Open the DevTools three dot menu and choose **Capture screenshot**.
5. Take a second shot of the options page: click the extension icon in the toolbar.

## Distribution

- Visibility: `Unlisted` for the first submission if you want to test the install flow, then `Public`.
- Countries: all.
