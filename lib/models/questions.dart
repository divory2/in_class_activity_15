class Question {
final String question;
final List<String> options;
final String correctAnswer;
Question({
required this.question,
required this.options,
required this.correctAnswer,
});
factory Question.fromJson(Map<String, dynamic> json) {
// Decode options by combining incorrect answers with the correct
//answer and shuffling them.
List<String> options =
List<String>.from(json['incorrect_answers']);//setting empty list equal to list incorrect answers
options.add(json['correct_answer']); //adding correct answers to options list
options.shuffle(); // shuffle list 
return Question( //returning 
question: json['question'], //question value to json question key
options: options, //set options key to options list
correctAnswer: json['correct_answer'], //set correctanswer key value to json correct answer key value pair
);
}
}
