import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fix_it/features/profile/presentation/bloc/user_profile_bloc/user_profile_bloc.dart';
import 'package:fix_it/core/utils/bloc_utils.dart';
import 'package:fix_it/features/profile/presentation/bloc/user_profile_event.dart' hide UserProfileEvent;
import 'package:fix_it/features/profile/domain/entities/user_profile_entity.dart';

/// EditProfileScreen
///
/// Business Rules:
/// - Add the main business rules or invariants enforced by this class.
/// - Be concise and concrete.
///
/// Error Scenarios:
/// - Describe common errors and how the class responds (exceptions,
///   fallbacks, retries).
///
/// Dependencies:
/// - List key dependencies, required services, or external resources.
///
/// Example usage:
/// ```dart
/// // Example: Create and use EditProfileScreen
/// final obj = EditProfileScreen();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class EditProfileScreen extends StatefulWidget {
  final UserProfileBloc bloc;

  const EditProfileScreen({super.key, required this.bloc});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _professionController = TextEditingController();

  @override
/// initState
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)
  void initState() {
    super.initState();
    // Load user profile when the screen initializes. Use a post-frame
    // callback to ensure the BlocProvider (or provided bloc) is available
    // in the widget tree. The EditProfileScreen receives the bloc instance
    // directly, but using safeAddEvent keeps behavior consistent and
    // defensive.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      safeAddEvent<UserProfileBloc>(context, LoadUserProfileEvent());
    });
  }

  @override
/// dispose
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _professionController.dispose();
    super.dispose();
  }

  @override
/// build
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is UserProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<UserProfileBloc, UserProfileState>(
          bloc: widget.bloc,
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserProfileLoaded) {
              // Initialize controllers with current user data
              _nameController.text = state.userProfile['name'] ?? '';
              _emailController.text = state.userProfile['email'] ?? '';
              _phoneController.text = state.userProfile['phone'] ?? '';
              _professionController.text = state.userProfile['profession'] ?? '';

              return _buildEditProfileForm(context, state);
            } else if (state is UserProfileUpdating) {
              return _buildEditProfileForm(context, null, isLoading: true);
            } else if (state is UserProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        safeAddEvent<UserProfileBloc>(context, LoadUserProfileEvent());
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('Something went wrong'));
          },
        ),
      ),
    );
  }

  Widget _buildEditProfileForm(
    BuildContext context,
    UserProfileLoaded? state, {
    bool isLoading = false,
  }) {
    final isProvider = state?.userProfile['userType'] == 'provider';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Email field
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Phone field
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),

            if (isProvider) ...[
              const SizedBox(height: 16),

              // Profession field (for providers)
              TextFormField(
                controller: _professionController,
                decoration: InputDecoration(
                  labelText: 'Profession',
                  hintText: 'Enter your profession',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.work),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your profession';
                  }
                  return null;
                },
              ),
            ],

            const SizedBox(height: 32),

            // Update button
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        // Create a UserProfileEntity with the updated data
                        // We need to get the current profile from the bloc state
                        final blocState = widget.bloc.state;
                        if (blocState is UserProfileLoaded) {
                          // Create a Map with the updated profile data
                          final updatedProfile = <String, dynamic>{
                            'name': _nameController.text.trim(),
                            'email': _emailController.text.trim(),
                            'phone': _phoneController.text.trim(),
                          };
                          
                          // Add profession if it's a provider
                          if (isProvider) {
                            updatedProfile['profession'] = _professionController.text.trim();
                          }
                          
                          // Create a UserProfileEntity from the map
                          final userProfileEntity = UserProfileEntity(
                            id: blocState.userProfile['id'] ?? '',
                            fullName: updatedProfile['name'] ?? '',
                            email: updatedProfile['email'] ?? '',
                            phoneNumber: updatedProfile['phone'],
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          );
                          
                          safeAddEvent<UserProfileBloc>(
                            context,
                            UpdateUserProfile(userProfileEntity) as UserProfileEvent,
                          );
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Update Profile',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
