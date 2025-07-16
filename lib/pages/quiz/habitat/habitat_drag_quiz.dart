import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/quiz/habitat/habitat_quiz_controller.dart';
import 'package:flutter_application_2/pages/quiz/habitat/model/habitatmodel.dart';
import 'package:flutter_application_2/pages/quiz/habitat/model/animalmodel.dart';
import 'package:get/get.dart';

class HabitatDragQuizPage extends StatelessWidget {
  const HabitatDragQuizPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.put(DragAndDropQuizController());

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
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => controller.onBackPressed(),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1.0),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.3),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Color.fromRGBO(33, 150, 243, 1.0),
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
                              color: Color.fromRGBO(69, 90, 100, 1.0),
                            ),
                          ),
                          const Text(
                            "Di mana hewan ini hidup?",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(99, 99, 99, 1),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                              Obx(() {
                                return Text(
                                  "${controller.score.value}/${controller.questions.length}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                  ),
                                );
                              }),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Progress bar untuk quiz
                          Obx(() {
                            double progress =
                                controller.questions.isEmpty
                                    ? 0.0
                                    : (controller.currentQuestionIndex.value +
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
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: GetBuilder<DragAndDropQuizController>(
                  id: 'quiz_body',
                  builder: (controller) {
                    if (controller.currentQuestion == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height - 200,
                        ),
                        child: Column(
                          children: [
                            // Enhanced Question Section dengan Rules
                            _buildEnhancedQuestionSection(controller),

                            // Hint Display Section
                            _buildHintSection(controller),

                            // Draggable animal image with flexible height
                            Container(
                              height: MediaQuery.of(context).size.height * 0.31,
                              padding: const EdgeInsets.all(16.0),
                              child: _buildDraggableAnimal(controller),
                            ),

                            // Hint Button
                            _buildHintButton(controller),

                            // Habitat options for dropping
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                children: [
                                  const Text(
                                    "Tarik hewan ke habitat yang sesuai:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(69, 90, 100, 1.0),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 150, // Increased from 130 to 150
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: controller.habitats.length,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            20, // Increased from 16 to 20
                                      ),
                                      itemBuilder: (context, index) {
                                        final habitat =
                                            controller.habitats[index];
                                        return _buildHabitatDropTarget(
                                          habitat,
                                          controller,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Enhanced Progress indicator
                            _buildEnhancedProgressSection(controller),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Enhanced Question Section dengan aturan sederhana
  Widget _buildEnhancedQuestionSection(DragAndDropQuizController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Question header
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 193, 7, 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.help_outline,
                  color: Color.fromRGBO(251, 140, 0, 1.0),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tebak Habitat!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(69, 90, 100, 1.0),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Text(
                        "Di mana ${controller.currentQuestion?.name ?? 'hewan ini'} hidup?",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(99, 99, 99, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Simple rules reminder
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.fromRGBO(240, 248, 255, 1.0),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
            ),
            child: Column(
              children: [
                Text(
                  "💡 Ingat aturan sederhana:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRuleItem('💧', 'Bisa berenang', '→ Air'),
                    _buildRuleItem('🏠', 'Dipelihara', '→ Rumah'),
                    _buildRuleItem('🌳', 'Hidup bebas', '→ Alam'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String emoji, String condition, String result) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(
            condition,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blue[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            result,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Hint Section
  Widget _buildHintSection(DragAndDropQuizController controller) {
    return Obx(() {
      if (!controller.showHint.value) {
        return SizedBox.shrink();
      }

      return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getHintColor(controller.currentHintLevel.value),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: _getHintBorderColor(controller.currentHintLevel.value),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getHintBorderColor(controller.currentHintLevel.value),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getHintIcon(controller.currentHintLevel.value),
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getHintTitle(controller.currentHintLevel.value),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _getHintBorderColor(
                        controller.currentHintLevel.value,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.getCurrentHint(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // Hint Button
  Widget _buildHintButton(DragAndDropQuizController controller) {
    return Obx(() {
      // Jika sudah dijawab, sembunyikan tombol hint
      if (controller.isAnswered.value) {
        return SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ElevatedButton(
          onPressed: () => controller.showNextHint(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(255, 193, 7, 1.0),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lightbulb_outline, size: 20, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                controller.currentHintLevel.value == 0
                    ? 'Butuh Bantuan?'
                    : controller.currentHintLevel.value < 3
                    ? 'Bantuan Lagi?'
                    : 'Lihat Jawaban',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Enhanced Progress Section
  Widget _buildEnhancedProgressSection(DragAndDropQuizController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Progress dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(controller.totalQuestions.value, (index) {
              bool isCompleted = index < controller.currentQuestionIndex.value;
              bool isCurrent = index == controller.currentQuestionIndex.value;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color:
                      isCompleted
                          ? Colors.green
                          : isCurrent
                          ? Colors.blue
                          : Colors.grey.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCurrent ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Center(
                  child:
                      isCompleted
                          ? Icon(Icons.check, color: Colors.white, size: 16)
                          : Text(
                            '${index + 1}',
                            style: TextStyle(
                              color:
                                  isCurrent ? Colors.white : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                ),
              );
            }),
          ),

          const SizedBox(height: 12),

          // Progress text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Obx(
                () => Text(
                  'Soal ${controller.currentQuestionIndex.value + 1} dari ${controller.totalQuestions.value}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[700],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Score display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(controller.totalQuestions.value, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(
                    Icons.star,
                    color:
                        index < controller.correctAnswers.value
                            ? Colors.amber
                            : Colors.grey[300],
                    size: 20,
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableAnimal(DragAndDropQuizController controller) {
    // Check if animal is already placed
    if (controller.isAnswered.value) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(8),
          constraints: BoxConstraints(maxWidth: 180, maxHeight: 180),
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color.fromRGBO(33, 150, 243, 0.5),
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 40,
                  color: Color.fromRGBO(76, 175, 80, 0.8),
                ),
                SizedBox(height: 12),
                Flexible(
                  child: Text(
                    "Hewan sudah dipindahkan",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(117, 117, 117, 1.0),
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate responsive sizes
          double maxWidth = constraints.maxWidth * 0.9;
          double maxHeight = constraints.maxHeight * 0.9;
          double containerSize = maxWidth > maxHeight ? maxHeight : maxWidth;
          containerSize = containerSize.clamp(150.0, 200.0);

          double imageHeight = containerSize * 0.7;

          return Draggable<String>(
            data: controller.currentQuestion!.id,
            feedback: Container(
              width: containerSize * 0.8,
              height: containerSize * 0.8,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  controller.currentQuestion!.imagePath,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                        strokeWidth: 3,
                        color: Color.fromRGBO(33, 150, 243, 1.0),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Color.fromRGBO(244, 67, 54, 0.1),
                      child: Icon(
                        Icons.pets,
                        size: 30,
                        color: Color.fromRGBO(244, 67, 54, 0.8),
                      ),
                    );
                  },
                ),
              ),
            ),
            childWhenDragging: Container(
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color.fromRGBO(33, 150, 243, 0.5),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Tarik ke habitat yang sesuai...",
                    style: TextStyle(
                      fontSize: containerSize > 180 ? 13 : 11,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(117, 117, 117, 1.0),
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            child: Container(
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1.0),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        controller.currentQuestion!.imagePath,
                        height: imageHeight,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            height: imageHeight,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                      strokeWidth: 4,
                                      backgroundColor: Color.fromRGBO(
                                        200,
                                        230,
                                        201,
                                        0.5,
                                      ),
                                      color: Color.fromRGBO(76, 175, 80, 0.8),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Loading...",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromRGBO(76, 175, 80, 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: imageHeight,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 235, 238, 0.5),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 40,
                                  color: Color.fromRGBO(244, 67, 54, 0.7),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    "Gambar tidak tersedia",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(244, 67, 54, 0.8),
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Text(
                        "Tarik ${controller.currentQuestion!.name} ke habitatnya!",
                        style: TextStyle(
                          fontSize: containerSize > 100 ? 16 : 11,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(69, 90, 100, 1.0),
                          height: 0.9, // Line height for better readability
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3, // Increased from 2 to 3 lines
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHabitatDropTarget(
    HabitatModel habitat,
    DragAndDropQuizController controller,
  ) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        final isHighlighted = candidateData.isNotEmpty;

        return Container(
          width: 120,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: habitat.color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            border:
                controller.currentAnimalHabitat.value == habitat.name
                    ? Border.all(
                      color: Color.fromRGBO(255, 255, 255, 1.0),
                      width: 3,
                    )
                    : isHighlighted
                    ? Border.all(
                      color: Color.fromRGBO(255, 255, 255, 0.8),
                      width: 2,
                      style: BorderStyle.solid,
                    )
                    : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              8.0,
            ), // Added padding inside container
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 3,
                  child: Obx(() {
                    // If this habitat has the animal
                    if (controller.currentAnimalHabitat.value == habitat.name) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.network(
                            controller.currentQuestion!.imagePath,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                          : null,
                                  strokeWidth: 2,
                                  color: habitat.color,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Color.fromRGBO(255, 255, 255, 0.5),
                                child: Icon(
                                  Icons.pets,
                                  color: habitat.color,
                                  size: 30,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }

                    // Default habitat icon - Enhanced dengan emoji dari model
                    return Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Emoji dari model (enhancement)
                            Text(
                              habitat.emoji ?? _getHabitatEmoji(habitat.name),
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 2),
                            // Icon fallback seperti kode asli
                            Icon(
                              habitat.icon ?? _getHabitatIcon(habitat.name),
                              color: Color.fromRGBO(255, 255, 255, 1.0),
                              size: 14, // Lebih kecil karena ada emoji
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 6),
                Flexible(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      habitat.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 255, 255, 1.0),
                        height: 1.2, // Line height for better spacing
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      onWillAccept: (data) => !controller.isAnswered.value,
      onAccept: (data) {
        controller.onDragAnimalToHabitat(habitat.name);
      },
    );
  }

  // Helper methods untuk hint system
  Color _getHintColor(int level) {
    switch (level) {
      case 1:
        return Color.fromRGBO(227, 242, 253, 1.0); // Light blue
      case 2:
        return Color.fromRGBO(255, 243, 224, 1.0); // Light orange
      case 3:
        return Color.fromRGBO(232, 245, 233, 1.0); // Light green
      default:
        return Color.fromRGBO(245, 245, 245, 1.0); // Light gray
    }
  }

  Color _getHintBorderColor(int level) {
    switch (level) {
      case 1:
        return Color.fromRGBO(33, 150, 243, 1.0); // Blue
      case 2:
        return Color.fromRGBO(255, 152, 0, 1.0); // Orange
      case 3:
        return Color.fromRGBO(76, 175, 80, 1.0); // Green
      default:
        return Color.fromRGBO(158, 158, 158, 1.0); // Gray
    }
  }

  IconData _getHintIcon(int level) {
    switch (level) {
      case 1:
        return Icons.help_outline;
      case 2:
        return Icons.rule;
      case 3:
        return Icons.visibility;
      default:
        return Icons.lightbulb_outline;
    }
  }

  String _getHintTitle(int level) {
    switch (level) {
      case 1:
        return 'Bantuan 1: Ciri-ciri Hewan';
      case 2:
        return 'Bantuan 2: Aturan Sederhana';
      case 3:
        return 'Bantuan 3: Jawaban';
      default:
        return 'Bantuan';
    }
  }

  // Helper methods untuk fallback jika model tidak memiliki emoji/icon
  String _getHabitatEmoji(String habitatName) {
    switch (habitatName) {
      case 'Air':
        return '💧';
      case 'Rumah':
        return '🏠';
      case 'Alam':
        return '🌳';
      case 'Hutan':
        return '🌲';
      case 'Padang Rumput':
        return '🌾';
      case 'Peternakan':
        return '🚜';
      case 'Laut':
        return '🌊';
      default:
        return '🌍';
    }
  }

  IconData _getHabitatIcon(String habitatName) {
    switch (habitatName) {
      case "Hutan":
        return Icons.forest;
      case "Laut":
        return Icons.water;
      case "Air":
        return Icons.water_drop;
      case "Padang Rumput":
        return Icons.grass;
      case "Rumah":
        return Icons.home;
      case "Peternakan":
        return Icons.agriculture;
      case "Alam":
        return Icons.forest;
      case "Kutub":
        return Icons.ac_unit;
      case "Gurun":
        return Icons.wb_sunny;
      case "Di mana saja":
        return Icons.public;
      default:
        return Icons.landscape;
    }
  }
}
