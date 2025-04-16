import'dart:convert';
import 'package:http/http.dart' as http;
import '../models/questions.dart';
class ApiService {
static Future<List<Question>> fetchQuestions() async {
final response = await http.get(
Uri.parse(
'https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple'),
); //making https get request to api endpoint
if (response.statusCode == 200) {
final data = json.decode(response.body); //capturing responsebody from request 
List<Question> questions = (data['results'] as List) //sending results key values to 
.map((questionData) => Question.fromJson(questionData)) //maping each result value in data and converting json format to lis
.toList();
return questions;
} else {
throw Exception('Failed to load questions');
}
}
}