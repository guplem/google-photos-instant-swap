/**
 * All user settings, their defaults, and the reading and writing helpers.
 *
 * The storage area is passed in instead of read from `chrome` directly, so the
 * pure logic in this file can be unit tested without a browser.
 */

/**
 * @typedef {'transitions' | 'transitions-and-animations'} InstantSwapLevel
 *
 * @typedef {object} ExtensionSettings
 * @property {boolean} instantSwapEnabled        Shorten the slide between photos.
 * @property {InstantSwapLevel} instantSwapLevel Which CSS motion to shorten.
 * @property {boolean} patchReducedMotion        Tell the page the viewer wants less motion.
 * @property {boolean} clampWebAnimations        Shorten JavaScript-driven animations too.
 */

/** @type {Readonly<ExtensionSettings>} */
export const DEFAULT_SETTINGS = Object.freeze({
  instantSwapEnabled: true,
  instantSwapLevel: /** @type {InstantSwapLevel} */ ('transitions'),
  patchReducedMotion: true,
  clampWebAnimations: false,
});

export const SETTINGS_STORAGE_KEY = 'settings:v1';

const INSTANT_SWAP_LEVELS = ['transitions', 'transitions-and-animations'];

/**
 * Drops unknown keys and replaces wrong or missing values with the default.
 * Storage can hold anything, including settings written by an older version.
 * @param {unknown} stored
 * @returns {ExtensionSettings}
 */
export function normalizeSettings(stored) {
  const raw = stored !== null && typeof stored === 'object' ? /** @type {Record<string, unknown>} */ (stored) : {};

  /**
   * @param {keyof ExtensionSettings} key
   * @returns {boolean}
   */
  const readBoolean = (key) =>
    typeof raw[key] === 'boolean' ? /** @type {boolean} */ (raw[key]) : /** @type {boolean} */ (DEFAULT_SETTINGS[key]);

  const level = raw.instantSwapLevel;

  return {
    instantSwapEnabled: readBoolean('instantSwapEnabled'),
    instantSwapLevel: /** @type {InstantSwapLevel} */ (
      typeof level === 'string' && INSTANT_SWAP_LEVELS.includes(level) ? level : DEFAULT_SETTINGS.instantSwapLevel
    ),
    patchReducedMotion: readBoolean('patchReducedMotion'),
    clampWebAnimations: readBoolean('clampWebAnimations'),
  };
}

/**
 * @param {chrome.storage.StorageArea} storageArea
 * @returns {Promise<ExtensionSettings>}
 */
export async function loadSettings(storageArea) {
  const stored = await storageArea.get(SETTINGS_STORAGE_KEY);
  return normalizeSettings(stored[SETTINGS_STORAGE_KEY]);
}

/**
 * @param {chrome.storage.StorageArea} storageArea
 * @param {Partial<ExtensionSettings>} changes
 * @returns {Promise<ExtensionSettings>}
 */
export async function saveSettings(storageArea, changes) {
  const current = await loadSettings(storageArea);
  const next = normalizeSettings({ ...current, ...changes });
  await storageArea.set({ [SETTINGS_STORAGE_KEY]: next });
  return next;
}
