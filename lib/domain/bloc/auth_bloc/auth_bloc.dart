import 'package:chat/domain/bloc/auth_bloc/auth_event.dart';
import 'package:chat/domain/bloc/auth_bloc/auth_state.dart';
import 'package:chat/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthSubmitEvent>(_onSubmit);
  }

  Future<void> _onSubmit(AuthSubmitEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());

      var data = await authRepository.login(event.username);

      emit(AuthAuthenticated(data));
    } catch (e) {
      emit(AuthSubmitFailure(e));
    }
  }
}
