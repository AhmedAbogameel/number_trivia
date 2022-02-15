import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/trivia_controls.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/widgets.dart';
import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Number Trivia'),),
      body: BlocProvider(
        create: (_) => sl<NumberTriviaBloc>(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(message: 'Start Searching!');
                  }  else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is Loaded) {
                    return TriviaDisplay(numberTrivia: state.numberTrivia);
                  } else if (state is Error) {
                    return MessageDisplay(message: state.message);
                  } else {
                    return Text('Unexpected Error!');
                  }
                },
              ),
              TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}