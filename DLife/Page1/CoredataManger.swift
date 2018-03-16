//
//  CoredataManger.swift
//  HelloMyCoreData
//
//  Created by Allen on 2018/2/23.
//  Copyright © 2018年 Allen. All rights reserved.
//

import UIKit
import CoreData
//泛型 但必須繼承 NSManagedObject <T:NSManagedObject, Z:NSObject>
class CoredataManger<T:NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
    
    //Constants from init().
    let momdFilename:String
    let dbFilename:String
    let dbFilePathURL:URL
    let entityName:String
    let sortKey:String
    
    init(momdFilename:String,
         dbFilename:String? = nil,
         dbFilePathURL:URL? = nil,
         entityName:String,
         sortKey:String){
        self.momdFilename = momdFilename
        if let dbFilename = dbFilename{
            self.dbFilename = dbFilename
        } else{
            self.dbFilename = entityName
        }
        if let dbFilePathURL = dbFilePathURL{
            self.dbFilePathURL = dbFilePathURL
        } else{
            self.dbFilePathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            NSLog("dbFilePathURL:\(self.dbFilePathURL)")
        }
        self.entityName = entityName
        self.sortKey = sortKey
        
        super.init()
    }
    //MARK: -Private methods/properties for CoreDatas.
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: momdFilename, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
   private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = dbFilePathURL.appendingPathComponent(dbFilename)
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        //GCD:分配CPU工作  Queue:水管（執行緒的概念）
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    // MARK: - Fetched results controller
    
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: entityName)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController as NSFetchedResultsController<NSFetchRequestResult>
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    private var _fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    //saveContext()執行完後被呼叫
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if saveCompletion != nil{
            saveCompletion?(true)
            saveCompletion = nil
        }
    }
    
    // MARK: - Core Data Saving support
    typealias SaveDownHandler = (_ success:Bool) -> Void
    private var saveCompletion:SaveDownHandler?
    
    func saveContext (completion:SaveDownHandler?) {
        if managedObjectContext.hasChanges {
            do {
                //Keep at saveCompletion
                if completion != nil {
                    saveCompletion = completion
                }
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                saveCompletion?(false)
                abort()
            }
        } else{
            saveCompletion?(false)
        }
    }
    //MARK: -Public Methods.
    var count:Int {
        let sectionInfo = self.fetchedResultsController.sections![0]
        return sectionInfo.numberOfObjects
    }
    //泛型Ｔ
    func createObject() -> T{
        let newManagedObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.managedObjectContext) as! T
        return newManagedObject
    }
    
    func delete(object:T){
        self.managedObjectContext.delete(object)
    }
    func fetchObject(at:Int) ->  T?{
        //Boundary check
        guard at >= 0 && at < count else{
            assertionFailure()
            return nil
        }
        //indexPath是二維
        let indexPath = IndexPath(row:at,section:0)
        return self.fetchedResultsController.object(at: indexPath) as? T
    }
    
    func search(keyword:String,attribute:String) -> [T]?{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:entityName)
        // ==> name CONTAINS[cd] "Lee"  [cd]:部分符合且不分大小寫
        let predicate = NSPredicate(format: attribute + " CONTAINS[cd] \"\(keyword)\"")
        request.predicate = predicate
        do{
            let results = try self.managedObjectContext.fetch(request) as? [T]
            return results
        } catch {
            assertionFailure("Fail to fetch: \(error)")
        }
        return nil
    }

}
