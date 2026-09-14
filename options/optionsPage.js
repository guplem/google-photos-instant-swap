/**
 * Reads and writes the settings shown on the options page.
 *
 * Settings live in `chrome.storage.sync` so they follow your Chrome profile.
 */

import { DEFAULT_SETTINGS, loadSettings, normalizeSettings, saveSettings } from '../src/settings/extensionSettings.js';

/**
 * @param {string} id
 * @returns {HTMLInputElement}
 */
const input = (id) => /** @type {HTMLInputElement} */ (document.getElementById(id));

/**
 * @param {string} id
 * @returns {HTMLSelectElement}
 */
const select = (id) => /** @type {HTMLSelectElement} */ (document.getElementById(id));

/** @param {string} message */
function showStatus(message) {
  const status = /** @type {HTMLElement} */ (document.getElementById('status'));
  status.textContent = message;
  setTimeout(() => {
    if (status.textContent === message) status.textContent = '';
  }, 3000);
}

/** @param {import('../src/settings/extensionSettings.js').ExtensionSettings} settings */
function showSettings(settings) {
  input('instantSwapEnabled').checked = settings.instantSwapEnabled;
  select('instantSwapLevel').value = settings.instantSwapLevel;
  input('patchReducedMotion').checked = settings.patchReducedMotion;
  input('clampWebAnimations').checked = settings.clampWebAnimations;
}

/** @returns {import('../src/settings/extensionSettings.js').ExtensionSettings} */
function collectSettings() {
  return normalizeSettings({
    instantSwapEnabled: input('instantSwapEnabled').checked,
    instantSwapLevel: select('instantSwapLevel').value,
    patchReducedMotion: input('patchReducedMotion').checked,
    clampWebAnimations: input('clampWebAnimations').checked,
  });
}

document.getElementById('save')?.addEventListener('click', async () => {
  const saved = await saveSettings(chrome.storage.sync, collectSettings());
  showSettings(saved);
  showStatus('Saved. Reload any open Google Photos tab.');
});

document.getElementById('reset')?.addEventListener('click', async () => {
  const saved = await saveSettings(chrome.storage.sync, { ...DEFAULT_SETTINGS });
  showSettings(saved);
  showStatus('Back to the defaults.');
});

showSettings(await loadSettings(chrome.storage.sync));
