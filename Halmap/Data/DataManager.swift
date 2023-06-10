//
//  DataManager.swift
//  Halmap
//
//  Created by 전지민 on 2022/10/09.
//

import SwiftUI
import FirebaseFirestore

class DataManager: ObservableObject {
    
    private let db = Firestore.firestore()
    
    @AppStorage("selectedTeam") var selectedTeam = "Hanwha"
    
    var teams: [Team] = []
    @Published var teamSongList: [TeamSong] = []
    @Published var playerList: [Player] = []
    @Published var playerSongs: [Song] = []
    @Published var teamSongs: [Song] = []
    @Published var favoriteSongs = PersistenceController.shared.fetchFavoriteSong()
    
    @Published var playerSongsAll = [[Song]](repeating: [], count: 10)
    @Published var teamSongsAll = [[Song]](repeating: [], count: 10)
    
    @Published var seasonSongs = [[String]](repeating: [], count: 10)
    
    var teamLists = TeamName.allCases
    
    init() {
        loadData()
        teamLists.forEach { teamName in
            fetchSong(team: teamName.rawValue, type: true) { songs in
                self.playerSongsAll[teamName.fetchTeamIndex()] = songs
                self.setSongList(team: self.selectedTeam)
            }
            fetchSong(team: teamName.rawValue, type: false) { songs in
                self.teamSongsAll[teamName.fetchTeamIndex()] = songs
            }
        }
        
        fetchSeasonData { data in
            self.seasonSongs = data
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
        self.playerSongs = playerSongsAll[TeamName(rawValue: selectedTeam)?.fetchTeamIndex() ?? 0]
        self.teamSongs = teamSongsAll[TeamName(rawValue: selectedTeam)?.fetchTeamIndex() ?? 0]
    }
    
    //MARK: 파이어스토어에서 해당하는 팀의 응원가 정보를 가져오는 함수
    ///team: 팀이름을 영어로 넣어주세요
    ///[Song] 값으로 반환합니다.
    func fetchSong(team: String, type: Bool, completionHandler: @escaping ([Song])->()) {
        var songs: [Song] = []
        
        db.collection(team)
            .whereField("type", isEqualTo: type)
            .order(by: "title", descending: false)
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
    
    func fetchSeasonData(completionHandler: @escaping ([[String]])->()) {
        db.collection("SeasonSong")
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
                            let seasonSong = try decoder.decode(SeasonSong.self, from: jsonData)
                            
                            completionHandler(self.processingSeasonSongData(data: seasonSong))
                        } catch let error {
                            print("error: \(error)")
                        }
                    }
                }
            }
    }
    
    func processingSeasonSongData(data: SeasonSong) -> [[String]] {
        var seasonData = [[String]](repeating: [], count: 10)
        
        seasonData[TeamName.doosan.fetchTeamIndex()] = splitData(data: data.doosan)
        seasonData[TeamName.hanwha.fetchTeamIndex()] = splitData(data: data.hanwha)
        seasonData[TeamName.samsung.fetchTeamIndex()] = splitData(data: data.samsung)
        seasonData[TeamName.lotte.fetchTeamIndex()] = splitData(data: data.lotte)
        seasonData[TeamName.lg.fetchTeamIndex()] = splitData(data: data.lg)
        seasonData[TeamName.ssg.fetchTeamIndex()] = splitData(data: data.ssg)
        seasonData[TeamName.kt.fetchTeamIndex()] = splitData(data: data.kt)
        seasonData[TeamName.nc.fetchTeamIndex()] = splitData(data: data.nc)
        seasonData[TeamName.kiwoom.fetchTeamIndex()] = splitData(data: data.kiwoom)
        seasonData[TeamName.kia.fetchTeamIndex()] = splitData(data: data.kia)
        
        return seasonData
    }
    
    func splitData(data: String) -> [String] {
        return data.split(separator: ",").map{ String($0) }
    }
    
    func checkSeasonSong(data: SongInfo) -> Bool {
        self.seasonSongs[TeamName(rawValue: data.team)?.fetchTeamIndex() ?? 0].contains(data.title)
    }
}
