# ChessMaster Design System & Visual Architecture

## 1. Overview & Core Philosophy
ChessMaster v1.3.1 enforces a unified, accessible, and high-contrast design system across all supported platforms (Web, Windows, Linux, Android). The design system guarantees:
- **Zero Piece Inconsistency**: Resolution-independent vector rendering for all 12 chess piece types, eliminating OS emoji fallbacks, purple/grey tinting, and DPI degradation.
- **WCAG AA Compliance**: High-contrast ratios on both light and dark squares, ensuring accessibility across all light, dark, and high-contrast themes.
- **Non-Destructive Overlays**: Highlights (selection, legal moves, checks, last moves, hints) are drawn strictly on overlay layers without altering piece colors.
- **Global Theme Synchronization**: Seamless dark/light theme toggle persisted in `UserProfile` and propagated reactively across the entire application hierarchy.

---

## 2. Shared Theme Architecture

### 2.1 PieceTheme
Defined in `apps/chess_app/lib/src/theme/piece_theme.dart`:
- `standard`: White pieces (`#FFFFFF` with `#1E293B` outline), Black pieces (`#0F172A` with `#64748B` outline).
- `highContrast`: High-visibility black and white with thick 3.5px contrasting borders.
- `classicWood`: Warm ivory (`#F5E6D3`) and deep walnut (`#2C1810`).

Every piece is rendered via `VectorPieceWidget` using `CustomPainter`, guaranteeing crisp vector fidelity at all DPI scales.

### 2.2 ChessBoardTheme
Defined in `apps/chess_app/lib/src/theme/chess_board_theme.dart`:
- `tournamentGreen`: Light squares (`#EEEED2`), Dark squares (`#769656`). Contrast ratio >= 4.5:1.
- `classicWood`: Light squares (`#E8C396`), Dark squares (`#9E5A2A`).
- `slateBlue`: Light squares (`#D1D5DB`), Dark squares (`#4B5563`).
- `highContrast`: Light squares (`#FFFFFF`), Dark squares (`#374151`). Contrast ratio >= 7:1 (WCAG AAA).

Overlay colors are standardized across all board themes:
- Selected Square: `Color(0x66F59E0B)` (Translucent Amber)
- Last Move Source/Dest: `Color(0x553B82F6)` (Translucent Royal Blue)
- Check Warning: `Color(0x88EF4444)` (Translucent Crimson)
- Legal Move Dot: `Color(0x7710B981)` (Emerald Indicator)

---

## 3. Global Color Palette & Semantic Surfaces
Defined in `apps/chess_app/lib/src/theme/chess_theme.dart`:

| Semantic Token | Dark Mode Value | Light Mode Value | Usage |
|---|---|---|---|
| `bg` | `#0B0F19` | `#F8FAFC` | App root background |
| `surf` | `#111827` | `#FFFFFF` | Card & panel background |
| `surfLight` | `#1F2937` | `#F1F5F9` | Input fields, active tiles |
| `brd` | `#374151` | `#E2E8F0` | Structural borders |
| `txt` | `#F9FAFB` | `#0F172A` | Primary typography |
| `txtSec` | `#9CA3AF` | `#475569` | Secondary descriptions |
| `txtMut` | `#6B7280` | `#94A3B8` | Subtitles, disabled states |
| `primary` | `#10B981` | `#059669` | Primary CTAs, active badges |
| `accentGold` | `#F59E0B` | `#D97706` | Exam badges, milestone markers |

---

## 4. Accessibility Guidelines
- **Touch Target Sizing**: Minimum 44x44 CSS pixels on interactive controls.
- **Font Scaling**: Resilient layouts supporting text scale factors from 1.0x to 2.0x.
- **Keyboard Navigation**: Focus outlines on all list tiles, dialog buttons, and scrubber sliders.
- **Reduced Motion Support**: Configurable animation speed (`Off`, `Fast`, `Normal`, `Learning`).
