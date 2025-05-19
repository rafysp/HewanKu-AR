import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/color_constant.dart';
import 'onboarding_controller.dart';
import 'widgets/cross_painter.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(OnboardingController());

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Text section at the top
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: ColorPrimary.textDark),
              ),

              const SizedBox(height: 150),

              // Placeholder image (box with X)
              Container(
                //
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: const CustomPaint(painter: CrossPainter()),
              ),

              const Spacer(), // Push the button to the bottom
              // "Mulai Belajar!" button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.onStartLearning(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPrimary.buttonBg,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Mulai Belajar!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
