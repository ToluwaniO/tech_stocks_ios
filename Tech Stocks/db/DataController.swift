//
// Created by Toluwani Ogunsanya on 2020-07-06.
// Copyright (c) 2020 Toluwani Ogunsanya. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer:NSPersistentContainer

    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    let backgroundContext:NSManagedObjectContext!

    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)

        backgroundContext = persistentContainer.newBackgroundContext()
    }

    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true

        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }

    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.configureContexts()
            self.autoSaveViewContext()
            completion?()
        }
    }

    private func autoSaveViewContext(interval:TimeInterval = 30) {
        print("autosaving")

        guard interval > 0 else {
            print("invalid interval")
            return
        }
        save()
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }

    func save() {
        do {
            if !viewContext.hasChanges {
                return
            }
            try? viewContext.save()
        } catch {
            print("An erroor occurred while trying to save")
        }
    }

    static let shared = DataController(modelName: "Tech_Stocks")
}