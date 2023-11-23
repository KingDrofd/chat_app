import 'dart:async';

import 'package:chat_app/components/custom_text_field.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  final String recieverUserEmail;
  final String recieverUserId;
  const ChatPage(
      {super.key,
      required this.recieverUserEmail,
      required this.recieverUserId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.recieverUserId, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _scrollDown();
            },
            icon: Icon(Icons.arrow_downward),
          ),
        ],
        backgroundColor: Colors.grey[800],
        title: Text(widget.recieverUserEmail),
      ),
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            "assets/whastsappBg.jpg",
            colorBlendMode: BlendMode.color,
            color: Colors.grey,
            fit: BoxFit.fitWidth,
            repeat: ImageRepeat.repeatY,
          ),
          Column(
            verticalDirection: VerticalDirection.down,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Container(child: _buildMessageList()),
              ),
              _buildMessageInput()
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.recieverUserId,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("loading...");
        }

        return ListView(
          reverse: false,
          itemExtent: snapshot.data!.docs.length.toDouble(),
          controller: _scrollController,
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Gap(10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: (data['senderId'] == _firebaseAuth.currentUser!.uid)
                    ? Colors.grey[800]
                    : Colors.green,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  data['message'],
                  style: GoogleFonts.roboto(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              onTap: () {
                Timer(Duration(milliseconds: 250), () {
                  _scrollDown();
                });
              },
              controller: _messageController,
              hintText: "Enter message",
            ),
          ),
          IconButton(
            onPressed: () {
              sendMessage();
              Timer(Duration(milliseconds: 250), () {
                _scrollDown();
              });
            },
            icon: Icon(
              Icons.send,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
