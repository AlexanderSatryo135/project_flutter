import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const ProfileScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = widget.isDarkMode;
    final Color cardColor = isDarkMode
        ? Colors.black.withOpacity(0.9)
        : const Color.fromARGB(255, 24, 43, 95).withOpacity(0.9);
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color subtitleColor = isDarkMode ? Colors.grey[300]! : Colors.grey;

    return Scaffold(
      appBar: AppBar(
        title: Text('title'.tr(), style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.black : const Color.fromARGB(255, 24, 43, 95),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Locale>(
                value: context.locale,
                onChanged: (locale) {
                  if (locale != null) context.setLocale(locale);
                },
                borderRadius: BorderRadius.circular(8),
                elevation: 2,
                dropdownColor: Colors.white.withOpacity(0.95),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                icon: const SizedBox.shrink(),
                items: const [
                  DropdownMenuItem(
                    value: Locale('en'),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Text('EN'),
                    ),
                  ),
                  DropdownMenuItem(
                    value: Locale('id'),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Text('ID'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
            color: Colors.white,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : const AssetImage('assets/dhito.jpg') as ImageProvider,
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Color.fromARGB(255, 255, 255, 255)),
                            onPressed: _pickImage,
                            tooltip: 'Change Profile Picture',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'name'.tr(),
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'nrp'.tr(),
                        style: TextStyle(fontSize: 18, color: subtitleColor),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'desc'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: textColor),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Info'),
                              content: Text('details'.tr()),
                            ),
                          );
                        },
                        icon: const Icon(Icons.info_outline),
                        label: Text('view_detail'.tr()),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          backgroundColor: const Color(0xFF37769B),
                          foregroundColor: Colors.white
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => _launchURL('https://maps.app.goo.gl/p3kyjL6Q4L5kHK3Y6'),
                        icon: const Icon(Icons.location_on),
                        label: Text('view_location'.tr()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF37769B),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          foregroundColor: Colors.white
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.link, color: textColor),
                            tooltip: 'GitHub',
                            onPressed: () => _launchURL('https://github.com/AlexanderSatryo135'),
                          ),
                          IconButton(
                            icon: Icon(Icons.account_circle, color: textColor),
                            tooltip: 'LinkedIn',
                            onPressed: () => _launchURL('https://www.linkedin.com/in/alexandersatryop'),
                          ),
                          IconButton(
                            icon: Icon(Icons.camera_alt, color: textColor),
                            tooltip: 'Instagram',
                            onPressed: () => _launchURL('https://instagram.com/alexandersatryoo'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
