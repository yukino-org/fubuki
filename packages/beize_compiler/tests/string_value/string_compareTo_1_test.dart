import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Value] String.CompareTo (1)';
  final BeizeProgramConstant program = await compileTestScript(
    'string_value',
    'string_compareTo_1.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['-1'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
