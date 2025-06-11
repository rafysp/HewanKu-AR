import 'package:flutter/material.dart';

class ModelItem extends StatelessWidget {
  final String imageUrl;
  final String name;

  const ModelItem({Key? key, required this.imageUrl, required this.name})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 84, // Fixed height to prevent overflow
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 68, // Reduced height to fit within container
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 2), // Smaller spacing
          Text(
            name,
            style: const TextStyle(
              fontSize: 10, // Smaller font
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
