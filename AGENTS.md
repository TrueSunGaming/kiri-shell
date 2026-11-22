# AGENTS.md

Guidance for working in this Quickshell config for Hyprland.

## Intent

This is a desktop shell, not a standalone app: it must stay quiet, legible over
arbitrary wallpapers and windows, and responsive without drawing attention to itself.
The aesthetic is **calm translucency, restrained motion, and geometric rhythm**. The
engineering style is **one source of truth for every design decision, small composable
pieces, declarative state, and per-monitor isolation**.

This document describes *how to work*, not *what the code currently contains*. The
source is always authoritative. If a file name, value, or API here disagrees with the
code, trust the code and update this document only if the underlying rule still holds.

## Orient yourself before editing

- Start at the QML entry point (`shell.qml` today) to see what is instantiated, how
  per-screen scopes are assembled, and what IPC surface is exposed. Do not assume a
  particular module is still wired in — check.
- Shared design tokens and system state are `pragma Singleton` types; per-object state
  adapters are lightweight `Scope` types; visual pieces are ordinary QML components
  and windows. Put new code in the matching layer.
- Quickshell maps the config root (the directory containing the entry point) to the
  `qs` import prefix and each subdirectory to a dotted module (`qs.<dir>.<subdir>`).
  No `qmldir` files are needed. Verify against current imports if unsure.
- Before adding a helper, look for an existing owner of the concern. There is usually
  already a token, base component, service, or adapter to extend.
- Ask early: is this state **global**, **per-monitor**, or **per-window/player**? The
  answer determines where it belongs and prevents cross-screen coupling.

## Design rules worth preserving

### Derive geometry, don't hardcode it

- A single relative scale should drive type sizes, spacing, radii, panel widths, and
  icon sizes. Use its `relative(base, steps)`-style helper with fractional and negative
  steps instead of literal pixel values.
- The `base` need not be the font size: derive panel width from screen width, a nested
  margin from its parent radius, a detail size from an icon size. Chaining relatives
  keeps nested elements proportional when the scale changes.
- Prefer coupled dimensions: height from width, margins from padding, radius from
  margin, panel width from viewport. A change to one token should reflow the shell
  coherently.
- Reserve raw pixels for genuine hairlines and rounding guards, and keep them local
  to the code that needs them. If a one-off constant becomes meaningful, promote it
  into the scale or token singleton rather than copying it around.

### Color and hierarchy

- All palette decisions live in one color token singleton. Consume semantic tokens
  (`accent`, `text`, subtle/nested surfaces, border, gradient stops, error); do not
  sprinkle literal colors through views.
- The accent is sparse: interactive state, selection, progress, and search highlights.
  Most of the UI should be neutral lightness and translucency.
- The frosted body is built from a dark component plus a light component so that
  opacity and brightness move together. Tune that recipe in one place, not per surface.
- Express hierarchy through lightness/alpha and weight, not additional hues. Derive
  secondary/disabled variants from the primary text token.
- Before introducing a new color token, check whether an existing token or a derived
  variant of it already expresses the intent.

### The glass stack

The frosted look is a stack, not a single fill: a translucent shield, a fine light
border, a masked noise grain, and compositor-level blur.

- New surfaces should compose the existing glass primitives. Keep the mask that ties
  grain to surface shape; unmasked noise looks like dirt.
- Never paint an opaque background over a glass surface — it defeats the blur. Use
  transparent windows and non-opaque surfaces so the compositor can show through.
- Blur/xray behavior belongs to the Hyprland integration (layer rules injected at
  startup and after compositor config reload). Namespace conventions are part of the
  visual design: changing a window namespace can silently remove blur or xray.
- Noise is rendered from a compiled shader asset, not the GLSL source. Keep source and
  compiled artifact in sync; generated binaries are commonly ignored by version
  control, so a fresh checkout needs a shader-compilation step before the shell runs.

### One motion language

- Transitions are spring-driven progress values, not fixed-duration animations. Reuse
  the shared spring so the whole shell settles with the same feel.
- Model show/hide as a boolean state plus an `animProgress` value driven by that
  spring, then derive opacity, transform, and layout from the single progress value.
- Perspective/morph helpers should be reusable presets with explicit origin and
  per-edge scales. When a component inverts top/bottom scales, treat that as an
  intentional drop-in vs. expand-up distinction, not a cosmetic detail.
- Hover and press states may use slightly different damping or opacity, but should
  never switch to a different easing family.

### Typography and icons

