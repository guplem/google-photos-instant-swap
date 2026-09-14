import test from 'node:test';
import assert from 'node:assert/strict';

import { DEFAULT_SETTINGS, normalizeSettings } from '../src/settings/extensionSettings.js';

test('an empty store gives the defaults', () => {
  assert.deepEqual(normalizeSettings(undefined), DEFAULT_SETTINGS);
  assert.deepEqual(normalizeSettings(null), DEFAULT_SETTINGS);
  assert.deepEqual(normalizeSettings('garbage'), DEFAULT_SETTINGS);
});

test('keeps valid values and repairs the invalid ones', () => {
  const settings = normalizeSettings({
    instantSwapEnabled: false,
    instantSwapLevel: 'something-else',
    patchReducedMotion: 'yes please',
  });

  assert.equal(settings.instantSwapEnabled, false);
  assert.equal(settings.instantSwapLevel, DEFAULT_SETTINGS.instantSwapLevel);
  assert.equal(settings.patchReducedMotion, DEFAULT_SETTINGS.patchReducedMotion);
});

test('keeps the stronger instant swap level when the user picks it', () => {
  assert.equal(
    normalizeSettings({ instantSwapLevel: 'transitions-and-animations' }).instantSwapLevel,
    'transitions-and-animations',
  );
});

test('drops keys we do not know, so a renamed setting cannot linger', () => {
  const settings = normalizeSettings({ ...DEFAULT_SETTINGS, instantSwapDelayMs: 350 });
  assert.deepEqual(Object.keys(settings).sort(), Object.keys(DEFAULT_SETTINGS).sort());
});
