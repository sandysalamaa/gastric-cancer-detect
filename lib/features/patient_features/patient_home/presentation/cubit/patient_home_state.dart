part of 'patient_home_cubit.dart';

abstract class PatientHomeState extends Equatable {
  const PatientHomeState();

  @override
  List<Object> get props => [];
}

class PatientHomeInitial extends PatientHomeState {}

class ResetParamsState extends PatientHomeState {}

class CreateOrderLoading extends PatientHomeState {}

class CreateOrderError extends PatientHomeState {
  final String message;
  const CreateOrderError({required this.message});
}

class CreateOrderSuccess extends PatientHomeState {}

class SelectDayState extends PatientHomeState {}

class ImagesChangeStates extends PatientHomeState {
  final File image;
  const ImagesChangeStates({required this.image});
}
