import 'package:flutter/material.dart';
class OnlyReverseAnimationPageRoute<T> extends MaterialPageRoute<T> {
  OnlyReverseAnimationPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool fullscreenDialog = false,
  }) : super(builder: builder, settings: settings, fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    final theme = Theme.of(context).pageTransitionsTheme;
    Animation<double> onlyForwardAnimation;
    switch (animation.status) {
      case AnimationStatus.reverse:
      case AnimationStatus.dismissed:
        onlyForwardAnimation = animation;
        break;
      case AnimationStatus.forward:
      case AnimationStatus.completed:
        onlyForwardAnimation = kAlwaysCompleteAnimation;
        break;
    }
    return theme.buildTransitions<T>(this, context, onlyForwardAnimation, secondaryAnimation, child);
  }
}