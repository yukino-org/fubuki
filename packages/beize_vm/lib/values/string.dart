import 'exports.dart';

class BeizeStringValue extends BeizePrimitiveObjectValue {
  BeizeStringValue(this.value);

  final String value;

  @override
  BeizeValue get(final BeizeValue key) {
    if (key is BeizeStringValue) {
      switch (key.value) {
        case 'isEmpty':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeBooleanValue(value.isEmpty),
          );

        case 'isNotEmpty':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeBooleanValue(value.isNotEmpty),
          );

        case 'length':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeNumberValue(value.length.toDouble()),
          );

        case 'compareTo':
          return BeizeNativeFunctionValue.sync(
            (final BeizeNativeFunctionCall call) {
              final BeizeStringValue other = call.argumentAt(0);
              return BeizeNumberValue(
                value.compareTo(other.value).toDouble(),
              );
            },
          );

        case 'contains':
          return BeizeNativeFunctionValue.sync(
            (final BeizeNativeFunctionCall call) {
              final BeizeStringValue other = call.argumentAt(0);
              return BeizeBooleanValue(value.contains(other.value));
            },
          );

        case 'startsWith':
          return BeizeNativeFunctionValue.sync(
            (final BeizeNativeFunctionCall call) {
              final BeizeStringValue other = call.argumentAt(0);
              return BeizeBooleanValue(value.startsWith(other.value));
            },
          );

        case 'endsWith':
          return BeizeNativeFunctionValue.sync(
            (final BeizeNativeFunctionCall call) {
              final BeizeStringValue other = call.argumentAt(0);
              return BeizeBooleanValue(value.endsWith(other.value));
            },
          );

        case 'indexOf':
          return BeizeNativeFunctionValue.sync(
            (final BeizeNativeFunctionCall call) {
              final BeizeStringValue other = call.argumentAt(0);
              return BeizeNumberValue(
                value.indexOf(other.value).toDouble(),
              );
            },
          );

        case 'lastIndexOf':
          return BeizeNativeFunctionValue.sync(
            (final BeizeNativeFunctionCall call) {
              final BeizeStringValue other = call.argumentAt(0);
              return BeizeNumberValue(
                value.lastIndexOf(other.value).toDouble(),
              );
            },
          );

        case 'substring':
          return BeizeNativeFunctionValue.sync(
            (final BeizeNativeFunctionCall call) {
              final BeizeNumberValue start = call.argumentAt(0);
              final BeizeNumberValue end = call.argumentAt(1);
              return BeizeStringValue(
                value.substring(start.intValue, end.intValue),
              );
            },
          );

        case 'replaceFirst':
          return BeizeNativeFunctionValue.sync(
            (final BeizeNativeFunctionCall call) {
              final BeizeStringValue from = call.argumentAt(0);
              final BeizeStringValue to = call.argumentAt(1);
              return BeizeStringValue(
                value.replaceFirst(from.value, to.value),
              );
            },
          );

        case 'replaceAll':
          return BeizeNativeFunctionValue.sync(
            (final BeizeNativeFunctionCall call) {
              final BeizeStringValue from = call.argumentAt(0);
              final BeizeStringValue to = call.argumentAt(1);
              return BeizeStringValue(
                value.replaceAll(from.value, to.value),
              );
            },
          );

        case 'replaceFirstMapped':
          return BeizeNativeFunctionValue.async(
            (final BeizeNativeFunctionCall call) async {
              final BeizeStringValue result = await replaceMapped(call, 1);
              return result;
            },
          );

        case 'replaceAllMapped':
          return BeizeNativeFunctionValue.async(
            (final BeizeNativeFunctionCall call) async {
              final BeizeStringValue result = await replaceMapped(call);
              return result;
            },
          );

