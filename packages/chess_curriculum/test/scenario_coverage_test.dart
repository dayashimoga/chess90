import 'package:chess_core/chess_core.dart';
import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:test/test.dart';

void main() {
  group('LessonScenario & Curriculum Models Deep Coverage', () {
    test('LessonScenario serializes and deserializes accurately', () {
      final scenario = LessonScenario(
        id: 'test_scenario_1',
        day: 5,
        phase: CurriculumPhase.phase1Fundamentals,
        concept: 'Knight Forks & Geometry',
        subconcept: 'Royal Fork',
        difficulty: 1250,
        learningObjective: 'Fork king and rook',
        prerequisites: [4],
        fen: 'r1b1kb1r/pp1p1ppp/2n1p3/1N6/4n3/2P1B3/PP3PPP/RN1QKB1R w KQkq - 0 9',
        sideToMove: PieceColor.white,
        conceptMarkers: ['c7', 'e8', 'a8'],
        teachingSequence: [
          const TeachingStep(
            stepIndex: 0,
            text: 'Knight on b5',
            highlightSquares: ['b5'],
            arrows: ['b5c7'],
            autoPlayMoveSan: 'Nc7+',
            interactiveAction: InteractiveAction(
              type: ActionType.executeMove,
              instruction: 'Jump knight to c7',
              targetSquares: ['c7'],
              expectedMoveSan: 'Nc7+',
              feedbackOnSuccess: 'Great fork!',
              feedbackOnFailure: 'Try Nc7+',
            ),
          ),
        ],
        interactiveActions: [
          const InteractiveAction(
            type: ActionType.predictTarget,
            instruction: 'Predict the target',
            targetSquares: ['c7'],
            expectedMoveSan: 'Nc7+',
            feedbackOnSuccess: 'Well spotted',
            feedbackOnFailure: 'Look for royal fork',
          ),
        ],
        expectedMoves: ['Nc7+'],
        acceptableAlternatives: ['Nd6+'],
        opponentReplies: ['Kd8'],
        refutations: {'wrong': 'Fails immediately'},
        hint1Concept: 'Look for check',
        hint2PieceOrSquare: 'Move knight',
        hint3Move: 'Play Nc7+',
        fullLine: ['Nc7+', 'Kd8', 'Nxa8'],
        explanation: 'Nc7 wins the rook',
        commonMistakes: ['Rushing'],
        miniGameConfig: {'type': 'fork_hunter'},
        practicePositions: [
          const PracticePosition(
            id: 'prac_1',
            fen: '4k3/8/8/8/8/8/8/4K3 w - - 0 1',
            sideToMove: PieceColor.white,
            instruction: 'Move king',
            expectedMoves: ['Ke2'],
            explanation: 'Walk king up',
            hintConcept: 'King activity',
            hintPieceOrSquare: 'King to e2',
            hintMove: 'Ke2',
            refutations: {'Kd2': 'Suboptimal'},
          ),
        ],
        retentionPositions: [
          const RetentionPosition(
            id: 'ret_1',
            fen: '4k3/8/8/8/8/8/8/4K3 w - - 0 1',
            sideToMove: PieceColor.white,
            instruction: 'Step up again',
            expectedMoves: ['Ke2'],
            explanation: 'Keep walking up',
            daysInterval: 5,
          ),
        ],
        source: 'Model Game',
        engineVerification: const EngineVerification(
          verified: true,
          engine: 'Stockfish 19',
          depth: 18,
          evalCentipawns: 450.0,
          bestMoveSan: 'Nc7+',
          timestamp: '2026-09-24T12:00:00Z',
        ),
      );

      final json = scenario.toJson();
      expect(json['id'], equals('test_scenario_1'));
      expect(json['concept'], equals('Knight Forks & Geometry'));

      final restored = LessonScenario.fromJson(json);
      expect(restored.id, equals('test_scenario_1'));
      expect(restored.day, equals(5));
      expect(restored.concept, equals('Knight Forks & Geometry'));
      expect(restored.subconcept, equals('Royal Fork'));
      expect(restored.difficulty, equals(1250));
      expect(restored.learningObjective, equals('Fork king and rook'));
      expect(restored.prerequisites, equals([4]));
      expect(restored.sideToMove, equals(PieceColor.white));
      expect(restored.conceptMarkers, equals(['c7', 'e8', 'a8']));
      expect(restored.teachingSequence.length, equals(1));
      expect(restored.interactiveActions.length, equals(1));
      expect(restored.expectedMoves, equals(['Nc7+']));
      expect(restored.acceptableAlternatives, equals(['Nd6+']));
      expect(restored.opponentReplies, equals(['Kd8']));
      expect(restored.refutations['wrong'], equals('Fails immediately'));
      expect(restored.hint1Concept, equals('Look for check'));
      expect(restored.hint2PieceOrSquare, equals('Move knight'));
      expect(restored.hint3Move, equals('Play Nc7+'));
      expect(restored.fullLine, equals(['Nc7+', 'Kd8', 'Nxa8']));
      expect(restored.explanation, equals('Nc7 wins the rook'));
      expect(restored.commonMistakes, equals(['Rushing']));
      expect(restored.miniGameConfig['type'], equals('fork_hunter'));
      expect(restored.practicePositions.length, equals(1));
      expect(restored.retentionPositions.length, equals(1));
      expect(restored.source, equals('Model Game'));
      expect(restored.engineVerification?.bestMoveSan, equals('Nc7+'));
      expect(restored.engineVerification?.verified, isTrue);

      // Practice and Retention position conversions
      final pracEx = scenario.practicePositions.first.toExercise();
      expect(pracEx.id, equals('prac_1'));
      expect(pracEx.solutionSan, equals(['Ke2']));

      final primaryEx = scenario.toPrimaryExercise();
      expect(primaryEx.id, equals('test_scenario_1'));
      expect(primaryEx.solutionSan, equals(['Nc7+']));
    });

    test('CurriculumExercise serialization and hint fallbacks', () {
      final ex = CurriculumExercise(
        id: 'ex_1',
        fen: '4k3/8/8/8/8/8/8/4K3 w - - 0 1',
        sideToPlay: PieceColor.white,
        instruction: 'Play white',
        solutionSan: ['Ke2'],
        explanation: 'King move',
        motif: 'Endgame',
        hintConcept: 'Concept 1',
        hintPiece: 'King',
        hintForcing: 'Ke2',
        refutationAnalysis: 'Kd2 is passive',
      );

      expect(ex.concept, equals('Concept 1'));
      expect(ex.targetPiece, equals('King'));
      expect(ex.tieredHints.length, equals(3));
      expect(ex.tieredHints[0], equals('Concept 1'));
      expect(ex.tieredHints[1], equals('King'));
      expect(ex.tieredHints[2], equals('Ke2'));

      final json = ex.toJson();
      final restored = CurriculumExercise.fromJson(json);
      expect(restored.id, equals('ex_1'));
      expect(restored.solutionSan, equals(['Ke2']));
      expect(restored.refutationAnalysis, equals('Kd2 is passive'));

      // Test fallback hint logic
      final exBare = CurriculumExercise(
        id: 'ex_bare',
        fen: '4k3/8/8/8/8/8/8/4K3 w - - 0 1',
        sideToPlay: PieceColor.white,
        instruction: 'Play',
        solutionSan: ['Ke2'],
        explanation: 'King move',
        motif: 'Endgame',
      );
      expect(exBare.concept, equals('Tactical Calculation'));
      expect(exBare.targetPiece, equals('active piece'));
      expect(exBare.tieredHints.length, equals(3));
    });

    test('CurriculumDay serialization and helper getters', () {
      final day = CurriculumCatalog.getDay(5);
      expect(day.dayNumber, equals(5));
      expect(day.displayLabel, contains('Day 5'));
      expect(day.shortExplanation, isNotEmpty);
      expect(day.commonMistakesList, isA<List<String>>());
      expect(day.cheatSheetText, isNotEmpty);

      final json = day.toJson();
      final restored = CurriculumDay.fromJson(json);
      expect(restored.dayNumber, equals(5));
      expect(restored.title, equals(day.title));
      expect(restored.phase, equals(day.phase));
      expect(restored.scenario, isNotNull);
      expect(restored.scenario?.expectedMoves, equals(['Nc7+']));
    });

    test('CurriculumCatalog catalog accessors and cheat sheets', () {
      final allDays = CurriculumCatalog.allDays;
      expect(allDays.length, equals(90));

      final day1 = CurriculumCatalog.getDay(1);
      expect(day1.dayNumber, equals(1));

      // Test out of bounds days throw ArgumentError
      expect(() => CurriculumCatalog.getDay(0), throwsArgumentError);
      expect(() => CurriculumCatalog.getDay(91), throwsArgumentError);

      // Test exams
      final exams = allDays.where((d) => d.isWeeklyExam).toList();
      expect(exams, isNotEmpty);
      expect(exams.first.dayNumber, equals(7));

      // Test all phases exist
      final phases = allDays.map((d) => d.phase).toSet();
      expect(phases.length, equals(13));

      // CheatSheetsCatalog
      final sheets = CheatSheetsCatalog.entries;
      expect(sheets, isNotEmpty);
      expect(sheets.first.id, isNotEmpty);
    });
  });
}
