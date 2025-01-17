//
//  DoctorEntity+CoreDataProperties.swift
//  Sahaty
//
//  Created by mido mj on 1/15/25.
//
//

import Foundation
import CoreData


extension DoctorEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DoctorEntity> {
        return NSFetchRequest<DoctorEntity>(entityName: "DoctorEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var isDoctor: Int64
    @NSManaged public var bio: String?
    @NSManaged public var jobSpecialtyNumber: Int64
    @NSManaged public var specialties: String?

}

extension DoctorEntity : Identifiable {

}
