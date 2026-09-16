import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/pantry_items.dart';
import 'widgets/ingredient_tile.dart';

// -----------------------------------------------------------------------------
// PANTRY PALETTE
// -----------------------------------------------------------------------------

const Color kInk = Color(0xFF4A3524);
const Color kCream = Color(0xFFFBF3E4);
const Color kPaper = Color(0xFFF1E2C8);
const Color kTwine = Color(0xFFD9BE96);
const Color kWood = Color(0xFF9C6B43);
const Color kWoodDark = Color(0xFF7A5133);
const Color kSage = Color(0xFF7E9068);
const Color kTerracotta = Color(0xFFC0703F);

// -----------------------------------------------------------------------------
// PANTRY SCREEN
// -----------------------------------------------------------------------------

class PantryScreen extends StatefulWidget {
const PantryScreen({super.key});

@override
State<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
// ---------------------------------------------------------------------------
// MASTER INGREDIENT LIST
// ---------------------------------------------------------------------------

final List<PantryItem> items = [
PantryItem(
id: 'milk',
name: 'Milk',
inFridge: true,
),
PantryItem(
id: 'eggs',
name: 'Eggs',
inFridge: true,
),
PantryItem(
id: 'cheese',
name: 'Cheese',
inFridge: true,
),
PantryItem(
id: 'butter',
name: 'Butter',
inFridge: true,
),
PantryItem(
id: 'chicken',
name: 'Chicken',
inFridge: false,
),
PantryItem(
id: 'tomatoes',
name: 'Tomatoes',
inFridge: false,
),
PantryItem(
id: 'apples',
name: 'Apples',
inFridge: false,
),
PantryItem(
id: 'yogurt',
name: 'Yogurt',
inFridge: false,
),
];

bool isLoading = true;

// ---------------------------------------------------------------------------
// FILTERED LISTS
// ---------------------------------------------------------------------------

List<PantryItem> get inFridgeItems {
return items.where((item) => item.inFridge).toList();
}

List<PantryItem> get needToBuyItems {
return items.where((item) => !item.inFridge).toList();
}

// ---------------------------------------------------------------------------
// STARTUP
// ---------------------------------------------------------------------------

@override
void initState() {
super.initState();
loadPantry();
}

// ---------------------------------------------------------------------------
// LOAD PANTRY FROM LOCAL STORAGE
// ---------------------------------------------------------------------------

Future<void> loadPantry() async {
final prefs = await SharedPreferences.getInstance();

final savedFridgeIds = prefs.getStringList('fridgeItems');

// If saved data exists, restore it.
// If this is the first launch, the starter values above remain unchanged.
if (savedFridgeIds != null) {
for (final item in items) {
item.inFridge = savedFridgeIds.contains(item.id);
}
}

if (!mounted) {
return;
}

setState(() {
isLoading = false;
});
}

// ---------------------------------------------------------------------------
// SAVE PANTRY TO LOCAL STORAGE
// ---------------------------------------------------------------------------

Future<void> savePantry() async {
final prefs = await SharedPreferences.getInstance();

final fridgeIds = items
    .where((item) => item.inFridge)
    .map((item) => item.id)
    .toList();

await prefs.setStringList(
'fridgeItems',
fridgeIds,
);
}

// ---------------------------------------------------------------------------
// MOVE ITEM INTO FRIDGE
// ---------------------------------------------------------------------------

void moveToFridge(PantryItem item) {
if (item.inFridge) {
return;
}

setState(() {
item.inFridge = true;
});

savePantry();
}

// ---------------------------------------------------------------------------
// MOVE ITEM TO NEED TO BUY
// ---------------------------------------------------------------------------

void moveToNeedToBuy(PantryItem item) {
if (!item.inFridge) {
return;
}

setState(() {
item.inFridge = false;
});

savePantry();
}

// ---------------------------------------------------------------------------
// SCREEN
// ---------------------------------------------------------------------------

@override
Widget build(BuildContext context) {
return Scaffold(
extendBodyBehindAppBar: true,
backgroundColor: Colors.transparent,

appBar: AppBar(
backgroundColor: Colors.transparent,
surfaceTintColor: Colors.transparent,
elevation: 0,
centerTitle: true,
title: const Text(
'Pantry Organizer',
style: TextStyle(
fontWeight: FontWeight.w800,
fontSize: 23,
letterSpacing: 0.4,
color: kInk,
),
),
),

body: Container(
decoration: const BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topCenter,
end: Alignment.bottomCenter,
colors: [
kCream,
kPaper,
],
),
),

child: CustomPaint(
painter: _GinghamPainter(),

child: SafeArea(
child: isLoading
? const Center(
child: CircularProgressIndicator(
color: kWood,
),
)
    : Padding(
padding: const EdgeInsets.fromLTRB(
16,
4,
16,
16,
),

child: Column(
children: [
// -----------------------------------------------------
// HEADER CARD
// -----------------------------------------------------

Container(
padding: const EdgeInsets.symmetric(
horizontal: 20,
vertical: 11,
),

decoration: BoxDecoration(
color: kCream,
borderRadius: BorderRadius.circular(14),
border: Border.all(
color: kTwine,
width: 1.4,
),
boxShadow: [
BoxShadow(
color: kWoodDark.withValues(
alpha: 0.12,
),
blurRadius: 8,
offset: const Offset(0, 4),
),
],
),

child: const Text(
'What do you have right now?',
style: TextStyle(
fontSize: 16.5,
fontWeight: FontWeight.w600,
color: kInk,
),
),
),

const SizedBox(height: 18),

// -----------------------------------------------------
// IN MY FRIDGE
// -----------------------------------------------------

Expanded(
child: PantrySection(
title: 'In My Fridge',
subtitle:
'Drag ingredients here if you have them',
items: inFridgeItems,
onAccept: moveToFridge,
accent: kSage,
icon: Icons.kitchen_outlined,
),
),

const SizedBox(height: 18),

// -----------------------------------------------------
// NEED TO BUY
// -----------------------------------------------------

Expanded(
child: PantrySection(
title: 'Need to Buy',
subtitle:
'Drag ingredients here if you need them',
items: needToBuyItems,
onAccept: moveToNeedToBuy,
accent: kTerracotta,
icon: Icons.shopping_basket_outlined,
),
),
],
),
),
),
),
),
);
}
}

