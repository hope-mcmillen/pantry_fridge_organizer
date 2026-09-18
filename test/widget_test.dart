// Widget tests for the Pantry Organizer home screen.
//
// The screen is two shelves -- "In My Fridge" and "Need to Buy" -- and the way
// you move an ingredient between them is by dragging its jar label from one
// shelf onto the other. These tests cover that the shelves render with their
// starter ingredients, and that a drag actually moves an item.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pantry_fridge_organizer/main.dart';
import 'package:pantry_fridge_organizer/pantry_screen.dart';

/// The shelf whose label reads [title].
Finder shelf(String title) => find.widgetWithText(PantrySection, title);

/// The jar label for [item], but only the one sitting on the [title] shelf.
Finder itemOnShelf(String title, String item) =>
    find.descendant(of: shelf(title), matching: find.text(item));

/// Drags [item] off the [from] shelf and drops it onto the [to] shelf.
Future<void> dragItem(
  WidgetTester tester, {
  required String item,
  required String from,
  required String to,
}) async {
  final gesture = await tester.startGesture(
    tester.getCenter(itemOnShelf(from, item)),
  );

  // Let the Draggable pick the label up before travelling.
  await tester.pump(const Duration(milliseconds: 100));

  await gesture.moveTo(tester.getCenter(shelf(to)));
  await tester.pump();

  await gesture.up();
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    // Each test starts with a first-launch pantry, independent of other tests.
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('both shelves render with their starter ingredients', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PantryOrganizerApp());
    await tester.pumpAndSettle();

    expect(find.text('Pantry Organizer'), findsOneWidget);
    expect(find.text('What do you have right now?'), findsOneWidget);

    expect(shelf('In My Fridge'), findsOneWidget);
    expect(shelf('Need to Buy'), findsOneWidget);

    // Starter contents of each shelf.
    expect(itemOnShelf('In My Fridge', 'Milk'), findsOneWidget);
    expect(itemOnShelf('In My Fridge', 'Eggs'), findsOneWidget);
    expect(itemOnShelf('Need to Buy', 'Chicken'), findsOneWidget);
    expect(itemOnShelf('Need to Buy', 'Apples'), findsOneWidget);

    // An ingredient lives on exactly one shelf to begin with.
    expect(itemOnShelf('In My Fridge', 'Chicken'), findsNothing);
    expect(itemOnShelf('Need to Buy', 'Milk'), findsNothing);
  });

  testWidgets('dragging an ingredient onto the fridge shelf moves it there', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PantryOrganizerApp());
    await tester.pumpAndSettle();

    await dragItem(
      tester,
      item: 'Chicken',
      from: 'Need to Buy',
      to: 'In My Fridge',
    );

    expect(itemOnShelf('In My Fridge', 'Chicken'), findsOneWidget);
    expect(itemOnShelf('Need to Buy', 'Chicken'), findsNothing);
  });

  testWidgets('dragging an ingredient onto the shopping shelf moves it there', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PantryOrganizerApp());
    await tester.pumpAndSettle();

    await dragItem(
      tester,
      item: 'Milk',
      from: 'In My Fridge',
      to: 'Need to Buy',
    );

    expect(itemOnShelf('Need to Buy', 'Milk'), findsOneWidget);
    expect(itemOnShelf('In My Fridge', 'Milk'), findsNothing);
  });

  testWidgets('dropping an ingredient back on its own shelf is a no-op', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PantryOrganizerApp());
    await tester.pumpAndSettle();

    await dragItem(
      tester,
      item: 'Eggs',
      from: 'In My Fridge',
      to: 'In My Fridge',
    );

    // Still there exactly once -- no duplicate label, and it did not vanish.
    expect(itemOnShelf('In My Fridge', 'Eggs'), findsOneWidget);
    expect(itemOnShelf('Need to Buy', 'Eggs'), findsNothing);
  });
}
