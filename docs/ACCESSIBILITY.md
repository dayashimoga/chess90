# Accessibility & Inclusive Design Standards

## 1. Compliance Standard
ChessMaster adheres strictly to **WCAG 2.1 AA** accessibility guidelines, ensuring that visually impaired, low-vision, and motor-impaired players have full, unhindered access to the mastery curriculum.

## 2. Color Contrast & Visual Aesthetics
The custom `ChessTheme` provides high-contrast, visually distinct palettes with contrast ratios exceeding WCAG AA minimums ($> 4.5:1$ for normal text, $> 3:1$ for large text and interactive components):

| Token | Hex Value | Semantic Purpose | Minimum Contrast Ratio |
| :--- | :--- | :--- | :--- |
| `backgroundDark` | `#121214` | Main page obsidian background | Background base |
| `surfaceDark` | `#1C1C20` | Card and modal container surface | Base surface |
| `boardLight` | `#EEEED2` | Light squares on the board | $> 7.2:1$ against dark text |
| `boardDark` | `#769656` | Dark squares on the board | $> 4.8:1$ against white pieces |
| `accentGold` | `#E5B84A` | Focus indicators, active tabs, stars | $> 5.5:1$ against background |
| `inCheckRed` | `#E74C3C` | Radial glow when King is in check | Visual urgency accent |
| `bestMoveGreen` | `#2ECC71` | Tactical solution arrows and badges | Positive reinforcement |

## 3. Keyboard Navigation & Shortcuts
All core platform workflows can be operated solely using a keyboard:

| Shortcut | Action |
| :--- | :--- |
| `Arrow Keys` | Move cursor focus between squares on the interactive board |
| `Enter` / `Space` | Select square / place piece on target square |
| `H` | Request progressive hint in active lab session |
| `Esc` | Clear active piece selection or dismiss modal dialog |
| `Left` / `Right` | Step backward / forward one ply in move list |
| `Ctrl + Z` / `Cmd + Z`| Undo last move (in free play / analysis modes) |
| `Ctrl + E` / `Cmd + E`| Toggle live engine evaluation |

## 4. Screen-Reader Semantics
Interactive widgets integrate Flutter's `Semantics` framework:
- **Board Squares**: Each square emits an accessible label: e.g., *"White Knight on f3, square light"* or *"Empty square e4, legal destination"*.
- **Move List**: Step announcements voice algebraic notation: e.g., *"Move 12. White played Knight takes d4, check"*.
- **Evaluation Bar**: Emits dynamic updates: e.g., *"Evaluation: White is winning by plus 2.4 pawns"*.

## 5. Scalable Typography & Reduced Motion
- **Display Scaling**: UI containers use flexible wrapping (`LayoutBuilder`, `SingleChildScrollView`, and percentage-based flex layouts) to guarantee zero text clipping or visual overflow at $100\%$, $125\%$, and $150\%$ OS font scaling.
- **Reduced Motion**: If the user has enabled OS-level reduced motion preferences (`MediaQuery.of(context).disableAnimations`), piece slide animations and pulsing radial glows are disabled immediately.
