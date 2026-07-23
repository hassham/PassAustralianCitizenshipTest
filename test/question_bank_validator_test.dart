import 'package:flutter_test/flutter_test.dart';
import 'package:pass_citizenship_test/features/practice/data/question_bank_validator.dart';

void main() {
  const validator = QuestionBankValidator();

  Map<String, dynamic> validBank() => {
    'schemaVersion': '1.0.0',
    'questionBankVersion': '1.0.0',
    'categories': [
      {'id': 'values'},
    ],
    'sourceEditions': [
      {'id': 'source-one'},
    ],
    'questions': [
      {
        'id': 'question-one',
        'categoryId': 'values',
        'text': 'Which answer is correct?',
        'status': 'ready_for_review',
        'difficulty': 'easy',
        'revision': 1,
        'isAustralianValuesQuestion': true,
        'options': [
          for (var index = 0; index < 4; index++)
            {
              'id': 'option-$index',
              'text': 'Option $index',
              'explanation': 'Explanation for option $index',
              'isCorrect': index == 2,
              'displayOrder': index,
            },
        ],
        'sourceReferences': [
          {'sourceEditionId': 'source-one', 'pageStart': 1, 'pageEnd': 1},
        ],
      },
    ],
  };

  test('accepts a semantically valid question bank', () {
    expect(() => validator.validate(validBank()), returnsNormally);
  });

  test('rejects a question with more than one correct option', () {
    final bank = validBank();
    final question = (bank['questions'] as List).first as Map<String, dynamic>;
    final options = question['options'] as List;
    (options.first as Map<String, dynamic>)['isCorrect'] = true;

    expect(
      () => validator.validate(bank),
      throwsA(isA<QuestionBankValidationException>()),
    );
  });
}
