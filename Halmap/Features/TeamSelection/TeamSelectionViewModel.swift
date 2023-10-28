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
    private var initialSelectedTeam: TeamName? = nil
    
    init(dataManager: DataManager, selectedTeamName: String? = nil) {
        self.dataManager = dataManager
        if let selectedTeamName {
            initialSelectedTeam = converStringToTeamName(selectedTeamName)
        }
    }
    
    func didSelectedTeam(with team: TeamName) {
        selectedTeam = team
    }
    
    func isSelectedTeam(with team: TeamName) -> Bool {
        guard let selectedTeam else {
            return initialSelectedTeam == team
        }
        return selectedTeam == team
    }
    
    func isChangedSelectedTeam() -> Bool {
        if let initialSelectedTeam, let selectedTeam {
            return initialSelectedTeam != selectedTeam
        }
        return selectedTeam != nil
    }
    
    func didTappedStartButton() -> Bool {
        guard let selectedTeam else { return true }
        let teamName = selectedTeam.rawValue
        UserDefaults.standard.set(teamName, forKey: "selectedTeam")
        dataManager.setSongList(team: teamName)
        return false
    }
    
    func getSelectedTeamName() -> String {
        selectedTeam?.rawValue ?? "error"
    }
    
    private func converStringToTeamName(_ teamName: String) -> TeamName? {
        TeamName.allCases.first(where: { $0.rawValue == teamName })
    }
}
