import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../feature/definition/domain/definition_for_write.dart';
import '../../feature/word/application/existing_public_word_state.dart';
import '../../feature/word/application/word_registration_controller.dart';
import '../../feature/word/domain/word_registration.dart';
import '../../feature/word/presentation/already_registered_word_dialog.dart';
import '../../util/mixin/presentation_mixin.dart';
import '../common_provider/dialog_controller.dart';
import '../common_provider/key_provider.dart';
import '../common_provider/snack_bar_controller.dart';
import '../common_widget/dialog/confirm_dialog.dart';
import '../design_system/design_system.dart';
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
  /// 入力が止まったとみなすまでの待ち時間。
  ///
  /// 1 文字ごとに既存語チェックを投げないための間引き。
  static const _lookupDebounce = Duration(milliseconds: 400);

  late final TextEditingController _wordController;
  late final TextEditingController _readingController;

  Timer? _lookupTimer;

  /// 既存語チェックに使う (表記, よみ)。入力が止まってから更新する。
  ({String reading, String word}) _lookupKey = (reading: '', word: '');

  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController(text: widget.initialWord ?? '');
    _readingController = TextEditingController();
  }

  @override
  void dispose() {
    _lookupTimer?.cancel();
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

  /// 入力そのものが登録可能な形式かどうか。既存語かどうかは含まない。
  bool get _isInputValid {
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

  /// 入力を反映し、間を置いてから既存語チェックの対象を更新する。
  void _handleInputChanged() {
    setState(() {});

    _lookupTimer?.cancel();
    _lookupTimer = Timer(_lookupDebounce, () {
      // 形式が不正な入力は問い合わせない（サーバーが 400 を返すため）。
      final key = _isInputValid
          ? (
              reading: _readingController.text.trim(),
              word: _wordController.text.trim(),
            )
          : (reading: '', word: '');
      if (!mounted || key == _lookupKey) {
        return;
      }
      setState(() {
        _lookupKey = key;
      });
    });
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

  Future<void> _submit(String? existingWordId) async {
    if (!_isInputValid || existingWordId != null) {
      return;
    }

    primaryFocus?.unfocus();

    WordRegistration? registration;
    await executeWithOverlayLoading(
      ref,
      action: () async {
        registration = await ref
            .read(wordRegistrationControllerProvider)
            .register(
              word: _wordController.text.trim(),
              reading: _readingController.text.trim(),
            );
      },
      errorToastMessage: '登録できませんでした。もう一度お試しください。',
      inBaseRouteBeforeAction: false,
    );

    final result = registration;
    if (result == null) {
      return;
    }

    switch (result.outcome) {
      case WordRegistrationOutcome.created:
      case WordRegistrationOutcome.promoted:
        // pop すると ref が破棄され、`executeWithOverlayLoading` 内で
        // ローディング終了ができなくなる。
        // そのため、`executeWithOverlayLoading` 完了後に画面遷移を行っている。
        ref
            .read(snackBarControllerProvider)
            .showSuccessSnackBar('登録しました！', ScaffoldMessengerType.baseRoute);
        await ref.read(appRouterProvider).pop();
      case WordRegistrationOutcome.alreadyPublic:
        // 見え方は何も変わっていないため、成功として伝えない。
        // チップの表示条件と実態を合わせるため、既存語チェックをやり直す。
        ref.invalidate(
          existingPublicWordIdProvider(
            word: _lookupKey.word,
            reading: _lookupKey.reading,
          ),
        );
        _showAlreadyRegisteredDialog(result.word.id);
    }
  }

  void _showAlreadyRegisteredDialog(String wordId) {
    ref
        .read(dialogControllerProvider)
        .show(
          AlreadyRegisteredWordDialog(
            onViewWord: () => unawaited(_openWordPage(wordId)),
          ),
        );
  }

  Future<void> _openWordPage(String wordId) async {
    // 閉じずに push する。閉じると `_close()` の確認ダイアログが毎回挟まる。
    await context.pushRoute(WordTopRoute(wordId: wordId));
  }

  @override
  Widget build(BuildContext context) {
    final draft = _draft;
    final asyncExistingWordId = ref.watch(
      existingPublicWordIdProvider(
        word: _lookupKey.word,
        reading: _lookupKey.reading,
      ),
    );
    // 検索に失敗したときは登録を妨げない（チップを出さない）。
    final existingWordId = switch (asyncExistingWordId) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final canRegister = _isInputValid && existingWordId == null;

    return Scaffold(
      appBar: AppBar(
        elevation: DsElevation.none,
        leading: DsIconButton(
          icon: CupertinoIcons.xmark,
          semanticLabel: '閉じる',
          onPressed: () => unawaited(_close()),
        ),
        title: const Text('言葉を登録'),
        actions: [
          DsAppBarAction(
            label: '登録',
            onPressed: canRegister
                ? () => unawaited(_submit(existingWordId))
                : null,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => primaryFocus?.unfocus(),
        child: Center(
          child: Padding(
            padding: DsSpacing.screenContentInsets,
            child: ListView(
              children: [
                DsTextField.multiline(
                  controller: _wordController,
                  autofocus: widget.initialWord == null,
                  maxLength: draft.maxWordLength,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => _handleInputChanged(),
                  size: DsTextFieldSize.prominent,
                  label: '登録する言葉',
                  hintText: '例: 二日目のカレー',
                  errorText: draft.outputWordError(),
                ),
                DsTextField.multiline(
                  controller: _readingController,
                  autofocus: widget.initialWord != null,
                  maxLength: draft.maxWordReadingLength,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => _handleInputChanged(),
                  onSubmitted: (_) => _submit(existingWordId),
                  label: '言葉のよみ',
                  hintText: '例: ふつかめのかれー',
                  errorText: draft.outputWordReadingError(),
                ),
                // 入力を終えた位置に出す。有無で下の余白がずれないよう、
                // 非表示でも領域を確保する。チップ自身が最小タップ領域を
                // 内側に持つため、前後に余白は足さない。
                Visibility(
                  visible: existingWordId != null,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: DsChip.navigable(
                      label: 'この言葉は登録済みです',
                      // 非表示のときはタップが届かない（maintainInteractivity）。
                      onTap: () {
                        if (existingWordId != null) {
                          unawaited(_openWordPage(existingWordId));
                        }
                      },
                    ),
                  ),
                ),
                // ignore: ds_hardcoded_spacing
                // 理由: キーボードで隠れないようにするための画面固有の下部余白。
                // 意味を持つ余白ではないためトークン化しない。
                // 追跡: #281
                const Gap(300),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
