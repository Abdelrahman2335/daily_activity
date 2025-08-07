import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'edit_project_state.dart';

class EditProjectCubit extends Cubit<EditProjectState> {
  EditProjectCubit() : super(EditProjectInitial());
}
