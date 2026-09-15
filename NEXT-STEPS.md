# Next steps: publish this extension on the Chrome Web Store

**Another agent left this file for you.** That agent works in Claude Code, in a terminal. It can read and write files,
and it can run commands, but it cannot control a browser. You can. This file tells you what is ready, what is left, and
where every value that you must type comes from.

Delete this file after the extension is live. It describes one task, not the project.

## Who does what

| Part                                      | State                                                         |
| ----------------------------------------- | ------------------------------------------------------------- |
| Code, name, version, icons                | Done. Version 1.0.0, name "Instant Swap for Google Photos".   |
| The ZIP that you upload                   | Done. Build it again with the command below if it is missing. |
| Promo tile, 3 screenshots, privacy policy | Done. Paths are in `store/storeListing.md`.                   |
| Every text that the dashboard asks for    | Done. All of them are in `store/storeListing.md`.             |
| The clicks in the Developer Dashboard     | **Yours.**                                                    |

## Before you open the dashboard

1. Read `store/storeListing.md` from top to bottom. It holds every text, in dashboard order. Copy from that file. Do
   not write new marketing text, and do not invent a claim that the file does not make.
2. Confirm that the ZIP exists at `dist/instant-swap-for-google-photos-1.0.0.zip`. If it is missing, ask the user to
   run this command in the project folder:
   ```
   powershell -ExecutionPolicy Bypass -File scripts/packageExtension.ps1
   ```
3. Confirm that the privacy policy page opens:
   <https://github.com/guplem/google-photos-instant-swap/blob/main/PRIVACY.md>

## Ask the user these questions first

Ask them together, before you click anything.

1. **The takedown.** The publisher account holds an old item, "Countdown to Rasta Run 2", with the state "Taken down".
   Ask the user why it was taken down. A past takedown can make the review of a new item stricter. If the user does not
   know, open that item in the dashboard and read the notice.
2. **Visibility.** Ask for `Public` or `Unlisted`. `Unlisted` hides the item from search, and the link still works. It
   is the safer first submission.
3. **A real screenshot.** The three images in `store/screenshots/` are enough to submit. A real capture of Google
   Photos makes the listing stronger, and only the user can take one. The steps are in `store/storeListing.md`. Ask
   whether they want to add one now or submit without it.

## The steps in the dashboard

The dashboard is at <https://chrome.google.com/webstore/devconsole>. The user is already signed in, as the publisher
"Triunity Studios".

1. Click **New item**. Upload `dist/instant-swap-for-google-photos-1.0.0.zip`.
2. Open the **Store listing** tab. Fill the name, the short description, the detailed description, the category, and the
   language from `store/storeListing.md`. Upload the icon, the promo tile, and the three screenshots. The file names and
   the order are in the same document.
3. Open the **Privacy** tab. Paste the single purpose text, the justification for the `storage` permission, and the
   justification for the host permission. Tick **nothing** in the data collection list, because this extension collects
   no data. Then tick the three certification boxes.
4. Open the **Distribution** tab. Set the visibility that the user chose, and set the countries to all.
5. **Stop here.** Show the user the summary page. Ask them to confirm before you submit. The submission is a legal
   declaration under their publisher name, so a human makes that last click or gives you a clear "yes".
6. Click **Submit for review**.

## Rules while you work

- **Never invent an answer in the Privacy tab.** Every claim there must match `PRIVACY.md` and the real code. The
  extension stores four settings in `chrome.storage.sync`, it reads no page content, and it sends no network request.
- **Never build a copy of the Google Photos interface** for a screenshot. It is a trademark problem and a reason for
  rejection. Use the images in `store/screenshots/`, or a real capture that the user takes.
- **Change no text to make it sound stronger.** The texts are written for a reviewer who checks each claim.
- **Report every rejection word for word** to the user. A rejection email names the policy that failed. Write the
  policy name and the exact wording into a GitHub issue, so the other agent can fix the code or the texts.

## After the review passes

1. Tell the user the item ID and the public URL.
2. Ask the other agent (in Claude Code) to update `README.md`: the Install section still says that the extension is not
   on the Chrome Web Store. It must then point to the store page.
3. Delete this file.
