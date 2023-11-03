import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Operator] Division (3)';
  final BeizeProgramConstant program = await compileTestScript(
    'division_operator',
    'division_3.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['Infinity'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
