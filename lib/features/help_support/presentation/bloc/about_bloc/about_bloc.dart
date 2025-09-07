import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'about_event.dart';
part 'about_state.dart';

class AboutBloc extends Bloc<AboutEvent, AboutState> {
  AboutBloc() : super(AboutInitial()) {
    on<LoadAboutInfoEvent>(_onLoadAboutInfo);
  }

  void _onLoadAboutInfo(
    LoadAboutInfoEvent event,
    Emitter<AboutState> emit,
  ) async {
    emit(AboutLoading());

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, you would call a use case here
      // final result = await getAboutInfoUseCase();

      // For now, we'll just simulate a successful response with mock data
      emit(const AboutLoaded(
        appVersion: '1.0.0',
        appDescription: 'Fix It is your one-stop solution for all home repair and maintenance needs. We connect you with skilled technicians who can fix anything from a leaky faucet to a broken appliance.',
        mission: 'To make home repairs and maintenance easy, accessible, and affordable for everyone by connecting customers with qualified service providers.',
        teamMembers: [
          TeamMember(name: 'John Doe', role: 'CEO & Founder'),
          TeamMember(name: 'Jane Smith', role: 'CTO'),
          TeamMember(name: 'Mike Johnson', role: 'Head of Operations'),
        ],
        contactInfo: ContactInfo(
          email: 'support@fixit.com',
          phone: '+1 (555) 123-4567',
          address: '123 Main St, City, Country',
        ),
      ));
    } catch (e) {
      emit(AboutError(e.toString()));
    }
  }
}
