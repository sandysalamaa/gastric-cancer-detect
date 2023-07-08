part of 'role_cubit.dart';

abstract class RoleState extends Equatable {
  const RoleState();

  @override
  List<Object> get props => [];
}

class RoleInitial extends RoleState {}

class RoleLoading extends RoleState {}

class DoctorRoleState extends RoleState {}

class PatientRoleState extends RoleState {}
