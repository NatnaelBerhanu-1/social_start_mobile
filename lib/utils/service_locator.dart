import 'package:get_it/get_it.dart';
import 'package:social_start/controllers/user_controller.dart';

GetIt getIt = GetIt.instance;

void setupLocator(){
  // TODO: place services and models
  getIt.registerSingleton(UserController());
}