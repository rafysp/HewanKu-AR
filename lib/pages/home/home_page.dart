// pages/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Responsive Top button with icon and text
              _buildTopButton(screenWidth, isTablet),

              // Responsive Carousel Fakta Hewan
              _buildFactsCarousel(controller, screenWidth, isTablet),

              SizedBox(height: _responsiveHeight(24, screenHeight)),

              // Responsive Section title for Learning Animals
              _buildSectionTitle(
                title: "Belajar Hewan",
                icon: Icons.menu_book,
                color: Colors.blue,
                screenWidth: screenWidth,
                isTablet: isTablet,
              ),

              SizedBox(height: _responsiveHeight(16, screenHeight)),

              // Responsive Featured section - Pengenalan Hewan
              _buildFeaturedSection(
                controller,
                screenWidth,
                screenHeight,
                isTablet,
              ),

              SizedBox(height: _responsiveHeight(24, screenHeight)),

              // Responsive Section title for Tanya Jawab
              _buildSectionTitle(
                title: "Tanya Jawab",
                icon: Icons.question_answer,
                color: Colors.orange,
                screenWidth: screenWidth,
                isTablet: isTablet,
              ),

              SizedBox(height: _responsiveHeight(16, screenHeight)),

              // Responsive Quiz Grid
              _buildResponsiveQuizGrid(
                controller,
                screenWidth,
                screenHeight,
                isTablet,
                isLargeScreen,
              ),

              SizedBox(height: _responsiveHeight(40, screenHeight)),
            ],
          ),
        ),
      ),
    );
  }

  // Enhanced responsive helper methods
  double _getResponsiveImageSize(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    // Increased base sizes to match taller container
    double baseSize = isTablet ? 160 : 130; // Increased from previous values

    // Adjust based on screen dimensions
    if (screenHeight < 600) {
      // Short screens - moderate reduction
      baseSize = isTablet ? 130 : 110;
    } else if (screenHeight < 700) {
      // Medium screens
      baseSize = isTablet ? 145 : 120;
    } else if (screenHeight > 800) {
      // Tall screens - can afford larger images to match container height
      baseSize = isTablet ? 180 : 150;
    }

    // Further adjust for width constraints
    if (screenWidth < 350) {
      baseSize = (baseSize * 0.75).clamp(80, 110); // Less aggressive reduction
    } else if (screenWidth > 900) {
      baseSize = (baseSize * 1.2).clamp(120, 220); // More generous increase
    }

    return baseSize;
  }

  // Calculate optimal featured section height
  double _calculateFeaturedHeight(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    double baseHeight =
        isTablet ? 240 : 200; // Increased base heights significantly

    // Adjust for screen height - more generous spacing
    if (screenHeight < 600) {
      // Short screens - still provide decent height
      baseHeight = isTablet ? 200 : 170;
    } else if (screenHeight < 700) {
      // Medium screens - good spacing
      baseHeight = isTablet ? 220 : 185;
    } else if (screenHeight > 800) {
      // Tall screens - can afford much more space
      baseHeight = isTablet ? 280 : 240;
    }

    // Additional adjustment for very wide screens
    if (screenWidth > 900) {
      baseHeight *= 1.15; // Increased multiplier for better proportion
    }

    // Expanded bounds for taller container
    return baseHeight.clamp(160, 320);
  }

  double _responsiveWidth(double baseWidth, double screenWidth) {
    if (screenWidth > 900) return baseWidth * 1.2; // Large screens
    if (screenWidth > 600) return baseWidth * 1.1; // Tablets
    if (screenWidth < 350) return baseWidth * 0.9; // Small phones
    return baseWidth; // Default phones
  }

  double _responsiveHeight(double baseHeight, double screenHeight) {
    if (screenHeight > 800) return baseHeight * 1.1; // Tall screens
    if (screenHeight < 600) return baseHeight * 0.8; // Short screens
    return baseHeight; // Default
  }

  double _responsiveFontSize(double baseFontSize, double screenWidth) {
    if (screenWidth > 900) return baseFontSize * 1.3; // Large screens
    if (screenWidth > 600) return baseFontSize * 1.2; // Tablets
    if (screenWidth < 350) return baseFontSize * 0.9; // Small phones
    return baseFontSize; // Default
  }

  EdgeInsets _responsivePadding(double screenWidth) {
    if (screenWidth > 900) return const EdgeInsets.all(24.0); // Large screens
    if (screenWidth > 600) return const EdgeInsets.all(20.0); // Tablets
    if (screenWidth < 350) return const EdgeInsets.all(12.0); // Small phones
    return const EdgeInsets.all(16.0); // Default
  }

  // Responsive Top Button
  Widget _buildTopButton(double screenWidth, bool isTablet) {
    return Padding(
      padding: _responsivePadding(screenWidth),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _responsiveWidth(16, screenWidth),
          vertical: _responsiveHeight(
            12,
            MediaQuery.of(Get.context!).size.height,
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink[100]!, Colors.purple[100]!],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(isTablet ? 35 : 30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: isTablet ? 5 : 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isTablet ? 32 : 24,
              height: isTablet ? 32 : 24,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.pets,
                size: isTablet ? 20 : 16,
                color: Colors.purple,
              ),
            ),
            SizedBox(width: isTablet ? 16 : 12),
            Text(
              'Belajar Hewan Yuk!',
              style: TextStyle(
                fontSize: _responsiveFontSize(16, screenWidth),
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Responsive Section Title
  Widget _buildSectionTitle({
    required String title,
    required IconData icon,
    required MaterialColor color,
    required double screenWidth,
    required bool isTablet,
  }) {
    return Padding(
      padding: _responsivePadding(screenWidth),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 12 : 8),
            decoration: BoxDecoration(
              color: color[100],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: isTablet ? 24 : 18),
          ),
          SizedBox(width: isTablet ? 12 : 8),
          Text(
            title,
            style: TextStyle(
              fontSize: _responsiveFontSize(18, screenWidth),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Responsive Featured Section
  Widget _buildFeaturedSection(
    HomeController controller,
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    // Dynamic height calculation based on screen size
    double featuredHeight = _calculateFeaturedHeight(
      screenWidth,
      screenHeight,
      isTablet,
    );

    return Padding(
      padding: _responsivePadding(screenWidth),
      child: GestureDetector(
        onTap: () => controller.onFeaturedImageTap(),
        child: Container(
          height: featuredHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[400]!, Colors.teal[200]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: isTablet ? 7 : 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Responsive decorative elements
              Positioned(
                right: isTablet ? -30 : -20,
                top: isTablet ? -30 : -20,
                child: Container(
                  width: isTablet ? 140 : 100,
                  height: isTablet ? 140 : 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: isTablet ? -40 : -30,
                bottom: isTablet ? -40 : -30,
                child: Container(
                  width: isTablet ? 160 : 120,
                  height: isTablet ? 160 : 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Responsive content
              Padding(
                padding: EdgeInsets.all(isTablet ? 24 : 16),
                child: Row(
                  children: [
                    // Text content
                    Expanded(
                      flex: isTablet ? 3 : 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Mengenal Hewan",
                            style: TextStyle(
                              fontSize: _responsiveFontSize(24, screenWidth),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                  color: Color.fromRGBO(0, 0, 0, 0.3),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: isTablet ? 6 : 4,
                          ), // Reduced spacing to save space
                          Text(
                            "Pelajari berbagai jenis hewan dan lihat bentuknya dengan AR",
                            style: TextStyle(
                              fontSize: _responsiveFontSize(14, screenWidth),
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          SizedBox(height: isTablet ? 20 : 16),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 20 : 16,
                              vertical: isTablet ? 12 : 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                isTablet ? 25 : 20,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.visibility,
                                  size: isTablet ? 20 : 16,
                                  color: Colors.teal[700],
                                ),
                                SizedBox(width: isTablet ? 8 : 6),
                                Text(
                                  "Lihat Hewan",
                                  style: TextStyle(
                                    fontSize: _responsiveFontSize(
                                      14,
                                      screenWidth,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Animal image
                    Container(
                      width: isTablet ? 160 : 120,
                      height: isTablet ? 160 : 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          "assets/images/animals_group.png",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.pets,
                              size: isTablet ? 70 : 50,
                              color: Colors.white.withOpacity(0.7),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Responsive Facts Carousel
  Widget _buildFactsCarousel(
    HomeController controller,
    double screenWidth,
    bool isTablet,
  ) {
    final List<Map<String, dynamic>> animalFacts = [
      {
        "fact":
            "Harimau memiliki garis-garis yang unik seperti sidik jari manusia",
        "color1": Colors.orange[400]!,
        "color2": Colors.deepOrange[300]!,
        "icon": Icons.pets,
      },
      {
        "fact": "Jerapah memiliki lidah panjang hingga 45-50 cm",
        "color1": Colors.amber[400]!,
        "color2": Colors.brown[300]!,
        "icon": Icons.language,
      },
      {
        "fact": "Gajah adalah satu-satunya mamalia yang tidak bisa melompat",
        "color1": Colors.grey[500]!,
        "color2": Colors.blueGrey[400]!,
        "icon": Icons.height,
      },
      {
        "fact": "Kupu-kupu mencicipi makanan menggunakan kaki mereka",
        "color1": Colors.purple[400]!,
        "color2": Colors.deepPurple[300]!,
        "icon": Icons.flutter_dash,
      },
    ];

    double carouselHeight = isTablet ? 140 : 120;
    double viewportFraction = screenWidth > 900 ? 0.7 : (isTablet ? 0.8 : 0.85);

    return CarouselSlider(
      options: CarouselOptions(
        height: carouselHeight,
        aspectRatio: 16 / 9,
        viewportFraction: viewportFraction,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
      items:
          animalFacts.map((fact) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(
                    horizontal: isTablet ? 8.0 : 5.0,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [fact["color1"], fact["color2"]],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                    boxShadow: [
                      BoxShadow(
                        color: fact["color1"].withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: isTablet ? 6 : 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Decorative elements
                      Positioned(
                        right: isTablet ? -25 : -20,
                        top: isTablet ? -25 : -20,
                        child: Container(
                          width: isTablet ? 100 : 80,
                          height: isTablet ? 100 : 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      // Content
                      Padding(
                        padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
                        child: Row(
                          children: [
                            // Icon
                            Container(
                              padding: EdgeInsets.all(isTablet ? 14 : 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Icon(
                                fact["icon"],
                                color: fact["color1"],
                                size: isTablet ? 28 : 24,
                              ),
                            ),
                            SizedBox(width: isTablet ? 20 : 16),

                            // Fact text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "TAHUKAH KAMU?",
                                    style: TextStyle(
                                      fontSize: _responsiveFontSize(
                                        12,
                                        screenWidth,
                                      ),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: isTablet ? 6 : 4),
                                  Text(
                                    fact["fact"],
                                    style: TextStyle(
                                      fontSize: _responsiveFontSize(
                                        14,
                                        screenWidth,
                                      ),
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: isTablet ? 4 : 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
    );
  }

  // Responsive Quiz Grid
  Widget _buildResponsiveQuizGrid(
    HomeController controller,
    double screenWidth,
    double screenHeight,
    bool isTablet,
    bool isLargeScreen,
  ) {
    int crossAxisCount;
    double childAspectRatio;
    double mainAxisSpacing;
    double crossAxisSpacing;

    if (isLargeScreen) {
      // Large screens (tablets in landscape, large phones)
      crossAxisCount = 4;
      childAspectRatio = 0.75; // Reduced to give more height for text
      mainAxisSpacing = 20;
      crossAxisSpacing = 20;
    } else if (isTablet) {
      // Tablets in portrait
      crossAxisCount = 3;
      childAspectRatio = 0.8; // Reduced to give more height for text
      mainAxisSpacing = 18;
      crossAxisSpacing = 18;
    } else if (screenWidth < 350) {
      // Small phones
      crossAxisCount = 1;
      childAspectRatio = 2.2; // Reduced to accommodate 3 lines of text
      mainAxisSpacing = 12;
      crossAxisSpacing = 12;
    } else {
      // Default phones
      crossAxisCount = 2;
      childAspectRatio = 0.75; // Reduced to give more height for text
      mainAxisSpacing = 16;
      crossAxisSpacing = 16;
    }

    return Padding(
      padding: _responsivePadding(screenWidth),
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
        children: [
          _buildQuizItem(
            title: "Tebak Gambar",
            icon: Icons.image,
            colors: [Colors.red[400]!, Colors.pink[200]!],
            description: "Tebak nama hewan dari gambar yang ditampilkan",
            onTap: () => controller.onCategoryTap(0),
            screenWidth: screenWidth,
            isTablet: isTablet,
            isSmallScreen: screenWidth < 350,
          ),
          _buildQuizItem(
            title: "Kategori Hewan",
            icon: Icons.grid_view,
            colors: [Colors.amber[400]!, Colors.yellow[200]!],
            description: "Kelompokkan hewan berdasarkan kategorinya",
            onTap: () => controller.onCategoryTap(1),
            screenWidth: screenWidth,
            isTablet: isTablet,
            isSmallScreen: screenWidth < 350,
          ),
          _buildQuizItem(
            title: "Habitat Hewan",
            icon: Icons.home,
            colors: [Colors.green[400]!, Colors.lightGreen[200]!],
            description: "Cocokkan hewan dengan tempat tinggalnya",
            onTap: () => controller.onCategoryTap(2),
            screenWidth: screenWidth,
            isTablet: isTablet,
            isSmallScreen: screenWidth < 350,
          ),
          _buildQuizItem(
            title: "Puzzle Hewan",
            icon: Icons.extension,
            colors: [Colors.blue[400]!, Colors.lightBlue[200]!],
            description: "Susun potongan gambar menjadi hewan yang utuh",
            onTap: () => controller.onCategoryTap(3),
            screenWidth: screenWidth,
            isTablet: isTablet,
            isSmallScreen: screenWidth < 350,
          ),
        ],
      ),
    );
  }

  // Responsive Quiz Item
  Widget _buildQuizItem({
    required String title,
    required IconData icon,
    required List<Color> colors,
    required String description,
    required VoidCallback onTap,
    required double screenWidth,
    required bool isTablet,
    required bool isSmallScreen,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
          boxShadow: [
            BoxShadow(
              color: colors[0].withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: isTablet ? 5 : 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative elements
            Positioned(
              right: isTablet ? -25 : -20,
              bottom: isTablet ? -25 : -20,
              child: Container(
                width: isTablet ? 80 : 60,
                height: isTablet ? 80 : 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Quiz badge
            Positioned(
              right: isTablet ? 12 : 8,
              top: isTablet ? 12 : 8,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 12 : 8,
                  vertical: isTablet ? 6 : 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: isTablet ? 14 : 10,
                      color: colors[0],
                    ),
                    SizedBox(width: isTablet ? 4 : 2),
                    Text(
                      "Quiz",
                      style: TextStyle(
                        fontSize: isTablet ? 12 : 10,
                        fontWeight: FontWeight.bold,
                        color: colors[0],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(
                isTablet ? 16.0 : (isSmallScreen ? 16.0 : 12.0),
              ),
              child:
                  isSmallScreen
                      ? _buildSmallScreenLayout(
                        title,
                        icon,
                        colors,
                        description,
                        screenWidth,
                      )
                      : _buildDefaultLayout(
                        title,
                        icon,
                        colors,
                        description,
                        screenWidth,
                        isTablet,
                      ),
            ),
          ],
        ),
      ),
    );
  }

  // Layout for small screens (horizontal)
  Widget _buildSmallScreenLayout(
    String title,
    IconData icon,
    List<Color> colors,
    String description,
    double screenWidth,
  ) {
    return Row(
      children: [
        // Icon
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Icon(icon, size: 24, color: colors[0]),
        ),
        const SizedBox(width: 16),
        // Text content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: _responsiveFontSize(16, screenWidth),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: _responsiveFontSize(13, screenWidth),
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 1.5,
                      offset: Offset(0.5, 0.5),
                    ),
                  ],
                  letterSpacing: 0.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Default layout (vertical)
  Widget _buildDefaultLayout(
    String title,
    IconData icon,
    List<Color> colors,
    String description,
    double screenWidth,
    bool isTablet,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon
        Container(
          padding: EdgeInsets.all(isTablet ? 14 : 10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Icon(icon, size: isTablet ? 28 : 24, color: colors[0]),
        ),
        SizedBox(height: isTablet ? 12 : 8),
        // Title
        Text(
          title,
          style: TextStyle(
            fontSize: _responsiveFontSize(14, screenWidth),
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                color: Color.fromRGBO(0, 0, 0, 0.2),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isTablet ? 6 : 4),
        // Description
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: _responsiveFontSize(13, screenWidth),
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.2,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 1.5,
                offset: Offset(0.5, 0.5),
              ),
            ],
            letterSpacing: 0.3,
          ),
          maxLines: isTablet ? 3 : 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
