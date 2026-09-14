# Settings in sync storage, under one versioned key, and nothing in local storage

## Context

Chrome gives an extension two storage areas, with very different limits.

- `chrome.storage.sync` follows the user's Chrome profile to their other computers. It holds about 100KB in total and about 8KB per item.
- `chrome.storage.local` stays on one computer and holds about 10MB.

This extension stores one thing: four user settings. They are tiny, and a user who turns the swap on for one computer wants it on every computer.

## Decision

- **Settings** live in `chrome.storage.sync` under the single key `settings:v1`.
- **Nothing lives in `chrome.storage.local`.** This extension records nothing about the user's photos, so there is nothing that belongs to one computer.

Settings are validated on read. `normalizeSettings` drops unknown keys and repairs wrong values, because storage can hold data written by an older version of the extension. Whenever you add a field, extend that function and add a test.

The `:v1` suffix in the key is the migration escape hatch. If the record shape ever changes in a way `normalizeSettings` cannot repair, write a `:v2` key and leave the old one behind.

**Rejected alternative:** `chrome.storage.local` for the settings. It is larger, but a preference that does not follow the profile is a preference the user has to set again on every computer.

**Rejected alternative:** one key per setting. Four keys cost four reads and four change events for no gain, and a partial write could leave the set inconsistent.

## Consequences

**Positive:**

- Settings follow the user's profile, which is what a user expects from a preference.
- One key means one read at startup and one `storage.onChanged` event per save.
- The whole extension needs only the `storage` permission.

**Trade-offs and follow-up:**

- `sync` writes are rate limited (about 120 writes per minute). The options page writes once per **Save settings** click, so this is far out of reach.
- If a future feature ever needs per-computer data, it must go in `local`, and this ADR must be updated then.
