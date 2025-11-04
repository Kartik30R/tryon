import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tryon/controller/app_provider.dart';
 
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Consumer to rebuild when currentUser or auth state changes
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final user = appProvider.currentUser;

        return Scaffold(
          backgroundColor: const Color(0xffF3F3F3),
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Profile',
              style: GoogleFonts.poppins(color: Colors.black),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: user == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      // User Info Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            _ProfileInfoTile(
                              icon: Icons.person_outline,
                              title: 'Name',
                              subtitle: user.name,
                            ),
                            const Divider(height: 20),
                            _ProfileInfoTile(
                              icon: Icons.email_outlined,
                              title: 'Email',
                              subtitle: user.email,
                            ),
                            const Divider(height: 20),
                            _ProfileInfoTile(
                              icon: Icons.phone_outlined,
                              title: 'Phone',
                              subtitle: user.phone,
                            ),
                            const Divider(height: 20),
                            _ProfileInfoTile(
                              icon: Icons.location_on_outlined,
                              title: 'Address',
                              subtitle: user.address,
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Logout Button
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SizedBox(
                            height: 55,
                            width: 200,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black),
                              onPressed: () {
                                // Call the logout method from the provider
                                // The AuthWrapper will handle navigation
                                context.read<AppProvider>().logout();
                              },
                              child: Text(
                                "Logout",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

// Helper widget for a consistent profile tile
class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isLast;

  const _ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey[600], size: 28),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  color: Colors.black,
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
