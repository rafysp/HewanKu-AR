// widgets/enhanced_puzzle_display.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/quiz/puzzle/model/puzzle_model.dart';

class EnhancedPuzzleSlotWidget extends StatelessWidget {
  final PuzzlePiece? piece;
  final double size;
  final VoidCallback? onTap;
  final int slotIndex;
  final bool isHighlighted;

  const EnhancedPuzzleSlotWidget({
    Key? key,
    this.piece,
    this.size = 130,
    this.onTap,
    required this.slotIndex,
    this.isHighlighted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: piece != null ? Colors.transparent : _getEmptySlotColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getBorderColor(),
            width: _getBorderWidth(),
          ),
          boxShadow: _getBoxShadow(),
        ),
        child: piece != null ? _buildFilledSlot() : _buildEmptySlot(),
      ),
    );
  }

  Widget _buildFilledSlot() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child:
                piece!.hasImage && piece!.pieceImage != null
                    ? Image(
                      image: piece!.pieceImage!,
                      fit:
                          BoxFit
                              .contain, // Changed to contain to show full image
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) {
                        return piece!.imageWidget;
                      },
                    )
                    : piece!.imageWidget,
          ),
        ),
        if (piece!.isFixed)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Icon(Icons.lock, color: Colors.white, size: 12),
            ),
          ),
        if (piece!.isPlaced && !piece!.isFixed)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Icon(Icons.check, color: Colors.white, size: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptySlot() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[100]!, Colors.grey[200]!],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            child: Icon(
              isHighlighted ? Icons.touch_app : Icons.add_circle_outline,
              size: isHighlighted ? 35 : 30, // Reduced from 45/40
              color: isHighlighted ? Colors.blue : Colors.blue.withOpacity(0.5),
            ),
          ),
          SizedBox(height: 4), // Reduced from 4
          Flexible(
            child: Text(
              'Slot ${slotIndex + 1}',
              style: TextStyle(
                fontSize: 12, // Reduced from 12
                color: Colors.grey[600],
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isHighlighted)
            Flexible(
              child: Container(
                margin: EdgeInsets.only(top: 2), // Reduced from 4
                padding: EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 1,
                ), // Reduced padding
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4), // Reduced from 8
                ),
                child: Text(
                  'Kosong',
                  style: TextStyle(
                    fontSize: 10, // Reduced from 10
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getEmptySlotColor() {
    if (isHighlighted) {
      return Colors.blue.withOpacity(0.1);
    }
    return Colors.grey[200]!;
  }

  Color _getBorderColor() {
    if (piece != null) {
      if (piece!.isFixed) {
        return Colors.green.withOpacity(0.7);
      } else if (piece!.isPlaced) {
        return Colors.green;
      }
      return Colors.transparent;
    }

    if (isHighlighted) {
      return Colors.blue;
    }
    return Colors.blue.withOpacity(0.5);
  }

  double _getBorderWidth() {
    if (isHighlighted || (piece != null && piece!.isPlaced)) {
      return 3;
    }
    return 2;
  }

  List<BoxShadow> _getBoxShadow() {
    if (isHighlighted) {
      return [
        BoxShadow(
          color: Colors.blue.withOpacity(0.3),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ];
    }

    if (piece != null && piece!.isPlaced) {
      return [
        BoxShadow(
          color: Colors.green.withOpacity(0.3),
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ];
    }

    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ];
  }
}

// Enhanced Available Pieces Widget
class EnhancedAvailablePiecesWidget extends StatelessWidget {
  final List<PuzzlePiece> pieces;
  final int selectedIndex;
  final Function(int) onPieceSelected;

  const EnhancedAvailablePiecesWidget({
    Key? key,
    required this.pieces,
    required this.selectedIndex,
    required this.onPieceSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (pieces.isEmpty) {
      return Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.celebration, size: 48, color: Colors.green),
            SizedBox(height: 8),
            Text(
              'Semua bagian sudah lengkap!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.touch_app, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Pilih bagian yang hilang (${pieces.length}/2):',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(pieces.length, (index) {
            final piece = pieces[index];
            final isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () => onPieceSelected(index),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isSelected ? Colors.blue : Colors.grey.withOpacity(0.3),
                    width: isSelected ? 3 : 2,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: piece.imageWidget,
                    ),
                    if (isSelected)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    // Remove the text label at bottom
                    // Positioned(
                    //   bottom: 4,
                    //   left: 4,
                    //   right: 4,
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    //     decoration: BoxDecoration(
                    //       color: Colors.black.withOpacity(0.7),
                    //       borderRadius: BorderRadius.circular(6),
                    //     ),
                    //     child: Text(
                    //       piece.pieceName,
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         fontSize: 10,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //       textAlign: TextAlign.center,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          }),
        ),
        // Remove the selected piece info section
        // if (selectedIndex >= 0 && selectedIndex < pieces.length)
        //   Container(
        //     margin: EdgeInsets.only(top: 12),
        //     padding: EdgeInsets.all(12),
        //     decoration: BoxDecoration(
        //       color: Colors.blue.withOpacity(0.1),
        //       borderRadius: BorderRadius.circular(8),
        //       border: Border.all(color: Colors.blue.withOpacity(0.3)),
        //     ),
        //     child: Row(
        //       children: [
        //         Icon(Icons.info_outline, color: Colors.blue, size: 20),
        //         SizedBox(width: 8),
        //         Expanded(
        //           child: Text(
        //             'Terpilih: ${pieces[selectedIndex].pieceName}\n${pieces[selectedIndex].description}',
        //             style: TextStyle(
        //               color: Colors.blue[700],
        //               fontSize: 12,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
      ],
    );
  }
}
