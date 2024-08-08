import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_app/auth/data/user_data_source.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserDataSource _dataSource = UserDataSource();
  // final _userProvider = UserProvider();

  LoginBloc() : super(SignInInitial());
  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
  if (event is SignInEvent) {
      yield* _mapCustomerLoginState(
          contact: event.email, password: event.password);
    } 
  }

  Stream<LoginState> _mapCustomerLoginState(
      {required String contact, required String password}) async* {
    yield SignInLoading();
    final dataResponse =
        await _dataSource.userLogin(contact: contact, password: password);
    if (dataResponse.data1) {
      yield SignInSuccess();
    } else {
      yield SignInFailed(message: dataResponse.data2);
    }
  }
}