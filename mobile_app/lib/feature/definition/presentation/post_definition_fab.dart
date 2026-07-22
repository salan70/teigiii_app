import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/router/app_router.dart';
import 'write_definition_base_page.dart';

/// 定義投稿・言葉登録へ遷移する拡張 FAB（Speed Dial）。
class PostDefinitionFAB extends StatefulWidget {
  const PostDefinitionFAB({super.key});

  @override
  State<PostDefinitionFAB> createState() => _PostDefinitionFABState();
}

class _PostDefinitionFABState extends State<PostDefinitionFAB>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  late final Animation<double> _wordFade;
  late final Animation<Offset> _wordSlide;
  late final Animation<double> _definitionFade;
  late final Animation<Offset> _definitionSlide;
  late final Animation<double> _iconTurns;

  bool get _isOpen => _controller.value > 0.5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      reverseDuration: const Duration(milliseconds: 220),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInCubic,
    );
    _wordFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.55, curve: Curves.easeOut),
      reverseCurve: const Interval(0.45, 1, curve: Curves.easeIn),
    );
    _wordSlide =
        Tween<Offset>(
          begin: const Offset(0.15, 0.45),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0, 0.7, curve: Curves.easeOutCubic),
            reverseCurve: const Interval(0.3, 1, curve: Curves.easeInCubic),
          ),
        );
    _definitionFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.85, curve: Curves.easeOut),
      reverseCurve: const Interval(0.15, 0.8, curve: Curves.easeIn),
    );
    _definitionSlide =
        Tween<Offset>(
          begin: const Offset(0.15, 0.55),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.15, 0.9, curve: Curves.easeOutCubic),
            reverseCurve: const Interval(0.1, 0.85, curve: Curves.easeInCubic),
          ),
        );
    _iconTurns = Tween<double>(
      begin: 0,
      end: 0.125,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_controller.isDismissed) {
      await _controller.forward();
    } else {
      await _controller.reverse();
    }
  }

  Future<void> _close() async {
    if (!_controller.isDismissed) {
      await _controller.reverse();
    }
  }

  Future<void> _openDefinitionPost() async {
    await _close();
    if (!mounted) {
      return;
    }
    await context.pushRoute(
      DefinitionPostRoute(
        initialDefinitionForWrite: null,
        autoFocusForm: WriteDefinitionFormType.word,
      ),
    );
  }

  Future<void> _openWordRegistration() async {
    await _close();
    if (!mounted) {
      return;
    }
    await context.pushRoute(WordRegistrationRoute());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final showActions = !_controller.isDismissed;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (showActions) ...[
              FadeTransition(
                opacity: _wordFade,
                child: SlideTransition(
                  position: _wordSlide,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.85,
                      end: 1,
                    ).animate(_expandAnimation),
                    alignment: Alignment.bottomRight,
                    child: _FabTextAction(
                      label: '言葉',
                      onPressed: _openWordRegistration,
                    ),
                  ),
                ),
              ),
              const Gap(10),
              FadeTransition(
                opacity: _definitionFade,
                child: SlideTransition(
                  position: _definitionSlide,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.85, end: 1).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(
                          0.15,
                          1,
                          curve: Curves.easeOutBack,
                        ),
                      ),
                    ),
                    alignment: Alignment.bottomRight,
                    child: _FabTextAction(
                      label: '定義',
                      onPressed: _openDefinitionPost,
                    ),
                  ),
                ),
              ),
              Gap(10 + (6 * _expandAnimation.value)),
            ],
            FloatingActionButton(
              heroTag: null,
              elevation: 3,
              onPressed: _toggle,
              child: RotationTransition(
                turns: _iconTurns,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    );
                  },
                  child: Icon(
                    _isOpen ? CupertinoIcons.xmark : CupertinoIcons.add,
                    key: ValueKey(_isOpen),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FabTextAction extends StatelessWidget {
  const _FabTextAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 3,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(28),
      color: colorScheme.secondaryContainer,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
