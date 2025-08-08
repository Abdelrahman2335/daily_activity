import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    debugPrint('🟢 BLoC Created: ${bloc.runtimeType}');
  }

  @override
  void onEvent(BlocBase bloc, Object? event) {
    if (bloc is Bloc) {
      super.onEvent(bloc, event);
    }
    debugPrint('🔵 Event: ${bloc.runtimeType} -> ${event.runtimeType}');
    debugPrint('   📝 Event Details: $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('🟡 State Change: ${bloc.runtimeType}');
    debugPrint('   📤 From: ${change.currentState.runtimeType}');
    debugPrint('   📥 To: ${change.nextState.runtimeType}');

    // Log detailed state information for AddCustomerCubit
    if (bloc.runtimeType.toString().contains('AddCustomer')) {
      _logAddCustomerState(change.currentState, change.nextState);
    }
  }

  @override
  void onTransition(BlocBase bloc, Transition transition) {
    if (bloc is Bloc) {
      super.onTransition(bloc, transition);
    }
    debugPrint('🔄 Transition: ${bloc.runtimeType}');
    debugPrint('   🎯 Event: ${transition.event.runtimeType}');
    debugPrint('   📤 From: ${transition.currentState.runtimeType}');
    debugPrint('   📥 To: ${transition.nextState.runtimeType}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('🔴 Error in ${bloc.runtimeType}: $error');
    debugPrint('   📍 StackTrace: $stackTrace');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    debugPrint('🔴 BLoC Closed: ${bloc.runtimeType}');
  }

  void _logAddCustomerState(Object? currentState, Object? nextState) {
    // Log form state details when it's AddCustomerFormState
    if (nextState.runtimeType.toString().contains('AddCustomerFormState')) {
      debugPrint('   📋 Form State Details:');
      try {
        final state = nextState as dynamic;
        debugPrint('      • Name: "${state.name}"');
        debugPrint('      • Phone: "${state.phone}"');
        debugPrint('      • Region: "${state.region}"');
        debugPrint('      • City: "${state.selectedCity}"');
        debugPrint('      • Item: "${state.selectedItem}"');
        debugPrint('      • Platform: "${state.selectedPlatform}"');
        debugPrint('      • Interest Level: "${state.interestLevel}"');
        debugPrint('      • Date: "${state.selectedDate}"');
        debugPrint('      • Form Valid: ${state.isFormValid}');
      } catch (e) {
        debugPrint('      ⚠️ Could not parse form state details: $e');
      }
    }

    // Log success/failure states
    if (nextState.runtimeType.toString().contains('Success')) {
      debugPrint('   ✅ Operation completed successfully!');
    }

    if (nextState.runtimeType.toString().contains('Failure')) {
      try {
        final state = nextState as dynamic;
        debugPrint('   ❌ Operation failed: ${state.errMessage}');
      } catch (e) {
        debugPrint('   ❌ Operation failed (could not get error message)');
      }
    }

    if (nextState.runtimeType.toString().contains('Loading')) {
      debugPrint('   ⏳ Operation in progress...');
    }
  }
}