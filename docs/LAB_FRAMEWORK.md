# Interactive Lab Framework

The ChessMaster Lab Framework powers hands-on, learn-by-doing interactive training environments.

## Lab Architecture

Every lab extends or interacts with `LabSession` (`packages/chess_labs/lib/src/lab_session.dart`):
- `currentBoard`: Tracks active piece coordinates.
- `solutionSan`: Ordered sequence of required moves (mainline and opponent replies).
- `hints`: Progressive hints revealed sequentially upon user request.
- `score`: Starts at 100%, deducting:
  - `-20%` per hint requested
  - `-25%` per incorrect move attempted
  - `-30%` for false "No Tactic" declaration.

## Specialized Lab Implementations

1. **Tactical Recognition Lab (`TacticalLab`)**:
   - Tests pattern identification (forks, pins, skewers, mating nets).
   - Automatically plays opponent replies specified in the solution line.
2. **"No Tactic Exists" Positions**:
   - Includes positions where playing for an intuitive sacrifice loses.
   - User must click the dedicated **"Declare No Tactic"** button or play the solid non-tactical move to pass.
3. **Candidate Selection Lab (`CandidateSelectionLab`)**:
   - User must identify viable candidate moves before calculating lines.
4. **Blindfold Calculation Lab (`BlindCalculationLab`)**:
   - Moves are fed via textual notation without moving pieces on the visual board.
   - The user must maintain the board state in mental imagery and play the concluding move.
5. **Endgame Win & Defend Lab (`EndgameWinDefendLab`)**:
   - User plays against an active chess engine.
   - Must deliver checkmate (in winning positions) or hold stalemate/perpetual (in defending positions) against active resistance.
