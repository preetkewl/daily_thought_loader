## 0.2.0

**Redesigned the loader UI.** It is now a full-screen, three-band splash
layout: optional logo pinned to the top, the thought vertically centred, and
the progress indicator pinned to the bottom. Content is centred within a
`maxContentWidth` and scales up on tablets.

* Defaults now resolve from the ambient `ThemeData` and screen size, so the
  loader looks finished with no styling.
* New style hooks: `backgroundColor`, `backgroundGradient`, `contentPadding`,
  `maxContentWidth`, `textAlign`, decorative opening quotation mark
  (`showQuotationMark` / `quotationMarkColor`), author accent rule
  (`showAuthorSeparator` / `authorSeparatorColor`), `progressBorderRadius`,
  `progressHandleInset`, and `animateIn`.
* The progress track now has rounded caps; the handle rides in its own lane
  above the track and is inset so it never clips at 0% / 100%.
* The quote fades and rises in on appearance (respects the platform
  reduced-motion setting).
* `thoughtTextStyle` / `authorTextStyle` are now merged over the resolved
  defaults instead of replacing them.
* `progressWidget` is now nullable; the default is a glowing dot in the
  progress colour.
* Progress is exposed to screen readers via `Semantics`.
* Added an `example/` app.

**Breaking:** `progressSectionHeight` now sizes only the handle lane (not the
whole progress area); the default `progressWidget` changed; the widget now
expands to fill its parent instead of sizing to its content.

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
