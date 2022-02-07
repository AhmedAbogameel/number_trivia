import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List<dynamic> properties;
  Failure(this.properties);

  @override
  List<Object?> get props => this.properties;
}
