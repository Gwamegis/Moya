//
//  Persistence.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import CoreData
import SwiftUI

struct PersistenceController {
    @AppStorage("selectedTeam") var selectedTeam = "Hanwha"
    @FetchRequest(entity: FavoriteSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteSong.date, ascending: true)], animation: .default) private var favoriteSongs: FetchedResults<FavoriteSong>
    
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Halmap")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func saveSongs(song: Song) {
        let context = container.viewContext
        let favoriteSong = FavoriteSong(context: context)
        favoriteSong.id = song.id
        favoriteSong.title = song.title
        favoriteSong.info = song.info
        favoriteSong.lyrics = song.lyrics
        favoriteSong.url = song.url
        favoriteSong.type = song.type
        favoriteSong.team = selectedTeam
        favoriteSong.date = Date()
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
//    func deleteSongs(song: FavoriteSong) {
//        container.viewContext.delete(song)
//
//        do {
//            try container.viewContext.save()
//        } catch {
//            container.viewContext.rollback()
//            print(error.localizedDescription)
//        }
//    }
    func deleteSongs(song: FavoriteSong) {
        
        container.viewContext.delete(song)
        
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
            print(error.localizedDescription)
        }
    }
    
    func fetchFavoriteSong() -> [FavoriteSong] {
        let fetchRequest: NSFetchRequest<FavoriteSong> = FavoriteSong.fetchRequest()
        
        do{
            return try container.viewContext.fetch(fetchRequest)
        }catch {
            return []
        }
    }
    
    func findFavoriteSong(song: Song) -> FavoriteSong {
        if let index = favoriteSongs.firstIndex(where: {song.id == $0.id}) {
            return favoriteSongs[index]
        } else {
            return FavoriteSong()
        }
    }
}
