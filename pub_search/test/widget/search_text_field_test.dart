import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pub_search/theme.dart';
import 'package:pub_search/widgets/search_text_field.dart';
import 'package:rive/rive.dart';

@GenerateNiceMocks([MockSpec<OnChanged>()])
import 'search_text_field_test.mocks.dart';

Widget makeTestable(Widget widget) => MaterialApp(
      theme: mainTheme,
      home: Material(
        child: Scaffold(
          body: widget,
        ),
      ),
    );

void main() {
  testWidgets(
    'Search icon animation should appear or disappear upon user interaction',
    (WidgetTester tester) async {
      final focusNode = FocusNode();
      final textEditingController = TextEditingController();

      final mockOnChanged = MockOnChanged();

      await tester.pumpWidget(
        makeTestable(
          SearchTextField(
            focusNode: focusNode,
            controller: textEditingController,
            onChanged: mockOnChanged.onChanged,
          ),
        ),
      );

      await tester.pumpAndSettle();

      final animationFinder = find.byType(RiveAnimation).hitTestable();
      final textFieldFinder = find.byType(TextField);
      final animatedOpacityFinder = find.byType(AnimatedOpacity);
      const text = 'abc';

      expect(animationFinder, findsOneWidget);
      expect(textFieldFinder, findsOneWidget);
      expect(
        (tester.firstWidget(animatedOpacityFinder) as AnimatedOpacity).opacity,
        equals(1),
      );
      expect(animatedOpacityFinder, findsOneWidget);

      await tester.tap(textFieldFinder);

      await tester.pumpAndSettle();

      expect(
        (tester.firstWidget(animatedOpacityFinder) as AnimatedOpacity).opacity,
        equals(0),
      );

      for (var i = 1; i <= text.length; i++) {
        final typedText = text.substring(0, i);

        await tester.enterText(textFieldFinder, typedText);
      }

      // await tester.enterText(textFieldFinder, text);

      await tester.pumpAndSettle();

      for (var i = 1; i <= text.length; i++) {
        final typedText = text.substring(0, i);

        verify(mockOnChanged.onChanged(typedText)).called(1);
      }

      expect(
        (tester.firstWidget(animatedOpacityFinder) as AnimatedOpacity).opacity,
        equals(0),
      );

      focusNode.unfocus();

      await tester.pumpAndSettle();

      expect(
        (tester.firstWidget(animatedOpacityFinder) as AnimatedOpacity).opacity,
        equals(0),
      );

      await tester.tap(textFieldFinder);
      await tester.pumpAndSettle();

      for (var i = 0; i < text.length; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.pumpAndSettle();
      }

      focusNode.unfocus();

      await tester.pumpAndSettle();

      expect(
        (tester.firstWidget(animatedOpacityFinder) as AnimatedOpacity).opacity,
        equals(1),
      );
    },
  );
}

class OnChanged {
  onChanged(String value) => (_) {
        //
      };
}
