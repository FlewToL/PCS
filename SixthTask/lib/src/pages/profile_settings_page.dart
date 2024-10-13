import 'package:flutter/material.dart';
import 'package:shop_app/src/objects/profile_class.dart';
import 'package:shop_app/src/pages/edit_settings_page.dart';
import 'dart:io';

class ProfileSettingsPage extends StatefulWidget {
  final ProfileSettings profSettItem;

  const ProfileSettingsPage({
    super.key,
    required this.profSettItem,
  });

  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  Widget _buildImage(String imgPath) {
    Widget imageWidget;

    if (imgPath.startsWith('assets/')) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Image.asset(
          imgPath,
          height: 200,
          width: 200,
          fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return const Icon(
              Icons.image_not_supported,
              size: 200,
              color: Colors.grey,
            );
          },
        ),
      );
    } else {
      File imageFile = File(imgPath);
      if (imageFile.existsSync()) {
        imageWidget = ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: Image.file(
            imageFile,
            height: 200,
            width: 200,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return const Icon(
                Icons.image_not_supported,
                size: 200,
                color: Colors.grey,
              );
            },
          ),
        );
      } else {
        imageWidget = const Icon(
          Icons.image_not_supported,
          size: 200,
          color: Colors.grey,
        );
      }
    }

    return Center(
      child: imageWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    var profSettItem = widget.profSettItem;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Настройки',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // Навигация к экрану редактирования
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditSettingsScreen(profSettItem: profSettItem),
                ),
              );

              // Обновление состояния после возврата
              setState(() {});
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(profSettItem.img),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          'Личные данные',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          profSettItem.phoneNumber,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          '${profSettItem.name} ${profSettItem.lastName}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          'E-mail',
                          style: TextStyle(
                            color: Color(0xFF999999),
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          profSettItem.email,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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
