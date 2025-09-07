// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_profile_bloc.dart';
import '../bloc/user_profile_event.dart';
import '../bloc/user_profile_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fix_it/core/utils/bloc_utils.dart';

import '../../domain/entities/user_profile_entity.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfileEntity profile;

  const ProfileHeader({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.primaryColor,
            theme.primaryColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Picture
            Stack(
              children: [
                BlocConsumer<UserProfileBloc, UserProfileState>(
                  listener: (context, state) {
                    if (state is UserProfileError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    final uploading = state is ProfilePictureUploading &&
                        state.profile.id == profile.id;
                    return GestureDetector(
                      onTap: uploading ? null : () => _showPickOptions(context),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                            child: ClipOval(
                              child: profile.profilePictureUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: Uri.encodeFull(
                                          profile.profilePictureUrl!),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: Colors.grey[300],
                                        child: Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                            ),
                          ),
                          if (uploading)
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                shape: BoxShape.circle,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 3,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        builder: (context) => Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text('Take Photo'),
                                onTap: () {
                                  Navigator.pop(context);
                                  // Use safeAddEvent so the event is dispatched
                                  // even if the modal context doesn't have the
                                  // provider in scope.
                                  safeAddEvent<UserProfileBloc>(
                                      context, UploadProfilePicture('camera'));
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: const Text('Choose from Gallery'),
                                onTap: () {
                                  Navigator.pop(context);
                                  safeAddEvent<UserProfileBloc>(
                                      context, UploadProfilePicture('gallery'));
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Name
            Text(
              profile.fullName,
              style: GoogleFonts.cairo(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Email
            Text(
              profile.email,
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),

            if (profile.phoneNumber != null) ...[
              const SizedBox(height: 4),
              Text(
                profile.phoneNumber!,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],

            if (profile.bio != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  profile.bio!,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(
                  icon: Icons.payment,
                  label: 'طرق الدفع',
                  value: profile.paymentMethods.length.toString(),
                ),
                _StatItem(
                  icon: Icons.calendar_today,
                  label: 'عضو منذ',
                  value: _getJoinedDate(profile.createdAt),
                ),
                _StatItem(
                  icon: Icons.verified_user,
                  label: 'الحالة',
                  value: 'مُفعل',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPickOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                safeAddEvent<UserProfileBloc>(
                    context, UploadProfilePicture('camera'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                safeAddEvent<UserProfileBloc>(
                    context, UploadProfilePicture('gallery'));
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getJoinedDate(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} سنة';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} شهر';
    } else {
      return '${difference.inDays} يوم';
    }
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
