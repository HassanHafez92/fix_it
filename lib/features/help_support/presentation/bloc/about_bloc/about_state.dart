part of 'about_bloc.dart';

class TeamMember {
  final String name;
  final String role;

  const TeamMember({
    required this.name,
    required this.role,
  });
}

class ContactInfo {
  final String? email;
  final String? phone;
  final String? address;

  const ContactInfo({
    this.email,
    this.phone,
    this.address,
  });
}

abstract class AboutState extends Equatable {
  const AboutState();

  @override
  List<Object?> get props => [];
}

class AboutInitial extends AboutState {}

class AboutLoading extends AboutState {}

class AboutLoaded extends AboutState {
  final String? appVersion;
  final String? appDescription;
  final String? mission;
  final List<TeamMember>? teamMembers;
  final ContactInfo? contactInfo;

  const AboutLoaded({
    this.appVersion,
    this.appDescription,
    this.mission,
    this.teamMembers,
    this.contactInfo,
  });

  @override
  List<Object?> get props => [appVersion, appDescription, mission, teamMembers, contactInfo];
}

class AboutError extends AboutState {
  final String message;

  const AboutError(this.message);

  @override
  List<Object> get props => [message];
}
