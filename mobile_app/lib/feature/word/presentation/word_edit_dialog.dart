import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../util/constant/string_regex.dart';
import '../application/word_state.dart';
import '../domain/word.dart';
import '../repository/word_repository.dart';

class WordEditDialog extends ConsumerStatefulWidget {
  const WordEditDialog({super.key, required this.word});

  final Word word;

  @override
  ConsumerState<WordEditDialog> createState() => _WordEditDialogState();
}

class _WordEditDialogState extends ConsumerState<WordEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _wordController;
  late final TextEditingController _readingController;
  var _isSaving = false;

  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController(text: widget.word.word);
    _readingController = TextEditingController(text: widget.word.reading);
  }

  @override
  void dispose() {
    _wordController.dispose();
    _readingController.dispose();
    super.dispose();
  }

  String? _validateWord(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return '言葉を入力してください';
    }
    if (text.length > 30) {
      return '30文字以内で入力してください';
    }
    return null;
  }

  String? _validateReading(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'よみを入力してください';
    }
    if (text.length > 50) {
      return '50文字以内で入力してください';
    }
    if (!combinedRegex.hasMatch(text)) {
      return 'よみに使えない文字が含まれています';
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);
    try {
      await ref
          .read(wordRepositoryProvider)
          .update(
            wordId: widget.word.id,
            word: _wordController.text.trim(),
            reading: _readingController.text.trim(),
          );
      ref.invalidate(wordProvider(widget.word.id));
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } on Object catch (_) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('言葉を修正できませんでした。')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('言葉を修正'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _wordController,
              decoration: const InputDecoration(labelText: '言葉'),
              maxLength: 30,
              validator: _validateWord,
            ),
            const Gap(8),
            TextFormField(
              controller: _readingController,
              decoration: const InputDecoration(labelText: 'よみ'),
              maxLength: 50,
              validator: _validateReading,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('保存'),
        ),
      ],
    );
  }
}
