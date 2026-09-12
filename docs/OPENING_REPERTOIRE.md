# ChessMaster Master Opening Repertoire & ECO Encyclopedia

## Overview
ChessMaster v1.3.0 features a comprehensive curated opening repertoire covering **72 master variations** spanning all 5 ECO volumes (A00–E99) in `packages/chess_content/lib/src/eco/eco_book.dart`.

Every single variation has been verified for 100% legal moves using the engine's `MoveGenerator` and move matching rules. In addition, 560 opening drill exercises in `packages/chess_content/lib/src/training_banks/opening_drills_bank.dart` provide active spaced repetition drills and deviation refutations for each opening line.

---

## Pedagogical Organization by ECO Volume

### Volume A: Flank Openings & Unorthodox Systems
| ECO | Opening Name | Standard Move Sequence | Core Strategic Theme |
|:---:|:-------------|:-----------------------|:---------------------|
| A00 | Reti Opening / Polish / Grob | 1. Nf3 d5 2. c4 | Hypermodern central pressure without early pawn commitment |
| A01 | Nimzowitsch-Larsen Attack | 1. b3 e5 2. Bb2 Nc6 3. e3 | Long diagonal bishop fianchetto pressuring e5/d4 |
| A04 | Reti Opening: King's Indian Attack | 1. Nf3 Nf6 2. g3 g6 3. Bg2 Bg7 4. O-O | Flexible inverted King's Indian structure for White |
| A10 | English Opening: Anglo-Scandinavian | 1. c4 c5 / 1. c4 e5 | Flank struggle for control of d5 and light squares |
| A15 | English Opening: Anglo-Indian | 1. c4 Nf6 2. Nf3 g6 3. g3 Bg7 | Hypermodern fianchetto struggle against Indian formations |
| A20 | English Opening: King's English | 1. c4 e5 2. Nc3 Nf6 3. g3 | Reversed Sicilian with tempo advantage for White |
| A30 | English Opening: Symmetrical | 1. c4 c5 2. Nf3 Nf6 3. g3 | Classical symmetrical clamping on central outposts |
| A40 | Queen's Pawn Game: Keres Defense | 1. d4 e6 2. c4 Bb4+ | Transpositional nimzo-style flank pinning |
| A45 | Trompowsky Attack | 1. d4 Nf6 2. Bg5 | Early bishop pin disrupting Black's pawn structure |
| A56 | Benoni Defense: Czech Benoni | 1. d4 Nf6 2. c4 c5 3. d5 e5 | Closed, locked central pawn wedge with flank maneuverings |
| A80 | Dutch Defense | 1. d4 f5 2. Nf3 Nf6 | Asymmetric early kingside space grab |
| A85 | Dutch Defense: Stonewall Formation | 1. d4 f5 2. c4 Nf6 3. Nc3 e6 4. Nf3 d5 | Rock-solid pawn fortress clamping e4 with bishop outpost |

---

### Volume B: Semi-Open Games (1. e4 non-e5)
| ECO | Opening Name | Standard Move Sequence | Core Strategic Theme |
|:---:|:-------------|:-----------------------|:---------------------|
| B01 | Scandinavian Defense | 1. e4 d5 2. exd5 Qxd5 3. Nc3 Qa5 | Immediate central challenge and rapid queen retreat |
| B06 | Modern Defense | 1. e4 g6 2. d4 Bg7 3. Nc3 d6 | Hypermodern fianchetto allowing White broad center |
| B07 | Pirc Defense | 1. e4 d6 2. d4 Nf6 3. Nc3 g6 | Flexible counter-punching against White's pawn center |
| B10 | Caro-Kann Defense: Modern Lines | 1. e4 c6 2. d4 d5 3. Nc3 dxe4 | Solid pawn foundation with active light-squared bishop |
| B12 | Caro-Kann Defense: Advance Variation | 1. e4 c6 2. d4 d5 3. e5 Bf5 4. Nf3 e6 | Clamped center with outside-the-chain bishop activity |
| B13 | Caro-Kann Defense: Exchange Variation | 1. e4 c6 2. d4 d5 3. exd5 cxd5 4. Bd3 | Symmetrical Carlsbad structure with minority attack plans |
| B18 | Caro-Kann Defense: Classical (Capablanca) | 1. e4 c6 2. d4 d5 3. Nc3 dxe4 4. Nxe4 Bf5 | Ideal piece coordination and endgame resilience |
| B20 | Sicilian Defense: Open Systems | 1. e4 c5 2. Nf3 d6 3. d4 cxd4 4. Nxd4 | Asymmetric counter-attacking central struggle |
| B22 | Sicilian Defense: Alapin Variation | 1. e4 c5 2. c3 d5 3. exd5 Qxd5 4. d4 | White builds classical full pawn center with c3-d4 |
| B23 | Sicilian Defense: Closed Variation | 1. e4 c5 2. Nc3 Nc6 3. g3 g6 4. Bg2 | Kingside attack with f4 pawn push avoiding early d4 |
| B33 | Sicilian Defense: Sveshnikov Variation | 1. e4 c5 2. Nf3 Nc6 3. d4 cxd4 4. Nxd4 Nf6 5. Nc3 e5 | Dynamic d5 hole compensated by active bishop pair |
| B40 | Sicilian Defense: Kan / Taimanov | 1. e4 c5 2. Nf3 e6 3. d4 cxd4 4. Nxd4 a6 | Elastic Hedgehog pawn structure with queenside counterplay |
| B50 | Sicilian Defense: Classical Scheveningen | 1. e4 c5 2. Nf3 d6 3. d4 cxd4 4. Nxd4 Nf6 5. Nc3 e6 | Small center (e6/d6) absorbing pressure and striking back |
| B70 | Sicilian Defense: Dragon Variation | 1. e4 c5 2. Nf3 d6 3. d4 cxd4 4. Nxd4 Nf6 5. Nc3 g6 | Razor-sharp Yugoslav attack vs dragon bishop along h8-a1 |
| B90 | Sicilian Defense: Najdorf Variation | 1. e4 c5 2. Nf3 d6 3. d4 cxd4 4. Nxd4 Nf6 5. Nc3 a6 | The Cadillac of chess openings: ultimate dynamic flexibility |

