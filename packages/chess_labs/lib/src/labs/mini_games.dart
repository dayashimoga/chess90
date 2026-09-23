import '../lab_session.dart';

/// Mini-game 1: Pawn Battle
/// Focus: Pawn breakthrough, creation of outside passed pawns, and promotion races.
class PawnBattleLab extends LabSession {
  final int targetMoveCount;

  PawnBattleLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required super.solutionSan,
    super.hints,
    required super.explanation,
    this.targetMoveCount = 5,
  }) : super(
          labType: 'pawn_battle',
        );
}

/// Mini-game 2: Fork Hunter
/// Focus: Spotting tactical double attacks and coordinating knight/pawn strikes.
class ForkHunterLab extends LabSession {
  final String forkingPiece;

  ForkHunterLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required super.solutionSan,
    super.hints,
    required super.explanation,
    required this.forkingPiece,
  }) : super(
          labType: 'fork_hunter',
        );
}

/// Mini-game 3: King Hunt
/// Focus: Driving the vulnerable enemy king into mating nets with forcing checks.
class KingHuntLab extends LabSession {
  final int maxPliesToMate;

  KingHuntLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required super.solutionSan,
    super.hints,
    required super.explanation,
    this.maxPliesToMate = 4,
  }) : super(
          labType: 'king_hunt',
        );
}

/// Mini-game 4: Opening Challenge
/// Focus: Executing theoretical opening mainlines and punishing early deviations.
class OpeningChallengeLab extends LabSession {
  final String openingName;
  final String ecoCode;

  OpeningChallengeLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required super.solutionSan,
    super.hints,
    required super.explanation,
    required this.openingName,
    required this.ecoCode,
  }) : super(
          labType: 'opening_challenge',
        );
}

/// Mini-game 5: Defender
/// Focus: Spotting severe opponent tactical threats and finding the only saving defensive resource.
class DefenderLab extends LabSession {
  final String opponentThreat;

  DefenderLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required super.solutionSan,
    super.hints,
    required super.explanation,
    required this.opponentThreat,
  }) : super(
          labType: 'defender',
        );
}

/// Mini-game 6: Convert It
/// Focus: Converting clear material or structural advantage into a technical win.
class ConvertItLab extends LabSession {
  final String advantageDescription;

  ConvertItLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required super.solutionSan,
    super.hints,
    required super.explanation,
    required this.advantageDescription,
  }) : super(
          labType: 'convert_it',
        );
}

/// Mini-game 7: Hold the Draw
/// Focus: Tenacious defense in inferior/pawn-down endgames, perpetual check, and fortress construction.
class HoldTheDrawLab extends LabSession {
  final String fortressTechnique;

  HoldTheDrawLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required super.solutionSan,
    super.hints,
    required super.explanation,
    required this.fortressTechnique,
  }) : super(
          labType: 'hold_the_draw',
        );
}
