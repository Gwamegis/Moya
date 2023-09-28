//
//  TeamSelectionViewModel.swift
//  Halmap
//
//  Created by 이지원 on 2023/09/29.
//

import Foundation

final class TeamSelectionViewModel: ObservableObject {
    @Published var buttonPressed = [Bool](repeating: false, count: 10)
    @Published var selectedTeam: TeamName? = nil
    
    private var dataManager: DataManager
    private var teamLogo = TeamName.allCases
    
    init(dataManager: DataManager, selectedTeamName: String? = nil) {
        self.dataManager = dataManager
        if let selectedTeamName {
            setSelectedTeam(teamName: selectedTeamName)
        }
    }
    
    func didSelectedTeam(with team: TeamName) {
        selectedTeam = team
    }
    
    func isSelectedTeam(with team: TeamName) -> Bool {
        guard let selectedTeam else { return false }
        return selectedTeam == team
    }
    
    func isExistSelectedTeam() -> Bool {
        selectedTeam != nil
    }
    
    func didTappedStartButton() {
        guard let selectedTeam else { return }
        let teamName = selectedTeam.rawValue
        UserDefaults.standard.set(teamName, forKey: "selectedTeam")
        dataManager.setSongList(team: teamName)
    }
    
    func getSelectedTeamName() -> String {
        selectedTeam?.rawValue ?? "error"
    }
    
    private func setSelectedTeam(teamName: String) {
        selectedTeam = TeamName.allCases.first(where: { $0.rawValue == teamName })
    }
}
