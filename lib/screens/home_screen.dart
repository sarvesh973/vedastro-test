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

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;

    if (profile == null && StorageService.currentProfile != null) {
      Future.microtask(() {
        ref.read(userProfileProvider.notifier).state = StorageService.currentProfile;
      });
    }

    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? screenWidth * 0.15 : 24,
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

                    const SizedBox(height: 32),

                    // Hero section
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
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
                              size: 40,
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 800.ms)
                              .scaleXY(begin: 0.8, end: 1.0, duration: 800.ms, curve: Curves.easeOut),
                          const SizedBox(height: 16),
                          const Text(
                            'VedAstro AI',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                          const SizedBox(height: 6),
                          const Text(
                            'Your personal Vedic astrologer',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 14,
                            ),
                          ).animate().fadeIn(duration: 600.ms, delay: 350.ms),

                          // Sun sign badge
                          if (profile != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.goldLight.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.goldLight.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.wb_sunny_outlined, color: AppColors.goldLight, size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${profile.westernSign} (Vedic: ${profile.sunSign})',
                                    style: const TextStyle(
                                      color: AppColors.goldLight,
                                      fontSize: 13,
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

                    const SizedBox(height: 36),

                    // Section title
                    const Text(
                      'Explore',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ).animate().fadeIn(duration: 500.ms, delay: 500.ms),

                    const SizedBox(height: 16),

                    // Vertical feature cards
                    _buildFeatureRow(
                      context: context,
                      icon: Icons.chat_bubble_outline_rounded,
                      title: 'Astrology Chat',
                      subtitle: 'Get personalized Vedic insights powered by AI',
                      color: AppColors.purpleAccent,
                      delay: 600,
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

                    const SizedBox(height: 12),

                    _buildFeatureRow(
                      context: context,
                      icon: Icons.back_hand_outlined,
                      title: 'Palm Reading',
                      subtitle: 'AI-powered Samudrik Shastra palm analysis',
                      color: AppColors.purpleLight,
                      delay: 700,
                      onTap: () {
                        Navigator.of(context).push(
                          _buildPageRoute(const PalmUploadScreen()),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    _buildFeatureRow(
                      context: context,
                      icon: Icons.auto_awesome_mosaic_outlined,
                      title: 'Kundli Chart',
                      subtitle: 'View your Vedic birth chart with house details',
                      color: AppColors.gold,
                      delay: 800,
                      onTap: () {
                        Navigator.of(context).push(
                          _buildPageRoute(const KundliScreen()),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    _buildFeatureRow(
                      context: context,
                      icon: Icons.workspace_premium_outlined,
                      title: 'Go Premium',
                      subtitle: 'Unlock unlimited readings & advanced features',
                      color: AppColors.goldLight,
                      delay: 900,
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
                    ),

                    const SizedBox(height: 32),

                    // Daily tip section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.purpleAccent.withOpacity(0.15),
                            AppColors.purpleSoft.withOpacity(0.08),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.purpleAccent.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lightbulb_outline, color: AppColors.goldLight, size: 18),
                              const SizedBox(width: 8),
                              const Text(
                                'Did you know?',
                                style: TextStyle(
                                  color: AppColors.goldLight,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Vedic astrology uses the sidereal zodiac, which accounts for the precession of equinoxes — making it astronomically more precise than Western astrology.',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 1000.ms)
                        .slideY(begin: 0.1, end: 0, duration: 600.ms, delay: 1000.ms),

                    const SizedBox(height: 24),

                    // Bottom text
                    Center(
                      child: Text(
                        'Based on Brihat Parashara Hora Shastra\n& Phaladeepika',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textMuted.withOpacity(0.6),
                          fontSize: 11,
                          height: 1.5,
                        ),
                      ),
                    ).animate().fadeIn(duration: 600.ms, delay: 1100.ms),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
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

  Widget _buildFeatureRow({
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
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: color.withOpacity(0.5),
              size: 22,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: Duration(milliseconds: delay))
        .slideX(begin: 0.05, end: 0, duration: 500.ms, delay: Duration(milliseconds: delay));
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
