//
//  Coin.swift
//  iCryyptPro
//
//  Created by YouTube on 2023-02-24.
//

import Foundation

struct CoinData: Decodable {
    let data: [Coin]
}

struct Coin: Decodable {
    let id: Int
    let name: String
    let maxSupply: Int?
    let rank: Int
    let pricingData: PricingData
    
    var logoURL: URL? {
        return URL(string: "https://s2.coinmarketcap.com/static/img/coins/200x200/\(id).png")
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case maxSupply = "max_supply"
        case rank = "cmc_rank"
        case pricingData = "quote"
    }
}

struct PricingData: Decodable {
    private let price: Double
    private let marketCap: Double
    
    var _price: Double {
        return Double(round(100_000 * price) / 100_000)
    }
    
    var _marketCap: Int {
        return Int(round(marketCap))
    }
    
    enum CodingKeys: String, CodingKey {
        case CAD
        case price
        case marketCap = "market_cap"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let cad = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .CAD)
        price = try cad.decode(Double.self, forKey: .price)
        marketCap = try cad.decode(Double.self, forKey: .marketCap)
    }
}
