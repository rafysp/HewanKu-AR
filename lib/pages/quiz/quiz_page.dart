// pages/quiz/quiz_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'quiz_controller.dart';

class QuizPage extends StatelessWidget {
  final QuizType quizType;
  final int categoryIndex;
  
  const QuizPage({
    Key? key, 
    required this.quizType,
    this.categoryIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hapus controller yang sudah ada untuk menghindari konflik
    Get.delete<QuizController>(force: true);
    
    final controller = Get.put(QuizController(
      quizType: quizType, 
      categoryIndex: categoryIndex
    ));
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[100]!,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Floating decorative elements
              Positioned(
                top: 20,
                right: 40,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.yellow[300]?.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: 100,
                left: 20,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.orange[300]?.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              
              Column(
                children: [
                  // Custom App Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                // Score indicator with stars
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ...List.generate(5, (index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 4),
                                          child: Icon(
                                            Icons.star,
                                            color: index < controller.score 
                                                ? Colors.amber 
                                                : Colors.grey[300],
                                            size: 28,
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                                
                                // Question Image dengan border lucu
                                if (controller.currentQuestion?.imageUrl != null)
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.8,
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
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Container(
                                            color: Colors.grey[100],
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
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
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.red[50],
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
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
                                    child: Stack(
                                      children: [
                                        // Dekorasi balon dialog
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.yellow[300],
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Center(
                                              child: Text(
                                                '?',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          controller.currentQuestion!.questionText,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey,
                                            height: 1.4,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                
                                const SizedBox(height: 30),
                                
                                // Answer options dengan animasi
                                if (controller.currentQuestion != null)
                                  Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    alignment: WrapAlignment.center,
                                    children: List.generate(
                                      controller.currentQuestion!.options.length,
                                      (index) => GestureDetector(
                                        onTap: () => controller.onAnswerTap(index),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          width: (MediaQuery.of(context).size.width - 64) / 2,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            gradient: _getOptionGradient(controller, index),
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: _getOptionShadowColor(controller, index).withOpacity(0.4),
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
                                                    color: Colors.white.withOpacity(0.9),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      String.fromCharCode(97 + index).toUpperCase(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    controller.currentQuestion!.options[index],
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      shadows: [
                                                        Shadow(
                                                          offset: Offset(1, 1),
                                                          blurRadius: 3,
                                                          color: Colors.black26,
                                                        ),
                                                      ],
                                                    ),
                                                    textAlign: TextAlign.center,
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
                                
                                // Progress dengan emoji
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        '🎯',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Soal ${controller.currentQuestionIndex + 1} dari ${controller.questions.length}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
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
      return LinearGradient(
        colors: [
          Colors.blue[400]!,
          Colors.blue[600]!,
        ],
      );
    }
    
    if (index == controller.currentQuestion!.correctAnswer) {
      return LinearGradient(
        colors: [
          Colors.green[400]!,
          Colors.green[600]!,
        ],
      );
    } else if (index == controller.selectedAnswer && 
               index != controller.currentQuestion!.correctAnswer) {
      return LinearGradient(
        colors: [
          Colors.red[400]!,
          Colors.red[600]!,
        ],
      );
    } else {
      return LinearGradient(
        colors: [
          Colors.grey[400]!,
          Colors.grey[500]!,
        ],
      );
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