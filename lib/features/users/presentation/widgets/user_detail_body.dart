import 'package:flutter/material.dart';
import '../../../../core/common/common.dart';
import '../../domain/entities/user.dart';

// User detail body widget - handles the display of a user profile header, gradient cover banner, overlapping profile avatar, name labels, and detail cards.
class UserDetailBody extends StatelessWidget {
  final User user;

  const UserDetailBody({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWideScreen = screenWidth > 600;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Banner & Avatar Stack
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Cover Gradient Banner
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.colorScheme.primary,
                      context.colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Overlapping Avatar
              Positioned(
                bottom: -50,
                child: _buildAvatar(context, user),
              ),
              // Floating Back Button in Body
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.3),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60), // Space for the overlapping avatar

          // Profile Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: isWideScreen
                ? Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Side: Name and Profile header info
                          Expanded(
                            flex: 2,
                            child: Card(
                              elevation: 0,
                              color: context.colorScheme.surfaceContainerHigh,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: context.colorScheme.outlineVariant.withValues(alpha: 0.5),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      user.fullName,
                                      style: context.textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '@${user.firstName.toLowerCase()}${user.lastName.toLowerCase()}',
                                      style: context.textTheme.bodyMedium?.copyWith(
                                        color: context.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Right Side: Info Tiles Card
                          Expanded(
                            flex: 3,
                            child: _buildDetailsCard(context, user),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        user.fullName,
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '@${user.firstName.toLowerCase()}${user.lastName.toLowerCase()}',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildDetailsCard(context, user),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, User user) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: context.colorScheme.surface,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: context.colorScheme.primaryContainer,
        backgroundImage: user.avatar.isNotEmpty ? NetworkImage(user.avatar) : null,
        child: user.avatar.isEmpty
            ? Text(
                user.firstName.isNotEmpty ? user.firstName[0] : '?',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.onPrimaryContainer,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, User user) {
    return Card(
      elevation: 0,
      color: context.colorScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildInfoTile(
              context,
              Icons.email_rounded,
              'Email Address',
              user.email,
            ),
            const Divider(height: 24),
            _buildInfoTile(
              context,
              Icons.phone_rounded,
              'Phone Number',
              user.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: context.colorScheme.surfaceContainerHighest,
          child: Icon(
            icon,
            size: 20,
            color: context.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.isNotEmpty ? value : 'N/A',
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
