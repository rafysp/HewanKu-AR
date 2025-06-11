import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/quiz/puzzle/puzzle_controller.dart';
import 'package:flutter_application_2/pages/quiz/puzzle/widget/puzzle_piece.dart';
import 'package:get/get.dart';

class SimplePuzzlePage extends StatelessWidget {
  const SimplePuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(187, 222, 251, 1.0),
              Color.fromRGBO(255, 255, 255, 1.0),
            ],
          ),
        ),
        child: SafeArea(
          child: GetBuilder<SimplePuzzleController>(
            init: SimplePuzzleController(),
            builder: (controller) {
              return Obx(() => controller.isLoading.value
                  ? _buildLoadingScreen(controller)
                  : _buildPuzzleContent(controller)
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen(SimplePuzzleController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          SizedBox(height: 24),
          Text(
            'Memuat puzzle ${controller.currentAnimal.name}...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Sedang memotong gambar menjadi puzzle',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPuzzleContent(SimplePuzzleController controller) {
    return Column(
      children: [
        // App Bar
        _buildAppBar(controller),

        // Main content
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Instruction card
                  _buildInstructionCard(controller),
                  
                  const SizedBox(height: 16),

                  // Main puzzle area
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Puzzle grid (left side)
                      Expanded(
                        flex: 3,
                        child: _buildPuzzleGrid(controller),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Target preview (right side)
                      Expanded(
                        flex: 2,
                        child: _buildTargetPreview(controller),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Available puzzle pieces
                  _buildAvailablePieces(controller),

                  const SizedBox(height: 16),

                  // Progress and controls
                  _buildProgressAndControls(controller),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(SimplePuzzleController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => controller.onBackPressed(),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.blue,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.getGameTitle(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(69, 90, 100, 1.0),
                  ),
                ),
                Text(
                  "Susun bagian tubuh ${controller.currentAnimal.name}!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(117, 117, 117, 1.0),
                  ),
                ),
                // Add random animals info
                Text(
                  "🎲 ${controller.getSessionAnimalsCount()} dari ${controller.getTotalAnimalsCount()} hewan (acak)",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromRGBO(117, 117, 117, 1.0),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          // Score indicator
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 152, 0, 0.7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  "${controller.score.value}/${controller.animals.length}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildInstructionCard(SimplePuzzleController controller) {
    return Obx(() {
      int missingCount = controller.getMissingPiecesCount();
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color.fromRGBO(76, 175, 80, 0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '2',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(76, 175, 80, 1.0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ada 2 bagian yang hilang!",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(69, 90, 100, 1.0),
                    ),
                  ),
                  Text(
                    "Pilih bagian yang hilang, lalu ketuk slot yang kosong.",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(117, 117, 117, 1.0),
                    ),
                  ),
                ],
              ),
            ),
            // Hint button
            GestureDetector(
              onTap: () => controller.showHint(),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Colors.blue,
                      size: 24,
                    ),
                    Text(
                      'Bantuan',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPuzzleGrid(SimplePuzzleController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Puzzle ${controller.currentAnimal.name}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(69, 90, 100, 1.0),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Obx(() => Text(
                'Petunjuk: ${controller.hintsUsed.value}',
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(117, 117, 117, 1.0),
                ),
              )),
            ],
          ),
          const SizedBox(height: 12),
          
          // 2x2 Grid using enhanced widgets
          Container(
            width: 280,
            height: 280,
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return _buildEnhancedGridSlot(controller, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedGridSlot(SimplePuzzleController controller, int position) {
    return Obx(() {
      final piece = controller.getGridPiece(position);
      final isHighlighted = controller.selectedPieceIndex.value >= 0 && piece == null;
      
      return EnhancedPuzzleSlotWidget(
        piece: piece,
        size: 130,
        slotIndex: position,
        isHighlighted: isHighlighted,
        onTap: () => controller.placePiece(position),
      );
    });
  }

  Widget _buildTargetPreview(SimplePuzzleController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Target Hewan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(69, 90, 100, 1.0),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                controller.currentAnimal.fullImagePath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 3,
                        color: Colors.blue,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.pets,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          controller.currentAnimal.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(69, 90, 100, 1.0),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.currentAnimal.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(69, 90, 100, 1.0),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '🔊 ${controller.currentAnimal.sound}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: controller.currentAnimal.themeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailablePieces(SimplePuzzleController controller) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        return EnhancedAvailablePiecesWidget(
          pieces: controller.availablePieces,
          selectedIndex: controller.selectedPieceIndex.value,
          onPieceSelected: (index) => controller.selectPiece(index),
        );
      }),
    );
  }

  Widget _buildProgressAndControls(SimplePuzzleController controller) {
    return Column(
      children: [
        // Progress indicator
        Obx(() {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: controller.currentAnimal.themeColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Text('🧩', style: TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Puzzle ${controller.currentAnimalIndex.value + 1} dari ${controller.animals.length}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(69, 90, 100, 1.0),
                          ),
                        ),
                        Text(
                          "Bagian tersisa: ${controller.getMissingPiecesCount()}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(117, 117, 117, 1.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Petunjuk: ${controller.hintsUsed.value}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(117, 117, 117, 1.0),
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Visual indicator of missing pieces
                        for (int i = 0; i < 2; i++)
                          Container(
                            margin: EdgeInsets.only(left: 2),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: i < controller.availablePieces.length 
                                  ? Colors.orange 
                                  : Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 16),

        // Control buttons
        Row(
          children: [
            // Reset puzzle button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => controller.resetCurrentPuzzle(),
                icon: Icon(Icons.refresh, color: Colors.white),
                label: Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Shuffle animals button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => controller.shuffleAnimals(),
                icon: Icon(Icons.shuffle, color: Colors.white),
                label: Text(
                  'Acak',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[600],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Previous animal button
            Expanded(
              child: Obx(() => ElevatedButton.icon(
                onPressed: controller.currentAnimalIndex.value > 0 
                    ? () {
                        controller.currentAnimalIndex.value--;
                        controller.initializePuzzle();
                      }
                    : null,
                icon: Icon(Icons.arrow_back, color: Colors.white),
                label: Text(
                  'Sebelumnya',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.currentAnimalIndex.value > 0 
                      ? Colors.blue 
                      : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              )),
            ),
            
            const SizedBox(width: 8),
            
            // Next animal button
            Expanded(
              child: Obx(() => ElevatedButton.icon(
                onPressed: controller.currentAnimalIndex.value < controller.animals.length - 1 
                    ? () => controller.nextPuzzle()
                    : null,
                icon: Icon(Icons.arrow_forward, color: Colors.white),
                label: Text(
                  'Berikutnya',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.currentAnimalIndex.value < controller.animals.length - 1 
                      ? Colors.green 
                      : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              )),
            ),
          ],
        ),
      ],
    );
  }
}