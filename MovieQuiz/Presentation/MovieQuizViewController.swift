import UIKit

final class MovieQuizViewController: UIViewController {

    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
        
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var counterLabel: UILabel!
    
    private var currentQuestionIndex = 0
    private var correctAnswers: Int = 0
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?",correctAnswer: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
    ]
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 8
        
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            
        }
    }
    
     private func showNextQuestionOrResults() {
         
      if currentQuestionIndex == questions.count - 1 { // 1
          showQuizResult()
      } else {
        
          currentQuestionIndex += 1
          let nextQuestion = questions[currentQuestionIndex]
          let viewModel = convert(model: nextQuestion, index: currentQuestionIndex, totalQuestions: questions.count)
          show(quiz: viewModel)
          
      }
    }
    
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    struct QuizStepViewModel {
        let image: UIImage // картинка фильма
        let question: String // вопрос о рейтинге квиза
        let questionNumber: String // строка с индексом номера
    }
    
    private func convert(model: QuizQuestion, index: Int, totalQuestions: Int) -> QuizStepViewModel {
        let image = UIImage(named: model.image) ?? UIImage()
        let question = model.text
        let questionNumber = "\(index + 1) / \(totalQuestions)"
        
        return QuizStepViewModel(image: image, question: question, questionNumber: questionNumber)
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyCornerRadius(to: yesButton, radius: 15)
        applyCornerRadius(to: noButton, radius: 15)
        
        questionLabel.textColor = .ypWhite
        
        guard !questions.isEmpty else { return }
        
        let currentQuestion = questions[currentQuestionIndex]
        
        let quizStep = convert(model: currentQuestion, index: currentQuestionIndex, totalQuestions: questions.count)
        show(quiz: quizStep)
    }

    // MARK: - Custom Methods
    
    private func applyCornerRadius(to button: UIButton, radius: Int) {
        button.layer.cornerRadius = 15
    }
    
    private func showQuizResult() {
        let alert = UIAlertController(
            title: "Этот раунд окончен!",
            message: "Ваш результат: \(correctAnswers) / \(questions.count)",
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: "Сыграть ещё раз", style: .default) { _ in
            self.restartQuiz()
        }

        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func restartQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0

        let firstQuestion = questions[currentQuestionIndex]
        let quizStep = convert(model: firstQuestion, index: currentQuestionIndex, totalQuestions: questions.count)
        show(quiz: quizStep)

        imageView.layer.borderColor = UIColor.clear.cgColor
    }
}




/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/
