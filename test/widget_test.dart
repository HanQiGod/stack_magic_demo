import 'package:flutter_test/flutter_test.dart';
import 'package:stack_magic_demo/main.dart';

void main() {
  testWidgets('Stack demo renders and toggles loading overlay', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Stack 图层魔法实验室'), findsOneWidget);
    expect(find.text('显示蒙层'), findsOneWidget);
    expect(find.text('加载中...'), findsNothing);

    await tester.tap(find.text('显示蒙层'));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('加载中...'), findsOneWidget);
    expect(find.text('点击任意处关闭'), findsOneWidget);

    await tester.tap(find.text('点击任意处关闭'));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('加载中...'), findsNothing);

    await tester.tap(find.text('文章配图'));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('文章配图模式'), findsOneWidget);
    expect(find.text('显示蒙层'), findsNothing);
  });
}
