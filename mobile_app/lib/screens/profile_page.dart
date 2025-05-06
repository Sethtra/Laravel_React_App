import 'package:flutter/material.dart';
import '../services/auth_service.dart';

// Re-using color constants, ensure they are accessible or redefine them here
const Color appAccentRed = Color(0xFFFF6B6B);
const Color appDarkText = Color(0xFF333333);
// const Color appLightText = Color(0xFF757575);
const Color profilePageBackgroundColor = Colors.white;
const Color profileListItemBackgroundColor = Colors.white;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  String? _userName;
  String? _userEmail; // Assuming you might want to display email too
  // String? _userProfileImageUrl; // For future use

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // In a real app, you might fetch more comprehensive user profile data
    final name = await _authService.getUserName();
    // final email = await _authService.getUserEmail(); // If you store/fetch email
    if (mounted) {
      setState(() {
        _userName = name ?? 'User';
        // _userEmail = email;
      });
    }
  }

  Future<void> _logout() async {
    final result = await _authService.logout();
    if (mounted) {
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Logout failed'),
            backgroundColor: Colors.red,
          ),
        );
        // Still navigate to login even if server logout fails, as token is cleared locally
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text('Are you sure you want to log out?')],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileImage() {
    // Placeholder image URL, replace with actual user image if available
    const String placeholderImageUrl =
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=100&q=60';

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[200],
            backgroundImage: const NetworkImage(placeholderImageUrl),
            // In a real app, use _userProfileImageUrl if fetched
            // backgroundImage: _userProfileImageUrl != null
            //     ? NetworkImage(_userProfileImageUrl!)
            //     : null, // Or a default asset image
            // child: _userProfileImageUrl == null
            //     ? Icon(Icons.person, size: 60, color: Colors.grey[400])
            //     : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                // TODO: Implement change profile picture functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Change picture tapped!')),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: appAccentRed,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = appAccentRed,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: profileListItemBackgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 18.0,
            ),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isLogout ? Colors.red.shade700 : appDarkText,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: profilePageBackgroundColor,
      appBar: AppBar(
        backgroundColor: profilePageBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: appDarkText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: appDarkText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: [
            _buildProfileImage(),
            const SizedBox(height: 16),
            if (_userName != null)
              Text(
                _userName!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: appDarkText,
                ),
              ),
            // if (_userEmail != null)
            //   Text(
            //     _userEmail!,
            //     style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            //   ),
            const SizedBox(height: 30),
            _buildProfileMenuItem(
              icon: Icons.person_outline,
              title: 'My Account',
              onTap: () {
                // TODO: Navigate to My Account page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('My Account tapped!')),
                );
              },
            ),
            _buildProfileMenuItem(
              icon: Icons.notifications_none_outlined,
              title: 'Notifications',
              onTap: () {
                // TODO: Navigate to Notifications page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications tapped!')),
                );
              },
            ),
            _buildProfileMenuItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings tapped!')),
                );
              },
            ),
            _buildProfileMenuItem(
              icon: Icons.help_outline,
              title: 'Help Center',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Help Center tapped!')),
                );
              },
            ),
            _buildProfileMenuItem(
              icon: Icons.logout_outlined,
              title: 'Log Out',
              iconColor: Colors.red.shade700,
              isLogout: true,
              onTap: _showLogoutConfirmationDialog,
            ),
          ],
        ),
      ),
    );
  }
}
