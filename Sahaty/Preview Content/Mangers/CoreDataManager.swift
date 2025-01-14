//
//  CoreDataManager.swift
//  Sahaty
//
//  Created by mido mj on 1/14/25.
//


import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "AppDataModel") // اسم ملف الـ Core Data
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
    }

    // MARK: - Save Context
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    // MARK: - Fetch Data
    func fetchData<T: NSManagedObject>(entity: T.Type) -> [T] {
        let context = persistentContainer.viewContext
        let request = T.fetchRequest()
        do {
            return try context.fetch(request) as! [T]
        } catch {
            print("Error fetching data: \(error)")
            return []
        }
    }

    // MARK: - Delete Data
    func deleteData(object: NSManagedObject) {
        let context = persistentContainer.viewContext
        context.delete(object)
        saveContext()
    }
}


