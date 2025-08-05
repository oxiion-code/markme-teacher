import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markme_admin/core/theme/color_scheme.dart';

class BatchContainer extends StatelessWidget {
  final String batchName;
  // The icon to display at the top of the container.
  final IconData iconData;
  // The list of colors to use for the linear gradient background.
  final List<Color> gradientColors;
  // Callback function for the button in the top-right corner.
  final VoidCallback? onRightCornerButtonPressed;
  // The icon for the button in the top-right corner.
  final IconData? rightCornerButtonIcon;
  // The color for the icon of the button in the top-right corner.
  final Color? rightCornerButtonIconColor;

  const BatchContainer({
    super.key,
    required this.batchName,
    required this.iconData,
    required this.gradientColors,
    this.onRightCornerButtonPressed,
    this.rightCornerButtonIcon,
    this.rightCornerButtonIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 192.0, // Equivalent to h-48 (48 * 4 = 192px)
      padding: const EdgeInsets.all(24.0), // Equivalent to p-6 (6 * 4 = 24px)
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0), // Equivalent to rounded-2xl
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary, // Equivalent to shadow-lg
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5), // changes position of shadow
          ),
        ],
        // Apply the linear gradient background
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      // Using Stack to layer the content (icon + text) and the new button.
      child: Stack(
        children: [
          // Main content: icon and batch name, centered within the stack
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out icon and text
            children: [
              // Placeholder Icon/Image
              Container(
                padding: const EdgeInsets.all(12.0), // Equivalent to p-3
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3), // Equivalent to bg-white bg-opacity-30
                  shape: BoxShape.circle, // Equivalent to rounded-full
                ),
                child: Icon(
                  iconData,
                  size: 64.0, // Equivalent to w-16 h-16 (16 * 4 = 64px)
                  // Adjust icon color based on gradient
                ),
              ),
              // Batch Name
              Text(
                batchName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.0, // Equivalent to text-xl
                  fontWeight: FontWeight.w600, // Equivalent to font-semibold
                  color: Colors.grey[800], // Equivalent to text-gray-800
                ),
              ),
            ],
          ),
          // Positioned button in the top-right corner
          if (rightCornerButtonIcon != null) // Only show the button if an icon is provided
            Positioned(
              top: -8.0, // Adjust position to move slightly outside the container for a cleaner look
              right: -16.0, // Adjust position
              child: IconButton(
                icon: Icon(
                  rightCornerButtonIcon,
                  color: Colors.black, // Use provided color or default
                  size: 28.0, // Adjust button icon size
                ),
                onPressed: onRightCornerButtonPressed, // Assign the callback
                splashRadius: 24.0, // Defines the radius of the ink splash
              ),
            ),
        ],
      ),
    );
  }
}
