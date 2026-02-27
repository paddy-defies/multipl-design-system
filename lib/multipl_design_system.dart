/// Multipl Design System V5
///
/// A Flutter widget library with 45 components, design tokens, and app theme.
///
/// ## Usage
///
/// In your `pubspec.yaml`:
/// ```yaml
/// dependencies:
///   multipl_design_system:
///     git:
///       url: https://github.com/paddy-defies/multipl-design-system.git
/// ```
///
/// Then import everything with a single line:
/// ```dart
/// import 'package:multipl_design_system/multipl_design_system.dart';
/// ```
library multipl_design_system;

// ── Tokens ────────────────────────────────────────────────────────────────────
export 'design_system/tokens/colors.dart';
export 'design_system/tokens/gradients.dart';
export 'design_system/tokens/motion.dart';
export 'design_system/tokens/radius.dart';
export 'design_system/tokens/shadows.dart';
export 'design_system/tokens/spacing.dart';
export 'design_system/tokens/typography.dart';

// ── Theme ─────────────────────────────────────────────────────────────────────
export 'design_system/theme/app_theme.dart';

// ── Widgets (45 components) ───────────────────────────────────────────────────
export 'design_system/widgets/widgets.dart';
