import 'package:flutter/material.dart';
import 'package:in_class_activity_15/models/questions.dart';

import '../../services/api_service.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _loading = true;
  bool _answered = false;
  String _selectedAnswer = "";
  String _feedbackText = "";

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await ApiService.fetchQuestions(); //calling the fetchquestion method from api service class
      setState(() {
        _questions = questions; //setting questions list 
        _loading = false; //bool for loading 
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      
          content: Text("Error has occured while loading questions"),
         action:  SnackBarAction (
            label: "ok",
            onPressed: (){
             Navigator.of(context).pop();

          },)
      )

      );
      print(e);
      // Handle error appropriately

    }
  }

  void _submitAnswer(String selectedAnswer) {
    setState(() {
      _answered = true;//bool for answered 
      _selectedAnswer = selectedAnswer; //tracking the selected answer and storing into variable 
      final correctAnswer = _questions[_currentQuestionIndex].correctAnswer; //getting the correct answer from question object
      if (selectedAnswer == correctAnswer) { //checking to see if selected answer equals the correct anser for the question 
        _score++; //incrementing score 
        _feedbackText = "Correct! The answer is $correctAnswer.";
      } else {
        _feedbackText = "Incorrect. The correct answer is $correctAnswer.";
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _answered = false; //setting bool for if question has been answered to false
      _selectedAnswer = ""; //reseting selectedanswer back to empty string 
      _feedbackText = ""; // reset feedback text to empty string 
      _currentQuestionIndex++; //incrementing the index for the currentqestion 
    });
  }

  Widget _buildOptionButton(String option) {
    return ElevatedButton(
      onPressed: _answered ? null : () => _submitAnswer(option),
      child: Text(option),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_currentQuestionIndex >= _questions.length) { //check to see if you have reached past the final question 
      return Scaffold(
        body: Center(
          child: Text('Quiz Finished! Your Score: $_score/${_questions.length}'),
        ),
      );
    }

    final question = _questions[_currentQuestionIndex];//the current question object

    return Scaffold(
      appBar: AppBar(title: Text('Quiz App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}/${_questions.length}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              question.question, //current question 
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ...question.options.map((option) => _buildOptionButton(option)), //map each question and calling buildoption method to display widget of options
            SizedBox(height: 20),
            if (_answered)
              Text(
                _feedbackText, 
                style: TextStyle(
                  fontSize: 16,
                  color: _selectedAnswer == question.correctAnswer
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            if (_answered)
              ElevatedButton(
                onPressed: _nextQuestion,
                child: Text('Next Question'),
              ),
          ],
        ),
      ),
    );
  }
}
