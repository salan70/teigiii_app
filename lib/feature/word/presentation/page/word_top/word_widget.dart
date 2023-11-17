import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common_widget/button/primary_filled_button.dart';
import '../../../../../core/common_widget/error_and_retry_widget.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../util/logger.dart';
import '../../../../definition/domain/definition_for_write.dart';
import '../../../../definition/util/write_definition_form_type.dart';
import '../../../application/word_state.dart';
import 'word_widget_shimmer.dart';

class WordWidget extends ConsumerWidget {
  const WordWidget({super.key, required this.wordId});

  final String wordId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncWord = ref.watch(wordProvider(wordId));

    return asyncWord.when(
      data: (word) {
        return Padding(
          padding: REdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Text(
                word.word,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                word.reading,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 24.h),
              Text(
                '${word.postedDefinitionCount}投稿',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              SizedBox(height: 8.h),
              Center(
                child: PrimaryFilledButton(
                  onPressed: () {
                    final definitionForWrite =
                        DefinitionForWrite.fromWord(word);
                    context.pushRoute(
                      PostDefinitionRoute(
                        initialDefinitionForWrite: definitionForWrite,
                        autoFocusForm: WriteDefinitionFormType.definition,
                      ),
                    );
                  },
                  text: 'この語句の定義を投稿する',
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
      loading: WordWidgetShimmer.new,
      error: (error, stackTrace) {
        // エラー発生後の再読み込み中の場合、trueになる
        if (asyncWord.isRefreshing) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: CupertinoActivityIndicator(),
          );
        }

        logger.e('語句[$wordId]の取得に失敗しました。'
            'error: $error, stackTrace: $stackTrace');
        return Padding(
          padding: REdgeInsets.symmetric(vertical: 24),
          child: ErrorAndRetryWidget(
            onRetry: () => ref.invalidate(wordProvider(wordId)),
          ),
        );
      },
    );
  }
}
