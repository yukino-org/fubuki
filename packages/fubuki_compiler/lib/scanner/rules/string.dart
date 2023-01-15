import '../../lexer/exports.dart';
import '../../token/exports.dart';
import '../scanner.dart';
import '../utils.dart';
import 'rules.dart';

abstract class FubukiStringScanner {
  static const FubukiScannerCustomRule rule =
      FubukiScannerCustomRule(matches, readString);

  static const String rawStringIdentifier = 'r';

  static bool isRawStringIdentifier(final String char) =>
      char == rawStringIdentifier;

  static bool matches(
    final FubukiScanner scanner,
    final FubukiInputIteration current,
  ) =>
      FubukiLexerUtils.isQuote(current.char) ||
      (isRawStringIdentifier(current.char) &&
          FubukiLexerUtils.isQuote(scanner.input.peek().char));

  static FubukiToken readString(
    final FubukiScanner scanner,
    final FubukiInputIteration current,
  ) {
    final FubukiCursor start = current.point;
    final bool isRaw = isRawStringIdentifier(current.char);
    if (isRaw) {
      final String delimiter = scanner.input.advance().char;
      return readRawString(scanner, delimiter, start);
    }

    return processString(readRawString(scanner, current.char, start));
  }

  static FubukiToken processString(final FubukiToken token) {
    final String literal = token.literal as String;
    final int length = literal.length;
    final FubukiStringBuffer buffer = FubukiStringBuffer();

    bool escaped = false;
    int i = 0;
    int row = 0;
    int column = 0;
    while (i < length) {
      final String char = literal[i];
      i++;
      column++;

      if (!escaped && char == r'\') {
        escaped = true;
        continue;
      }

      if (!escaped) {
        buffer.write(char);
        continue;
      }

      switch (char) {
        case r'\':
          buffer.write(r'\');
          break;

        case 't':
          buffer.write('\t');
          break;

        case 'r':
          buffer.write('\r');
          break;

        case 'n':
          buffer.write('\n');
          break;

        case 'f':
          buffer.write('\f');
          break;

        case 'b':
          buffer.write('\b');
          break;

        case 'v':
          buffer.write('\v');
          break;

        case 'u':
          final int end = i + 4;
          if (end < length) {
            final String digit = literal.substring(i, end);
            final int? parsed = int.tryParse(digit, radix: 16);
            if (parsed != null) {
              buffer.write(String.fromCharCode(parsed));
              i = end;
              break;
            }
          }

          return FubukiToken(
            FubukiTokens.illegal,
            literal,
            token.span,
            error: 'Invalid unicode escape sequence',
            errorSpan: FubukiSpan(
              FubukiCursor(
                position: token.span.start.position + i,
                row: row,
                column: column,
              ),
              FubukiCursor(
                position: token.span.start.position + end,
                row: row,
                column: column + 4,
              ),
            ),
          );

        case 'x':
          final int end = i + 2;
          if (end < length) {
            final String digit = literal.substring(i, end);
            final int? parsed = int.tryParse(digit, radix: 16);
            if (parsed != null) {
              buffer.write(String.fromCharCode(parsed));
              i = end;
              break;
            }
          }

          return FubukiToken(
            FubukiTokens.illegal,
            literal,
            token.span,
            error: 'Invalid unicode escape sequence',
            errorSpan: FubukiSpan(
              FubukiCursor(
                position: token.span.start.position + i,
                row: row,
                column: column,
              ),
              FubukiCursor(
                position: token.span.start.position + end,
                row: row,
                column: column + 2,
              ),
            ),
          );

        default:
          if (char == '\n') {
            row++;
            column = 0;
          }
          buffer.write(char);
      }
      escaped = false;
    }

    return FubukiToken(token.type, buffer.toString(), token.span);
  }

  static FubukiToken readRawString(
    final FubukiScanner scanner,
    final String delimiter,
    final FubukiCursor start,
  ) {
    final FubukiStringBuffer buffer = FubukiStringBuffer();

    bool finished = false;
    bool escaped = false;
    FubukiCursor end = start;

    while (!finished && !scanner.input.isEndOfFile()) {
      final FubukiInputIteration current = scanner.input.advance();
      if (!escaped && current.char == delimiter) {
        finished = true;
        break;
      }
      escaped = !escaped && current.char == r'\';
      buffer.write(current.char);
      end = current.point;
    }

    final String output = buffer.toString();
    if (!finished) {
      return FubukiToken(
        FubukiTokens.illegal,
        output,
        FubukiSpan(start, end),
        error: 'Unterminated string literal',
      );
    }

    return FubukiToken(FubukiTokens.string, output, FubukiSpan(start, end));
  }
}
