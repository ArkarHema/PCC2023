import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class chatbot extends StatefulWidget {
  const chatbot({super.key});

  @override
  State<chatbot> createState() => _chatbotState();
}

class _chatbotState extends State<chatbot> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  final _bot = const types.User(id: '123');

  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Chat(
          messages: _messages,
          onSendPressed: _handleSendPressed,
          user: _user,
          // showUserAvatars: true,
        ),
      );

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  @override
  void initState() {
    // todo
    int adherenceScore = 50; //set adherence score and name here
    String userName = 'Nakul';
    String reply;
    if (adherenceScore < 40) {
      reply =
          "Hey $userName, your medicine adherence score is a bit low right now. Remember, taking your medicines on time is essential for your health. Let's work together to improve it! ";
    } else if (40 <= adherenceScore && adherenceScore <= 70) {
      reply =
          "Hi $userName! You're doing a decent job with your medicine adherence, but there's always room for improvement. Keep up the good work, and let's aim for an even higher score next time! ";
    } else {
      reply =
          "Wow, $userName! Your high medicine adherence score is truly commendable. You're taking excellent care of your health. Keep it up, and don't forget, I'm here to support you every step of the way! 🌟";
    }
    late final initialBotMessage = types.TextMessage(
      author: _bot,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: UniqueKey().toString(),
      text: reply,
    );
    _addMessage(initialBotMessage);
    super.initState();
  }

  Future<void> _handleSendPressed(types.PartialText message) async {
    final userMessage = message.text;
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: userMessage,
    );

    _addMessage(textMessage);

    // Send the user's message to ChatGPT API and get a reply
    final chatGPTReply = await _getChatGPTReply(userMessage);
    print(chatGPTReply);
    if (chatGPTReply != null) {
      final replyMessage = types.TextMessage(
        author: _bot,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: UniqueKey().toString(),
        text: chatGPTReply, // Generate the reply here.
      );

      _addMessage(replyMessage);
    } else {
      print("no reply");
    }
  }

  Future<String?> _getChatGPTReply(String userMessage) async {
    final apiKey = '${dotenv.env['OPENAPITOKEN']}';
    final endpoint = 'https://api.openai.com/v1/chat/completions';
    print("req started");
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content":
                "You are a casual friendly AI companion. You appreciate the user when he has a high medicine adherenceScore, else you motivate and encourage them to eat their medicines on time when the app reminds you to take. You will also provide mental health guidance . \nYou know the following details about the user\nname: \"Harsha\",\nadherenceScore: 16(out of 100)"
          },
          {"role": "user", "content": userMessage}
        ],
        "temperature": 1,
        "max_tokens": 50,
        "top_p": 1,
        "frequency_penalty": 0,
        "presence_penalty": 0,
      }),
    );
    print("req ended");
    print(response);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final choices = data['choices'] as List<dynamic>;

      if (choices.isNotEmpty) {
        final message = choices[0]['message'] as Map<String, dynamic>;
        final content = message['content'] as String;
        return content;
      }
    } else {
      // Handle API errors here
      print('ChatGPT API error: ${response.statusCode}');
      return null;
    }
  }
}
