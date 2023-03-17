//
//  DataManager.swift
//  Halmap
//
//  Created by 전지민 on 2022/10/09.
//

import AVFoundation
import Foundation
import FirebaseFirestore

class DataManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    private let db = Firestore.firestore()
    
    var selectedTeam: String = (UserDefaults.standard.string(forKey: "selectedTeam") ?? "Hanwha")
    var teams: [Team] = []
    @Published var teamSongList: [TeamSong] = []
    @Published var playerList: [Player] = []
    @Published var playerSongs: [Song] = []
    @Published var teamSongs: [Song] = []
    @Published var currentIndex: Int = 0
    
    var audioPlayer: AVPlayer!
    
    override init() {
        super.init()
        loadData()
        fetchSong(team: selectedTeam, type: true) { songs in
            self.playerSongs = songs
        }
        fetchSong(team: selectedTeam, type: false) { songs in
            self.teamSongs = songs
        }
    }
    
    func loadData(){
        let fileNm: String = "Music"
        let extensionType = "json"
        
        guard let fileLocation = Bundle.main.url(forResource: fileNm, withExtension: extensionType) else { return }
        guard let jsonData = try? Data(contentsOf: fileLocation) else { return }

        do {
            let teamArray = try JSONDecoder().decode(TeamList.self, from: jsonData)
            teams = teamArray.teamLists

            // TODO: 데이터 불러오는 위치 다시 생각해보기
            setList(teamName: selectedTeam)
        }
        catch let error {
            print(error)
        }
    }
    
    func setList(teamName: String) {
        var index = 0
        
        switch teamName {
        case "Doosan" :
            index = 0
        case "Lotte":
            index = 1
        case "Hanwha":
            index = 2
        default:
            index = 0
        }
        self.teamSongList = teams[index].teamSongs
        self.playerList = teams[index].player
    }
    
    func setSongList(team: String) {
        fetchSong(team: team, type: true) { songs in
            self.playerSongs = songs
        }
        fetchSong(team: team, type: false) { songs in
            self.teamSongs = songs
        }
    }
    
    //MARK: 파이어스토어에서 해당하는 팀의 응원가 정보를 가져오는 함수
    ///team: 팀이름을 영어로 넣어주세요
    ///[Song] 값으로 반환합니다.
    func fetchSong(team: String, type: Bool, completionHandler: @escaping ([Song])->()) {
        var songs: [Song] = []
        
        db.collection(team)
            .whereField("type", isEqualTo: type)
            .getDocuments { (querySnapshot, error) in
                if let error {
                    print("Error getting documents: \(error)")
                } else {
                    guard let documents = querySnapshot?.documents else { return }
                    let decoder = JSONDecoder()
                    
                    for document in documents {
                        do {
                            let data = document.data()
                            let jsonData = try JSONSerialization.data(withJSONObject: data)
                            let song = try decoder.decode(Song.self, from: jsonData)
                            songs.append(song)
                        } catch let error {
                            print("error: \(error)")
                        }
                    }
                    completionHandler(songs)
                }
            }
    }
}

//MARK: 음악 재생 관련 함수 모음
extension DataManager {

    func playSoundURL(isTeam: Bool) {
        var urlString: String?
        
        stopSound()
        if isTeam {
            urlString = teamSongs[currentIndex].url
        } else {
            urlString = playerSongs[currentIndex].url
        }
        guard let urlString = urlString else { fatalError("url을 받아올 수 없습니다.") }
        
        guard let url = URL(string: urlString) else { fatalError("url을 변환할 수 없습니다.") }
        let item = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: item)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
        audioPlayer.play()
    }
    func stopSound(){
        guard let player = audioPlayer else {
            return
        }
        player.pause()
    }
    
    func playNextSong(isTeam: Bool, isForward: Bool) {
        stopSound()
        if isForward {
            if isTeam {
                if 0 > currentIndex - 1 {
                    currentIndex = teamSongs.count - 1
                } else {
                    currentIndex -= 1
                }
            } else {
                if 0 > currentIndex - 1 {
                    currentIndex = playerSongs.count - 1
                } else {
                    currentIndex -= 1
                }
            }
        } else {
            if isTeam {
                if teamSongs.count - 1 < currentIndex + 1 {
                    currentIndex = 0
                } else {
                    currentIndex += 1
                }
            } else {
                if playerSongs.count - 1 < currentIndex + 1 {
                    currentIndex = 0
                } else {
                    currentIndex += 1
                }
            }
        }
    }
    
    func setCurrentIndex(index: Int) {
        self.currentIndex = index
    }
}
