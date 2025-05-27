import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color irisPurple = Color(0xFF9575CD);

    return Scaffold(
      backgroundColor: Colors
          .white, // Bisa diganti warna latar, misal Colors.white atau irisPurple.withOpacity(0.1) kalau mau soft background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Image.asset('assets/images/logo.png', width: 120),
              const SizedBox(height: 24),
              // Judul dengan Google Fonts Poppins dan warna hitam
              Text(
                'Welcome to TICKY!',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              // Subtitle dengan font Poppins dan warna abu-abu
              Text(
                'Manage your tasks with colorful ease.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
              // Tombol Get Started dengan warna irisPurple
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: irisPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: Text(
                  'Get Started',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
