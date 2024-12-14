import 'package:flutter/material.dart';
import 'package:shop_app/src/service/food_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart'; // Импортируем пакет intl

import 'chat_page.dart';

class AdminChatList extends StatefulWidget {
  const AdminChatList({Key? key}) : super(key: key);

  @override
  _AdminChatListState createState() => _AdminChatListState();
}

class _AdminChatListState extends State<AdminChatList> {
  final SupabaseClient supabase = Supabase.instance.client;
  final foodService = FoodService();
  List<Map<String, dynamic>> _userList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsersWithMessages();
  }

  void _fetchUsersWithMessages() async {
    try {
      final users = await foodService.fetchUsers();

      final supabaseResponse = await supabase
          .from('messages')
          .select('user_id, message, created_at')
          .order('created_at', ascending: false);

      if (supabaseResponse is List<dynamic>) {
        final Map<String, Map<String, dynamic>> latestMessages = {};
        for (var message in supabaseResponse) {
          final userId = message['user_id'];
          if (!latestMessages.containsKey(userId)) {
            latestMessages[userId] = {
              'message': message['message'] ?? '',
              'created_at': message['created_at'] ?? '',
            };
          }
        }

        final List<Map<String, dynamic>> usersWithMessages = users
            .where((user) => latestMessages.containsKey(user['id']))
            .map((user) => {
                  'user_id': user['id'] ?? 'Unknown ID',
                  'username': user['name'] ?? 'Неизвестный пользователь',
                  'last_message': latestMessages[user['id']]?['message'] ?? '',
                  'last_message_time':
                      latestMessages[user['id']]?['created_at'] ?? '',
                })
            .toList();

        usersWithMessages.sort((a, b) {
          final timeA = DateTime.tryParse(a['last_message_time']);
          final timeB = DateTime.tryParse(b['last_message_time']);

          if (timeA != null && timeB != null) {
            return timeB.compareTo(timeA);
          }
          return 0;
        });

        setState(() {
          _userList = usersWithMessages;
          _isLoading = false;
        });
      } else {
        print('Ошибка: Пустой или некорректный ответ от Supabase');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Ошибка загрузки пользователей: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatTime(String timestamp) {
    final DateTime? time = DateTime.tryParse(timestamp);
    if (time != null) {
      final DateFormat dateFormat = DateFormat('HH:mm');
      return dateFormat.format(time);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Диалоги с пользователями",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userList.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 50,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Нет пользователей с сообщениями',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: 340,
                        child: Text(
                          'Когда появятся сообщения, они отобразятся здесь',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF333333),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _userList.length,
                  itemBuilder: (context, index) {
                    final user = _userList[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              userId: user['user_id'] ?? 'Unknown ID',
                              role: 'admin',
                              chatWithUsername: user['username'] ??
                                  'Неизвестный пользователь',
                              onMessageSent: _fetchUsersWithMessages,
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.125),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFEFEF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                color: Colors.black,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['user_id'] ?? 'Unknown ID',
                                    style: const TextStyle(
                                      color: Color(0xFF888888),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    user['username'] ??
                                        'Неизвестный пользователь',
                                    style: const TextStyle(
                                      color: Color(0xFF222222),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Text(
                                        '${_formatTime(user['last_message_time'])} :' ??
                                            '',
                                        style: const TextStyle(
                                          color: Color(0xFF777777),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          user['last_message'] ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Color(0xFF777777),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
