import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../feature/auth/application/auth_state.dart';
import '../../feature/community_dictionary/application/community_word_list.dart';
import '../../feature/community_dictionary/domain/community_dictionary.dart';
import '../../feature/definition/domain/definition_for_write.dart';
import '../../feature/definition/presentation/write_definition_base_page.dart';
import '../../feature/timeline/application/timeline_state.dart';
import '../../feature/word/domain/word.dart';
import '../../feature/word/repository/word_repository.dart';
import '../../feature/word_list/repository/fetch_word_list_repository.dart';
import '../api/api_exception.dart';
import '../router/app_router.dart';

/// 重複候補確認を含む明示的な言葉登録画面。
///
/// @doc doc/specs/mobile-app-functional-spec.md#7-1-言葉の登録
@RoutePage()
class WordRegistrationPage extends ConsumerStatefulWidget {
  const WordRegistrationPage({super.key});

  @override
  ConsumerState<WordRegistrationPage> createState() =>
      _WordRegistrationPageState();
}

class _WordRegistrationPageState extends ConsumerState<WordRegistrationPage> {
  final _wordController = TextEditingController();
  final _readingController = TextEditingController();
  Timer? _debounce;
  List<Word> _candidates = const [];
  Word? _createdWord;
  bool _isLoadingCandidates = false;
  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _debounce?.cancel();
    _wordController.dispose();
    _readingController.dispose();
    super.dispose();
  }

  void _scheduleCandidates(String value) {
    _debounce?.cancel();
    final query = value.trim();
    if (query.isEmpty) {
      setState(() => _candidates = const []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (!mounted) {
        return;
      }
      setState(() => _isLoadingCandidates = true);
      try {
        final result = await ref
            .read(fetchWordListRepositoryProvider)
            .fetchCommunityWordList(
              filter: CommunityWordFilter.all,
              query: query,
              cursor: null,
            );
        if (mounted && _wordController.text.trim() == query) {
          setState(() => _candidates = result.list.take(5).toList());
        }
      } on Object {
        if (mounted) {
          setState(() => _candidates = const []);
        }
      } finally {
        if (mounted) {
          setState(() => _isLoadingCandidates = false);
        }
      }
    });
  }

  Future<void> _submit() async {
    final word = _wordController.text.trim();
    final reading = _readingController.text.trim();
    if (word.isEmpty || reading.isEmpty) {
      setState(() => _error = '表記とよみを入力してください。');
      return;
    }
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      final created = await ref
          .read(wordRepositoryProvider)
          .create(word: word, reading: reading);
      if (mounted) {
        ref
          ..invalidate(communityWordListProvider)
          ..invalidate(discoverTimelineProvider);
        setState(() => _createdWord = created);
      }
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }
      if (error.statusCode == 409 && error.body != null) {
        final conflict = WordConflictResponse.fromJson(error.body!);
        final existing = conflict.existingWord;
        setState(() {
          _error = '同じ表記の言葉がすでにあります。';
          _candidates = [
            Word(
              id: existing.id,
              word: existing.word,
              reading: existing.reading,
              initialSubGroupLabel: '',
              postedDefinitionCount: 0,
            ),
          ];
        });
      } else {
        setState(() => _error = '言葉を登録できませんでした。');
      }
    } on Object {
      if (mounted) {
        setState(() => _error = '言葉を登録できませんでした。');
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _continueToDefinition() {
    final userId = ref.read(userIdProvider);
    final word = _createdWord;
    if (userId == null || word == null) {
      return;
    }
    context.replaceRoute(
      DefinitionPostRoute(
        initialDefinitionForWrite: DefinitionForWrite.fromWord(word, userId),
        autoFocusForm: WriteDefinitionFormType.definition,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final createdWord = _createdWord;
    return Scaffold(
      appBar: AppBar(title: const Text('言葉を登録')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (createdWord != null) ...[
            Text(
              '「${createdWord.word}」を登録しました。',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _continueToDefinition,
              child: const Text('続けて定義を書く'),
            ),
            TextButton(onPressed: context.maybePop, child: const Text('完了')),
          ] else ...[
            TextField(
              controller: _wordController,
              autofocus: true,
              maxLength: 30,
              textInputAction: TextInputAction.next,
              onChanged: _scheduleCandidates,
              decoration: const InputDecoration(labelText: '表記'),
            ),
            TextField(
              controller: _readingController,
              maxLength: 50,
              onSubmitted: (_) => _submit(),
              decoration: const InputDecoration(labelText: 'よみ'),
            ),
            if (_isLoadingCandidates)
              const LinearProgressIndicator()
            else if (_candidates.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('既存の候補', style: Theme.of(context).textTheme.titleMedium),
              for (final candidate in _candidates)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(candidate.word),
                  subtitle: Text(candidate.reading),
                  onTap: () =>
                      context.pushRoute(WordTopRoute(wordId: candidate.id)),
                ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('登録'),
            ),
          ],
        ],
      ),
    );
  }
}
