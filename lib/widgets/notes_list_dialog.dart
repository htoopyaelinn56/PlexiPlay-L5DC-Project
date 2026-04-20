import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../supabase/supabase_service.dart';
import '../theme/neo_theme.dart';

class NotesListDialog extends ConsumerWidget {
  final VoidCallback onClose;
  final String videoId;

  const NotesListDialog({
    super.key,
    required this.onClose,
    required this.videoId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(notesStreamProvider(videoId));
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 400),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: NeoTheme.green,
          border: Border.all(
            color: NeoTheme.black,
            width: NeoTheme.borderThick,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: NeoTheme.black, offset: Offset(6, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Saved Notes',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: NeoTheme.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: NeoTheme.black,
                    size: 28,
                  ),
                  onPressed: onClose,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: asyncValue.when(
                data: (data) {
                  if (data.isEmpty) {
                    return const Center(
                      child: Text(
                        'No notes yet! Add one at your current timestamp.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black54,
                          fontSize: 18,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: data.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final note = data[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: NeoTheme.white,
                          border: Border.all(color: NeoTheme.black, width: 2),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: NeoTheme.black,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '@ ${note.timestamp}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                color: NeoTheme.pink,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              note.note,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: NeoTheme.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                error: (e, st) {
                  return Center(
                    child: Text(
                      'Failed to load notes',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 20,
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
          ],
        ),
      ),
    );
  }
}

