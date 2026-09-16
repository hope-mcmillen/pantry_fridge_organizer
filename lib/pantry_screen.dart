import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------
// PANTRY PALETTE
//
// Warm paper, twine and wood tones. Tune the look of the whole screen here.
// -----------------------------------------------------------------------------

const Color kInk = Color(0xFF4A3524); // dark cocoa text
const Color kCream = Color(0xFFFBF3E4); // label paper
const Color kPaper = Color(0xFFF1E2C8); // shelf paper
const Color kTwine = Color(0xFFD9BE96); // hairlines + borders
const Color kWood = Color(0xFF9C6B43); // shelf board
const Color kWoodDark = Color(0xFF7A5133); // shelf board underside
const Color kSage = Color(0xFF7E9068); // accent -> "In My Fridge"
const Color kTerracotta = Color(0xFFC0703F); // accent -> "Need to Buy"

class PantryScreen extends StatefulWidget {
  const PantryScreen({super.key});

  @override
  State<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
  // Temporary starter ingredients.
  // Later, these can be replaced with your actual ingredient data.
  final List<String> inFridge = [
    'Milk',
    'Eggs',
    'Cheese',
    'Butter',
  ];

  final List<String> needToBuy = [
    'Chicken',
    'Tomatoes',
    'Apples',
    'Yogurt',
  ];

  // Moves an ingredient into the fridge.
  void moveToFridge(String item) {
    setState(() {
      needToBuy.remove(item);

      if (!inFridge.contains(item)) {
        inFridge.add(item);
      }
    });
  }

  // Moves an ingredient into the shopping list.
  void moveToNeedToBuy(String item) {
    setState(() {
      inFridge.remove(item);

      if (!needToBuy.contains(item)) {
        needToBuy.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Let the shelf paper run all the way up behind the status bar.
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
        // THE BACKGROUND: warm cream shelf paper.
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kCream, kPaper],
          ),
        ),

        // A faint gingham weave painted over the paper, so the backdrop has
        // texture instead of reading as flat colour.
        child: CustomPaint(
          painter: _GinghamPainter(),

          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Column(
                children: [
                  // The prompt, set on a little recipe card.
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 11,
                    ),

                    decoration: BoxDecoration(
                      color: kCream,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: kTwine, width: 1.4),
                      boxShadow: [
                        BoxShadow(
                          color: kWoodDark.withValues(alpha: 0.12),
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

                  // IN MY FRIDGE SECTION
                  Expanded(
                    child: PantrySection(
                      title: 'In My Fridge',
                      subtitle: 'Drag ingredients here if you have them',
                      items: inFridge,
                      onAccept: moveToFridge,
                      accent: kSage,
                      icon: Icons.kitchen_outlined,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // NEED TO BUY SECTION
                  Expanded(
                    child: PantrySection(
                      title: 'Need to Buy',
                      subtitle: 'Drag ingredients here if you need them',
                      items: needToBuy,
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
// GINGHAM BACKDROP
//
// Faint kitchen-cloth check drawn behind everything.
// -----------------------------------------------------------------------------

class _GinghamPainter extends CustomPainter {
  static const double _spacing = 26;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kWood.withValues(alpha: 0.035)
      ..strokeWidth = 9;

    for (double x = 0; x < size.width; x += _spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += _spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GinghamPainter oldDelegate) => false;
}

// -----------------------------------------------------------------------------
// PANTRY SECTION
//
// A shelf: paper-backed cubby with a wooden board along the bottom.
// -----------------------------------------------------------------------------

class PantrySection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> items;
  final Function(String) onAccept;

  // Colour + glyph that identify this shelf at a glance.
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
    return DragTarget<String>(
      onAcceptWithDetails: (details) {
        onAccept(details.data);
      },

      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,

          width: double.infinity,

          decoration: BoxDecoration(
            // Deeper than the cards, so the cream labels sit forward of it.
            color: isHovering
                ? accent.withValues(alpha: 0.16)
                : kPaper,

            borderRadius: BorderRadius.circular(22),

            border: Border.all(
              color: isHovering
                  ? accent
                  : kTwine,
              width: isHovering ? 2.5 : 1.5,
            ),

            boxShadow: [
              BoxShadow(
                color: kWoodDark.withValues(alpha: isHovering ? 0.30 : 0.16),
                blurRadius: isHovering ? 22 : 12,
                offset: const Offset(0, 7),
              ),
            ],
          ),

          // Clip so the wooden board tucks into the rounded bottom corners.
          child: ClipRRect(
            borderRadius: BorderRadius.circular(21),

            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SHELF LABEL: glyph plaque + title over subtitle
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),

                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: accent.withValues(alpha: 0.45),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      color: kInk.withValues(alpha: 0.60),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Twine rule under the label.
                        Container(
                          height: 1,
                          color: kTwine.withValues(alpha: 0.8),
                        ),

                        const SizedBox(height: 14),

                        Expanded(
                          child: items.isEmpty
                              ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add_circle_outline,
                                  size: 28,
                                  color: accent.withValues(alpha: 0.45),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  'Drag ingredients here',
                                  style: TextStyle(
                                    color: kInk.withValues(alpha: 0.45),
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
                              children: items
                                  .map(
                                    (item) => IngredientTile(
                                  name: item,
                                ),
                              )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // THE SHELF BOARD
                Container(
                  height: 13,

                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [kWood, kWoodDark],
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

// -----------------------------------------------------------------------------
// INGREDIENT TILE
// -----------------------------------------------------------------------------

class IngredientTile extends StatelessWidget {
  final String name;

  const IngredientTile({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: name,

      // What appears underneath your finger while dragging.
      feedback: Material(
        color: Colors.transparent,
        child: IngredientCard(
          name: name,
          dragging: true,
        ),
      ),

      // What stays behind while the item is being dragged.
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: IngredientCard(
          name: name,
        ),
      ),

      child: IngredientCard(
        name: name,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// INGREDIENT CARD
//
// A jar label: paper card, twine rule, hand-written-weight name.
// -----------------------------------------------------------------------------

class IngredientCard extends StatelessWidget {
  final String name;
  final bool dragging;

  const IngredientCard({
    super.key,
    required this.name,
    this.dragging = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.fromLTRB(7, 9, 7, 10),

      decoration: BoxDecoration(
        color: kCream,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(
          color: dragging
              ? kWood
              : kTwine,
          width: 1.4,
        ),

        boxShadow: [
          BoxShadow(
            color: kWoodDark.withValues(alpha: dragging ? 0.32 : 0.16),
            blurRadius: dragging ? 14 : 5,
            offset: Offset(0, dragging ? 7 : 3),
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // -----------------------------------------------------------
          // IMAGE PLACEHOLDER
          //
          // Your hand-drawn ingredient images can replace this later:
          // swap the Icon below for Image.asset('images/<name>.png').
          // -----------------------------------------------------------

          Container(
            width: 54,
            height: 54,

            decoration: BoxDecoration(
              color: kPaper.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: kTwine.withValues(alpha: 0.75),
              ),
            ),

            child: Icon(
              Icons.image_outlined,
              size: 27,
              color: kWood.withValues(alpha: 0.55),
            ),
          ),

          const SizedBox(height: 8),

          // Twine rule, like the crease on a jar label.
          Container(
            height: 1,
            width: 42,
            color: kTwine,
          ),

          const SizedBox(height: 7),

          Text(
            name,
            textAlign: TextAlign.center,

            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: kInk,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
