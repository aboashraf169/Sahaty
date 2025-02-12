//
//  AdviceModel.swift
//  Sahaty
//
//  Created by mido mj on 12/14/24.
//

import Foundation

struct AdviceModel: Identifiable, Codable {
    var id: Int = 0
    var advice: String = ""
    var doctorID: Int = 1
    var createdAt: String = ""
    var updatedAt: String = ""
    
    // MARK: - API Request Body
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "advice": advice,
            "doctor_id": doctorID,
            "created_at": createdAt,
            "updated_at": updatedAt
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case advice
        case doctorID = "doctor_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


struct AdviceResponse: Codable {
    let currentPage: Int
    let data: [AdviceModel]
    let firstPageURL: String
    let from: Int
    let lastPage: Int
    let lastPageURL: String
    let links: [Link]
    let nextPageURL: String?
    let path: String
    let perPage: Int
    let prevPageURL: String?
    let to: Int
    let total: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to
        case total
    }
}

struct Link: Codable {
    let url: String?
    let label: String
    let active: Bool
}




struct ResponseUserAdvice : Codable{
    let data: [UserAdviceModel]
    let links : AdviceLink
    let meta : Meta
}
struct UserAdviceModel : Codable{
    var id : Int
    var advice : String
}
struct Meta : Codable{
    var current_page : Int
    var from : Int
    var last_page : Int
    var links : [Link]
    var path : String
    var per_page : Int
    var to : Int
    var total : Int
}

struct AdviceLink: Codable {
    let first: String
    let last: String
    let prev: Int?
    let next: String
}

