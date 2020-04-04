//
//  RankingVC.swift
//  StayHome
//
//  Created by Enrico Castelli on 22/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit


class RankingVC: UIViewController, FirestoreProvider, AlertProvider, ScreenshotProvider {
    
    var players: [Player]?
    @IBOutlet weak var barView: BarView!
    @IBOutlet weak var tableView: UITableView!
    var shareView: ShareView?
    var shareIsOpen = false
    var animationEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setBarView()
        getData()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }

    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        tableView.register(UINib(nibName: RankingCell.identifier, bundle: nil), forCellReuseIdentifier: RankingCell.identifier)
        tableView.backgroundColor = .white
    }
    
    private func setBarView() {
        barView.onLeftTap = backTapped
        barView.onRightTap = shareTapped
        barView.rightImage = UIImage(systemName: "square.and.arrow.up")
    }
    
    private func getData() {
        getFriends(success: { (players) in
            if let mePlayer = UserData.shared.mePlayer {
                self.players = players + [mePlayer]
            } else {
                self.players = players
            }
            self.players?.sort(by: { $0.score > $1.score })
            self.tableView.reloadData()
        }) { (error) in
            self.presentGeneralError(error)
        }
    }
    
    private func bounce(_ row: Int, _ cell: RankingCell){
        guard animationEnabled else { return }
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: 0, y: view.frame.height)
        transform = transform.scaledBy(x: 0.4, y: 1)
        cell.transform = transform
        let duration = row <= 2 ? 0.4 : 0.3
        let delay = row <= 2 ? (0.3*Double(row)) : 1.0
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: [.curveEaseInOut], animations: {
            cell.transform = CGAffineTransform.identity
        }) { (_) in
            cell.animateProgress()
        }
    }
    
    
    private func backTapped() {
        view.endEditing(true)
        navigation.pop()
    }
    
    private func shareTapped() {
        shareIsOpen ? closeShareView() : openShareView()
        shareIsOpen = !shareIsOpen
    }
    
    @objc private func viewTapped() {
        shareIsOpen ? closeShareView() : nil
    }
    
    private func openShareView() {
        guard let image = takeScreenshot() else { return }
        barView.rightImage = UIImage(systemName: "square.and.arrow.up.fill")
        let size = barView.rightButton.frame
        shareView = ShareView(image, startingFrame: size)
        view.addSubview(shareView!)
    }
    
    
    private func closeShareView() {
        barView.rightImage = UIImage(systemName: "square.and.arrow.up")
        shareView?.close()
    }
    
   func willTakeScreenshot() {
        barView.isHidden = true
    }
    
    func didTakeScreenShot() {
        barView.isHidden = false
    }
}

extension RankingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RankingCell.identifier, for: indexPath) as! RankingCell
        cell.player = players?[indexPath.row]
        cell.index = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        bounce(indexPath.row, cell as! RankingCell)
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        animationEnabled = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}


