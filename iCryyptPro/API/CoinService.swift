//
//  CoinService.swift
//  iCryyptPro
//
//  Created by YouTube on 2023-02-24.
//

import Foundation

enum CoinServiceError: Error {
    case unknown(String = "An unknown error occurred.")
    case decodingError(String = "Error parsing server response.")
    case serverError(CoinError)
}

class CoinService {
    
    static func fetchCoins(
        completion: @escaping (Result<[Coin], CoinServiceError>)->Void) {
        guard let request = Endpoint.fetchCoins().request else { return }
        
            
        URLSession.shared.dataTask(with: request) { data, resp, error in
            if let error = error {
                completion(.failure(.unknown(error.localizedDescription)))
                return
            }
            
            if let resp = resp as? HTTPURLResponse, resp.statusCode != 200 {
                do {
                    let coinError = try JSONDecoder().decode(CoinError.self, from: data ?? Data())
                    completion(.failure(.serverError(coinError)))
                } catch {
                    completion(.failure(.unknown("Unknown Server Error")))
                }
                return
            }
            
            if let data = data {
                
                do {
                    let decoder = JSONDecoder()
                    let coinData = try decoder.decode(CoinData.self, from: data)
                    completion(.success(coinData.data))
                } catch {
                    completion(.failure(.decodingError()))
                    return
                }
            } else {
                completion(.failure(.unknown()))
            }
        }.resume()
    }
    
}