// -----------------------------------------------------------------------------
// GINGHAM BACKGROUND
// -----------------------------------------------------------------------------

class _GinghamPainter extends CustomPainter {
static const double _spacing = 26;

@override
void paint(Canvas canvas, Size size) {
final paint = Paint()
..color = kWood.withValues(alpha: 0.035)
..strokeWidth = 9;

for (double x = 0; x < size.width; x += _spacing) {
canvas.drawLine(
Offset(x, 0),
Offset(x, size.height),
paint,
);
}

for (double y = 0; y < size.height; y += _spacing) {
canvas.drawLine(
Offset(0, y),
Offset(size.width, y),
paint,
);
}
}

@override
bool shouldRepaint(covariant _GinghamPainter oldDelegate) {
return false;
}
}

// -----------------------------------------------------------------------------
// PANTRY SECTION
// -----------------------------------------------------------------------------

class PantrySection extends StatelessWidget {
final String title;
final String subtitle;

// IMPORTANT:
// This is now PantryItem, not String.
final List<PantryItem> items;

// IMPORTANT:
// Drag-and-drop now passes the entire PantryItem.
final void Function(PantryItem) onAccept;

final Color accent;
final IconData icon;

const PantrySection({
super.key,
required this.title,
required this.subtitle,
required this.items,
required this.onAccept,
required this.accent,
required this.icon,
});

@override
Widget build(BuildContext context) {
return DragTarget<PantryItem>(
onAcceptWithDetails: (details) {
onAccept(details.data);
},

builder: (
context,
candidateData,
rejectedData,
) {
final bool isHovering = candidateData.isNotEmpty;

return AnimatedContainer(
duration: const Duration(milliseconds: 220),
curve: Curves.easeOut,
width: double.infinity,

decoration: BoxDecoration(
color: isHovering
? accent.withValues(alpha: 0.16)
    : kPaper,

borderRadius: BorderRadius.circular(22),

border: Border.all(
color: isHovering ? accent : kTwine,
width: isHovering ? 2.5 : 1.5,
),

boxShadow: [
BoxShadow(
color: kWoodDark.withValues(
alpha: isHovering ? 0.30 : 0.16,
),
blurRadius: isHovering ? 22 : 12,
offset: const Offset(0, 7),
),
],
),

child: ClipRRect(
borderRadius: BorderRadius.circular(21),

child: Column(
children: [
Expanded(
child: Padding(
padding: const EdgeInsets.fromLTRB(
16,
16,
16,
10,
),

child: Column(
crossAxisAlignment: CrossAxisAlignment.start,

children: [
// -----------------------------------------------------
// SECTION HEADER
// -----------------------------------------------------

Row(
children: [
Container(
padding: const EdgeInsets.all(8),

decoration: BoxDecoration(
color: accent.withValues(
alpha: 0.18,
),
borderRadius: BorderRadius.circular(12),
border: Border.all(
color: accent.withValues(
alpha: 0.45,
),
),
),

child: Icon(
icon,
size: 19,
color: accent,
),
),

const SizedBox(width: 11),

Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [
Text(
title,
style: const TextStyle(
fontSize: 21,
fontWeight: FontWeight.w800,
color: kInk,
),
),

const SizedBox(height: 2),

Text(
subtitle,
style: TextStyle(
fontSize: 12.5,
color: kInk.withValues(
alpha: 0.60,
),
),
),
],
),
),
],
),

const SizedBox(height: 10),

Container(
height: 1,
color: kTwine.withValues(
alpha: 0.8,
),
),

const SizedBox(height: 14),

// -----------------------------------------------------
// INGREDIENTS
// -----------------------------------------------------

Expanded(
child: items.isEmpty
? Center(
child: Column(
mainAxisSize: MainAxisSize.min,

children: [
Icon(
Icons.add_circle_outline,
size: 28,
color: accent.withValues(
alpha: 0.45,
),
),

const SizedBox(height: 8),

Text(
'Drag ingredients here',
style: TextStyle(
color: kInk.withValues(
alpha: 0.45,
),
fontWeight: FontWeight.w500,
),
),
],
),
)
    : SingleChildScrollView(
child: Wrap(
spacing: 12,
runSpacing: 12,

children: items.map((item) {
return IngredientTile(
item: item,
);
}).toList(),
),
),
),
],
),
),
),

// -------------------------------------------------------------
// WOODEN SHELF
// -------------------------------------------------------------

Container(
height: 13,

decoration: const BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topCenter,
end: Alignment.bottomCenter,
colors: [
kWood,
kWoodDark,
],
),
),
),
],
),
),
);
},
);
}
}
