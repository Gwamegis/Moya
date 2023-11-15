//
//  DataManager.swift
//  Halmap
//
//  Created by 전지민 on 2022/10/09.
//

import SwiftUI
import FirebaseFirestore
import FirebaseRemoteConfig
import FirebaseFirestoreSwift

class DataManager: ObservableObject {
    
    private let db = Firestore.firestore()
    
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    @AppStorage("selectedTeam") var selectedTeam = "Hanwha"
    @AppStorage("isShouldShowNotification") var isShouldShowNotification = false
    @AppStorage("isShouldShowTraffic") var isShouldShowTraffic = false
    @AppStorage("latestVersion") var latestVersion = "1.0.0"
    @AppStorage("latestTrafficDate") var latestTrafficDate = "20230706" {
        didSet {
            isShouldShowTraffic = true
        }
    }
    
    var teams: [Team] = []
    @Published var teamSongList: [TeamSong] = []
    @Published var playerList: [Player] = []
    @Published var playerSongs: [Song] = []
    @Published var teamSongs: [Song] = []
    @Published var favoriteSongs = PersistenceController.shared.fetchFavoriteSong()
    @Published var playListSongs = PersistenceController.shared.fetchPlayListSong()
    
    @Published var playerSongsAll = [[Song]](repeating: [], count: 10)
    @Published var teamSongsAll = [[Song]](repeating: [], count: 10)
    
    @Published var seasonSongs = [[String]](repeating: [], count: 10)
    
    @Published var trafficNotification: [Traffic] = []
    @Published var versionNotification: [Notification] = []
    
    var teamLists = TeamName.allCases
    
    init() {
        Task {
            try await fetchRemoteLatestVersion()
        }
        fetchTrafficNotification()
        
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
    
    func fetchTrafficNotification() {
        db.collection("Traffic")
            .order(by: "date", descending: false)
            .getDocuments() { (querySnapshot, error) in
                if let error {
                    print("Error getting documents: \(error)")
                } else {
                    guard let documents = querySnapshot?.documents else { return }
                    if documents.isEmpty {
                        self.trafficNotification.append(Traffic())
                    } else {
                        for document in documents {
                            let data = document.data()
                            if let date = data["date"] as? Timestamp {
                                self.trafficNotification.append(
                                    Traffic(
                                        date: date.dateValue(),
                                        title: data["title"] as! String,
                                        description: data["description"] as! String
                                    )
                                )
                                self.isShouldShowTraffic = self.isNewTrafficNotification(remoteData: date.dateValue())
                            }
                        }
                    }
                }
            }
    }
    private func isNewTrafficNotification(remoteData: Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        
        let remoteDate = dateFormatter.string(from: remoteData)
        let currentDate = dateFormatter.string(from: Date())
        
        if latestTrafficDate < remoteDate && remoteDate == currentDate {
            return true
        } else {
            return false
        }
    }
    
    //새로운 버전 알림과 관련된 함수들
    func fetchVersionNotification(completionHandler: @escaping ([Notification]) -> ()) {
        var notifications: [Notification] = []
        db.collection("IOSVersion")
            .getDocuments() { (querySnapshot, error) in
                if let error {
                    print("Error getting documents: \(error)")
                } else {
                    guard let documents = querySnapshot?.documents else { return }
                    let decoder = JSONDecoder()
                    
                    for document in documents {
                        do {
                            let data = document.data()
                            let jsonData = try JSONSerialization.data(withJSONObject: data)
                            let notification = try decoder.decode(Notification.self, from: jsonData)
                            notifications.append(notification)
                        } catch let error {
                            print("error: \(error)")
                        }
                    }
                    completionHandler(notifications)
                }
            }
    }
    
    private func fetchRemoteLatestVersion() async throws {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        do {
            let config = try await remoteConfig.fetchAndActivate()
            switch config {
            case .successFetchedFromRemote:
                
                let remoteVersion = remoteConfig.configValue(forKey: "latest_version").stringValue ?? ""
                let appVersion = fetchAppVersion()
                
                if compareVersion(fetchVersion: remoteVersion, appVersion: appVersion) == ComparisonResult.orderedAscending && remoteVersion > latestVersion {
                    Task {
                        fetchVersionNotification{ notifications in
                            if notifications.isEmpty {
                                self.versionNotification.append(Notification())
                            } else {
                                self.versionNotification = notifications
                                self.isShouldShowNotification = true
                            }
                        }
                    }
                } else {
                    self.versionNotification.append(Notification())
                }
                return
            case .successUsingPreFetchedData:
                return
            default:
                print("error activating")
                return
            }
        } catch let error {
            print("Error fetching: \(error.localizedDescription)")
        }
    }
    
    private func fetchAppVersion() -> String {
        guard let info = Bundle.main.infoDictionary,
              let appVersion = info["CFBundleShortVersionString"] as? String else { return ""}
        
        return appVersion
    }
    private func compareVersion(fetchVersion: String, appVersion: String) -> ComparisonResult {
        let majorFetch = Int(Array(fetchVersion.split(separator: "."))[0])!
        let majorApp = Int(Array(appVersion.split(separator: "."))[0])!
        
        if majorApp > majorFetch {
            return ComparisonResult.orderedDescending
        } else if majorApp < majorFetch {
            return ComparisonResult.orderedAscending
        }
        
        let minorFetch = Int(Array(fetchVersion.split(separator: "."))[1])!
        let minorApp = Int(Array(appVersion.split(separator: "."))[1])!
        
        if minorApp > minorFetch {
            return ComparisonResult.orderedDescending
        } else if minorApp < minorFetch {
            return ComparisonResult.orderedAscending
        }
        return ComparisonResult.orderedSame
    }
}
