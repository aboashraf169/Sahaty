//
//  APIManager.swift
//  Sahaty
//
//  Created by mido mj on 1/11/25.
//


import Foundation

class APIManager {
    static let shared = APIManager() // Singleton Instance
    private init() {}
    
    private let baseURL = "http://127.0.0.1:8000/api"
    private var bearerToken: String?
    
    // MARK: - Set Bearer Token
    func setBearerToken(_ token: String) {
        self.bearerToken = token
    }
    
    // MARK: - Send Request
    func sendRequest(
        endpoint: String,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        // Add Bearer Token if available
        if let token = bearerToken {
            print("Bearer Token being sent: \(token)")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Add parameters for POST/PUT requests
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        
        print("Request URL: \(request.url?.absoluteString ?? "")")
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        print("Request Body: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "")")

        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
    
    func fetchArticles(completion: @escaping (Result<[ArticleModel], Error>) -> Void) {
    sendRequest(endpoint: "/doctor/articles", method: .get) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedResponse = try JSONDecoder().decode(ArticleResponse.self, from: data)
                    completion(.success(decodedResponse.data))
                } catch {
                    print("Failed to decode articles: \(error.localizedDescription)")
                    completion(.failure(APIError.decodingError))
                }
            case .failure(let error):
                print("Failed to fetch articles: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}

// MARK: - HTTPMethod Enum
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}



// MARK: - APIError Enum
enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError(message: String) // حالة لمعالجة الأخطاء القادمة من الخادم
    case unknownError // خطأ غير معروف

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid."
        case .noData:
            return "No data received from the server."
        case .decodingError:
            return "Failed to decode the response."
        case .serverError(let message):
            return message // عرض رسالة الخادم المخصصة
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}



struct ArticleResponse: Codable {
    let data: [ArticleModel]
}
