import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const StudentCardApp());
}

class StudentCardApp extends StatelessWidget {
  const StudentCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Card',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Roboto'),
      home: const StudentCardScreen(),
    );
  }
}

/// Cuts all four corners equally, giving the card an angled / "edge-cut" outline.
class CutCornerClipper extends CustomClipper<Path> {
  final double cut;
  CutCornerClipper(this.cut);

  @override
  Path getClip(Size size) {
    final c = math.min(cut, math.min(size.width, size.height) / 2);
    final path = Path()
      ..moveTo(c, 0)
      ..lineTo(size.width - c, 0)
      ..lineTo(size.width, c)
      ..lineTo(size.width, size.height - c)
      ..lineTo(size.width - c, size.height)
      ..lineTo(c, size.height)
      ..lineTo(0, size.height - c)
      ..lineTo(0, c)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class StudentCardScreen extends StatefulWidget {
  const StudentCardScreen({super.key});

  @override
  State<StudentCardScreen> createState() => _StudentCardScreenState();
}

class _StudentCardScreenState extends State<StudentCardScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // ⬇️ Replace these with the real student's information
  static const String studentName = 'Abrar Siddique';
  static const String regNumber = 'CS-2024-001';
  static const String department = 'Computer Science';
  static const String semester = '5th Semester';
  static const String section = 'Section A';
  static const String email = 'abrar.siddique@cui.edu.pk';
  static const String imageUrl =
      'https://api.dicebear.com/7.x/initials/png?seed=Abrar%20Ahmad&backgroundColor=0ea5e9&fontFamily=Arial';

  static const double cutSize = 26;
  static const double borderWidth = 3;
  static const Color neonCyan = Color(0xFF22D3EE);
  static const Color neonViolet = Color(0xFFA855F7);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF020617), Color(0xFF0F172A), Color(0xFF1E1B4B)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [neonCyan, neonViolet],
                    ).createShader(bounds),
                    child: const Text(
                      'STUDENT IDENTITY CARD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _buildGlowingCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlowingCard() {
    return Container(
      // outer ambient glow behind the whole card
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: neonCyan.withValues(alpha: 0.35),
            blurRadius: 40,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: neonViolet.withValues(alpha: 0.25),
            blurRadius: 60,
            spreadRadius: 4,
          ),
        ],
      ),
      child: SizedBox(
        width: 340,
        child: Stack(
          children: [
            // Rotating neon light chasing around the cut border
            Positioned.fill(
              child: ClipPath(
                clipper: CutCornerClipper(cutSize),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return Transform.rotate(
                      angle: _controller.value * 2 * math.pi,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: SweepGradient(
                            colors: [
                              neonCyan,
                              Colors.transparent,
                              Colors.transparent,
                              neonViolet,
                              Colors.transparent,
                              Colors.transparent,
                              neonCyan,
                            ],
                            stops: [0.0, 0.12, 0.5, 0.62, 0.74, 0.98, 1.0],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Frosted glass card content, inset so the rotating light shows as a border ring
            Padding(
              padding: const EdgeInsets.all(borderWidth),
              child: ClipPath(
                clipper: CutCornerClipper(cutSize - borderWidth),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1220).withValues(alpha: 0.85),
                    ),
                    child: _cardContent(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: [neonCyan, neonViolet]),
            boxShadow: [
              BoxShadow(color: neonCyan.withValues(alpha: 0.6), blurRadius: 18),
            ],
          ),
          child: const CircleAvatar(
            radius: 46,
            backgroundColor: Color(0xFF0B1220),
            backgroundImage: NetworkImage(imageUrl),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          studentName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [Shadow(color: neonCyan, blurRadius: 12)],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: neonViolet.withValues(alpha: 0.7)),
            borderRadius: BorderRadius.circular(20),
            color: neonViolet.withValues(alpha: 0.12),
          ),
          child: const Text(
            department,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: neonCyan,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Divider(color: Colors.white.withValues(alpha: 0.12), thickness: 1, height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 22),
          child: Column(
            children: [
              _infoRow(Icons.badge_outlined, 'Registration No.', regNumber),
              _infoRow(Icons.calendar_today_outlined, 'Semester', semester),
              _infoRow(Icons.groups_outlined, 'Section', section),
              _infoRow(Icons.email_outlined, 'Email', email),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: neonCyan.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: neonCyan.withValues(alpha: 0.4)),
            ),
            child: Icon(icon, size: 17, color: neonCyan),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.5)),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}