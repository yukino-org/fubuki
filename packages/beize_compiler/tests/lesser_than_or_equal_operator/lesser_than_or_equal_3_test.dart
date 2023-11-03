import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Operator] Lesser Than Or Equal (3)';
  final BeizeProgramConstant program = await compileTestScript(
    'lesser_than_or_equal_operator',
    'lesser_than_or_equal_3.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['false'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
