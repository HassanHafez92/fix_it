import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_app_settings_usecase.dart';
import '../../domain/usecases/update_app_settings_usecase.dart';
import '../../domain/entities/app_settings_entity.dart';
import '../../../../core/usecases/usecase.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetAppSettingsUseCase getAppSettings;
  final UpdateAppSettingsUseCase updateAppSettings;

  SettingsBloc({
    required this.getAppSettings,
    required this.updateAppSettings,
  }) : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateSettings>(_onUpdateSettings);
    on<ResetSettings>(_onResetSettings);
  }

  void _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());

    try {
      final result = await getAppSettings(NoParamsImpl());

      result.fold(
        (failure) => emit(const SettingsError('فشل في تحميل الإعدادات')),
        (settings) => emit(SettingsLoaded(settings)),
      );
    } catch (e) {
      emit(SettingsError('حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  void _onUpdateSettings(
    UpdateSettings event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      emit(SettingsUpdating(event.settings));

      try {
        final result = await updateAppSettings(event.settings);

        result.fold(
          (failure) => emit(const SettingsError('فشل في تحديث الإعدادات')),
          (_) => emit(SettingsLoaded(event.settings)),
        );
      } catch (e) {
        emit(SettingsError('حدث خطأ في تحديث الإعدادات: ${e.toString()}'));
      }
    }
  }

  void _onResetSettings(
    ResetSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());

    try {
      // Reset to default settings
      const defaultSettings = AppSettingsEntity();

      final result = await updateAppSettings(defaultSettings);

      result.fold(
        (failure) => emit(const SettingsError('فشل في إعادة تعيين الإعدادات')),
        (_) => emit(const SettingsLoaded(defaultSettings)),
      );
    } catch (e) {
      emit(SettingsError('حدث خطأ في إعادة التعيين: ${e.toString()}'));
    }
  }
}