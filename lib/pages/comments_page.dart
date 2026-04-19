import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plexi_play/supabase/supabase_service.dart';
import '../supabase/comment_controller.dart';
import '../theme/neo_theme.dart';
import '../widgets/neo_back_button.dart';

class CommentsPage extends ConsumerStatefulWidget {
  final String videoId;

  const CommentsPage({super.key, required this.videoId});

  @override
  ConsumerState<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends ConsumerState<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isButtonPressed = false;

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    ref
        .read(commentControllerProvider.notifier)
        .addComment(videoId: widget.videoId, comment: text);

    // Scroll to bottom after adding a new comment
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(commentControllerProvider);
    ref.listen(commentControllerProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          _commentController.clear();
        },
        error: (e, st) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.redAccent,
            ),
          );
        },
      );
    });
    return Scaffold(
      backgroundColor: NeoTheme.cream,
      appBar: AppBar(
        backgroundColor: NeoTheme.white,
        elevation: 0,
        centerTitle: false,
        leading: Row(
          children: [const SizedBox(width: 20), const NeoBackButton()],
        ),
        leadingWidth: 64,
        title: Text(
          'Comments',
          style: const TextStyle(
            color: NeoTheme.black,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(color: NeoTheme.black, height: 3),
        ),
      ),
      body: SafeArea(
        child: ref
            .watch(commentsStreamProvider(widget.videoId))
            .when(
              data: (data) {
                return Column(
                  children: [
                    // Comments List
                    Expanded(
                      child: data.isEmpty
                          ? Center(
                              child: Text(
                                'No comments yet! Comment here to be the first one.',
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(
                                16,
                              ).copyWith(left: 20, right: 20),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final comment = data[index];
                                final avatarColor = NeoTheme.yellow;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Avatar
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: avatarColor,
                                          border: Border.all(
                                            color: NeoTheme.black,
                                            width: NeoTheme.borderThick,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: NeoTheme.black,
                                              offset: Offset(2, 2),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            comment.username
                                                .substring(0, 1)
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Comment Body
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  comment.username,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 14,
                                                    color: NeoTheme.black,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  DateFormat(
                                                    'MMM d, yyyy hh:mm:ss',
                                                  ).format(comment.createdAt),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: NeoTheme.white,
                                                border: Border.all(
                                                  color: NeoTheme.black,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                      topRight: Radius.circular(
                                                        12,
                                                      ),
                                                      bottomLeft:
                                                          Radius.circular(12),
                                                      bottomRight:
                                                          Radius.circular(12),
                                                      topLeft: Radius.circular(
                                                        2,
                                                      ), // Pointy chat bubble tail
                                                    ),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: NeoTheme.black,
                                                    offset: Offset(3, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Text(
                                                comment.comment,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                  color: NeoTheme.black,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    // Floating Comment Input Area
                    Container(
                      padding: const EdgeInsets.all(16).copyWith(top: 12),
                      decoration: const BoxDecoration(
                        color: NeoTheme.cream,
                        border: Border(
                          top: BorderSide(
                            color: NeoTheme.black,
                            width: NeoTheme.borderThick,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: NeoTheme.white,
                                border: Border.all(
                                  color: NeoTheme.black,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: const [
                                  BoxShadow(
                                    color: NeoTheme.black,
                                    offset: Offset(3, 3),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _commentController,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Add a comment...',
                                  hintStyle: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTapDown: (_) =>
                                setState(() => _isButtonPressed = true),
                            onTapCancel: () =>
                                setState(() => _isButtonPressed = false),
                            onTapUp: (_) {
                              setState(() => _isButtonPressed = false);
                              _addComment();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeInOut,
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: NeoTheme.pink,
                                border: Border.all(
                                  color: NeoTheme.black,
                                  width: 2,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: _isButtonPressed
                                    ? []
                                    : const [
                                        BoxShadow(
                                          color: NeoTheme.black,
                                          offset: Offset(3, 3),
                                        ),
                                      ],
                              ),
                              transform: Matrix4.translationValues(
                                _isButtonPressed ? 3.0 : 0.0,
                                _isButtonPressed ? 3.0 : 0.0,
                                0.0,
                              ),
                              child: state.isLoading
                                  ? Padding(
                                      padding: EdgeInsetsGeometry.all(10),
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.send_rounded,
                                      color: NeoTheme.black,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              error: (e, st) {
                return Center(
                  child: Text(
                    'Error loading comments: $e',
                    style: const TextStyle(
                      color: NeoTheme.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(color: NeoTheme.black),
                );
              },
            ),
      ),
    );
  }
}
