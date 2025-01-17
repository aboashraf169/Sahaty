//
//  CoreDataManager.swift
//  Sahaty
//
//  Created by mido mj on 1/14/25.


import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    private var cachedDoctor: DoctorModel?

    private init() {
        persistentContainer = NSPersistentContainer(name: "AppDataModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        if let storeURL = persistentContainer.persistentStoreDescriptions.first?.url {
             do {
                 try FileManager.default.removeItem(at: storeURL)
                 print("Old Persistent Store deleted.")
             } catch {
                 print("Failed to delete old Persistent Store: \(error)")
             }
         }
        // تمكين الترحيل التلقائي
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        description?.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        
        let container = NSPersistentContainer(name: "AppDataModel")


        container.loadPersistentStores { _, error in
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
    
    // MARK: - Save Advice Doctor Data
    func saveAdvicesToCoreData(_ advices: [AdviceModel]) {
        let context = CoreDataManager.shared.persistentContainer.viewContext

        // حذف البيانات القديمة
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = AdviceEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Failed to delete old advices: \(error)")
        }

        // حفظ البيانات الجديدة
        for advice in advices {
            let entity = AdviceEntity(context: context)
            entity.id = Int64(advice.id)
            entity.advice = advice.advice
            entity.doctorID = Int64(advice.doctorID ?? 0)
            entity.createdAt = advice.createdAt
            entity.updatedAt = advice.updatedAt
        }

        do {
            try context.save()
            print("Advices saved successfully to Core Data.")
        } catch {
            print("Failed to save advices to Core Data: \(error)")
        }
    }
    
    // MARK: - Fetch Advices Data
    func fetchAdvices() -> [AdviceModel] {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<AdviceEntity> = AdviceEntity.fetchRequest()

        do {
            let entities = try context.fetch(request)
            return entities.map { entity in
                AdviceModel(
                    id: Int(entity.id),
                    advice: entity.advice ?? "",
                    doctorID: Int(entity.doctorID),
                    createdAt: entity.createdAt ?? "",
                    updatedAt: entity.updatedAt ?? ""

                )
            }
        } catch {
            print("Failed to fetch advices: \(error.localizedDescription)")
            return []
        }
    }
    // MARK: - Clear All Advices Data
    func deleteAllAdvices() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = AdviceEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            saveContext()
            print("All advices deleted from Core Data.")
        } catch {
            print("Error deleting advices: \(error.localizedDescription)")
        }
    }



    // MARK: - Save Articals Doctor Data
    func saveArticles(_ articles: [ArticleModel]) {
        let context = persistentContainer.viewContext
        for article in articles {
            let entity = ArticleEntity(context: context)
            entity.id = Int64(article.id)
            entity.title = article.title
            entity.subject = article.subject
            entity.img = article.img
            entity.userID = Int64(article.userID)
            entity.createdAt = article.createdAt
            entity.updatedAt = article.updatedAt
        }
        CoreDataManager.shared.saveContext()
    }
    // MARK: - Fetch Articals Doctor Data
    func fetchArticles() -> [ArticleModel] {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        do {
            let entities = try context.fetch(request)

            return entities.map { entity in
                ArticleModel(
                    id: Int(entity.id), // فك اختيار القيمة الاختيارية وتحويلها إلى Int
                    title: entity.title ?? "",
                    subject: entity.subject ?? "",
                    img: entity.img,
                    userID: Int(entity.userID), // فك اختيار القيمة الاختيارية وتحويلها إلى Int
                    createdAt: entity.createdAt ?? "",
                    updatedAt: entity.updatedAt ?? ""
                )
            }
        } catch {
            print("Failed to fetch articles: \(error.localizedDescription)")
            return []
        }
    }
    // MARK: - Clear All Articles Data
    func deleteAllArticles() {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        do {
            let articles = try context.fetch(request)
            articles.forEach { context.delete($0) }
            saveContext()
            print("All articles deleted.")
        } catch {
            print("Failed to delete articles: \(error.localizedDescription)")
        }
    }
    
    
    
    
    
    // MARK: - Save Doctor Data
    func saveDoctor(_ doctor: DoctorModel) {
        let context = persistentContainer.viewContext
        let doctorEntity = DoctorEntity(context: context)
        doctorEntity.id = Int64(doctor.id)
        doctorEntity.name = doctor.name
        doctorEntity.email = doctor.email
        doctorEntity.isDoctor = Int64(doctor.isDoctor)
        doctorEntity.bio = doctor.bio
        print("Saving Job Specialty Number: \(doctor.jobSpecialtyNumber)")
        doctorEntity.jobSpecialtyNumber = Int64(doctor.jobSpecialtyNumber)
        doctorEntity.specialties = encodeSpecialtiesToJSON(doctor.specialties)
        saveContext()
        print("Doctor data saved to Core Data")

    }
    // MARK: - Fetch Doctor Data
    func fetchDoctor() -> DoctorModel? {
        // إذا كانت البيانات موجودة في ذاكرة التخزين المؤقت، أعدها مباشرةً
        if let cachedDoctor = cachedDoctor {
            print("Returning cached doctor data.")
            return cachedDoctor
        }

        // إذا لم تكن موجودة في ذاكرة التخزين المؤقت، قم بتحميلها من Core Data
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<DoctorEntity> = DoctorEntity.fetchRequest()
        
        do {
            if let doctorEntity = try context.fetch(request).first {
                // تحويل الكيان إلى النموذج وتخزينه في الذاكرة المؤقتة
                let doctor = mapDoctorEntityToModel(doctorEntity)
                cachedDoctor = doctor // تخزين البيانات في الكاش
                print("Doctor data loaded from Core Data.")
                return doctor
            }
        } catch {
            print("Error fetching doctor: \(error)")
        }

        return nil
    }
    // MARK: - Clear Doctor Data
    func deleteAllDoctors() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = DoctorEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            saveContext()
            print("All doctor data deleted from Core Data")
        } catch {
            print("Error deleting doctor data: \(error)")
        }
    }
    // MARK: - Map Doctor Entity To Model
    private func mapDoctorEntityToModel(_ entity: DoctorEntity) -> DoctorModel {
        print("Fetching Job Specialty Number from Core Data: \(entity.jobSpecialtyNumber)")
        return DoctorModel(
            id: Int(entity.id),
            name: entity.name ?? "",
            email: entity.email ?? "",
            isDoctor: Int(entity.isDoctor),
            jobSpecialtyNumber: Int(entity.jobSpecialtyNumber),
            bio: entity.bio,
            specialties: decodeSpecialtiesFromJSON(entity.specialties)
        )
    }
    

    
    func clearCache() {
        cachedDoctor = nil
        print("Doctor cache cleared.")
    }
    
    
    // MARK: - Helper Methods
    private func encodeSpecialtiesToJSON(_ specialties: [Specialty]) -> String? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(specialties)
            return String(data: data, encoding: .utf8)
        } catch {
            print("Error encoding specialties: \(error)")
            return nil
        }
    }

    private func decodeSpecialtiesFromJSON(_ json: String?) -> [Specialty] {
        guard let json = json, let data = json.data(using: .utf8) else {
            return []
        }
        let decoder = JSONDecoder()
        do {
            return try decoder.decode([Specialty].self, from: data)
        } catch {
            print("Error decoding specialties: \(error)")
            return []
        }
    }

}

