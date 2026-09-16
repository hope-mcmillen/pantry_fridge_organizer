import 'package:flutter/material.dart';

import '../models/pantry_items.dart';

class IngredientTile extends StatelessWidget {
  final PantryItem item;

  const IngredientTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<PantryItem>(
      data: item,

      // This is what follows the user's finger while dragging.
      feedback: Material(
        color: Colors.transparent,
        child: IngredientCard(
          item: item,
          isDragging: true,
        ),
      ),

      // This stays behind while the item is being dragged.
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: IngredientCard(
          item: item,
        ),
      ),

      // Normal appearance of the ingredient.
      child: IngredientCard(
        item: item,
      ),
    );
  }
}

class IngredientCard extends StatelessWidget {
  final PantryItem item;
  final bool isDragging;

  const IngredientCard({
    super.key,
    required this.item,
    this.isDragging = false,
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
            blurRadius: isDragging ? 10 : 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIngredientImage(),

          const SizedBox(height: 8),

          Text(
            item.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientImage() {
    // ---------------------------------------------------------
    // HAND-DRAWN IMAGE
    // ---------------------------------------------------------
    //
    // Once an imagePath has been provided, Flutter will display
    // your custom ingredient artwork.
    //
    // Example:
    // assets/ingredients/milk.png
    //
    // Until then, a placeholder image icon is displayed.
    // ---------------------------------------------------------

    if (item.imagePath != null && item.imagePath!.isNotEmpty) {
      return Container(
        width: 55,
        height: 55,
        padding: const EdgeInsets.all(4),
        child: Image.asset(
          item.imagePath!,
          fit: BoxFit.contain,

          // If Flutter cannot find the image, show the
          // placeholder instead of crashing the UI.
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder();
          },
        ),
      );
    }

    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.image_outlined,
        size: 30,
        color: Colors.grey,
      ),
    );
  }
}