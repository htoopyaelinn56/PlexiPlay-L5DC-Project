import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';
import '../widgets/neo_back_button.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoTheme.cream,
      appBar: AppBar(
        leading: const Row(
          children: [SizedBox(width: 20), NeoBackButton()],
        ),
        leadingWidth: 64,
        title: const Text('About', style: TextStyle(color: NeoTheme.black, fontWeight: FontWeight.w900)),
        backgroundColor: NeoTheme.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: NeoTheme.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(color: NeoTheme.black, height: 3),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    border: Border.all(color: NeoTheme.black, width: 3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: NeoTheme.black,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'PlexiPlay',
                  style: TextStyle(
                    color: NeoTheme.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Version 0.1.0',
              style: TextStyle(
                color: NeoTheme.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const DonateDialog(),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: NeoTheme.yellow,
                  border: Border.all(color: NeoTheme.black, width: 3),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: NeoTheme.black, offset: Offset(4, 4)),
                  ],
                ),
                child: const Text(
                  'Donate',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: NeoTheme.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DonateDialog extends StatefulWidget {
  const DonateDialog({super.key});

  @override
  State<DonateDialog> createState() => _DonateDialogState();
}

class _DonateDialogState extends State<DonateDialog> {
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
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
                const Text(
                  'Donate',
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
                  onPressed: () => Navigator.pop(context),
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
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontWeight: FontWeight.w600),
                decoration: const InputDecoration(
                  hintText: 'Enter amount...',
                  hintStyle: TextStyle(fontWeight: FontWeight.w500),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                  prefixText: '\$ ',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    final amount = _amountController.text.trim();
                    if (amount.isNotEmpty) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Donated \$$amount successfully!'),
                          backgroundColor: NeoTheme.black,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
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
                      'Donate Now',
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
