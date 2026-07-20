import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/definition/application/definition_for_write_notifier.dart';
import '../../feature/definition/domain/definition.dart';
import '../../feature/definition/presentation/write_definition_base_page.dart';
import '../../util/mixin/presentation_mixin.dart';
import '../router/app_router.dart';

@RoutePage()
class DefinitionEditPage extends ConsumerWidget with PresentationMixin {
  const DefinitionEditPage({super.key, required this.initialDefinition});

  final Definition initialDefinition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialDefinitionForWrite = initialDefinition.toDefinitionForWrite();
    final provider = definitionForWriteNotifierProvider(
      initialDefinitionForWrite,
    );
    final asyncDefinitionForWrite = ref.watch(provider);
    final notifier = ref.watch(provider.notifier);

    return asyncDefinitionForWrite.when(
      data: (definitionForWrite) {
        final canSave =
            initialDefinition.canEditAt(DateTime.now()) && notifier.canEdit();
        return WriteDefinitionBasePage(
          definitionForWrite: definitionForWrite,
          onWordChanged: notifier.changeWord,
          onWordReadingChanged: notifier.changeWordReading,
          onPublicChanged: (value) =>
              notifier.changePublicState(isPublic: value),
          onDefinitionChanged: notifier.changeDefinition,
          isChanged: notifier.isChanged(),
          appBarActionWidget: InkWell(
            onTap: canSave
                ? () async {
                    primaryFocus?.unfocus();
                    await executeWithOverlayLoading(
                      ref,
                      action: () async {
                        await notifier.edit();
                        await ref.read(appRouterProvider).maybePop();
                      },
                      errorToastMessage: '保存できませんでした。もう一度お試しください。',
                      successToastMessage: '保存しました！',
                      inBaseRouteBeforeAction: false,
                    );
                  }
                : null,
            child: Text(
              '保存',
              style: canSave
                  ? Theme.of(context).textTheme.titleLarge
                  : Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.3),
                    ),
            ),
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
    );
  }
}
