# PGN and FEN Ingestion and Serialization

## 1. Overview
The `chess_core` package provides complete, offline-first parsing, validation, and serialization of Portable Game Notation (PGN) and Forsyth-Edwards Notation (FEN).

## 2. FEN Specification & Implementation
FEN represents the state of a single chess position using 6 space-delimited fields:
`[piece placement] [active color] [castling rights] [en passant square] [halfmove clock] [fullmove number]`

### 2.1 Parsing Algorithm
- **Piece Placement**: 8 ranks separated by `/` from rank 8 to rank 1. Digits 1-8 represent consecutive empty squares. Characters `p, r, n, b, q, k` (black) and `P, R, N, B, Q, K` (white) define pieces.
- **Active Color**: `w` or `b`.
- **Castling Availability**: Subsets of `KQkq` or `-` if neither side has castling rights.
- **En Passant Target Square**: Coordinate e.g. `e3`, `c6`, or `-`.
- **Halfmove Clock**: Non-negative integer tracking moves since the last capture or pawn push (50-move rule counter).
- **Fullmove Number**: Integer starting at 1, incremented after every Black turn.

### 2.2 Zobrist Hashing
Every position parsed or generated maintains a 64-bit Zobrist hash computed by XORing pseudo-random values for:
- Piece-square pairs: `zobristPieceSquare[piece][square]`
- Active side to move: `zobristBlackTurn`
- Castling rights flags: `zobristCastling[flags]`
- En passant file: `zobristEnPassant[file]`

Threefold repetition is verified in $O(1)$ lookup time against the position history counter map.

## 3. PGN Grammar and Capabilities
The PGN parser handles standard and non-standard PGN streams, recursive annotation variations (RAVs), numeric annotation glyphs (NAGs), and engine annotation tags.

### 3.1 Tag Pairs
Extracted header tags conform to the Seven Tag Roster:
- `Event`: Event name or tournament classification.
- `Site`: Location or offline local session identifier.
- `Date`: Format `YYYY.MM.DD` or `????.??.??`.
- `Round`: Round designation.
- `White`: White player name or engine profile.
- `Black`: Black player name or engine profile.
- `Result`: `1-0`, `0-1`, `1/2-1/2`, or `*`.

Additional metadata tags ingested:
- `ECO`: Encyclopedia of Chess Openings code (e.g., `B90`, `D35`).
- `FEN`: Setup FEN for puzzles and tactical lab starts.
- `SetUp`: `1` if starting from custom FEN.
- `Annotator`: Model analysis engine or human analyst.

### 3.2 Move Text, Clocks & Engine Evals
The parser ingests move tokens, comments enclosed in `{ ... }`, and engine annotations:
- Clock tags: `[%clk 1:29:45]`
- Engine evaluations: `[%eval +1.84]` or `[%eval #-2]`
- Best moves / alternate lines in parenthetical variations: `(12... Nxd4 13. Bxd4)`

## 4. Error Handling and Resilience
1. **Illegal Move Rejection**: If a PGN contains an illegal move according to `MoveGenerator.generateLegalMoves()`, the parser flags the offending ply, records line/column coordinates, and provides recovery without terminating the platform process.
2. **Ambiguous SAN Disambiguation**: Moves like `Rad1` or `N5f3` or `Qh4e1` are resolved by matching source files, ranks, or exact coordinates against legal move candidate lists.
3. **Roundtrip Invariance**:
   $$\text{FEN} \xrightarrow{\text{parse}} \text{Board} \xrightarrow{\text{toFen}} \text{FEN}$$
   Every board position exported matches the input representation identically.
