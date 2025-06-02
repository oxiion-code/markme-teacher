import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_ng/blocs/theme/theme_event.dart';
import 'package:task_ng/blocs/theme/theme_state.dart';
import 'package:task_ng/theme/app_theme.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
    : super(ThemeState(themeData: AppTheme.lightTheme, isDarkMode: false)) {
    on<ToggleTheme>((event, emit) {
      final isDark = !state.isDarkMode;
      emit(
        ThemeState(
          themeData: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
          isDarkMode: isDark,
        ),
      );
    });
  }
}
