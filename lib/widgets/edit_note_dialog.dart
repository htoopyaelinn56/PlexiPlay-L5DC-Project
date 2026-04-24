import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../supabase/note_controller.dart';
import '../theme/neo_theme.dart';

class EditNoteDialog extends ConsumerStatefulWidget {
  final int noteId;
  final String videoId;
  final String timestamp;
  final String initialNote;
  final VoidCallback onClose;

  const EditNoteDialog({
    super.key,
    required this.noteId,
    required this.videoId,
    required this.timestamp,
    required this.initialNote,
    required this.onClose,
  });

  @override
  ConsumerState<EditNoteDialog> createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends ConsumerState<EditNoteDialog> {
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.initialNote);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _handleEdit() {
    if (_noteController.text.trim().isEmpty) return;
    ref.read(noteControllerProvider.notifier).editNote(
          noteId: widget.noteId,
          note: _noteController.text.trim(),
          videoId: widget.videoId,
        );
    widget.onClose();
  }

  void _handleDelete() {
    ref.read(noteControllerProvider.notifier).deleteNote(
          noteId: widget.noteId,
          videoId: widget.videoId,
        );
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: NeoTheme.blue,
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Note at ${widget.timestamp}',
                  style: const TextStyle(
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
                  onPressed: widget.onClose,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: NeoTheme.white,
                border: Border.all(color: NeoTheme.black, width: 2),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(color: NeoTheme.black, offset: Offset(2, 2)),
                ],
              ),
              child: TextField(
                controller: _noteController,
                maxLines: 3,
                style: const TextStyle(fontWeight: FontWeight.w600),
                decoration: const InputDecoration(
                  hintText: 'Type your awesome thoughts...',
                  hintStyle: TextStyle(fontWeight: FontWeight.w500),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _handleDelete,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: NeoTheme.pink,
                      border: Border.all(color: NeoTheme.black, width: 2),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(color: NeoTheme.black, offset: Offset(2, 2)),
                      ],
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: NeoTheme.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _handleEdit,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: NeoTheme.yellow,
                      border: Border.all(color: NeoTheme.black, width: 2),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(color: NeoTheme.black, offset: Offset(2, 2)),
                      ],
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: NeoTheme.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


