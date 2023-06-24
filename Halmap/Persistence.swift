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
    @FetchRequest(entity: CollectedSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.date, ascending: true)], animation: .default) private var collectedSongs: FetchedResults<CollectedSong>
    
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
    
    func saveSongs(song: SongInfo, playListTitle: String?) {
        let context = container.viewContext
        let collectedSong = CollectedSong(context: context)
        collectedSong.id = song.id
        collectedSong.title = song.title
        collectedSong.info = song.info
        collectedSong.lyrics = song.lyrics
        collectedSong.url = song.url
        collectedSong.type = song.type
        collectedSong.playListTitle = playListTitle
        collectedSong.team = song.team
        collectedSong.date = Date()
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func deleteSongs(song: CollectedSong) {
        
        container.viewContext.delete(song)
        
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
            print(error.localizedDescription)
        }
    }
    
    func fetchFavoriteSong() -> [CollectedSong] {
        let fetchRequest: NSFetchRequest<CollectedSong> = CollectedSong.fetchRequest()
        
        do{
            return try container.viewContext.fetch(fetchRequest)
        }catch {
            return []
        }
    }
    
    func findFavoriteSong(song: Song) -> CollectedSong {
        if let index = collectedSongs.firstIndex(where: {song.id == $0.id}) {
            return collectedSongs[index]
        } else {
            return CollectedSong()
        }
    }
    
    func fetchPlayListSong() -> [CollectedSong] {
        let fetchRequest: NSFetchRequest<CollectedSong> = CollectedSong.fetchRequest()
        
        do{
            return try container.viewContext.fetch(fetchRequest)
        }catch {
            return []
        }
    }
    
    
    func findPlayListSong(song: Song) -> CollectedSong {
        if let index = collectedSongs.firstIndex(where: {song.id == $0.id}) {
            return collectedSongs[index]
        } else {
            return CollectedSong()
        }
    }
}
