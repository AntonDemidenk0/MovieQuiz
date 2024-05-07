import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - IB Outlets
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var stackView: UIStackView!
    // MARK: - Private Properties
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactory?
    private var currentQuestion: QuizQuestion?
    private let statisticService = StatisticServiceImplementation()
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        stackView.isHidden = true
        showLoadingIndicator()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
    }
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
        QuestionFactory.isRequestingQuestion = false
    }
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.stackView.isHidden = false
        }
        activityIndicator.isHidden = true
    }
    func didFailToLoadData(with error: Error) {
        showNetworkError(error: error)
    }
    // MARK: - AlertPresenter Methods
    func resetQuestionsResult() {
        self.currentQuestionIndex = 0
        self.correctAnswers = 0
        if let questionFactory = questionFactory {
            questionFactory.requestNextQuestion()
        }
    }
    // MARK: - IB Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    // MARK: - Private Methods
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        yesButton.isEnabled = false
        noButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            endGame(correctAnswers: correctAnswers, totalQuestions: questionsAmount)
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            let viewModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз",
                correctAnswers: correctAnswers,
                totalQuestions: questionsAmount,
                completion: { [weak self] in
                    self?.resetQuestionsResult()
                })
            let alertPresenter = AlertPresenter(viewController: self)
            alertPresenter.show(quiz: viewModel, statisticService: statisticService)
            imageView.layer.borderWidth = 0
        } else {
            currentQuestionIndex += 1
            if let questionFactory = questionFactory {
                questionFactory.self.requestNextQuestion()
            }
            imageView.layer.borderWidth = 0
        }
    }
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    private func showNetworkError(error: Error) {
        hideLoadingIndicator()
        
        let alert = UIAlertController(
            title: "Ошибка", message: error.localizedDescription,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Попробовать еще раз", style: .default) { [self] _ in
            resetQuestionsResult()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    private func endGame(correctAnswers: Int, totalQuestions: Int) {
        statisticService.store(correct: correctAnswers, total: totalQuestions)
    }
}


