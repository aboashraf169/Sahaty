//
//  ArticleEntity+CoreDataProperties.swift
//  Sahaty
//
//  Created by mido mj on 1/15/25.
//
//

import Foundation
import CoreData


extension ArticleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleEntity> {
        return NSFetchRequest<ArticleEntity>(entityName: "ArticleEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var subject: String?
    @NSManaged public var img: String?
    @NSManaged public var userID: Int64 
    @NSManaged public var createdAt: String?
    @NSManaged public var updatedAt: String?

}

extension ArticleEntity : Identifiable {

}
