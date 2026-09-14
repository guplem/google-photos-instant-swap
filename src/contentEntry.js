/**
 * Entry point of the page half of the extension. Runs in the isolated world, so
 * it can use `chrome.*` APIs and can read the DOM, but cannot see the page's own
 * JavaScript variables.
 *
 * It has one job: publish the settings on the <html> element, where the
 * stylesheet and the MAIN world patch read them, and keep them up to date when
 * the user changes them on the options page.
 */

import { loadSettings } from './settings/extensionSettings.js';

/**
 * Puts the settings where the stylesheet and the MAIN world script read them.
 * @param {import('./settings/extensionSettings.js').ExtensionSettings} next
 */
function publishSettings(next) {
  const root = document.documentElement;

  if (next.instantSwapEnabled) root.setAttribute('data-gpis-instant-swap', next.instantSwapLevel);
  else root.removeAttribute('data-gpis-instant-swap');

  root.setAttribute(
    'data-gpis-main-world',
    JSON.stringify({ patchReducedMotion: next.patchReducedMotion, clampWebAnimations: next.clampWebAnimations }),
  );
}

export async function start() {
  // Only <html> is touched here, and it already exists at document_start, so
  // this never has to wait for <body>.
  publishSettings(await loadSettings(chrome.storage.sync));

  chrome.storage.onChanged.addListener((_changes, areaName) => {
    if (areaName !== 'sync') return;
    void loadSettings(chrome.storage.sync).then(publishSettings);
  });
}
