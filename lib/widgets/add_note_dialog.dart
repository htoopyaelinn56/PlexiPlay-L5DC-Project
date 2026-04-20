import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/neo_theme.dart';

class AddNoteDialog extends ConsumerStatefulWidget {
  final String timestamp;
  final VoidCallback onClose;
  final Function(String) onSave;

  const AddNoteDialog({
    super.key,
    required this.timestamp,
    required this.onClose,
    required this.onSave,
  });

  @override
  ConsumerState<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends ConsumerState<AddNoteDialog> {
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
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
                  'Note at ${widget.timestamp}',
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onSave(_noteController.text.trim());
                  },
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
                      'Save Note',
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

