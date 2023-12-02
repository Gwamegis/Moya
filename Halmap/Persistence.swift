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
    
    func saveSongs(song: Song, playListTitle: String?, order: Int64) {
        let context = container.viewContext
        let collectedSong = CollectedSong(context: context)
        
        collectedSong.id = song.id
        collectedSong.title = song.title
        collectedSong.info = song.info
        collectedSong.lyrics = song.lyrics
        collectedSong.url = song.url
        collectedSong.type = song.type
        collectedSong.playListTitle = playListTitle
        collectedSong.team = UserDefaults.standard.string(forKey: "selectedTeam")
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
    
    private func saveSongs(song: CollectedSong, playListTitle: String, order: Int64) {
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
    }
    
    func saveSongs(collectedSong: CollectedSong, playListTitle: String?, menuType: MenuType, collectedSongs: FetchedResults<CollectedSong>) {
        let context = container.viewContext
        let count = collectedSongs.count
        
        switch menuType {
        case .playNext:
            if let currentIndex = collectedSongs.firstIndex(where: {$0.id == UserDefaults.standard.string(forKey: "currentSongId")}) {
                if let index = collectedSongs.firstIndex(where: { $0.id == collectedSong.id }) {
                    if index < currentIndex {
                        var startOrder = collectedSongs[index].order
                        for i in index+1...currentIndex {
                            print(collectedSongs[i].safeTitle, collectedSongs[i].order, startOrder)
                            collectedSongs[i].order = startOrder
                            startOrder += 1
                        }
                        collectedSongs[index].order = startOrder
                    } else if index > currentIndex {
                        let newOrder = collectedSongs[currentIndex+1].order
                        var startOrder = collectedSongs[currentIndex+1].order+1
                        for i in currentIndex+1..<index {
                            print(collectedSongs[i].safeTitle, collectedSongs[i].order, startOrder)
                            collectedSongs[i].order = startOrder
                            startOrder += 1
                        }
                        collectedSongs[index].order = newOrder
                    }
                    resetBufferList(song: collectedSong)
                } else {
                    //새로운 곡을 바로 다음에 추가
                    for i in currentIndex+1..<count {
                        print(collectedSongs[i].safeTitle)
                        collectedSongs[i].order += 1
                    }
                    
                    collectedSong.playListTitle = playListTitle
                    collectedSong.date = Date()
                    collectedSong.order = Int64(currentIndex + 1)
                }
            }
            break
        case .playLast:
            if let index = collectedSongs.firstIndex(where: { $0.id == collectedSong.id }) {
                var startOrder = collectedSongs[index].order
                for i in index+1..<count {
                    collectedSongs[i].order = startOrder
                    startOrder += 1
                }
                collectedSongs[index].order = startOrder
                resetBufferList(song: collectedSong)
            } else {
                collectedSong.playListTitle = playListTitle
                collectedSong.date = Date()
                collectedSong.order = Int64(count)
            }
            break
        default:
            resetBufferList(song: collectedSong)
            break
        }
        
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
    
    func fetchPlaylistAll() {
        let fetchRequest = CollectedSong.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CollectedSong.order, ascending: true)]
        fetchRequest.predicate = PlaylistFilter(filter: "defaultPlaylist").predicate
        
        do {
            let old = try container.viewContext.fetch(fetchRequest)
            
            for song in old {
                container.viewContext.delete(song)
            }
            
            try container.viewContext.save()
        } catch {
            print("Failed to fetch and delete songs: \(error)")
        }
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CollectedSong.date, ascending: true)]
        fetchRequest.predicate = PlaylistFilter(filter: "favorite").predicate
        
        do {
            let new = try container.viewContext.fetch(fetchRequest)
            
            var order = 0
            for song in new {
                saveSongs(song: song, playListTitle: "defaultPlaylist", order: Int64(order))
                order += 1
            }
            try container.viewContext.save()
        } catch {
            print("Failed to fetch and delete songs: \(error)")
        }
    }
    
    func fetchPlaylistAllMain(newSongs: [Song]) {
        let fetchRequest = CollectedSong.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CollectedSong.order, ascending: true)]
        fetchRequest.predicate = PlaylistFilter(filter: "defaultPlaylist").predicate
        
        do {
            let old = try container.viewContext.fetch(fetchRequest)
            
            for song in old {
                container.viewContext.delete(song)
            }
            
            try container.viewContext.save()
        } catch {
            print("Failed to fetch and delete songs: \(error)")
        }
        
        do {
            var order = 0
            for song in newSongs {
                saveSongs(song: song, playListTitle: "defaultPlaylist", order: Int64(order))
                order += 1
            }
            try container.viewContext.save()
        } catch {
            print("Failed to fetch and delete songs: \(error)")
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
