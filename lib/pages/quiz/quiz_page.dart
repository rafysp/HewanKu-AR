// pages/quiz/quiz_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/score_tracking/score_controller.dart'; // Import score controller
import 'package:get/get.dart';
import 'quiz_controller.dart';

class QuizPage extends StatelessWidget {
  final QuizType quizType;
  final int categoryIndex;

  const QuizPage({Key? key, required this.quizType, this.categoryIndex = 0})
    : super(key: key);

  // Helper method for responsive answer box height
  double _getResponsiveAnswerHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Significantly increased base height for better text accommodation
    double baseHeight = 120; // Increased from 80 to 120

    // Adjust based on screen size
    if (screenHeight > 800) {
      baseHeight = 140; // Taller for large screens
    } else if (screenHeight > 700) {
      baseHeight = 130; // Medium-tall screens
    } else if (screenHeight < 600) {
      baseHeight =
          110; // Shorter for small screens but still much taller than original
    }

    // Adjust for tablet/wide screens
    if (screenWidth > 600) {
      baseHeight += 15; // Extra height for tablets
    }

    return baseHeight;
  }

  // Helper method for responsive answer font size
  double _getResponsiveAnswerFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 600) {
      return 20; // Larger font for tablets
    } else if (screenWidth > 400) {
      return 18; // Default phones
    } else {
      return 16; // Smaller phones
    }
  }

  @override
  Widget build(BuildContext context) {
    // ============ TAMBAHAN: Pastikan ScoreController tersedia ============
    // Pastikan ScoreController sudah diinisialisasi
    if (!Get.isRegistered<ScoreController>()) {
      Get.put(ScoreController());
    }
    // ============ END TAMBAHAN ============

    Get.delete<QuizController>(force: true);

    final controller = Get.put(QuizController(quizType: quizType));

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[100]!, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // Custom App Bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        // Back button with face
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
                                  color: Colors.grey.withOpacity(0.3),
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
                                controller.getQuizTitle(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              const Text(
                                "Yuk, jawab soalnya!",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(99, 99, 99, 1),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ============ MODIFIKASI: Score indicator dengan progress bar ============
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Score dengan bintang
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  GetBuilder<QuizController>(
                                    id: 'score',
                                    builder: (controller) {
                                      return Text(
                                        "${controller.score}/${controller.questions.length}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              // Progress bar untuk soal
                              GetBuilder<QuizController>(
                                id: 'quiz_body',
                                builder: (controller) {
                                  double progress =
                                      controller.questions.isEmpty
                                          ? 0.0
                                          : (controller.currentQuestionIndex +
                                                  1) /
                                              controller.questions.length;

                                  return Container(
                                    width: 80,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: progress,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        // ============ END MODIFIKASI ============

                        // ============ TAMBAHAN: Timer Display ============
                        GetBuilder<QuizController>(
                          id: 'timer',
                          builder:
                              (controller) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                margin: const EdgeInsets.only(left: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      controller.getFormattedElapsedTime(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        ),
                        // ============ END TAMBAHAN ============
                      ],
                    ),
                  ),

                  Expanded(
                    child: GetBuilder<QuizController>(
                      id: 'quiz_body',
                      builder: (controller) {
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                // Question Image dengan border lucu
                                if (controller.currentQuestion?.imageUrl !=
                                    null)
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.blue[200]!,
                                        width: 6,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.network(
                                        controller.currentQuestion!.imageUrl!,
                                        fit: BoxFit.contain,
                                        loadingBuilder: (
                                          context,
                                          child,
                                          loadingProgress,
                                        ) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Container(
                                            color: Colors.grey[100],
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircularProgressIndicator(
                                                    color: Colors.blue,
                                                    strokeWidth: 5,
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Text(
                                                    'Tunggu ya...',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Container(
                                            color: Colors.red[50],
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.error_outline,
                                                  size: 50,
                                                  color: Colors.red[300],
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Ups! Gambar tidak bisa muncul',
                                                  style: TextStyle(
                                                    color: Colors.red[600],
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                const SizedBox(height: 20),

                                // Question text dalam balon dialog
                                if (controller.currentQuestion != null)
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      controller.currentQuestion!.questionText,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey,
                                        height: 1.4,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                const SizedBox(height: 30),

                                // Answer options dengan container yang lebih tinggi
                                if (controller.currentQuestion != null)
                                  Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    alignment: WrapAlignment.center,
                                    children: List.generate(
                                      controller
                                          .currentQuestion!
                                          .options
                                          .length,
                                      (index) => GestureDetector(
                                        onTap:
                                            () => controller.onAnswerTap(index),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          width:
                                              (MediaQuery.of(
                                                    context,
                                                  ).size.width -
                                                  64) /
                                              2,
                                          height: _getResponsiveAnswerHeight(
                                            context,
                                          ), // RESPONSIVE HEIGHT - INCREASED
                                          decoration: BoxDecoration(
                                            gradient: _getOptionGradient(
                                              controller,
                                              index,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: _getOptionShadowColor(
                                                  controller,
                                                  index,
                                                ).withOpacity(0.4),
                                                blurRadius: 6,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Stack(
                                            children: [
                                              // Letter circle
                                              Positioned(
                                                top: 10,
                                                left: 10,
                                                child: Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.9),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      String.fromCharCode(
                                                        97 + index,
                                                      ).toUpperCase(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal:
                                                            12.0, // Increased horizontal padding
                                                        vertical: 8.0,
                                                      ),
                                                  child: Text(
                                                    controller
                                                        .currentQuestion!
                                                        .options[index],
                                                    style: TextStyle(
                                                      fontSize:
                                                          _getResponsiveAnswerFontSize(
                                                            context,
                                                          ), // RESPONSIVE FONT
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      height:
                                                          1.2, // Better line spacing
                                                      shadows: [
                                                        Shadow(
                                                          offset: Offset(1, 1),
                                                          blurRadius: 3,
                                                          color: Colors.black26,
                                                        ),
                                                      ],
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    maxLines:
                                                        4, // Allow up to 4 lines for longer text
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                const SizedBox(height: 30),

                                // ============ MODIFIKASI: Progress dengan timer dan emoji ============
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      // Progress indicator
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            '🎯',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          const SizedBox(width: 8),
                                          GetBuilder<QuizController>(
                                            id: 'quiz_body',
                                            builder: (controller) {
                                              return Text(
                                                "Soal ${controller.currentQuestionIndex + 1} dari ${controller.questions.length}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueGrey,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Timer indicator (real-time update)
                                      GetBuilder<QuizController>(
                                        id: 'timer',
                                        builder: (controller) {
                                          return Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.timer_outlined,
                                                size: 16,
                                                color: Colors.grey[600],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                controller
                                                    .getFormattedElapsedTime(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                // ============ END MODIFIKASI ============
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper untuk gradient warna options
  LinearGradient _getOptionGradient(QuizController controller, int index) {
    if (!controller.isAnswered) {
      return LinearGradient(colors: [Colors.blue[400]!, Colors.blue[600]!]);
    }

    if (index == controller.currentQuestion!.correctAnswer) {
      return LinearGradient(colors: [Colors.green[400]!, Colors.green[600]!]);
    } else if (index == controller.selectedAnswer &&
        index != controller.currentQuestion!.correctAnswer) {
      return LinearGradient(colors: [Colors.red[400]!, Colors.red[600]!]);
    } else {
      return LinearGradient(colors: [Colors.grey[400]!, Colors.grey[500]!]);
    }
  }

  // Helper untuk shadow color
  Color _getOptionShadowColor(QuizController controller, int index) {
    if (!controller.isAnswered) {
      return Colors.blue;
    }

    if (index == controller.currentQuestion!.correctAnswer) {
      return Colors.green;
    } else if (index == controller.selectedAnswer &&
        index != controller.currentQuestion!.correctAnswer) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }
}
