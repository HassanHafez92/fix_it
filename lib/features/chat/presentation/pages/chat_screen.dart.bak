// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fix_it/core/theme/app_theme.dart';
import 'package:fix_it/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fix_it/core/di/injection_container.dart';
import 'package:fix_it/core/utils/bloc_utils.dart';
import 'package:fix_it/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:fix_it/core/services/file_upload_service.dart';
import 'package:fix_it/features/chat/presentation/widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUserId;
  final String otherUserName;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load chat messages when screen opens. Defer to post-frame to ensure
    // provider is available in the widget tree.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      safeAddEvent<ChatBloc>(context, LoadChatMessagesEvent(chatId: widget.chatId));
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUserName),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showChatOptions(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatMessagesLoaded) {
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      return MessageBubble(
                        message: message,
                        isMe: message.senderId ==
                            'current_user_id', // Replace with actual current user ID
                      );
                    },
                  );
                } else if (state is ChatError) {
                  return Center(
                    child: Text('Error: ${state.message}'),
                  );
                }
                return const Center(child: Text('Start a conversation'));
              },
            ),
          ),

          // Message input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Attachment button
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              _showAttachmentOptions(context);
            },
            color: AppTheme.primaryColor,
          ),

          // Text input
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: null,
            ),
          ),

          const SizedBox(width: 8),

          // Send button
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              final isSending = state is ChatSending;

              return IconButton(
                icon: isSending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send),
                onPressed: isSending || _messageController.text.trim().isEmpty
                    ? null
                    : () {
                        _sendMessage();
                      },
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      safeAddEvent<ChatBloc>(
        context,
        SendMessageEvent(
          chatId: widget.chatId,
          message: _messageController.text.trim(),
        ),
      );

      _messageController.clear();

      // Scroll to bottom after a short delay to allow the message to be added
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _showChatOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('View Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/provider-details',
                  arguments: {'providerId': widget.otherUserId},
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Block User'),
              onTap: () {
                Navigator.pop(context);
                _showBlockConfirmation(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Chat',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUpload(fromCamera: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUpload(fromCamera: false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Location'),
              onTap: () {
                Navigator.pop(context);
                _sendLocation();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickAndUpload({required bool fromCamera}) async {
    try {
      final uploader = sl<FileUploadService>();

      // Pick file using centralized service which handles permissions
      File? file;
      if (fromCamera) {
        file = await uploader.pickImageFromCamera();
      } else {
        file = await uploader.pickImageFromGallery();
      }

      if (file == null) return;
      if (!mounted) return;

      // Ask for optional caption
      final caption = await showDialog<String?>(
        context: context,
        builder: (context) {
          final TextEditingController captionController =
              TextEditingController();
          return AlertDialog(
            title: const Text('Add a caption (optional)'),
            content: TextField(
              controller: captionController,
              decoration: const InputDecoration(hintText: 'Say something...'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(captionController.text.trim()),
                child: const Text('Send'),
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      // Show temporary indicator
      final snack = ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uploading image...')),
      );

      final uploadedUrl = await uploader.uploadFile(file);

      // remove upload SnackBar
      snack.close();

      if (uploadedUrl == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image')),
        );
        return;
      }

      // Dispatch send with uploaded URL and optional caption
      if (!mounted) return;

      safeAddEvent<ChatBloc>(
        context,
        SendMessageEvent(
          chatId: widget.chatId,
          message: caption ?? '',
          attachmentUrl: uploadedUrl,
          attachmentType: 'image',
        ),
      );

      // Scroll to bottom after a short delay
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!mounted) return;
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick/upload image: $e')),
      );
    }
  }

  Future<void> _sendLocation() async {
    try {
      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Location permissions are permanently denied')),
        );
        return;
      }

      // Get position
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final lat = pos.latitude;
      final lng = pos.longitude;

      // Reverse geocode for human readable address
      String address = '';
      try {
        final placemarks = await placemarkFromCoordinates(lat, lng);
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          address = [p.street, p.locality, p.administrativeArea, p.country]
              .where((s) => s != null && s.isNotEmpty)
              .join(', ');
        }
      } catch (_) {
        address = '';
      }

      final attachmentUrl = '$lat,$lng';

      if (!mounted) return;
      safeAddEvent<ChatBloc>(
        context,
        SendMessageEvent(
          chatId: widget.chatId,
          message:
              address.isNotEmpty ? 'Location: $address' : 'Shared a location',
          attachmentUrl: attachmentUrl,
          attachmentType: 'location',
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    }
  }

  void _showBlockConfirmation(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Block User'),
          content:
              Text('Are you sure you want to block ${widget.otherUserName}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Close the confirmation dialog first
                Navigator.pop(dialogContext);

                // Persist blocked user id locally so the app can hide/ignore messages
                // from this user until a server-side block feature is implemented.
                try {
                  final prefs = await SharedPreferences.getInstance();
                  const blockedKey = 'blocked_users';
                  final blocked = prefs.getStringList(blockedKey) ?? <String>[];
                  if (!blocked.contains(widget.otherUserId)) {
                    blocked.add(widget.otherUserId);
                    await prefs.setStringList(blockedKey, blocked);
                  }
                } catch (_) {
                  // ignore errors - still proceed to notify the user
                }

                // Ensure both the State and the parent BuildContext are still mounted
                if (!mounted) return;

                // Check if parentContext is still valid before using it
                if (parentContext.mounted) {
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    SnackBar(
                      content: Text('${widget.otherUserName} has been blocked'),
                    ),
                  );
                }

                // Close the chat screen and return to the previous list
                if (parentContext.mounted) {
                  Navigator.pop(parentContext);
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Block'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Chat'),
          content: const Text(
              'Are you sure you want to delete this chat? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Close the confirmation dialog first
                Navigator.pop(dialogContext);

                // Perform local delete: clear cached messages and remove chat from cached chat list
                try {
                  final local = sl<ChatLocalDataSource>();

                  // Clear messages cache for this chat
                  await local.cacheChatMessages(widget.chatId, []);

                  // Remove chat from cached chat list if present
                  final chats = await local.getCachedChatList();
                  final updated =
                      chats.where((c) => c.id != widget.chatId).toList();
                  await local.cacheChatList(updated);
                } catch (_) {
                  // ignore errors - still proceed to notify the user
                }

                // Ensure both the State and the parent BuildContext are still mounted
                if (!mounted) return;

                // Check if parentContext is still valid before using it
                if (parentContext.mounted) {
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                  const SnackBar(
                    content: Text('Chat has been deleted'),
                  ),
                  );
                }

                // Close the chat screen and return to the previous list
                if (parentContext.mounted) {
                  Navigator.pop(parentContext);
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