        case 'trim':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeStringValue(value.trim()),
          );

        case 'trimLeft':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeStringValue(value.trimLeft()),
          );

        case 'trimRight':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeStringValue(value.trimRight()),
          );

        case 'padLeft':
          return BeizeNativeFunctionValue.sync(
              (final BeizeNativeFunctionCall call) {
            final BeizeNumberValue amount = call.argumentAt(0);
            final BeizeStringValue by = call.argumentAt(1);
            return BeizeStringValue(value.padLeft(amount.intValue, by.value));
          });

        case 'padRight':
          return BeizeNativeFunctionValue.sync(
              (final BeizeNativeFunctionCall call) {
            final BeizeNumberValue amount = call.argumentAt(0);
            final BeizeStringValue by = call.argumentAt(1);
            return BeizeStringValue(value.padRight(amount.intValue, by.value));
          });

        case 'split':
          return BeizeNativeFunctionValue.sync(
              (final BeizeNativeFunctionCall call) {
            final BeizeStringValue delimiter = call.argumentAt(0);
            return BeizeListValue(
              value
                  .split(delimiter.value)
                  .map((final String x) => BeizeStringValue(x))
                  .toList(),
            );
          });

        case 'codeUnitAt':
          return BeizeNativeFunctionValue.sync(
            (final BeizeNativeFunctionCall call) {
              final BeizeNumberValue index = call.argumentAt(0);
              return BeizeNumberValue(
                value.codeUnitAt(index.intValue).toDouble(),
              );
            },
          );

        case 'charAt':
          return BeizeNativeFunctionValue.sync(
            (final BeizeNativeFunctionCall call) {
              final BeizeNumberValue index = call.argumentAt(0);
              return BeizeStringValue(value[index.intValue]);
            },
          );

        case 'toCodeUnits':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeListValue(
              value.codeUnits
                  .map((final int x) => BeizeNumberValue(x.toDouble()))
                  .toList(),
            ),
          );

        case 'toLowerCase':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeStringValue(value.toLowerCase()),
          );

        case 'toUpperCase':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeStringValue(value.toUpperCase()),
          );

        case 'format':
          return BeizeNativeFunctionValue.sync(
            (final BeizeNativeFunctionCall call) {
              final BeizePrimitiveObjectValue value = call.argumentAt(0);
              return BeizeStringValue(format(value));
            },
          );

        default:
      }
    }
    return super.get(key);
  }

  Future<BeizeStringValue> replaceMapped(
    final BeizeNativeFunctionCall call, [
    final int? count,
  ]) async {
    final BeizeStringValue pattern = call.argumentAt(0);
    final BeizeFunctionValue mapper = call.argumentAt(1);
    final String result = await replacePatternMapped(
      pattern.value,
      (final Match match) async {
        final BeizeValue result = await call.frame.callValue(
          mapper,
          <BeizeValue>[BeizeStringValue(match.group(0)!)],
        ).unwrapUnsafe();
        return result.cast<BeizeStringValue>().value;
      },
      count: count,
    );
    return BeizeStringValue(result);
  }

  Future<String> replacePatternMapped(
    final Pattern pattern,
    final Future<String> Function(Match) mapper, {
    final int? count,
  }) async {
    String result = value;
    int adjuster = 0;
    int i = 0;
    for (final Match x in pattern.allMatches(result)) {
      if (count != null && i >= count) break;
      final String by = await mapper(x);
      final String nResult = result.replaceRange(
        x.start + adjuster,
        x.end + adjuster,
        by,
      );
      adjuster = nResult.length - result.length;
      result = nResult;
      i++;
    }
    return result;
  }

  String format(final BeizePrimitiveObjectValue env) {
    if (env is BeizeListValue) {
      int i = 0;
      return value.replaceAllMapped(
        RegExp(r'(?<!\\){([^}]*)}'),
        (final Match match) {
          final String key = match[1]!;
          if (key.isEmpty) {
            return env.getIndex(i++).kToString();
          }
          return env.getIndex(int.parse(key)).kToString();
        },
      );
    }
    final String result = value.replaceAllMapped(
      RegExp(r'(?<!\\){([^}]+)}'),
      (final Match match) {
        final String key = match[1]!;
        return env.get(BeizeStringValue(key)).kToString();
      },
    );
    return result;
  }

  @override
  final BeizeValueKind kind = BeizeValueKind.string;

  @override
  BeizeStringValue kClone() => BeizeStringValue(value);

  @override
  String kToString() => value;

  @override
  bool get isTruthy => value.isNotEmpty;

  @override
  int get kHashCode => value.hashCode;
}
