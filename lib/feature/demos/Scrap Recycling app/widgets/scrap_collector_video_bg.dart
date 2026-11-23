import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animated background simulating a realistic documentary video of a scrap / waste
/// collector picking up cardboard and recyclable scrap on a city street.
class ScrapCollectorVideoBackground extends StatefulWidget {
  final Widget child;
  final double overlayOpacity;

  const ScrapCollectorVideoBackground({
    super.key,
    required this.child,
    this.overlayOpacity = 0.65,
  });

  @override
  State<ScrapCollectorVideoBackground> createState() => _ScrapCollectorVideoBackgroundState();
}

class _ScrapCollectorVideoBackgroundState extends State<ScrapCollectorVideoBackground>
    with TickerProviderStateMixin {
  late AnimationController _cameraController;
  late AnimationController _particlesController;
  late AnimationController _flareController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _panAnimation;

  final List<_DustParticle> _particles = List.generate(
    18,
    (index) => _DustParticle(
      x: math.Random().nextDouble(),
      y: math.Random().nextDouble(),
      size: 2.0 + math.Random().nextDouble() * 3.5,
      speed: 0.2 + math.Random().nextDouble() * 0.5,
      alpha: 0.2 + math.Random().nextDouble() * 0.4,
    ),
  );

  @override
  void initState() {
    super.initState();

    // Cinematic Ken-Burns Camera Slow Pan & Zoom (Video Simulation)
    _cameraController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _cameraController, curve: Curves.easeInOutSine),
    );

    _panAnimation = Tween<Offset>(
      begin: const Offset(0.01, 0.0),
      end: const Offset(-0.02, -0.02),
    ).animate(
      CurvedAnimation(parent: _cameraController, curve: Curves.easeInOutSine),
    );

    // Subtle sun flare shimmer
    _flareController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Floating particles
    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _particlesController.dispose();
    _flareController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Animated Video Camera Pan & Zoom of the Scrap Collector
        AnimatedBuilder(
          animation: _cameraController,
          builder: (context, _) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.translate(
                offset: Offset(
                  _panAnimation.value.dx * MediaQuery.of(context).size.width,
                  _panAnimation.value.dy * MediaQuery.of(context).size.height,
                ),
                child: Image.asset(
                  'assets/images/scrap_collector_bg.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to stylized emerald background if image not found
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF064E3B), Color(0xFF0F172A)],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),

        // 2. Cinematic Lens Sunlight Shimmer
        AnimatedBuilder(
          animation: _flareController,
          builder: (context, _) {
            final flareOpacity = 0.15 + (_flareController.value * 0.12);
            return Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFDE68A).withValues(alpha: flareOpacity),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // 3. Floating Dust & Leaf Particles
        AnimatedBuilder(
          animation: _particlesController,
          builder: (context, _) {
            return CustomPaint(
              painter: _ParticlePainter(
                particles: _particles,
                progress: _particlesController.value,
              ),
              size: Size.infinite,
            );
          },
        ),

        // 4. Cinematic Dark Vignette & Gradient Overlays (Ensures UI legibility)
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.65),
                const Color(0xFF064E3B).withValues(alpha: 0.45),
                Colors.black.withValues(alpha: widget.overlayOpacity),
                Colors.black.withValues(alpha: 0.92),
              ],
              stops: const [0.0, 0.25, 0.65, 1.0],
            ),
          ),
        ),

        // 5. Live "VIDEO AMBIANCE" indicator badge in top corner
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24, width: 0.8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444), // red record dot
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'LIVE RECYCLING SCENE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // 6. Child content over background
        widget.child,
      ],
    );
  }
}

class _DustParticle {
  final double x;
  double y;
  final double size;
  final double speed;
  final double alpha;

  _DustParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.alpha,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_DustParticle> particles;
  final double progress;

  _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      final currentY = ((p.y - (progress * p.speed)) % 1.0) * size.height;
      final currentX = (p.x * size.width) + math.sin(progress * 2 * math.pi + p.x) * 12;

      paint.color = const Color(0xFF6EE7B7).withValues(alpha: p.alpha);
      canvas.drawCircle(Offset(currentX, currentY), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
