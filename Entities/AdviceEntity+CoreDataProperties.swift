//
//  AdviceEntity+CoreDataProperties.swift
//  Sahaty
//
//  Created by mido mj on 1/15/25.
//
//

import Foundation
import CoreData


extension AdviceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AdviceEntity> {
        return NSFetchRequest<AdviceEntity>(entityName: "AdviceEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var advice: String?
    @NSManaged public var doctorID: Int64
    @NSManaged public var createdAt: String?
    @NSManaged public var updatedAt: String?

}

extension AdviceEntity : Identifiable {

}
