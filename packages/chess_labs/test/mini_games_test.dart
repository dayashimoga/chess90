import 'package:chess_labs/chess_labs.dart';
import 'package:test/test.dart';

void main() {
  group('MiniGames Classes Test', () {
    test('PawnBattleLab instantiates and holds properties', () {
      final lab = PawnBattleLab(
        id: 'pb_1',
        title: 'Pawn Race',
        initialFen: '8/4P3/8/8/8/8/4p3/8 w - - 0 1',
        solutionSan: ['e8=Q'],
        hints: ['Push the pawn'],
        explanation: 'Promote first',
        targetMoveCount: 3,
      );
      expect(lab.labType, equals('pawn_battle'));
      expect(lab.targetMoveCount, equals(3));
      expect(lab.title, equals('Pawn Race'));
    });

    test('ForkHunterLab instantiates and holds properties', () {
      final lab = ForkHunterLab(
        id: 'fh_1',
        title: 'Knight Fork',
        initialFen: '4k3/8/8/8/8/8/8/4N3 w - - 0 1',
        solutionSan: ['Nd3'],
        hints: ['Find the fork square'],
        explanation: 'Forks king and queen',
        forkingPiece: 'Knight',
      );
      expect(lab.labType, equals('fork_hunter'));
      expect(lab.forkingPiece, equals('Knight'));
    });

    test('KingHuntLab instantiates and holds properties', () {
      final lab = KingHuntLab(
        id: 'kh_1',
        title: 'King Hunt Drill',
        initialFen: '4k3/8/8/8/8/8/8/4R3 w - - 0 1',
        solutionSan: ['Re8#'],
        explanation: 'Mating net',
        maxPliesToMate: 2,
      );
      expect(lab.labType, equals('king_hunt'));
      expect(lab.maxPliesToMate, equals(2));
    });

    test('OpeningChallengeLab instantiates and holds properties', () {
      final lab = OpeningChallengeLab(
        id: 'oc_1',
        title: 'Ruy Lopez Challenge',
        initialFen: 'r1bqkbnr/pppp1ppp/2n5/1B2p3/4P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3',
        solutionSan: ['a6'],
        explanation: 'Morphy Defense',
        openingName: 'Ruy Lopez',
        ecoCode: 'C60',
      );
      expect(lab.labType, equals('opening_challenge'));
      expect(lab.openingName, equals('Ruy Lopez'));
      expect(lab.ecoCode, equals('C60'));
    });

    test('DefenderLab instantiates and holds properties', () {
      final lab = DefenderLab(
        id: 'def_1',
        title: 'Under Attack',
        initialFen: '4k3/8/8/8/8/8/8/4R3 w - - 0 1',
        solutionSan: ['Kf1'],
        explanation: 'Step out of pin',
        opponentThreat: 'Checkmate on e8',
      );
      expect(lab.labType, equals('defender'));
      expect(lab.opponentThreat, equals('Checkmate on e8'));
    });

    test('ConvertItLab and HoldTheDrawLab instantiate correctly', () {
      final conv = ConvertItLab(
        id: 'conv_1',
        title: 'Convert +3 Advantage',
        initialFen: '4k3/8/8/8/8/8/8/4R3 w - - 0 1',
        solutionSan: ['Re1'],
        explanation: 'Trade down',
        advantageDescription: '+1 Rook up',
      );
      expect(conv.labType, equals('convert_it'));
      expect(conv.advantageDescription, equals('+1 Rook up'));

      final hold = HoldTheDrawLab(
        id: 'hold_1',
        title: 'Fortress Defense',
        initialFen: '4k3/8/8/8/8/8/8/4R3 w - - 0 1',
        solutionSan: ['Ke7'],
        explanation: 'Build fortress',
        fortressTechnique: 'Light-square blockade',
      );
      expect(hold.labType, equals('hold_the_draw'));
      expect(hold.fortressTechnique, equals('Light-square blockade'));
    });
  });
}
