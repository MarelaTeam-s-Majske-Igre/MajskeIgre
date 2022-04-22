import 'package:app/services/global/global_context.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:meta/meta.dart';

part 'update_app_event.dart';
part 'update_app_state.dart';

class UpdateAppBloc extends Bloc<UpdateAppEvent, UpdateAppState> {
  UpdateAppBloc() : super(UpdateAppInitial()) {
    on<CheckForUpdateEvent>(_checkForUpdateEvent);
  }

  _checkForUpdateEvent(CheckForUpdateEvent event, Emitter emit) async {
    emit(CheckingForUpdateState());

    try {
      var info = await InAppUpdate.checkForUpdate();
      emit(UpdatingAppState());
      _performUpdate(info).then((value) => emit(AppUpdatedState()));
      emit(AppUpdatedState());
    } catch (e) {
      // await Future.delayed(Duration(seconds: 1));
      emit(ErrorUpdateState());
      // _showSnackbar("Napaka pri pridobivanju informacij o posodobitvah");

    }
  }

  Future<void> _performUpdate(AppUpdateInfo info) async {
    if (info.updateAvailability == UpdateAvailability.updateAvailable) {
      await InAppUpdate.performImmediateUpdate().catchError(
        // ignore: invalid_return_type_for_catch_error
        (e) => _showSnackbar(
          e.toString(),
        ),
      );
    }
  }
}

void _showSnackbar(String string) {
  var key = NavigationService.navigatorKey;
  if (key.currentContext != null) {
    ScaffoldMessenger.of(key.currentContext!)
        .showSnackBar(SnackBar(content: Text(string)));
  }
}
