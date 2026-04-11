import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/starfield_background.dart';
import '../services/storage_service.dart';
import '../providers/providers.dart';
import 'user_details_screen.dart';
import 'chat_screen.dart';
import 'palm_upload_screen.dart';
import 'kundli_screen.dart';
import 'settings_screen.dart';
import 'paywall_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  double _overscrollAmount = 0;

  bool _handleOverscroll(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;

    final pixels = notification.metrics.pixels;
    final maxExtent = notification.metrics.maxScrollExtent;

    if (notification is ScrollUpdateNotification && pixels > maxExtent) {
      setState(() {
        _overscrollAmount = (pixels - maxExtent).clamp(0, 80);
      });
    } else if (notification is ScrollEndNotification) {
      setState(() {
        _overscrollAmount = 0;
      });
    } else if (notification is ScrollUpdateNotification && pixels <= maxExtent && _overscrollAmount > 0) {
      setState(() {
        _overscrollAmount = 0;
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final profile = ref.watch(userProfileProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;

    if (profile == null && StorageService.currentProfile != null) {
      Future.microtask(() {
        ref.read(userProfileProvider.notifier).state = StorageService.currentProfile;
      });
    }

    final revealOpacity = (_overscrollAmount / 60).clamp(0.0, 1.0);

    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          child: Stack(
            children: [
              // Hidden "Made in India" behind content
              Positioned(
                left: 0,
                right: 0,
                bottom: 16,
                child: Opacity(
                  opacity: revealOpacity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Made with ',
                        style: TextStyle(
                          color: AppColors.textMuted.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                      Icon(
                        Icons.favorite,
                        color: AppColors.purpleAccent.withOpacity(0.7),
                        size: 13,
                      ),
                      Text(
                        ' in India ',
                        style: TextStyle(
                          color: AppColors.textMuted.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                      const Text(
                        '\u{1F1EE}\u{1F1F3}',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              // Main scrollable content
              NotificationListener<ScrollNotification>(
                onNotification: _handleOverscroll,
                child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? screenWidth * 0.15 : 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // Top bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            profile?.name.isNotEmpty == true
                                ? profile!.name
                                : 'Explorer',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            _buildPageRoute(const SettingsScreen()),
                          );
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surfaceLight,
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: const Icon(
                            Icons.settings_outlined,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 500.ms),

                  const SizedBox(height: 28),

                  // Hero section
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.purpleAccent.withOpacity(0.3),
                                AppColors.purpleAccent.withOpacity(0.05),
                              ],
                            ),
                            border: Border.all(
                              color: AppColors.purpleAccent.withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: AppColors.goldLight,
                            size: 36,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 800.ms)
                            .scaleXY(begin: 0.8, end: 1.0, duration: 800.ms, curve: Curves.easeOut),
                        const SizedBox(height: 14),
                        const Text(
                          'VedAstro AI',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                        const SizedBox(height: 4),
                        const Text(
                          'Your personal Vedic astrologer',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13,
                          ),
                        ).animate().fadeIn(duration: 600.ms, delay: 350.ms),
                        if (profile != null) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.goldLight.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.goldLight.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.wb_sunny_outlined, color: AppColors.goldLight, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  '${profile.westernSign} (Vedic: ${profile.sunSign})',
                                  style: const TextStyle(
                                    color: AppColors.goldLight,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 500.ms, delay: 500.ms),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 2x2 Feature grid
                  Row(
                    children: [
                      // AI Chat - big card
                      Expanded(
                        child: _buildGridCard(
                          context: context,
                          icon: Icons.chat_bubble_outline_rounded,
                          title: 'AI Chat',
                          subtitle: 'Ask anything about your stars',
                          color: AppColors.purpleAccent,
                          delay: 500,
                          onTap: () {
                            if (profile != null) {
                              Navigator.of(context).push(
                                _buildPageRoute(const ChatScreen()),
                              );
                            } else {
                              Navigator.of(context).push(
                                _buildPageRoute(const UserDetailsScreen()),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Palm Reading
                      Expanded(
                        child: _buildGridCard(
                          context: context,
                          icon: Icons.back_hand_outlined,
                          title: 'Palm Reading',
                          subtitle: 'AI Samudrik Shastra',
                          color: AppColors.purpleLight,
                          delay: 600,
                          onTap: () {
                            Navigator.of(context).push(
                              _buildPageRoute(const PalmUploadScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      // Kundli Chart
                      Expanded(
                        child: _buildGridCard(
                          context: context,
                          icon: Icons.auto_awesome_mosaic_outlined,
                          title: 'Kundli Chart',
                          subtitle: 'Your Vedic birth chart',
                          color: AppColors.gold,
                          delay: 700,
                          onTap: () {
                            Navigator.of(context).push(
                              _buildPageRoute(const KundliScreen()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Horoscope
                      Expanded(
                        child: _buildGridCard(
                          context: context,
                          icon: Icons.calendar_month_outlined,
                          title: 'Horoscope',
                          subtitle: 'Daily / Weekly / Monthly',
                          color: AppColors.purpleGlow,
                          delay: 800,
                          onTap: () {
                            if (profile != null) {
                              Navigator.of(context).push(
                                _buildPageRoute(const ChatScreen()),
                              );
                            } else {
                              Navigator.of(context).push(
                                _buildPageRoute(const UserDetailsScreen()),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Go Premium bar
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const PaywallScreen(),
                          transitionsBuilder: (_, animation, __, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 1),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 400),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.15),
                            ),
                            child: const Icon(
                              Icons.workspace_premium_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Go Premium',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Unlimited readings & advanced features',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 900.ms)
                      .slideY(begin: 0.1, end: 0, duration: 500.ms, delay: 900.ms),

                  const SizedBox(height: 24),

                  // Did you know tip
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.purpleAccent.withOpacity(0.15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: AppColors.goldLight, size: 16),
                            const SizedBox(width: 8),
                            const Text(
                              'Did you know?',
                              style: TextStyle(
                                color: AppColors.goldLight,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Vedic astrology uses the sidereal zodiac, which accounts for the precession of equinoxes — making it astronomically more precise than Western astrology.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 1000.ms),

                  const SizedBox(height: 20),

                  Center(
                    child: Text(
                      'Based on Brihat Parashara Hora Shastra & Phaladeepika',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textMuted.withOpacity(0.5),
                        fontSize: 10,
                        height: 1.4,
                      ),
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 1100.ms),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Widget _buildGridCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required int delay,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.06),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: Duration(milliseconds: delay))
        .scaleXY(begin: 0.95, end: 1.0, duration: 500.ms, delay: Duration(milliseconds: delay));
  }

  PageRouteBuilder _buildPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
