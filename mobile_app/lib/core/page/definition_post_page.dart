import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/definition/application/definition_draft_editor.dart';
import '../../feature/definition/domain/definition_for_write.dart';
import '../../feature/definition/presentation/write_definition_base_page.dart';
import '../../feature/definition/repository/definition_draft_repository.dart';
import '../../feature/definition/util/after_post_navigation_type.dart';
import '../../feature/introduction/repository/definition_guide_repository.dart';
import '../../util/logger.dart';
import '../../util/mixin/presentation_mixin.dart';
import '../router/app_router.dart';

/// 定義の新規入力・Draft 再開・投稿を一画面で扱うページ。
///
/// @doc doc/specs/mobile-app-functional-spec.md#14-初回利用
@RoutePage()
class DefinitionPostPage extends ConsumerStatefulWidget {
  const DefinitionPostPage({
    super.key,
    this.draftId,
    required this.initialDefinitionForWrite,
    required this.autoFocusForm,
    this.afterPostNavigation = AfterPostNavigationType.toDetail,
  });

  final String? draftId;
  final WriteDefinitionFormType? autoFocusForm;
  final DefinitionForWrite? initialDefinitionForWrite;
  final AfterPostNavigationType afterPostNavigation;

  @override
  ConsumerState<DefinitionPostPage> createState() => _DefinitionPostPageState();
}

