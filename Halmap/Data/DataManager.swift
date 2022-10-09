//
//  DataManager.swift
//  Halmap
//
//  Created by 전지민 on 2022/10/09.
//

import Foundation

class DataManager: ObservableObject {
    
    var selectedTeam: String = (UserDefaults.standard.string(forKey: "selectedTeam") ?? "Hanwha")
    var teams: [Team] = []
    @Published var teamSongList: [TeamSong] = []
    @Published var playerList: [Player] = []
    
    init() {
        loadData()
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
}
