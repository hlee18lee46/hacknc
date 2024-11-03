import SwiftUI

// MARK: - Models
struct QuizQuestion: Codable, Hashable {
    let quizCategory: String
    let financialLiteracyQuiz: String
    let option1: String
    let option2: String
    let option3: String
    let answer: String
    
    enum CodingKeys: String, CodingKey {
        case quizCategory = "quiz_category"
        case financialLiteracyQuiz = "financial_literacy_quiz"
        case option1, option2, option3, answer
    }
}

struct VerifyResponse: Codable {
    let correct: Bool
    let correctAnswer: String
}

struct Score: Codable {
    let id: String
    let right: Int
    let wrong: Int
}

// MARK: - View Models

class QuizViewModel: ObservableObject {
    @Published var currentQuestion: QuizQuestion?
    @Published var currentQuestionIndex = 0
    @Published var showResult = false
    @Published var isCorrect = false
    @Published var correctAnswer = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var score: Score?
    
    private let baseURL = "http://127.0.0.1:5000" // Make sure this matches your Flask server URL
    
    init() {
        createScore()
    }
    
    func createScore() {
        guard let url = URL(string: "\(baseURL)/api/scores/create") else {
            errorMessage = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("Creating score with URL: \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                    print("Score creation error: \(error)")
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received for score creation"
                    return
                }
                
                // Print raw response for debugging
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Score creation response: \(responseString)")
                }
                
                do {
                    let score = try JSONDecoder().decode(Score.self, from: data)
                    self?.score = score
                    print("Score created successfully: \(score)")
                    self?.fetchQuestion() // Fetch first question after score is created
                } catch {
                    self?.errorMessage = "Score decoding error: \(error.localizedDescription)"
                    print("Score decoding error: \(error)")
                }
            }
        }.resume()
    }
    
    func updateScore(isCorrect: Bool) {
        guard let scoreId = score?.id else {
            print("No score ID available")
            errorMessage = "No score ID available"
            return
        }
        
        guard let url = URL(string: "\(baseURL)/api/scores/\(scoreId)/update") else {
            errorMessage = "Invalid score update URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let updateBody = ["correct": isCorrect]
        request.httpBody = try? JSONEncoder().encode(updateBody)
        
        print("Updating score with URL: \(url.absoluteString), isCorrect: \(isCorrect)")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Score update error: \(error.localizedDescription)"
                    print("Score update error: \(error)")
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received from score update"
                    return
                }
                
                // Print raw response for debugging
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Score update response: \(responseString)")
                }
                
                do {
                    let updatedScore = try JSONDecoder().decode(Score.self, from: data)
                    self?.score = updatedScore
                    print("Score updated successfully: \(updatedScore)")
                } catch {
                    self?.errorMessage = "Score update decode error: \(error.localizedDescription)"
                    print("Score update decode error: \(error)")
                }
            }
        }.resume()
    }
    
    func fetchQuestion() {
        guard let url = URL(string: "\(baseURL)/api/question/\(currentQuestionIndex)") else {
            errorMessage = "Invalid question URL"
            return
        }
        
        isLoading = true
        
        print("Fetching question with URL: \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Question fetch error: \(error.localizedDescription)"
                    print("Question fetch error: \(error)")
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No question data received"
                    return
                }
                
                do {
                    let question = try JSONDecoder().decode(QuizQuestion.self, from: data)
                    self?.currentQuestion = question
                    print("Question fetched successfully: \(question)")
                } catch {
                    self?.errorMessage = "Question decode error: \(error.localizedDescription)"
                    print("Question decode error: \(error)")
                }
            }
        }.resume()
    }
    
    func verifyAnswer(_ selected: String) {
        guard let encodedAnswer = selected.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/api/verify/\(currentQuestionIndex)/\(encodedAnswer)") else {
            errorMessage = "Invalid verification URL"
            return
        }
        
        print("Verifying answer with URL: \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Answer verification error: \(error.localizedDescription)"
                    print("Answer verification error: \(error)")
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No verification data received"
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(VerifyResponse.self, from: data)
                    self?.isCorrect = response.correct
                    self?.correctAnswer = response.correctAnswer
                    self?.showResult = true
                    self?.updateScore(isCorrect: response.correct)
                    print("Answer verified successfully: \(response)")
                } catch {
                    self?.errorMessage = "Verification decode error: \(error.localizedDescription)"
                    print("Verification decode error: \(error)")
                }
            }
        }.resume()
    }
    
    func nextQuestion() {
        currentQuestionIndex += 1
        showResult = false
        fetchQuestion()
    }
    
    func resetQuiz() {
        currentQuestionIndex = 0
        showResult = false
        isCorrect = false
        correctAnswer = ""
        createScore()
    }
}

// MARK: - Views
struct QuizView: View {
    @StateObject private var viewModel = QuizViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading question...")
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Score Display
                            if let score = viewModel.score {
                                HStack {
                                    Text("Correct: \(score.right)")
                                        .foregroundColor(.green)
                                    Spacer()
                                    Text("Incorrect: \(score.wrong)")
                                        .foregroundColor(.red)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                            
                            if let errorMessage = viewModel.errorMessage {
                                Text("Error: \(errorMessage)")
                                    .foregroundColor(.red)
                                    .padding()
                            }
                            
                            if let question = viewModel.currentQuestion {
                                QuestionView(question: question, viewModel: viewModel)
                            }
                            
                            if viewModel.showResult {
                                ResultView(viewModel: viewModel)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Financial Quiz")
        }
    }
}

struct QuestionView: View {
    let question: QuizQuestion
    let viewModel: QuizViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text(question.quizCategory)
                .font(.headline)
                .foregroundColor(.blue)
            
            Text(question.financialLiteracyQuiz)
                .font(.title2)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 15) {
                AnswerButton(text: question.option1) {
                    viewModel.verifyAnswer(question.option1)
                }
                
                AnswerButton(text: question.option2) {
                    viewModel.verifyAnswer(question.option2)
                }
                
                AnswerButton(text: question.option3) {
                    viewModel.verifyAnswer(question.option3)
                }
            }
            .disabled(viewModel.showResult)
        }
    }
}

struct ResultView: View {
    let viewModel: QuizViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            Text(viewModel.isCorrect ? "Correct! 🎉" : "Incorrect!")
                .font(.title)
                .foregroundColor(viewModel.isCorrect ? .green : .red)
            
            if !viewModel.isCorrect {
                Text("Correct answer: \(viewModel.correctAnswer)")
                    .foregroundColor(.blue)
            }
            
            Button("Next Question") {
                viewModel.nextQuestion()
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
}

struct AnswerButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.body)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
}
