import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Statement] Match (2)';
  final BeizeProgramConstant program =
      await compileTestScript('match_statement', 'match_2.beize');

  test('$title - Bytecode', () async {
    final BeizeChunk chunk = extractChunk(program);
    final BeizeTestChunk expectedChunk = BeizeTestChunk();
    expectedChunk.addOpCode(BeizeOpCodes.opConstant);
    expectedChunk.addConstant(0, 1.0);
    expectedChunk.addOpCode(BeizeOpCodes.opAbsoluteJump);
    expectedChunk.addCode(4);
    expectedChunk.addOpCode(BeizeOpCodes.opTop);
    expectedChunk.addOpCode(BeizeOpCodes.opConstant);
    expectedChunk.addConstant(1, 0.0);
    expectedChunk.addOpCode(BeizeOpCodes.opEqual);
    expectedChunk.addOpCode(BeizeOpCodes.opJumpIfFalse);
    expectedChunk.addCode(12);
    expectedChunk.addOpCode(BeizeOpCodes.opBeginScope);
    expectedChunk.addOpCode(BeizeOpCodes.opLookup);
    expectedChunk.addConstant(2, 'out');
    expectedChunk.addOpCode(BeizeOpCodes.opConstant);
    expectedChunk.addConstant(3, 'c-0');
    expectedChunk.addOpCode(BeizeOpCodes.opCall);
    expectedChunk.addCode(1);
    expectedChunk.addOpCode(BeizeOpCodes.opPop);
    expectedChunk.addOpCode(BeizeOpCodes.opEndScope);
    expectedChunk.addOpCode(BeizeOpCodes.opPop);
    expectedChunk.addOpCode(BeizeOpCodes.opAbsoluteJump);
    expectedChunk.addCode(34);
    expectedChunk.addOpCode(BeizeOpCodes.opPop);
    expectedChunk.addOpCode(BeizeOpCodes.opAbsoluteJump);
    expectedChunk.addCode(25);
    expectedChunk.addOpCode(BeizeOpCodes.opLookup);
    expectedChunk.addConstant(2, 'out');
    expectedChunk.addOpCode(BeizeOpCodes.opConstant);
    expectedChunk.addConstant(4, 'c-else');
    expectedChunk.addOpCode(BeizeOpCodes.opCall);
    expectedChunk.addCode(1);
    expectedChunk.addOpCode(BeizeOpCodes.opPop);
    expectedChunk.addOpCode(BeizeOpCodes.opAbsoluteJump);
    expectedChunk.addCode(34);
    expectedChunk.addOpCode(BeizeOpCodes.opPop);
    expect(tcpc(chunk), tcptc(expectedChunk));
  });

  test('$title - Channel', () async {
    final List<String> expected = <String>['c-else'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}