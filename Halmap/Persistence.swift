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
    @FetchRequest(entity: CollectedSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.date, ascending: true)], predicate: PlayListFilter(filter: "bufferPlayList").predicate, animation: .default) var bufferPlayListSongs: FetchedResults<CollectedSong>
    
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
    
    func createCollectedSong(song: SongInfo, playListTitle: String?) -> CollectedSong {
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
        
        print("collectedSong", collectedSong, song.title)
        return collectedSong
    }
    
    func resetBufferList(song: CollectedSong){
        
        if song.playListTitle == "bufferPlayList" {
            container.viewContext.delete(song)
        }
        
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
            print(error.localizedDescription)
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
    
    func deleteSongs(indexSet: IndexSet){
        
        @FetchRequest(entity: CollectedSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.date, ascending: true)], predicate: PlayListFilter(filter: "defaultPlayList").predicate, animation: .default) var defaultPlayListSongs: FetchedResults<CollectedSong>
        
//        withAnimation {
            indexSet.map { defaultPlayListSongs[$0] }.forEach(container.viewContext.delete)

            do {
                try container.viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
//        }
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
