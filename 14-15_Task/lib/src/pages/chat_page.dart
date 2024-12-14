import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String role;
  final String? chatWithUsername;
  final VoidCallback? onMessageSent;

  const ChatScreen(
      {Key? key,
      required this.userId,
      required this.role,
      this.chatWithUsername,
      this.onMessageSent})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _messageController = TextEditingController();
  List<dynamic> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _subscribeToMessages();
  }

  void _fetchMessages() async {
    try {
      final response = await supabase
          .from('messages')
          .select()
          .eq('user_id', widget.userId)
          .order('created_at', ascending: true);

      setState(() {
        _messages = (response as List<dynamic>).reversed.toList();
      });
    } catch (e) {
      print('Ошибка загрузки сообщений: $e');
    }
  }

  void _subscribeToMessages() {
    supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('user_id', widget.userId)
        .order('created_at')
        .listen((List<dynamic> event) {
          setState(() {
            _messages = event;
          });
        });
  }

  void _sendMessage(String message) async {
    if (message.isEmpty) return;

    try {
      final response;

      if (widget.role == 'user') {
        response = await supabase.from('messages').insert({
          'user_id': widget.userId,
          'message': message,
          'is_support': false,
        }).select();
      } else {
        response = await supabase.from('messages').insert({
          'user_id': widget.userId,
          'message': message,
          'is_support': true,
        }).select();
      }

      if (response.isNotEmpty) {
        _messageController.clear();

        setState(() {
          _messages.insert(0, response.first);
        });
        widget.onMessageSent?.call();
      } else {
        print('Ошибка отправки сообщения: сервер не вернул данные.');
      }
    } catch (e) {
      print('Ошибка отправки сообщения: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSupport = widget.role == 'admin';
    final chatTitle =
        isSupport ? widget.chatWithUsername ?? 'Пользователь' : 'Поддержка';
    final userId = isSupport ? widget.userId ?? '' : '';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              chatTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            if (userId.isNotEmpty)
              Text(
                userId,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          SizedBox(height: 240,),
                          Icon(
                            Icons.headset_mic_rounded,
                            size: 50,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 4,),
                          Text(
                            'Здравствуйте!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            'Задавайте любой вопрос, и мы постараемся вам помочь!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF555555),
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      )
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isCurrentUser = widget.role == 'admin'
                          ? message['is_support'] == true
                          : message['is_support'] == false;

                      final messageTime =
                          DateTime.tryParse(message['created_at'] ?? '') ??
                              DateTime.now();
                      final formattedTime =
                          '${messageTime.hour}:${messageTime.minute.toString().padLeft(2, '0')}';

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        child: Align(
                          alignment: isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * (4 / 5), // Максимальная ширина — 2/3 экрана
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: isCurrentUser
                                    ? const Color(0xFFE1F8CD)
                                    : const Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(20),
                                  topRight: const Radius.circular(20),
                                  bottomLeft: isCurrentUser
                                      ? const Radius.circular(20)
                                      : const Radius.circular(4),
                                  bottomRight: isCurrentUser
                                      ? const Radius.circular(4)
                                      : const Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    message['message'] ?? '',
                                    style: const TextStyle(
                                      color: Color(0xFF111111),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    formattedTime,
                                    style: TextStyle(
                                      color: isCurrentUser
                                          ? const Color(0xFF64a358)
                                          : const Color(0xFF888888),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: TextField(
                      cursorColor: const Color(0xFF60CA00),
                      controller: _messageController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFEEEEEE),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Введите сообщение',
                        hintStyle: const TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => _sendMessage(_messageController.text),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF60CA00),
                    shape: const CircleBorder(),
                    fixedSize: const Size(46.0, 46.0),
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
