//
//  Persistence.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import CoreData
import SwiftUI

struct PersistenceController {
    @AppStorage("selectedTeam") var selectedTeam = ""
    
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
    
    func saveSongs(song: SongInfo, playListTitle: String?, order: Int64) {
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
        collectedSong.order = order
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func saveSongs(collectedSong: CollectedSong, playListTitle: String?, menuType: MenuType, collectedSongs: FetchedResults<CollectedSong>) {
        let context = container.viewContext
        var order = Int64(collectedSongs.count)
        
        if let currentIndex = collectedSongs.firstIndex(where: {$0.id == UserDefaults.standard.string(forKey: "currentSongId")}) {
            switch menuType {
            case .playNext:
                if let index = collectedSongs.firstIndex(where: { $0.id == collectedSong.id }) {
                    
                } else {
                    
                }
                
                break
            case .playLast:
                if let index = collectedSongs.firstIndex(where: { $0.id == collectedSong.id }) {
                    
                }
                break
            default:
                resetBufferList(song: collectedSong)
                break
            }
        }
        
//        collectedSong.playListTitle = playListTitle
//        collectedSong.date = Date()
//        collectedSong.order = order
        
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
    
    /// index를 이용하여 Playlist에서 곡을 지우는 함수.
    func deleteSong(at indexs: IndexSet, from results: FetchedResults<CollectedSong>) {
        
        for index in indexs {
            let song = results[index]
            container.viewContext.delete(song)
            
            for i in index..<results.count {
                results[i].order -= 1
            }
        }
        
        do {
            try container.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    /// defaultPlaylist 순서를 변경하는 함수
    func moveDefaultPlaylistSong(from source: IndexSet, to destination: Int, based results: FetchedResults<CollectedSong>){
        
        guard let itemToMove = source.first else { return }
        
        if itemToMove < destination{
            var startIndex = itemToMove + 1
            let endIndex = destination - 1
            var startOrder = results[itemToMove].order
            while startIndex <= endIndex{
                results[startIndex].order = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            results[itemToMove].order = startOrder
        }
        
        else if destination < itemToMove{
            var startIndex = destination
            let endIndex = itemToMove - 1
            var startOrder = results[destination].order + 1
            let newOrder = results[destination].order
            while startIndex <= endIndex{
                results[startIndex].order = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            results[itemToMove].order = newOrder
        }
        
        do{
            try container.viewContext.save()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    
    func fetchCollectedSong() -> [CollectedSong] {
        let fetchRequest: NSFetchRequest<CollectedSong> = CollectedSong.fetchRequest()
        
        do{
            return try container.viewContext.fetch(fetchRequest)
        }catch {
            return []
        }
    }
    
    func fincCollectedSong(song: SongInfo, collectedSongs: FetchedResults<CollectedSong>) -> CollectedSong {
        if let index = collectedSongs.firstIndex(where: {song.id == $0.id}) {
            return collectedSongs[index]
        } else {
            return CollectedSong()
        }
    }
    
    func findCollectedSongIndex(song: SongInfo, collectedSongs: FetchedResults<CollectedSong>) -> Int {
        if let index = collectedSongs.firstIndex(where: {song.id == $0.id}) {
            return index
        } else {
            return 0
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
        
        return collectedSong
    }
    
    /// CollectedSong을 생성하기 위해 BufferList에 넣은 곡을 지우는 함수.
    func resetBufferList(song: CollectedSong){
        
        if song.playListTitle == "bufferPlaylist" {
            container.viewContext.delete(song)
        }
        
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
            print(error.localizedDescription)
        }
    }
    
    func reorderSelectedSong(index: Int, results: FetchedResults<CollectedSong>) {
        results[index].order = Int64(results.count-1)
        for i in index+1..<results.count {
            results[i].order -= 1
        }
        do{
            try container.viewContext.save()
        }
        catch{
            print(error.localizedDescription)
        }
    }
}
