import 'package:flutter/material.dart';
// import 'package:fix_it/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fix_it/core/utils/bloc_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fix_it/l10n/app_localizations.dart';

import 'package:fix_it/core/utils/app_routes.dart';
import '../../../chat/presentation/bloc/chat_list_bloc/chat_list_bloc.dart';
import '../../../chat/presentation/widgets/chat_list_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fix_it/core/di/injection_container.dart';
import 'package:fix_it/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:fix_it/features/chat/data/models/chat_model.dart';

/// Chat tab of the main dashboard
///
/// Provides communication features:
/// - View all active chats with service providers
/// - Start new conversations
/// - Quick access to recent messages
/// - Real-time chat updates
class DashboardChatTab extends StatefulWidget {
  const DashboardChatTab({super.key});

  @override
  State<DashboardChatTab> createState() => _DashboardChatTabState();
}

class _DashboardChatTabState extends State<DashboardChatTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
    // Load chat list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      safeAddEvent<ChatListBloc>(context, LoadChatListEvent());
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
    _searchController.dispose();
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context, theme),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            _buildSearchSection(context, theme),
            Expanded(
              child: _buildChatList(context, theme),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewChatOptions(context);
        },
        backgroundColor: theme.primaryColor,
        child: Icon(Icons.add_comment),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        AppLocalizations.of(context)!.messages,
        style: GoogleFonts.cairo(
          color: theme.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        BlocBuilder<ChatListBloc, ChatListState>(
          builder: (context, state) {
            int unreadCount = 0;
            if (state is ChatListLoaded) {
              unreadCount =
                  state.chats.where((chat) => chat.unreadCount > 0).length;
            }

            return Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.mark_email_read, color: theme.primaryColor),
                  onPressed: () {
                    safeAddEvent<ChatListBloc>(context, LoadChatListEvent());
                  },
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        unreadCount > 9 ? '9+' : unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'archived':
                _showArchivedChats();
                break;
              case 'blocked':
                _showBlockedUsers();
                break;
              case 'settings':
                Navigator.pushNamed(context, AppRoutes.settings);
                break;
              case 'mark_read':
                _markAllAsRead();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'archived',
              child: Row(
                children: [
                  Icon(Icons.archive),
                  SizedBox(width: 8),
                  Text('Archived Chats'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'blocked',
              child: Row(
                children: [
                  Icon(Icons.block),
                  SizedBox(width: 8),
                  Text('Blocked Users'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings),
                  SizedBox(width: 8),
                  Text('Chat Settings'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'mark_read',
              child: Row(
                children: [
                  Icon(Icons.mark_email_read),
                  SizedBox(width: 8),
                  Text('Mark all as read'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchSection(BuildContext context, ThemeData theme) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.searchConversationsHint,
            hintStyle: GoogleFonts.cairo(color: Colors.grey[600]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          style: GoogleFonts.cairo(),
        ),
      ),
    );
  }

  Widget _buildChatList(BuildContext context, ThemeData theme) {
    return BlocBuilder<ChatListBloc, ChatListState>(
      builder: (context, state) {
        if (state is ChatListLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ChatListError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load chats',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    safeAddEvent<ChatListBloc>(context, LoadChatListEvent());
                  },
                  child: Text(AppLocalizations.of(context)!.tryAgain),
                ),
              ],
            ),
          );
        }

        if (state is ChatListLoaded) {
          var chats = state.chats;

          // Filter chats based on search query
          if (_searchQuery.isNotEmpty) {
            chats = chats.where((chat) {
              return chat.otherUserName
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()) ||
                  (chat.lastMessage
                          ?.toLowerCase()
                          .contains(_searchQuery.toLowerCase()) ??
                      false);
            }).toList();
          }

          if (chats.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _searchQuery.isNotEmpty
                        ? Icons.search_off
                        : Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
              ? AppLocalizations.of(context)!.noMatchingConversations
              : AppLocalizations.of(context)!.noConversationsYet,
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _searchQuery.isNotEmpty
                        ? AppLocalizations.of(context)!.trySearchingDifferentKeywords
                        : AppLocalizations.of(context)!.startConversationWithProvider,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_searchQuery.isEmpty) ...[
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.services);
                      },
                      child: Text(AppLocalizations.of(context)!.services),
                    ),
                  ],
                ],
              ),
            );
          }

          return Container(
            color: Colors.grey[50],
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: chats.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey[300],
                indent: 72,
              ),
              itemBuilder: (context, index) {
                final chat = chats[index];
                return GestureDetector(
                  onLongPress: () {
                    _showChatOptions(context, chat.id);
                  },
                  child: ChatListItem(
                    chat: chat,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.chat,
                        arguments: {
                          'chatId': chat.id,
                          'participantName': chat.otherUserName,
                          'participantAvatar': chat.otherUserProfileImage,
                        },
                      );
                    },
                  ),
                );
              },
            ),
          );
        }

        return const Center(
          child: Text('Unknown state'),
        );
      },
    );
  }

  Future<void> _onRefresh() async {
  safeAddEvent<ChatListBloc>(context, LoadChatListEvent());
  }

  void _markAllAsRead() {
    // Mark all cached chats as read locally and refresh the chat list
    () async {
      try {
        final local = sl<ChatLocalDataSource>();
        final chats = await local.getCachedChatList();

        final updated = chats.map((c) {
          return ChatModel(
            id: c.id,
            userId: c.userId,
            otherUserId: c.otherUserId,
            otherUserName: c.otherUserName,
            otherUserProfileImage: c.otherUserProfileImage,
            lastMessage: c.lastMessage,
            lastMessageTime: c.lastMessageTime,
            unreadCount: 0,
            createdAt: c.createdAt,
          );
        }).toList();

        await local.cacheChatList(updated);
        // Trigger reload
        if (mounted) {
          safeAddEvent<ChatListBloc>(context, LoadChatListEvent());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.allChatsMarkedRead)),
          );
        }
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.failedToMarkChatsRead)),
          );
        }
      }
    }();
  }

  void _showNewChatOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.startNewConversation,
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
                ListTile(
                leading: const Icon(Icons.search),
                title: Text(AppLocalizations.of(context)!.findServiceProvider),
                subtitle: Text(AppLocalizations.of(context)!.searchAndMessageProviders),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.providers);
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: Text(AppLocalizations.of(context)!.fromRecentBookings),
                subtitle: Text(AppLocalizations.of(context)!.messageProvidersFromBookings),
                onTap: () {
                  Navigator.pop(context);
                  _showRecentProviders(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.support_agent),
                title: Text(AppLocalizations.of(context)!.contactSupport),
                subtitle: Text(AppLocalizations.of(context)!.getHelpFromSupport),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.contactSupport);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChatOptions(BuildContext context, String chatId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.archive),
                title: const Text('Archive Chat'),
                onTap: () {
                  Navigator.pop(context);
                  _archiveChat(chatId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.volume_off),
                title: const Text('Mute Notifications'),
                onTap: () {
                  Navigator.pop(context);
                  _muteChat(chatId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text('Block User',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _blockUser(chatId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete Chat',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _deleteChat(chatId);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showArchivedChats() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => FutureBuilder<List<String>>(
        future: () async {
          final prefs = await SharedPreferences.getInstance();
          return prefs.getStringList('archived_chats') ?? <String>[];
        }(),
        builder: (context, snap) {
          final archived = snap.data ?? <String>[];
          if (snap.connectionState != ConnectionState.done) {
            return const SizedBox(
                height: 200, child: Center(child: CircularProgressIndicator()));
          }
          if (archived.isEmpty) {
            return SizedBox(
              height: 200,
              child: Center(child: Text('No archived chats')),
            );
          }
          return SizedBox(
            height: 300,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: archived.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) => ListTile(
                title: Text(archived[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showBlockedUsers() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return FutureBuilder<List<String>>(
          future: () async {
            final prefs = await SharedPreferences.getInstance();
            return prefs.getStringList('blocked_users') ?? <String>[];
          }(),
          builder: (context, snap) {
            final blocked = snap.data ?? <String>[];
            if (snap.connectionState != ConnectionState.done) {
              return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()));
            }
            if (blocked.isEmpty) {
              return SizedBox(
                  height: 200, child: Center(child: Text('No blocked users')));
            }

            // Map IDs to names using cached chats when available
            final localChatsFuture =
                sl<ChatLocalDataSource>().getCachedChatList();

            return FutureBuilder(
              future: localChatsFuture,
              builder: (c2, snap2) {
                final chats = snap2.data ?? <ChatModel>[];
                return SizedBox(
                  height: 300,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: blocked.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final id = blocked[index];
                      final match = chats.firstWhere(
                        (ch) => ch.otherUserId == id,
                        orElse: () => ChatModel(
                          id: id,
                          userId: '',
                          otherUserId: id,
                          otherUserName: id,
                          otherUserProfileImage: null,
                          lastMessage: null,
                          lastMessageTime: null,
                          unreadCount: 0,
                          createdAt: DateTime.now(),
                        ),
                      );

                      return ListTile(
                        title: Text(match.otherUserName),
                        subtitle: Text(match.otherUserId),
                        trailing: TextButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final list = prefs.getStringList('blocked_users') ??
                                <String>[];
                            list.remove(id);
                            await prefs.setStringList('blocked_users', list);
                            if (!mounted) return;
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(content: Text('User unblocked')),
                            );
                            // refresh this sheet by rebuilding
                            setState(() {});
                          },
              child: const Text('Unblock',
                style: TextStyle(color: Colors.red)),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showRecentProviders(BuildContext context) {
    // Build a list of recent providers from cached chats
    final state = context.read<ChatListBloc>().state;
    List<ChatModel> chats = [];
    if (state is ChatListLoaded) {
      chats =
          state.chats.map((c) => ChatModel.fromEntity(c as dynamic)).toList();
    }

    final providers = <String, String>{};
    for (var c in chats) {
      providers[c.otherUserId] = c.otherUserName;
    }

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SizedBox(
        height: 320,
        child: providers.isEmpty
            ? const Center(child: Text('No recent providers'))
            : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: providers.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final entry = providers.entries.elementAt(index);
                  return ListTile(
                    title: Text(entry.value),
                    subtitle: Text(entry.key),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.providerDetails,
                          arguments: {'providerId': entry.key});
                    },
                  );
                },
              ),
      ),
    );
  }

  void _archiveChat(String chatId) {
    () async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final archived = prefs.getStringList('archived_chats') ?? <String>[];
        if (!archived.contains(chatId)) {
          archived.add(chatId);
          await prefs.setStringList('archived_chats', archived);
        }

        final local = sl<ChatLocalDataSource>();
        final chats = await local.getCachedChatList();
        final updated = chats.where((c) => c.id != chatId).toList();
        await local.cacheChatList(updated);

        if (mounted) {
          safeAddEvent<ChatListBloc>(context, LoadChatListEvent());
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Chat archived')));
        }
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to archive chat')));
        }
      }
    }();
  }

  void _muteChat(String chatId) {
    () async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final muted = prefs.getStringList('muted_chats') ?? <String>[];
        if (!muted.contains(chatId)) {
          muted.add(chatId);
          await prefs.setStringList('muted_chats', muted);
        }
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Chat muted')));
        }
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to mute chat')));
        }
      }
    }();
  }

  void _blockUser(String chatId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Block User'),
        content: const Text(
            'Are you sure you want to block this user? You won\'t receive messages from them.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                final local = sl<ChatLocalDataSource>();
                final chats = await local.getCachedChatList();
                final match = chats.firstWhere((c) => c.id == chatId,
                    orElse: () => throw Exception('Not found'));
                final otherId = match.otherUserId;

                final prefs = await SharedPreferences.getInstance();
                final blocked =
                    prefs.getStringList('blocked_users') ?? <String>[];
                if (!blocked.contains(otherId)) {
                  blocked.add(otherId);
                  await prefs.setStringList('blocked_users', blocked);
                }

                // remove chat locally
                final updated = chats.where((c) => c.id != chatId).toList();
                await local.cacheChatList(updated);

                if (mounted) {
                  safeAddEvent<ChatListBloc>(context, LoadChatListEvent());
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User blocked')));
                }
              } catch (_) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to block user')));
                }
              }
            },
            child: const Text('Block', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteChat(String chatId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Chat'),
        content: const Text(
            'Are you sure you want to delete this conversation? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                final local = sl<ChatLocalDataSource>();
                await local.cacheChatMessages(chatId, []);
                final chats = await local.getCachedChatList();
                final updated = chats.where((c) => c.id != chatId).toList();
                await local.cacheChatList(updated);
                if (mounted) {
                  safeAddEvent<ChatListBloc>(context, LoadChatListEvent());
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Chat deleted')));
                }
              } catch (_) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to delete chat')));
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
