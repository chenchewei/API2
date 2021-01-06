//
//  ChangeDistanceDialogVC.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2021/1/2.
//  Copyright © 2021 mmslab-mini. All rights reserved.
//

import UIKit

protocol ChangeDistanceDialogVCDelegate: class {
    func passDistance(distance: Int)
}


class ChangeDistanceDialogVC: UIViewController {

    @IBOutlet var tableView_distance: UITableView!
    weak var delegate: ChangeDistanceDialogVCDelegate?
    let disArr = [500,1000,1500,2000,2500]
    var currentDis = 2000
    
    convenience init(currentDis: Int) {
        self.init()
        self.currentDis = currentDis
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView_distance.register(UINib(nibName: "DistanceTableViewCell", bundle: nil), forCellReuseIdentifier: "DistanceTableViewCell")
        // Do any additional setup after loading the view.
    }
    @IBAction func cancelBtnClicked(_ sender: Any) {
        dialogDismiss()
    }
    

    
}

extension ChangeDistanceDialogVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceTableViewCell", for: indexPath) as! DistanceTableViewCell
        cell.setCell(dis: disArr[indexPath.row], isCheck: (disArr[indexPath.row] == currentDis))
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
extension ChangeDistanceDialogVC: DistanceTableViewCellDelegate {
    func checked(cell: UITableViewCell) {
        
        guard let indexPath = tableView_distance.indexPath(for: cell) else { return }
        
        delegate?.passDistance(distance: disArr[indexPath.row])
        // self dismiss
        
    }
    
    
}
extension UIViewController {
    
    func removePresented(completion:(() -> Void)? = nil) {
        guard let presented = self.presentedViewController else { return }
        presented.dialogDismiss(completion: completion)
    }
    
    
    func dialogShow(vc: UIViewController) {
        self.modalPresentationStyle = .overFullScreen
        let transition = CATransition()
        transition.duration = 0.1
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.window?.layer.add(transition, forKey: kCATransition)
        vc.present(self, animated: false) {
            self.view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.view.alpha = 0
            UIView.animate(withDuration: 0.1, animations: {
                self.view.alpha = 1
                self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    func dialogDismiss(completion:(() -> Void)? = nil) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromTop
        self.view.window?.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: completion)
    }
}
