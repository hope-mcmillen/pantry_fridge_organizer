import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: const Text(
          'Pantry Organizer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'What do you have right now?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 20),

              // IN MY FRIDGE SECTION
              Expanded(
                child: PantrySection(
                  title: 'In My Fridge',
                  subtitle: 'Drag ingredients here if you have them',
                  items: inFridge,
                  onAccept: moveToFridge,
                ),
              ),

              const SizedBox(height: 16),

              // NEED TO BUY SECTION
              Expanded(
                child: PantrySection(
                  title: 'Need to Buy',
                  subtitle: 'Drag ingredients here if you need them',
                  items: needToBuy,
                  onAccept: moveToNeedToBuy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// PANTRY SECTION
// -----------------------------------------------------------------------------

class PantrySection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> items;
  final Function(String) onAccept;

  const PantrySection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.onAccept,
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
          duration: const Duration(milliseconds: 200),

          width: double.infinity,

          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: isHovering
                ? Colors.green.shade100
                : Colors.grey.shade100,

            borderRadius: BorderRadius.circular(20),

            border: Border.all(
              color: isHovering
                  ? Colors.green
                  : Colors.grey.shade300,
              width: isHovering ? 2 : 1,
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: items.isEmpty
                    ? const Center(
                  child: Text(
                    'Drag ingredients here',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
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
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 8,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(15),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: dragging ? 10 : 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // -----------------------------------------------------------
          // IMAGE PLACEHOLDER
          //
          // Your hand-drawn ingredient images can replace this later.
          // -----------------------------------------------------------

          Container(
            width: 50,
            height: 50,

            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),

            child: const Icon(
              Icons.image_outlined,
              size: 30,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            name,
            textAlign: TextAlign.center,

            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}