- Route text through the shared text primitive so font, numeral features, variable
  weight, legibility shadow, and text metrics stay consistent. Use measured metrics
  for fixed-width labels (clocks especially) so content changes don't resize the UI.
- Icons are semantic names resolved through a central mapping with a raw-name
  fallback. Add new aliases to that mapping rather than embedding glyphs in views.
- Highlighted search matches should use the accent converted to a rich-text color by
  the existing helper, so highlighting follows accent changes automatically.

## Structural invariants

- **Per-screen by default.** The entry point maintains a scope per monitor. New
  panels belong in that scope, take the current screen as a required property, and
  resolve monitor-scoped state through the monitor adapter — never through a global
  "active monitor" lookup that can be wrong on multi-monitor setups.
- **Layers and input are intentional.** Each window picks a layer and namespace, uses
  a transparent/non-opaque surface, and constrains its input region. Fullscreen
  overlays should mask input and grab focus only while open, and release both on
  focus loss. Popups should anchor to their triggering item and clear selection when
  dismissed.
- **State ownership.** System integrations (compositor, audio, media, notifications,
  power, network, desktop entries, clocks, fonts, process helpers) live in singleton
  services. Shell-outs, file reads, and event subscriptions belong there or in
  scripts — not in views. Views consume bindings and emit user intent.
- **Bindings over imperative updates.** Prefer declarative bindings; never overwrite
  one without restoring a binding afterward (user-driven slider edits are the classic
  case). Where an update must be forced, the codebase uses an explicit void/dependency
  read — keep that idiom and document why it exists.
- **Don't propagate known warts.** If you encounter suspicious conditions or FIXMEs,
  don't copy them into new code. Fix them deliberately when touching that area, or
  leave a clear note explaining why they remain.

## Code style

- Use loose equality (`==` / `!=`) for ordinary comparisons. Reserve strict equality
  (`===` / `!==`) for cases where operands can have different types and that
  distinction is the point of the check.
- Don't write comments. Prefer clear names, small scopes, and structure that explains
  itself; add a comment only when the user explicitly asks for one.

## Where to make common changes

Find the owner by responsibility; treat the names below as current landmarks to
verify, not as a fixed map.

| Concern | Look for |
| --- | --- |
| Palette, accent, translucency recipe | color token singleton |
| Spacing, type scale, panel dimensions | sizing token singleton |
| Frosted surfaces, grain, morphing, springs | glass components, shader directory, animation helpers, compositor layer rules |
| Top bar, tray, status controls | main panel module and its popup components |
| Launcher and fuzzy search | active launcher module, fuzzy-search utility, IPC handler in the entry point |
| Notifications | notification service, display component, OSD panel, notification-center popup |
| Audio/media/power/wifi/compositor state | matching singleton service; per-object adapters for windows and players |
| Glyph aliases | icon mapping data |

## Adding something new

1. Decide global vs. per-monitor vs. per-object, and put state in the corresponding
   singleton, screen scope, or adapter.
2. Compose existing primitives and tokens. If you need a new size, derive it from the
   scale; if you need a new color, derive it from the palette; if you need motion, use
   the shared spring.
3. For any new window, set layer, namespace, transparency, mask/input region, and
   focus behavior deliberately.
4. Wire new per-screen UI into the entry-point scope so it appears on every monitor.
5. If you introduce a new semantic concept (icon, accent state, token), add it to the
   central mapping/token set rather than local constants.
6. Update this document only when the *rule* changes — not to mirror implementation
   details that the source already expresses better.

## Workflow and verification

- Run from the config root; relative paths are used for scripts, shaders, and assets.
- After editing shader source, regenerate the compiled artifact and reload. A plain
  reload typically restarts the shell and clears its QML cache; check the current
  scripts before relying on that.
- Use the entry point's IPC surface to drive the launcher/key overlay when testing.
- There is no automated test suite. Verify behavior, not pixels: correct rendering on
  every monitor, input only where intended, open/close and focus-grab behavior,
  mutually exclusive notification surfaces, empty and multi-item media states,
  status OSD on the focused monitor, and glass/blur surviving a compositor reload.
- Watch the console for binding loops, missing properties, and shader errors.

## Final review checklist

- No magic numbers where a scale/token exists.
- No opaque fills over frosted surfaces; masks intact.
- Springs reused; progress-driven animation.
- Multi-monitor safe; correct layer/namespace/input/focus.
- Side effects in services/scripts, views declarative.
- Bindings preserved after user edits.
- New semantic values added to their central map/token set.
- Loose equality used unless the type distinction matters.
- No new comments.
- Source verified; this document changed only if guidance, not details, changed.
