import 'dart:math';

import 'package:over_react/over_react.dart';
part 'progress.over_react.g.dart';

/// Bootstrap's `Progress` component stylizes the HTML5 `<progress>` element with a
/// few extra CSS classes and some crafty browser-specific CSS.
///
/// See: <http://v4-alpha.getbootstrap.com/components/progress/>
@Factory()
UiFactory<ProgressProps> Progress = _$Progress;

@Props()
class _$ProgressProps extends UiProps {
  /// The current value of the [Progress] component.
  ///
  /// This value should be between the [min] and [max] values.
  ///
  /// Default: `0.0`
  double value;

  /// The min value of the [Progress] component.
  ///
  /// Default: `0.0`
  double min;

  /// The max value of the [Progress] component.
  ///
  /// Default: `100.0`
  double max;

  /// The skin / "context" for the [Progress] component.
  ///
  /// See: <http://v4-alpha.getbootstrap.com/components/progress/#contextual-alternatives>.
  ///
  /// Default: [ProgressSkin.DEFAULT]
  ProgressSkin skin;

  /// Whether to render a "Barber Pole" gradient stripe effect in the [Progress] component.
  ///
  /// Default: false
  bool isStriped;

  /// Whether to animate the "Barber Pole" gradient stripe effect in the [Progress] component.
  ///
  /// __Note:__ Has no effect if [isStriped] is `false`.
  ///
  /// Default: false
  bool isAnimated;

  /// Optionally add a caption that describes the context of the [Progress] component.
  ///
  /// See: <http://v4-alpha.getbootstrap.com/components/progress/#example>.
  ///
  /// Default: [ProgressComponent._getPercentComplete]%
  String caption;

  /// Additional props to be added to the [caption] element _(if specified)_.
  Map captionProps;

  /// Whether the [caption] should be visible.
  ///
  /// Default: false
  bool showCaption;

  /// Whether the [caption] should be appended with the value of [value].
  ///
  /// Default: true
  bool showPercentComplete;

  /// Additional props to be added to the [Dom.div] that wraps around the [caption] element and `<progress>` element.
  Map rootNodeProps;
}

@State()
class _$ProgressState extends UiState {
  /// An autogenerated GUID, used as a fallback when [ProgressProps.id] is unspecified, and
  /// saved on the state so it will persist across remounts.
  ///
  /// HTML id attributes are needed on `<progress>` elements for proper accessibility support,
  /// so this state value ensures there's always a valid ID value to use.
  String id;
}

@Component2()
class ProgressComponent extends UiStatefulComponent2<ProgressProps, ProgressState> {
  @override
  Map getDefaultProps() => (newProps()
    ..value = 0.0
    ..min = 0.0
    ..max = 100.0
    ..skin = ProgressSkin.DEFAULT
    ..isStriped = false
    ..isAnimated = false
    ..showCaption = false
    ..showPercentComplete = true
  );

  @override
  Map getInitialState() => (newState()
    ..id = 'progress_' + generateGuid(4)
  );

  @override
  render() {
    return (Dom.div()..addProps(props.rootNodeProps))(
      renderCaptionNode(),
      renderProgressNode(),
      props.children
    );
  }

  ReactElement renderProgressNode() {
    return (Dom.progress()
      ..addProps(copyUnconsumedDomProps())
      ..addProps(ariaProps()
        ..labelledby = captionId
      )
      ..className = _getProgressNodeClasses().toClassName()
      ..id = id
      ..value = currentValue
      ..max = props.max
    )();
  }

  ReactElement renderCaptionNode() {
    var captionClasses = new ClassNameBuilder.fromProps(props.captionProps)
      ..add('sr-only', !props.showCaption);

    var captionText = props.caption  ?? '';

    if (props.showPercentComplete) {
      captionText += ' ${_getPercentComplete()}%';
    }

    return (Dom.div()
      ..addProps(props.captionProps)
      ..id = captionId
      ..className = captionClasses.toClassName()
    )(captionText);
  }

  ClassNameBuilder _getProgressNodeClasses() {
    return new ClassNameBuilder()
      ..add('progress')
      ..add('progress-striped', props.isStriped)
      ..add('progress-animated', props.isAnimated)
      ..add(props.skin.className);
  }

  /// Get the percentage complete based on [ProgressProps.min], [ProgressProps.max] and [ProgressProps.value].
  double _getPercentComplete() {
    return (props.value - props.min) / (props.max - props.min) * 100;
  }

  /// Returns the value that determines the width of the progress bar
  /// within the rendered [Progress] component via [DomPropsMixin.value].
  ///
  /// Note that the value of the HTML `<progress>` element's value
  /// attribute will never be less than the value of [ProgressProps.min].
  double get currentValue => max(props.min, props.value);

  String get id => props.id ?? state.id;

  String get captionId => '${id}_caption';
}

/// Contextual skin options for a [Progress] component.
class ProgressSkin extends ClassNameConstant {
  const ProgressSkin._(String name, String className) : super(name, className);

  /// [className] value: ''
  static const ProgressSkin DEFAULT =
      const ProgressSkin._('DEFAULT', '');

  /// [className] value: 'progress-danger'
  static const ProgressSkin DANGER =
      const ProgressSkin._('DANGER', 'progress-danger');

  /// [className] value: 'progress-success'
  static const ProgressSkin SUCCESS =
      const ProgressSkin._('SUCCESS', 'progress-success');

  /// [className] value: 'progress-warning'
  static const ProgressSkin WARNING =
      const ProgressSkin._('WARNING', 'progress-warning');

  /// [className] value: 'progress-info'
  static const ProgressSkin INFO =
      const ProgressSkin._('INFO', 'progress-info');
}

