// pages/score_history/score_history_page.dart - Kid-Friendly for Special Needs
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/home/score_history/score_history_controller.dart';
import 'package:flutter_application_2/pages/score_tracking/score_model.dart';
import 'package:get/get.dart';

class ScoreHistoryPage extends StatelessWidget {
  const ScoreHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ScoreHistoryController());

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Color(0xFFF5F8FF), // Soft blue background
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar with fun design
            _buildKidsAppBar(controller, screenWidth, isTablet),

            // Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
                  return _buildKidsLoadingState(
                    screenWidth,
                    screenHeight,
                    isTablet,
                  );
                }

                if (controller.errorMessage.isNotEmpty) {
                  return _buildKidsErrorState(
                    controller,
                    screenWidth,
                    screenHeight,
                    isTablet,
                  );
                }

                if (!controller.hasScores) {
                  return _buildKidsEmptyState(
                    screenWidth,
                    screenHeight,
                    isTablet,
                  );
                }

                return Column(
                  children: [
                    // Fun Statistics Card with Achievement Badges inside
                    _buildKidsStatisticsCard(controller, screenWidth, isTablet),

                    // Score List with fun design (more space now)
                    Expanded(
                      child: _buildKidsScoreList(
                        controller,
                        screenWidth,
                        isTablet,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),

      // Bottom Navigation with bigger buttons
      bottomNavigationBar: Container(
        child: _buildKidsBottomNavBar(controller, screenWidth, isTablet),
      ),
    );
  }

  // Kids-friendly App Bar with cheerful colors (without back button)
  Widget _buildKidsAppBar(
    ScoreHistoryController controller,
    double screenWidth,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF4CAF50), // Green
            Color(0xFF8BC34A), // Light green
            Color(0xFFFFC107), // Yellow
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(isTablet ? 35 : 30),
          bottomRight: Radius.circular(isTablet ? 35 : 30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Title with fun emoji (takes more space now)
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Center alignment
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center the title
                      children: [
                        Text(
                          '📚 Buku Nilai',
                          style: TextStyle(
                            fontSize: isTablet ? 28 : 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 4,
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Obx(
                      () => Text(
                        controller.hasScores
                            ? '🎉 ${controller.scores.length} quiz sudah selesai!'
                            : '🌟 Ayo mulai quiz pertamamu!',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          color: Colors.white.withOpacity(0.95),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              // Refresh button with animation
              GestureDetector(
                onTap: () => controller.refreshScores(),
                child: Container(
                  padding: EdgeInsets.all(isTablet ? 16 : 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.refresh,
                    color: Color(0xFF2196F3),
                    size: isTablet ? 28 : 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Fun loading state with animated characters
  Widget _buildKidsLoadingState(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated loading character
          Container(
            width: isTablet ? 120 : 100,
            height: isTablet ? 120 : 100,
            decoration: BoxDecoration(
              color: Colors.orange[100],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('🐱', style: TextStyle(fontSize: isTablet ? 60 : 50)),
            ),
          ),
          SizedBox(height: isTablet ? 32 : 24),

          CircularProgressIndicator(color: Colors.orange[600], strokeWidth: 4),
          SizedBox(height: isTablet ? 24 : 16),

          Text(
            '🔍 Mencari buku nilai...',
            style: TextStyle(
              fontSize: isTablet ? 22 : 18,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tunggu sebentar ya! 😊',
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Kid-friendly error state
  Widget _buildKidsErrorState(
    ScoreHistoryController controller,
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 32 : 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isTablet ? 120 : 100,
              height: isTablet ? 120 : 100,
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '😔',
                  style: TextStyle(fontSize: isTablet ? 60 : 50),
                ),
              ),
            ),
            SizedBox(height: isTablet ? 32 : 24),

            Text(
              'Oops! Ada masalah',
              style: TextStyle(
                fontSize: isTablet ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.red[600],
              ),
            ),
            SizedBox(height: isTablet ? 16 : 12),

            Text(
              'Buku nilai tidak bisa dibuka sekarang',
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isTablet ? 32 : 24),

            ElevatedButton.icon(
              onPressed: () => controller.refreshScores(),
              icon: Icon(Icons.refresh, size: isTablet ? 28 : 24),
              label: Text(
                'Coba Lagi',
                style: TextStyle(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[600],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 24,
                  vertical: isTablet ? 16 : 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isTablet ? 25 : 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Cheerful empty state
  Widget _buildKidsEmptyState(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 32 : 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.1),

            // Big friendly illustration
            Container(
              width: isTablet ? 200 : 160,
              height: isTablet ? 200 : 160,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[100]!, Colors.purple[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '📝',
                  style: TextStyle(fontSize: isTablet ? 80 : 64),
                ),
              ),
            ),
            SizedBox(height: isTablet ? 40 : 32),

            Text(
              '🌟 Buku Nilai Kosong',
              style: TextStyle(
                fontSize: isTablet ? 28 : 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: isTablet ? 16 : 12),

            Text(
              'Ayo mulai quiz pertamamu!\nKamu pasti bisa! 💪',
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                color: Colors.grey[700],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isTablet ? 40 : 32),

            // Big colorful start button
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[400]!, Colors.blue[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(isTablet ? 30 : 25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => Get.back(),
                icon: Text(
                  '🎯',
                  style: TextStyle(fontSize: isTablet ? 28 : 24),
                ),
                label: Text(
                  'Mulai Quiz!',
                  style: TextStyle(
                    fontSize: isTablet ? 22 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 40 : 32,
                    vertical: isTablet ? 20 : 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isTablet ? 30 : 25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fun statistics card with emojis, colors, and achievement badges (compact version)
  Widget _buildKidsStatisticsCard(
    ScoreHistoryController controller,
    double screenWidth,
    bool isTablet,
  ) {
    return Obx(() {
      final stats = controller.getStatistics();
      if (stats.isEmpty) return SizedBox.shrink();

      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: isTablet ? 24 : 20,
          vertical: isTablet ? 16 : 12,
        ),
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE1F5FE), // Light blue
              Color(0xFFF3E5F5), // Light purple
              Color(0xFFFFF3E0), // Light orange
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
          border: Border.all(color: Colors.blue[200]!, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Compact header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('📊', style: TextStyle(fontSize: isTablet ? 24 : 20)),
                SizedBox(width: isTablet ? 8 : 6),
                Text(
                  'Laporan Kamu',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 16 : 12),

            // Compact stats in horizontal layout
            Row(
              children: [
                Expanded(
                  child: _buildKidsStatItemCompact(
                    '🎯',
                    'Rata-rata',
                    '${stats['average'].toStringAsFixed(0)}',
                    Colors.blue,
                    isTablet,
                  ),
                ),
                SizedBox(width: isTablet ? 12 : 8),
                Expanded(
                  child: _buildKidsStatItemCompact(
                    '⭐',
                    'Terbaik',
                    '${stats['highest'].toStringAsFixed(0)}',
                    Colors.amber,
                    isTablet,
                  ),
                ),
                SizedBox(width: isTablet ? 12 : 8),
                Expanded(
                  child: _buildKidsStatItemCompact(
                    '🏆',
                    'Total',
                    '${stats['total_quizzes']}',
                    Colors.green,
                    isTablet,
                  ),
                ),
              ],
            ),

            // Achievement badges moved here (compact version)
            SizedBox(height: isTablet ? 16 : 12),
            _buildAchievementBadgesInline(controller, isTablet),
          ],
        ),
      );
    });
  }

  // Compact version of stat items
  Widget _buildKidsStatItemCompact(
    String emoji,
    String label,
    String value,
    Color color,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 12 : 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: isTablet ? 20 : 18)),
          SizedBox(height: isTablet ? 6 : 4),
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: isTablet ? 2 : 1),
          Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 11 : 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Achievement badges inline (compact version)
  Widget _buildAchievementBadgesInline(
    ScoreHistoryController controller,
    bool isTablet,
  ) {
    return Obx(() {
      if (controller.scores.isEmpty) return SizedBox.shrink();

      final bestScores = controller.getBestScores();
      List<Widget> badges = [];

      // Check achievements
      if (bestScores.isNotEmpty && bestScores.first.score >= 90) {
        badges.add(
          _buildAchievementBadgeSmall('🌟', 'Bintang!', Colors.amber, isTablet),
        );
      }
      if (controller.scores.length >= 5) {
        badges.add(
          _buildAchievementBadgeSmall('🎯', 'Rajin!', Colors.blue, isTablet),
        );
      }
      if (controller.scores.length >= 10) {
        badges.add(
          _buildAchievementBadgeSmall('🏆', 'Juara!', Colors.green, isTablet),
        );
      }

      if (badges.isEmpty) return SizedBox.shrink();

      return Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 12 : 10,
              vertical: isTablet ? 6 : 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
              border: Border.all(color: Colors.purple[200]!, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🏅', style: TextStyle(fontSize: isTablet ? 16 : 14)),
                SizedBox(width: isTablet ? 6 : 4),
                Text(
                  'Pencapaian',
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[800],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Wrap(
            spacing: isTablet ? 8 : 6,
            runSpacing: isTablet ? 6 : 4,
            alignment: WrapAlignment.center,
            children: badges,
          ),
        ],
      );
    });
  }

  Widget _buildAchievementBadgeSmall(
    String emoji,
    String title,
    Color color,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 12 : 10,
        vertical: isTablet ? 8 : 6,
      ),
      decoration: BoxDecoration(
        // Gunakan background putih dengan sedikit tint warna
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        border: Border.all(
          color: color,
          width: 2,
        ), // Border lebih tebal untuk kontras
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: TextStyle(fontSize: isTablet ? 16 : 14)),
          SizedBox(width: isTablet ? 6 : 4),
          Text(
            title,
            style: TextStyle(
              fontSize: isTablet ? 12 : 11,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(
                0.9,
              ), // Sedikit transparan untuk softer look
              shadows: [
                // Tambahkan shadow untuk kontras lebih baik
                Shadow(
                  offset: Offset(0.5, 0.5),
                  blurRadius: 1,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKidsStatItem(
    String emoji,
    String label,
    String value,
    Color color,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        border: Border.all(color: color.withOpacity(0.3)),
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
          Text(emoji, style: TextStyle(fontSize: isTablet ? 28 : 24)),
          SizedBox(height: isTablet ? 8 : 4),
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: isTablet ? 4 : 2),
          Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 14 : 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Remove the separate achievement badges function since it's now integrated
  // Achievement badges are now inside the statistics card

  // Fun score list with animal themes
  Widget _buildKidsScoreList(
    ScoreHistoryController controller,
    double screenWidth,
    bool isTablet,
  ) {
    return Obx(
      () => RefreshIndicator(
        onRefresh: () => controller.refreshScores(),
        color: Colors.orange[600],
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 20),
          itemCount: controller.scores.length,
          itemBuilder: (context, index) {
            final score = controller.scores[index];
            return _buildKidsScoreCard(score, index, screenWidth, isTablet);
          },
        ),
      ),
    );
  }

  Widget _buildKidsScoreCard(
    ScoreModel score,
    int index,
    double screenWidth,
    bool isTablet,
  ) {
    // Fun animal emojis based on score
    String animalEmoji =
        score.score >= 90
            ? '🦁'
            : score.score >= 80
            ? '🐯'
            : score.score >= 70
            ? '🐻'
            : score.score >= 60
            ? '🐶'
            : '🐱';

    Color scoreColor =
        score.score >= 80
            ? Colors.green
            : score.score >= 60
            ? Colors.orange
            : Colors.red;

    // Fun gradient colors
    List<Color> cardGradient =
        score.score >= 80
            ? [Colors.green[50]!, Colors.blue[50]!]
            : score.score >= 60
            ? [Colors.orange[50]!, Colors.yellow[50]!]
            : [Colors.red[50]!, Colors.pink[50]!];

    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: cardGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isTablet ? 25 : 20),
        border: Border.all(color: scoreColor.withOpacity(0.3), width: 3),
        boxShadow: [
          BoxShadow(
            color: scoreColor.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Big score circle with animal
          Container(
            width: isTablet ? 100 : 80,
            height: isTablet ? 100 : 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  scoreColor.withOpacity(0.2),
                  scoreColor.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(color: scoreColor, width: 3),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  animalEmoji,
                  style: TextStyle(fontSize: isTablet ? 24 : 20),
                ),
                Text(
                  '${score.score.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.bold,
                    color: scoreColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: isTablet ? 24 : 20),

          // Score details with fun design
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '📚 ${score.category}',
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    // Big grade badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 16 : 12,
                        vertical: isTablet ? 8 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: scoreColor,
                        borderRadius: BorderRadius.circular(isTablet ? 15 : 12),
                        boxShadow: [
                          BoxShadow(
                            color: scoreColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        score.grade,
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 12 : 8),

                // Fun score description
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 12 : 8,
                    vertical: isTablet ? 8 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
                    border: Border.all(color: scoreColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    '✅ ${score.correctAnswers} benar dari ${score.totalQuestions} soal',
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 12 : 8),

                // Time and date with icons
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 8 : 6,
                        vertical: isTablet ? 4 : 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(isTablet ? 8 : 6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '⏰',
                            style: TextStyle(fontSize: isTablet ? 16 : 14),
                          ),
                          SizedBox(width: 4),
                          Text(
                            _formatDuration(score.duration),
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 12,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: isTablet ? 12 : 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 8 : 6,
                        vertical: isTablet ? 4 : 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple[50],
                        borderRadius: BorderRadius.circular(isTablet ? 8 : 6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '📅',
                            style: TextStyle(fontSize: isTablet ? 16 : 14),
                          ),
                          SizedBox(width: 4),
                          Text(
                            _formatDate(score.dateTime),
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 12,
                              color: Colors.purple[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKidsBottomNavBar(
    ScoreHistoryController controller,
    double screenWidth,
    bool isTablet,
  ) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 40, // ← Angkat navbar dari navigasi Android
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFF8F9FA)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        // ← Hapus borderRadius
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Container(
        height: isTablet ? 75 : 65, // ← Responsive height
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 3, // ← Padding ditambah sedikit
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home Button
            _buildKidsNavItemReadable(
              emoji: '🏠',
              label: 'Beranda',
              isActive: false,
              color: Colors.blue,
              onTap: () => controller.navigateToHome(),
            ),

            // Score History Button (Active)
            _buildKidsNavItemReadable(
              emoji: '📚',
              label: 'Nilai',
              isActive: true,
              color: Colors.orange,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKidsNavItemReadable({
    required String emoji,
    required String label,
    required bool isActive,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 4, // ← Padding diperbesar
        ),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.15) : Colors.transparent,
          // ← Hapus borderRadius (kotak persegi)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 24, // ← Tinggi emoji diperbesar
              child: Text(
                emoji,
                style: TextStyle(
                  fontSize: 20,
                ), // ← Emoji diperbesar dari 14 ke 20
              ),
            ),
            SizedBox(height: 2), // ← Spacing diperbesar sedikit
            Container(
              height: 20, // ← Tinggi text diperbesar
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14, // ← Font diperbesar dari 9 ke 12
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                  color: isActive ? color : Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for formatting
  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '${seconds} detik';
    } else {
      int minutes = seconds ~/ 60;
      int remainingSeconds = seconds % 60;
      if (remainingSeconds > 0) {
        return '${minutes}m ${remainingSeconds}d';
      } else {
        return '${minutes} menit';
      }
    }
  }

  String _formatDate(DateTime date) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
