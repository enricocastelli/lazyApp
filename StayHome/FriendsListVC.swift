//
//  FriendsListVC.swift
//  StayHome
//
//  Created by Enrico Castelli on 22/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit

class FriendsListVC: UIViewController, FirestoreProvider, AlertProvider {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var barView: BarView!

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var players = [Player]()
    var filteredPlayers = [Player]()
    var animationEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setBarView()
        emptyView.alpha = 0
        getData()
        emptyLabel.font = Font.with(.light, 23)
        searchField.delegate = self
        searchField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func setTableView() {
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: RankingCell.identifier, bundle: nil), forCellReuseIdentifier: RankingCell.identifier)
    }
    
    private func setBarView(){
        barView.onLeftTap = backTapped
        barView.onRightTap = addTapped
        barView.rightImage = UIImage(systemName: "plus.circle.fill")
        barView.lineHidden = true
    }
    
    func getData() {
        getFriends(success: { (players) in
            players.isEmpty ? self.showEmptyView() : self.hideEmptyView()
            self.players = players
            self.filteredPlayers = players
            self.tableView.reloadData()
        }) { (error) in
            self.presentGeneralError(error)
        }
    }
    
    private func showEmptyView() {
        barView.animateRightButton()
        UIView.animate(withDuration: 0.3) {
            self.emptyView.alpha = 1
        }
    }
    
    private func hideEmptyView() {
        barView.stopAnimateRightButton()
        UIView.animate(withDuration: 0.3) {
            self.emptyView.alpha = 0
        }
    }
    
    private func backTapped() {
        view.endEditing(true)
        navigation.pop()
    }
    
    private func addTapped() {
        view.endEditing(true)
        self.present(AddFriendVC(), animated: true, completion: nil)
    }
    
    @objc private func viewTapped() {
        view.endEditing(true)
    }
}

extension FriendsListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RankingCell.identifier, for: indexPath) as! RankingCell
        cell.player = filteredPlayers[indexPath.row]
        cell.hideExtra()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard animationEnabled else { return }
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: -view.frame.width, y: 0)
        cell.transform = transform
        UIView.animate(withDuration: 0.07, delay: 0.03*Double(indexPath.row), usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: [.curveEaseInOut], animations: {
            cell.transform = CGAffineTransform.identity
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RankingCell
        let playerVC = PlayerVC(self.filteredPlayers[indexPath.row])
        playerVC.delegate = self
        navigation.presentDetail(playerVC, frame:  cell.frameInSuperview())
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        animationEnabled = false
    }
}

extension FriendsListVC: UITextFieldDelegate {
    
    @objc func textChanged(_ textField: UITextField) {
        animationEnabled = false
        guard let text = textField.text else { return }
        filteredPlayers = players.filter({ $0.name.lowercased().starts(with: text.lowercased())})
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension FriendsListVC: PlayerVCDelegate {

    func shouldUpdate() {
        getData()
    }

}
