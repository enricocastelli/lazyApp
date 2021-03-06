//
//  NavigationC.swift
//  StayHome
//
//  Created by Enrico Castelli on 23/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit

class Navigation: UINavigationController, FirestoreProvider, AlertProvider {
    
    fileprivate var detailOpeningFrame: CGRect?
    var isPresentingDetail: Bool {
        return lastVC is DetailPresentable
    }
    var swipe: UIPanGestureRecognizer!
    var lastVC: UIViewController? {
        return self.viewControllers.last
    }
    var firstVC: UIViewController? {
        return self.viewControllers.first
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        interactivePopGestureRecognizer?.isEnabled = false
        swipe = UIPanGestureRecognizer(target: self, action: #selector(swiped(_:)))
        swipe.delegate = self
        view.addGestureRecognizer(swipe)
        guard !isFirstTime() else { return }
        addFriendsObserver { (newFriends) in
            self.presentAlert("Hey!", subtitle: "Someone just added you! \(self.friendsString(newFriends))", firstButtonTitle: "Add Them", secondButtonTitle: "Nope", firstCompletion: {
                for fr in newFriends {
                    self.addFriendToSelf(fr, success: { }) { (_) in } }
            }) {
                self.removePendingFriends(success: { }) { (_) in }
            }
        }
    }
    
    func friendsString(_ friends: [String]) -> String {
        var str = "\n"
        for fr in friends {
            str.append("\(fr)\n")
        }
        return str
    }
    
    @objc func swiped(_ swipe: UIPanGestureRecognizer) {
        let loc = swipe.location(in: view)
        guard viewControllers.count > 1, let direction = swipe.direction else { return }
        switch swipe.state {
        case .ended:
            isPresentingDetail ? closeDetail() : pop()
        case .began:
            swipeBegan(loc, direction)
        default: break
        }
    }
    
    private func swipeBegan(_ loc: CGPoint, _ direction: GestureDirection) {
        if isPresentingDetail {
            guard direction == .Down  else {
                swipe.isEnabled = false
                defer { swipe.isEnabled = true }
                return
            }
        } else {
            guard loc.x < view.frame.width/2, direction == .Right else {
                swipe.isEnabled = false
                defer { swipe.isEnabled = true }
                return
            }
        }
    }
    
    func push(_ toVC: UIViewController, shouldRemove: Bool = false) {
        guard let window = UIApplication.shared.windows.first,
            let fromVC = lastVC else { return }
        let preanimationPosition: CGFloat = 8.0
        let previousPagePosition = -view.frame.width
        let nextPagePosition = view.frame.width
        toVC.view.frame = UIScreen.main.bounds
        toVC.view.transform = CGAffineTransform(translationX: nextPagePosition, y: 0)
        window.addSubview(toVC.view)
        UIView.animate(withDuration: 0.07, animations: {
            fromVC.view.transform = CGAffineTransform(translationX: preanimationPosition, y: 0)
        }, completion: { (_) in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: [.allowUserInteraction], animations: {
                fromVC.view.transform = CGAffineTransform(translationX: previousPagePosition, y: 0)
                toVC.view.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: { (_) in
                self.viewControllers.append(toVC)
                if shouldRemove {
                    self.viewControllers = [toVC]
                }
            })
        })
    }
    
    func pop() {
        guard let window = UIApplication.shared.delegate?.window,
            self.viewControllers.count > 1,
            let fromVC = lastVC,
            let index = self.viewControllers.firstIndex(of: fromVC) else { return }
        let toVC = self.viewControllers[index - 1]
        let preanimationPosition: CGFloat = -8.0
        let previousPagePosition = view.frame.width
        let nextPagePosition = -view.frame.width
        toVC.view.transform = CGAffineTransform(translationX: nextPagePosition, y: 0)
        window?.addSubview(toVC.view)
        UIView.animate(withDuration: 0.07, animations: {
            fromVC.view.transform = CGAffineTransform(translationX: preanimationPosition, y: 0)
        }, completion: { (_) in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: [.allowUserInteraction], animations: {
                fromVC.view.transform = CGAffineTransform(translationX: previousPagePosition, y: 0)
                toVC.view.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: { (_) in
                self.viewControllers.removeLast()
            })
        })
    }
    
    func presentDetail(_ toVC: DetailPresentable, frame: CGRect) {
        guard let window = UIApplication.shared.delegate?.window,
        let fromVC = lastVC else { return }
        detailOpeningFrame = frame
        toVC.view.frame = frame
        toVC.modalPresentationStyle = .overCurrentContext
        window?.addSubview(toVC.view)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: [.allowUserInteraction], animations: {
            toVC.view.frame = fromVC.view.frame
            toVC.animateOpening()
        }, completion: { (_) in
            self.viewControllers.append(toVC)
        })
    }
    
    func closeDetail() {
        guard let window = UIApplication.shared.delegate?.window,
            let detailOpeningFrame = detailOpeningFrame,
            self.viewControllers.count > 1,
            let fromVC = lastVC,
            let detail = fromVC as? DetailPresentable,
            let index = self.viewControllers.firstIndex(of: fromVC) else { return }
        let toVC = self.viewControllers[index - 1]
        window?.insertSubview(toVC.view, at: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: [.allowUserInteraction], animations: {
            detail.view.frame = detailOpeningFrame
            detail.animateClosing()
        }, completion: { (_) in
            self.viewControllers.removeLast()
        })
    }
}

extension Navigation: UIGestureRecognizerDelegate {
    
}
