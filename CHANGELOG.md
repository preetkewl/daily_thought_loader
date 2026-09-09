## 0.1.0

**Breaking:** `DailyThoughtLoader` now picks a single random thought from
`thoughts` and displays it for `duration`, then calls `onComplete` once. It no
longer cycles through the list. `thoughts` is now a selection pool.

* Added an optional `random` parameter for deterministic selection in tests.
* `onComplete` is now invoked in a post-frame callback, so callers can safely
  navigate from it.
* `duration` changes are now honoured at runtime (previously ignored).
* The author line is hidden when the author string is empty.

## 0.0.1

* Initial release.
