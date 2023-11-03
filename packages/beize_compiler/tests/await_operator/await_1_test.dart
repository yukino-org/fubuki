import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Operator] Await (1)';
  final BeizeProgramConstant program = await compileTestScript(
    'await_operator',
    'await_1.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['Unawaited', 'c-0'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
