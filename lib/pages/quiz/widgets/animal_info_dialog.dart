// pages/quiz/widgets/animal_info_dialog.dart
import 'package:flutter/material.dart';

class AnimalInfoDialog extends StatefulWidget {
  final String animalName;
  final String description;
  final String? imageUrl;
  final VoidCallback onNext;
  final bool isCorrect;
  final String? selectedAnswer; // Tambahkan jawaban yang dipilih user

  const AnimalInfoDialog({
    Key? key,
    required this.animalName,
    required this.description,
    this.imageUrl,
    required this.onNext,
    required this.isCorrect,
    this.selectedAnswer,
  }) : super(key: key);

  @override
  State<AnimalInfoDialog> createState() => _AnimalInfoDialogState();
}

class _AnimalInfoDialogState extends State<AnimalInfoDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Method untuk mendapatkan pesan berdasarkan apakah jawaban benar/salah
  String _getMessage() {
    if (widget.isCorrect) {
      return "HEBAT! 🌟";
    } else {
      List<String> encouragingMessages = [
        "HAMPIR! 💡",
        "BAGUS! 👏",
        "SEMANGAT! 💪",
        "JANGAN MENYERAH! 🌈",
        "TERUS BELAJAR! 📚",
      ];
      return encouragingMessages[DateTime.now().millisecond %
          encouragingMessages.length];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Main dialog container dengan decorasi menarik
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors:
                          widget.isCorrect
                              ? [Colors.green[50]!, Colors.green[100]!]
                              : [
                                Colors.blue[50]!,
                                Colors.blue[100]!,
                              ], // Warna biru untuk jawaban salah
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Floating decorative circles
                      Positioned(
                        top: -20,
                        right: -20,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color:
                                widget.isCorrect
                                    ? Colors.green[200]?.withOpacity(0.3)
                                    : Colors.blue[200]?.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -10,
                        left: -10,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color:
                                widget.isCorrect
                                    ? Colors.green[200]?.withOpacity(0.3)
                                    : Colors.blue[200]?.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // Fun icon with bounce animation
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.bounceOut,
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      gradient: RadialGradient(
                                        colors:
                                            widget.isCorrect
                                                ? [
                                                  Colors.green[400]!,
                                                  Colors.green[600]!,
                                                ]
                                                : [
                                                  Colors.blue[400]!,
                                                  Colors.blue[600]!,
                                                ], // Biru untuk salah
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: (widget.isCorrect
                                                  ? Colors.green
                                                  : Colors.blue)
                                              .withOpacity(0.4),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      widget.isCorrect
                                          ? Icons.star
                                          : Icons
                                              .psychology, // Brain icon untuk belajar
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),

                            // Fun title dengan pesan beragam
                            Text(
                              _getMessage(),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color:
                                    widget.isCorrect
                                        ? Colors.green[700]
                                        : Colors.blue[700],
                                letterSpacing: 1.5,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(1, 1),
                                    blurRadius: 3,
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Motivational message for incorrect answers
                            if (!widget.isCorrect)
                              Text(
                                "Kamu sudah berusaha dengan baik!",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue[700],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            const SizedBox(height: 20),

                            // Description in a fancy card
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Untuk jawaban salah, tampilkan koreksi
                                  if (!widget.isCorrect &&
                                      widget.selectedAnswer != null)
                                    Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.orange[50],
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Text(
                                            "Kamu menjawab: ${widget.selectedAnswer}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.orange[600],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green[50],
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Text(
                                            "Jawaban yang benar: ${widget.animalName}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.green[600],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                      ],
                                    ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 4,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color:
                                              widget.isCorrect
                                                  ? Colors.green
                                                  : Colors.blue,
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          widget.description,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                            height: 1.5,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Fancy next button dengan pesan berbeda
                            ElevatedButton(
                              onPressed: widget.onNext,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    widget.isCorrect
                                        ? Colors.blueAccent
                                        : Colors.indigo,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5,
                                shadowColor: Colors.blueAccent.withOpacity(0.4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.isCorrect
                                        ? "Lanjut Yuk!"
                                        : "Ayo Coba Lagi!",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Preview section dengan styling yang lebih menarik
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewButton(String letter) {
    return Container(
      width: 50,
      height: 35,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[400]!, Colors.grey[500]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
