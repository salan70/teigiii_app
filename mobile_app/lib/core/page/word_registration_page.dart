import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../feature/definition/domain/definition_for_write.dart';
import '../../feature/timeline/application/discover_timeline_state.dart';
import '../../feature/word/repository/word_repository.dart';
import '../../feature/word_list/application/community_dictionary_index_list_state.dart';
import '../../feature/word_list/application/word_list_state_by_search_word.dart';
import '../../util/mixin/presentation_mixin.dart';
import '../common_provider/dialog_controller.dart';
import '../common_widget/dialog/confirm_dialog.dart';
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

class _WordRegistrationPageState extends ConsumerState<WordRegistrationPage>
    with PresentationMixin {
  late final TextEditingController _wordController;
  late final TextEditingController _readingController;

  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController(text: widget.initialWord ?? '');
    _readingController = TextEditingController();
  }

  @override
  void dispose() {
    _wordController.dispose();
    _readingController.dispose();
    super.dispose();
  }

  DefinitionForWrite get _draft => DefinitionForWrite(
    id: null,
    authorId: '',
    word: _wordController.text,
    wordReading: _readingController.text,
    isPublic: true,
    definition: '',
  );

  bool get _canRegister {
    final draft = _draft;
    return draft.outputWordError() == null &&
        draft.word.isNotEmpty &&
        draft.outputWordReadingError() == null &&
        draft.wordReading.isNotEmpty;
  }

  bool get _isChanged {
    final initialWord = widget.initialWord ?? '';
    return _wordController.text != initialWord ||
        _readingController.text.isNotEmpty;
  }

  Future<void> _close() async {
    primaryFocus?.unfocus();

    if (!_isChanged) {
      await context.popRoute();
      return;
    }

    ref
        .read(dialogControllerProvider)
        .show(
          ConfirmDialog(
            confirmMessage: '入力した内容は保存されません。\nよろしいですか？',
            onAccept: context.popRoute,
            confirmButtonText: 'OK',
          ),
        );
  }

  Future<void> _submit() async {
    if (!_canRegister) {
      return;
    }

    primaryFocus?.unfocus();

    // TODO(me): フラグを使わないようにしたい。
    var isActionCompleted = false;
    await executeWithOverlayLoading(
      ref,
      action: () async {
        await ref
            .read(wordRepositoryProvider)
            .create(
              word: _wordController.text.trim(),
              reading: _readingController.text.trim(),
            );
        isActionCompleted = true;
      },
      errorToastMessage: '登録できませんでした。もう一度お試しください。',
      successToastMessage: '登録しました！',
      inBaseRouteBeforeAction: false,
    );

    if (!isActionCompleted) {
      return;
    }

    // pop すると ref が破棄され、`executeWithOverlayLoading` 内で
    // ローディング終了ができなくなる。
    // そのため、`executeWithOverlayLoading` 完了後に画面遷移を行っている。
    ref
      ..invalidate(communityDictionaryIndexListStateNotifierProvider)
      ..invalidate(discoverTimelineStateNotifierProvider)
      ..invalidate(wordListStateBySearchWordNotifierProvider);
    await ref.read(appRouterProvider).pop();
  }

  @override
  Widget build(BuildContext context) {
    final draft = _draft;
    final canRegister = _canRegister;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.xmark),
          onPressed: _close,
        ),
        title: const Text('言葉を登録'),
        actions: [
          Center(
            child: InkWell(
              onTap: canRegister ? _submit : null,
              child: Text(
                '登録',
                style: canRegister
                    ? Theme.of(context).textTheme.titleLarge
                    : Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.3),
                      ),
              ),
            ),
          ),
          const Gap(24),
        ],
      ),
      body: GestureDetector(
        onTap: () => primaryFocus?.unfocus(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              children: [
                const Gap(8),
                TextFormField(
                  controller: _wordController,
                  autofocus: widget.initialWord == null,
                  maxLength: draft.maxWordLength,
                  maxLines: null,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => setState(() {}),
                  style: Theme.of(context).textTheme.titleLarge,
                  decoration: InputDecoration(
                    hintText: '例: 二日目のカレー',
                    labelText: '登録する言葉',
                    errorText: draft.outputWordError(),
                    border: InputBorder.none,
                  ),
                ),
                TextFormField(
                  controller: _readingController,
                  autofocus: widget.initialWord != null,
                  maxLength: draft.maxWordReadingLength,
                  maxLines: null,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => setState(() {}),
                  onFieldSubmitted: (_) => _submit(),
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: InputDecoration(
                    hintText: '例: ふつかめのかれー',
                    labelText: '言葉のよみ',
                    errorText: draft.outputWordReadingError(),
                    border: InputBorder.none,
                  ),
                ),
                const Gap(300),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
