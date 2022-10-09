//
//  DataManager.swift
//  Halmap
//
//  Created by 전지민 on 2022/10/09.
//

import Foundation

class DataManager: ObservableObject {
    
    var teams: [Team] = []
    var teamSongList: [TeamSong] = []
    var playerList: [Player] = []
    
    init() {
        loadData()
    }
    
    func loadData(){
        let fileNm: String = "test"
        let extensionType = "json"
        
        guard let fileLocation = Bundle.main.url(forResource: fileNm, withExtension: extensionType) else { return }
        guard let jsonData = try? Data(contentsOf: fileLocation) else { return }
        
        do {
            let teamArray = try JSONDecoder().decode(TeamList.self, from: jsonData)
            self.teams = teamArray.teamLists
            
            // TODO: 데이터 불러오는 위치 다시 생각해보기
            setList(id: 0)
        }
        catch let error {
            print(error)
        }
    }
    func setList(id: Int) {
        self.teamSongList = teams[id].teamSongs
        self.playerList = teams[id].player
    }
}
