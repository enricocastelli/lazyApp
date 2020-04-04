//
//  HomeVC.swift
//  StayHome
//
//  Created by Enrico Castelli on 22/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController, FirestoreProvider, HealthProvider, AlertProvider, TextPresenter, RemoteConfigProvider {

    @IBOutlet weak var stepsContainerView: UIView!
    @IBOutlet weak var titleContainerView: UIView!
    @IBOutlet weak var tabView: TabView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var line: UILabel!
    @IBOutlet weak var blurredView: UIVisualEffectView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lineConstraint: NSLayoutConstraint!
    
    var animalView: AnimalView?
    var stepsCounter: CounterView?
    var canCallData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        setCollection()
        tabView.delegate = self
        if let animal = getAnimal() {
            collectionView.scrollToItem(at: IndexPath(row: animal.rawValue, section: 0), at: .centeredHorizontally, animated: false)
        }
        updateData {
            guard let score = UserData.shared.score else { return }
            self.startInitialAnimation(score)
        }
        blurredView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        canCallData = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !hasAnimalSubview(), let score = UserData.shared.mePlayer?.score {
            addView(LazyAnimal.typeForLevel(score), duration: 0.1)
        }
        guard canCallData else { return }
        updateData {
            guard let score = UserData.shared.score else { return }
            self.stepsCounter?.update(score, {
                let animalUpdated = LazyAnimal.typeForLevel(score)
                if self.getAnimal() != animalUpdated {
                    self.storeAnimal(animalUpdated)
                    self.removeAnimalSubviews()
                    self.goToIndex(score)
                }
                self.animalView = AnimalView(LazyAnimal.typeForLevel(score))
            })
        }
    }
    
    private func setTitle() {
        let time = Date().getTime()
        let string = getTitle() ?? "GOOD \(time.string.uppercased())"
        let first = addText(string, delay: 0.5, duration: 1, position: CGPoint(x: 36, y: 0), lineWidth: 0.5, font: Font.with(.hairline, 27), color: UIColor.darkGray.withAlphaComponent(0.5), inView: titleContainerView)
        let _ = addText(getName() + " !", delay: 1.5, duration: 0.5, position: CGPoint(x: 36, y: first.frame.maxY + first.path!.boundingBox.height + 16), lineWidth: 1, font: Font.with(.thin, 36), color: UIColor.darkGray.withAlphaComponent(0.8), inView: titleContainerView)
    }
    
    private func setCollection() {
        collectionView.register(UINib(nibName: LazyAnimalCell.identifier, bundle: nil), forCellWithReuseIdentifier: LazyAnimalCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        let inset = (view.frame.width/2) - (view.frame.width/4)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        collectionView.alpha = 0
    }

    
    func updateData(_ completion: @escaping() -> ()) {
        self.getAll { (steps, distance) in
            self.update(steps: steps, distance: distance, {
                completion()
            }) { (error) in
                self.presentGeneralError(error)
                completion()
            }
        }
    }
    
    private func addBigView(_ animal: LazyAnimal) {
        if let bigView = view.subviews.filter({ $0.isKind(of: RoundView.self)}).first {
            UIView.animate(withDuration: 0.4) {
                bigView.backgroundColor = animal.color
            }
        } else {
            let bigView = RoundView(frame: CGRect(x: 0, y: 0, width: view.frame.width*1.5, height: view.frame.width*1.5))
            bigView.backgroundColor = animal.color
            bigView.center = CGPoint(x: view.center.x, y: 0)
            bigView.transform = CGAffineTransform(scaleX: 0, y: 0)
            bigView.alpha = 0.2
            view.insertSubview(bigView, at: 0)
            UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: {
                bigView.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    private func startInitialAnimation(_ lazy: Double) {
        self.stepsCounter = CounterView(lazy, {
            self.goToIndex(lazy)
        })
        
        self.stepsContainerView.addContentView(self.stepsCounter!)
    }
    
    private func goToIndex(_ lazy: Double) {
        let animal = LazyAnimal.typeForLevel(lazy)
        addBigView(animal)
        storeAnimal(animal)
        line.backgroundColor = animal.color
        lineConstraint.constant = stepsCounter!.frame.width
        collectionView.scrollToItem(at: IndexPath(item: animal.index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func addView(_ animal: LazyAnimal, duration: Double = 0.5) {
        guard let cell = collectionView.cellForItem(at: IndexPath(item: animal.index, section: 0)) else { return }
        animalView =  AnimalView(animal)
        animalView!.delegate = self
        guard navigation.lastVC == self else { return }
        animalView!.frame = cell.frameInSuperview()
        view.insertSubview(animalView!, aboveSubview: blurredView)
        UIView.animate(withDuration: duration, animations: {
            self.collectionView.alpha = 0.2
            self.animalView!.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (_) in
        }
    }
    
    func removeAnimalSubviews() {
        for subview in view.subviews {
            if subview.isKind(of: AnimalView.self) {
                subview.removeFromSuperview()
            }
        }
    }
    
    func hasAnimalSubview() -> Bool {
        guard let animalView = animalView else { return false }
        return view.subviews.contains(animalView)
    }
    
    @objc func viewTapped() {
        animalView?.dismiss()
    }
    
    func openGames() {
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
          }
        }
        navigation.push(FriendsListVC())
    }
    
    func openRanking() {
        navigation.push(RankingVC())
    }
    
    func openAddFriend() {
        self.present(AddFriendVC(), animated: true, completion: nil)
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LazyAnimal.array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LazyAnimalCell.identifier, for: indexPath) as! LazyAnimalCell
        cell.animal = LazyAnimal.array[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.width/2
        return CGSize(width: size, height: size/0.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return view.frame.width/5
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard let animal = getAnimal() else { return }
        if !self.hasAnimalSubview() {
            self.addView(animal)
        } else {
            self.animalView!.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
    }
}

extension HomeVC: TabViewDelegate {
    
    func didTapIndex(_ index: Int) {
        switch index {
        case 0: openAddFriend()
        case 1: openGames()
        case 2: openRanking()
        default:
            break
        }
    }
}

extension HomeVC: AnimalViewDelegate {
    
    func willTakeScreenshot() {
        tabView.isHidden = true
    }
    
    func didTakeScreenShot() {
        tabView.isHidden = false
    }
    
    
    func didOpen() {
        blurredView.isHidden = false
        blurredView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.blurredView.alpha = 1
        }
    }
    
    func didClose() {
        UIView.animate(withDuration: 0.3) {
            self.blurredView.alpha = 0
        }
    }
    
    
}