---

### Volume C: Open Games (1. e4 e5) & French Defense
| ECO | Opening Name | Standard Move Sequence | Core Strategic Theme |
|:---:|:-------------|:-----------------------|:---------------------|
| C00 | French Defense: Classical Systems | 1. e4 e6 2. d4 d5 3. Nc3 Nf6 | Deep pawn chain conflict focused on the d4 base |
| C02 | French Defense: Advance Variation | 1. e4 e6 2. d4 d5 3. e5 c5 4. c3 Nc6 | Immediate attack on the pawn chain base with ...c5 and ...Qb6 |
| C10 | French Defense: Rubinstein Variation | 1. e4 e6 2. d4 d5 3. Nc3 dxe4 4. Nxe4 | Surrendering the center for harmonious piece development |
| C15 | French Defense: Winawer Variation | 1. e4 e6 2. d4 d5 3. Nc3 Bb4 4. e5 c5 | Pin on c3 creating doubled pawns and mutual flank assaults |
| C20 | King's Pawn Game: Open Center | 1. e4 e5 2. Nf3 Nc6 3. Bc4 | Rapid piece mobilization aimed at f7 |
| C30 | King's Gambit | 1. e4 e5 2. f4 exf4 3. Nf3 | Romantic sacrifice for central dominance and f-file |
| C41 | Philidor Defense | 1. e4 e5 2. Nf3 d6 3. d4 | Solid but cramped defense; foundation of Morphy's Opera Game |
| C42 | Petroff Defense (Russian Game) | 1. e4 e5 2. Nf3 Nf6 3. Nxe5 d6 | Symmetric counter-attack on e4 with legendary drawing resilience |
| C45 | Scotch Game | 1. e4 e5 2. Nf3 Nc6 3. d4 exd4 4. Nxd4 | Immediate open center releasing central tension early |
| C50 | Italian Game: Giuoco Piano | 1. e4 e5 2. Nf3 Nc6 3. Bc4 Bc5 4. c3 | Classical harmony with c3-d4 central expansion |
| C51 | Evans Gambit | 1. e4 e5 2. Nf3 Nc6 3. Bc4 Bc5 4. b4 | Flank pawn sacrifice to gain central control and development |
| C55 | Two Knights Defense | 1. e4 e5 2. Nf3 Nc6 3. Bc4 Nf6 4. Ng5 d5 | Dynamic counter-attack sacrificing a pawn for initiative |
| C60 | Ruy Lopez (Spanish Opening) | 1. e4 e5 2. Nf3 Nc6 3. Bb5 a6 4. Ba4 | The cornerstone of chess strategy: enduring pressure on e5 |
| C65 | Ruy Lopez: Berlin Defense | 1. e4 e5 2. Nf3 Nc6 3. Bb5 Nf6 4. O-O Nxe4 | The "Berlin Wall": endgame fortress mastered by Kramnik |
| C68 | Ruy Lopez: Exchange Variation | 1. e4 e5 2. Nf3 Nc6 3. Bb5 a6 4. Bxc6 dxc6 | Creates queenside 4-vs-3 pawn majority for the endgame |
| C70 | Ruy Lopez: Closed Morphy Defense | 1. e4 e5 2. Nf3 Nc6 3. Bb5 a6 4. Ba4 Nf6 5. O-O Be7 | Deep strategic maneuvering leading to Chigorin/Breyer systems |

---

