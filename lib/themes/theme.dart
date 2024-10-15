import 'package:app/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData theme = ThemeData(
  fontFamily: GoogleFonts.nunito().fontFamily, // Using Google Fonts globally

  // Colors
  primaryColor:
      primary600, // Primary color for various UI elements // Accent color for elements like floating action buttons

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primary600,
      foregroundColor: Colors.white, // Background color

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),

      padding: EdgeInsets.symmetric(
          horizontal: 16, vertical: 18), // Padding inside button
      elevation: 2, // Shadow of the button
      side: BorderSide(color: primary600), // Border color (optional)
    ),
  ),

  textSelectionTheme: TextSelectionThemeData(
    cursorColor: primary600, // Cursor color
    selectionColor: primary600.withOpacity(0.5), // Selection highlight color
    selectionHandleColor: primary600, // Handle color
  ),

  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: primary600, // Color when the field is focused
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: neutral300, // Default border color (for unfocused fields)
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color:
            neutral300, // Border color when the field is enabled but not focused
      ),
      borderRadius: BorderRadius.circular(8),
    ),
  ),

  // Additional theme properties can be set here
);
