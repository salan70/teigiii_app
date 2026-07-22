import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../feature/auth/application/auth_state.dart';
import '../../feature/definition/domain/definition_for_write.dart';
import '../../feature/definition/presentation/write_definition_base_page.dart';
import '../../feature/timeline/application/discover_timeline_state.dart';
import '../../feature/word/domain/word.dart';
import '../../feature/word/repository/word_repository.dart';
import '../../feature/word_list/application/community_dictionary_index_list_state.dart';
import '../router/app_router.dart';

@RoutePage()
class WordRegistrationPage extends ConsumerStatefulWidget {
  const WordRegistrationPage({super.key, this.initialWord});

  /// 検索ゼロ件 CTA などから渡す表記の初期値。
  final String? initialWord;

  @override
  ConsumerState<WordRegistrationPage> createState() =>
      _WordRegistrationPageState();
}

class _WordRegistrationPageState extends ConsumerState<WordRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _wordController;
  final _readingController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController(text: widget.initialWord ?? '');
  }

  @override
  void dispose() {
    _wordController.dispose();
    _readingController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_isSubmitting) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final word = await ref
          .read(wordRepositoryProvider)
          .create(
            word: _wordController.text.trim(),
            reading: _readingController.text.trim(),
          );
      if (!mounted) {
        return;
      }
      ref
        ..invalidate(communityDictionaryIndexListStateNotifierProvider)
        ..invalidate(discoverTimelineStateNotifierProvider);
      await _showSuccessDialog(word);
    } on Exception {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('登録できませんでした。もう一度お試しください。')));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _showSuccessDialog(Word word) async {
    final userId = ref.read(userIdProvider)!;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text('「${word.word}」を登録しました'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await context.maybePop();
              if (!mounted) {
                return;
              }
              await context.pushRoute(
                DefinitionPostRoute(
                  initialDefinitionForWrite: DefinitionForWrite.fromWord(
                    word,
                    userId,
                  ),
                  autoFocusForm: WriteDefinitionFormType.definition,
                ),
              );
            },
            child: const Text('続けて定義を書く'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await context.maybePop();
            },
            child: const Text('完了'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('言葉を登録')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _wordController,
                decoration: const InputDecoration(
                  labelText: '表記',
                  hintText: '例: 自由',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? '表記を入力してください' : null,
                textInputAction: TextInputAction.next,
              ),
              const Gap(16),
              TextFormField(
                controller: _readingController,
                decoration: const InputDecoration(
                  labelText: 'よみ',
                  hintText: '例: じゆう',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'よみを入力してください' : null,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
              ),
              const Gap(32),
              FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('登録する'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