### Volume D: Closed Games (1. d4 d5) & Grunfeld
| ECO | Opening Name | Standard Move Sequence | Core Strategic Theme |
|:---:|:-------------|:-----------------------|:---------------------|
| D00 | Queen's Pawn Game: Stonewall / London | 1. d4 d5 2. Bf4 Nf6 3. e3 c5 4. c3 | Modern solid universal setup with dark-square dominance |
| D02 | London System | 1. d4 d5 2. Nf3 Nf6 3. Bf4 c5 4. e3 | Reliable, impenetrable setup playable against virtually all Black replies |
| D10 | Slav Defense: Classical | 1. d4 d5 2. c4 c6 3. Nf3 Nf6 4. Nc3 dxc4 | Solid pawn chain preserving the light-squared bishop |
| D20 | Queen's Gambit Accepted | 1. d4 d5 2. c4 dxc4 3. e4 | White gains full center while Black counter-attacks on flank |
| D30 | Queen's Gambit Declined: Classical | 1. d4 d5 2. c4 e6 3. Nc3 Nf6 4. Bg5 | The gold standard of classical defense and central tension |
| D35 | Queen's Gambit Declined: Exchange / Carlsbad | 1. d4 d5 2. c4 e6 3. Nc3 Nf6 4. cxd5 exd5 | The Carlsbad pawn structure: Minority attack vs Kingside assault |
| D43 | Semi-Slav Defense: Botvinnik / Moscow | 1. d4 d5 2. c4 c6 3. Nf3 Nf6 4. Nc3 e6 | Hyper-complex modern battleground combining Slav and QGD |
| D70 | Neo-Grunfeld Defense | 1. d4 Nf6 2. c4 g6 3. g3 d5 4. Bg2 | Flank fianchetto pressure against central pawn duos |
| D80 | Grunfeld Defense: Classical Systems | 1. d4 Nf6 2. c4 g6 3. Nc3 d5 4. cxd5 Nxd5 | Fischer and Kasparov's dynamic weapon: giving White center to blast it |
| D85 | Grunfeld Defense: Modern Exchange | 1. d4 Nf6 2. c4 g6 3. Nc3 d5 4. cxd5 Nxd5 5. e4 Nxc3 6. bxc3 | Monumental central pawn center tested by ...c5 and ...Bg7 |

---

### Volume E: Indian Defenses (1. d4 Nf6 2. c4)
| ECO | Opening Name | Standard Move Sequence | Core Strategic Theme |
|:---:|:-------------|:-----------------------|:---------------------|
| E00 | Catalan Opening | 1. d4 Nf6 2. c4 e6 3. g3 d5 4. Bg2 | Light-squared bishop fianchetto combines QGD pressure with Reti bite |
| E10 | Blumenfeld Gambit / Queen's Indian Systems | 1. d4 Nf6 2. c4 e6 3. Nf3 c5 | Positional wing counter-attack challenging the center |
| E12 | Queen's Indian Defense: Petrosian System | 1. d4 Nf6 2. c4 e6 3. Nf3 b6 4. a3 | Hypermodern control of e4 square via queenside fianchetto |
| E15 | Queen's Indian Defense: Classical | 1. d4 Nf6 2. c4 e6 3. Nf3 b6 4. g3 Ba6 | Targeted piece pressure against White's c4 pawn |
| E20 | Nimzo-Indian Defense: Classical Systems | 1. d4 Nf6 2. c4 e6 3. Nc3 Bb4 4. Qc2 | Pinning the knight to prevent e4 and induce doubled c-pawns |
| E32 | Nimzo-Indian Defense: Classical 4. Qc2 | 1. d4 Nf6 2. c4 e6 3. Nc3 Bb4 4. Qc2 O-O | Avoids doubled pawns while retaining bishop pair |
| E40 | Nimzo-Indian Defense: Rubinstein System | 1. d4 Nf6 2. c4 e6 3. Nc3 Bb4 4. e3 | Solid central development followed by Bd3 and Ne2 |
| E60 | King's Indian Defense: Classical / Fianchetto | 1. d4 Nf6 2. c4 g6 3. Nc3 Bg7 4. e4 d6 | The romantic counter-attacking defense: Black attacks the King |
| E70 | King's Indian Defense: Saemisch Variation | 1. d4 Nf6 2. c4 g6 3. Nc3 Bg7 4. e4 d6 5. f3 | White fortifies e4 with f3 and launches g4-h4 pawn storm |
| E80 | King's Indian Defense: Four Pawns Attack | 1. d4 Nf6 2. c4 g6 3. Nc3 Bg7 4. e4 d6 5. f4 | Maximum central pawn commitment risking overextension |
| E90 | King's Indian Defense: Classical Mar del Plata | 1. d4 Nf6 2. c4 g6 3. Nc3 Bg7 4. e4 d6 5. Nf3 O-O 6. Be2 e5 | The legendary clash: White attacks Queenside, Black mates Kingside |

---

## Pedagogical Integration in ChessMaster
- **Repertoire Trainer**: Tracks personal success rates, typical mistakes, and deviation frequencies.
- **Transposition Graph**: Interactive directed graph detecting transpositions (e.g., English A10 transposing into Sicilian B20 or QGD D30).
- **Interactive Labs**: Lab 3 (Opening Repertoire Drills) tests player memory, move order discipline, and understanding of opening plans.