class _DefinitionPostPageState extends ConsumerState<DefinitionPostPage>
    with WidgetsBindingObserver, PresentationMixin {
  bool _allowPop = false;
  bool _completed = false;
  bool _backgroundSaveFailed = false;
  Future<bool>? _backgroundSave;
  bool _showDefinitionGuide = false;

  DefinitionDraftEditorProvider get _provider => definitionDraftEditorProvider(
    widget.draftId,
    widget.initialDefinitionForWrite,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_loadDefinitionGuide());
  }

  Future<void> _loadDefinitionGuide() async {
    if (widget.draftId != null) {
      return;
    }
    try {
      final repository = ref.read(definitionGuideRepositoryProvider);
      if (!await repository.shouldShow() || !mounted) {
        return;
      }
      setState(() => _showDefinitionGuide = true);
      await repository.markAsShown();
    } on Object catch (error, stackTrace) {
      logger.e(
        'Definition guide state could not be loaded',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _backgroundSaveFailed &&
        mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_backgroundSaveFailed) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('下書きを保存できませんでした。'),
            action: SnackBarAction(
              label: '再試行',
              onPressed: () => unawaited(_saveInBackground()),
            ),
          ),
        );
      });
      return;
    }
    if (_completed ||
        (state != AppLifecycleState.inactive &&
            state != AppLifecycleState.paused &&
            state != AppLifecycleState.hidden)) {
      return;
    }
    unawaited(_saveInBackground());
  }

  Future<bool> _saveInBackground() {
    return _backgroundSave ??= ref
        .read(_provider.notifier)
        .save()
        .then((saved) {
          _backgroundSaveFailed = false;
          return saved;
        })
        .catchError((Object error, StackTrace stackTrace) {
          _backgroundSaveFailed = true;
          logger.e(
            'Draft autosave failed',
            error: error,
            stackTrace: stackTrace,
          );
          return false;
        })
        .whenComplete(() => _backgroundSave = null);
  }

  Future<void> _close() async {
    final draft = ref.read(_provider).valueOrNull;
    if (draft == null) {
      return;
    }
    final notifier = ref.read(_provider.notifier);

    if (!draft.hasAnyInput) {
      if (draft.isPersisted) {
        final delete = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text('空になった下書きを削除しますか？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('キャンセル'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('削除'),
              ),
            ],
          ),
        );
        if (delete != true) {
          return;
        }
        var deleted = false;
        await executeWithOverlayLoading(
          ref,
          action: () async {
            await notifier.delete();
            deleted = true;
          },
          errorToastMessage: '下書きを削除できませんでした。',
          inBaseRouteBeforeAction: false,
        );
        if (!deleted) {
          return;
        }
      }
      await _pop();
      return;
    }

    try {
      if (await notifier.save()) {
        await _pop();
      }
    } on Object catch (error, stackTrace) {
      logger.e(
        'Draft save on close failed',
        error: error,
        stackTrace: stackTrace,
      );
      if (!mounted) {
        return;
      }
      final retry = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text('下書きを保存できませんでした。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('編集に戻る'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('変更を破棄'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('再試行'),
            ),
          ],
        ),
      );
      if (retry == true) {
        await _close();
      } else if (retry == false) {
        await _pop();
      }
    }
  }

  Future<void> _pop() async {
    if (mounted) {
      setState(() => _allowPop = true);
      await WidgetsBinding.instance.endOfFrame;
    }
    await ref.read(appRouterProvider).maybePop();
  }

  Future<void> _saveExplicitly() async {
    await executeWithOverlayLoading(
      ref,
      action: () => ref.read(_provider.notifier).save(),
      errorToastMessage: '下書きを保存できませんでした。',
      successToastMessage: '下書きを保存しました。',
      inBaseRouteBeforeAction: false,
      inBaseRouteAfterAction: false,
    );
  }

  Future<void> _post() async {
    final notifier = ref.read(_provider.notifier);
    String? definitionId;
    try {
      definitionId = await notifier.finalize();
    } on WordReadingMismatchException catch (mismatch) {
      if (!mounted) {
        return;
      }
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('よみが登録内容と異なります'),
          content: Text(
            '「${mismatch.word}」は「${mismatch.existingReading}」で登録されています。'
            'この言葉に定義を投稿しますか？',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('投稿する'),
            ),
          ],
        ),
      );
      if (confirmed == true) {
        definitionId = await notifier.finalize(confirmReadingMismatch: true);
      }
    }
    if (definitionId == null || !mounted) {
      return;
    }

    _completed = true;
    await _pop();
    if (widget.afterPostNavigation == AfterPostNavigationType.toDetail) {
      await ref
          .read(appRouterProvider)
          .push(DefinitionDetailRoute(definitionId: definitionId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncDraft = ref.watch(_provider);
    final notifier = ref.watch(_provider.notifier);

    return PopScope(
      canPop: _allowPop || _completed,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          unawaited(_close());
        }
      },
      child: asyncDraft.when(
        data: (draft) {
          final fields = draft.fields;
          return WriteDefinitionBasePage(
            autoFocusForm: widget.autoFocusForm,
            definitionForWrite: fields,
            wordFieldsReadOnly: draft.wordId != null,
            guideWidget: _showDefinitionGuide
                ? const Card(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('全体に公開／非公開を選べます。入力途中でも「下書きを保存」で、あとから続けられます。'),
                    ),
                  )
                : null,
            onWordChanged: notifier.changeWord,
            onWordReadingChanged: notifier.changeWordReading,
            onPublicChanged: (value) =>
                notifier.changePublicState(isPublic: value),
            onDefinitionChanged: notifier.changeDefinition,
            isChanged: notifier.isChanged,
            onClose: _close,
            bodyActionWidget: TextButton.icon(
              onPressed: draft.hasAnyInput ? _saveExplicitly : null,
              icon: const Icon(Icons.save_outlined),
              label: const Text('下書きを保存'),
            ),
            appBarActionWidget: TextButton(
              onPressed: draft.canFinalize
                  ? () async {
                      primaryFocus?.unfocus();
                      try {
                        await _post();
                      } on Object catch (error, stackTrace) {
                        logger.e(
                          'Definition finalize failed',
                          error: error,
                          stackTrace: stackTrace,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('投稿できませんでした。')),
                          );
                        }
                      }
                    }
                  : null,
              child: const Text('投稿'),
            ),
          );
        },
        loading: () => Scaffold(
          appBar: AppBar(elevation: 0),
          body: const Center(child: CircularProgressIndicator()),
        ),
        error: (error, stackTrace) => Scaffold(
          appBar: AppBar(elevation: 0),
          body: Center(child: Text(error.toString())),
        ),
      ),
    );
  }
}
