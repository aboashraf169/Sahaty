//
//  Post.swift
//  Sahaty
//
//  Created by mido mj on 12/15/24.
//

import Foundation

struct ArticalModel : Identifiable  {
    var id = UUID()
    var description: String
    var name: String
    var userName: String
    var addTime: String
    var imagePost: String?
    var personImage: String?

    
    init(id: UUID = UUID(), description: String, name: String, userName: String, addTime : String , imagePost: String? = nil, personImage: String? = nil) {
        self.id = id
        self.description = description
        self.name = name
        self.userName = userName
        self.addTime = addTime
        self.imagePost = imagePost
        self.personImage = personImage
    }
}

