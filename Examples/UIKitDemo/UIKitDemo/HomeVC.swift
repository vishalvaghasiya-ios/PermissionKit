//
//  HomeVC.swift
//  UIKitDemo
//
//  Created by Nexios Technologies on 20/11/25.
//

import UIKit
import PermissionKit

class HomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var permissions: [PermissionItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupData()
    }

    private func setupData() {
        tableView.register(UINib(nibName: "PermissionTVCell", bundle: nil), forCellReuseIdentifier: "PermissionTVCell")
        let all: [AppPermission] = [
            .camera,
            .photos,
            .locationWhenInUse,
            .locationAlways,
            .notifications,
            .microphone,
            .contacts,
            .calendar,
            .reminders,
            .speech,
            .motion,
            .tracking,
            .screenRecording,
            .health,
            .mediaLibrary
        ]

        // 1) Initialize UI immediately with placeholders (fast, non-blocking)
        permissions = all.map { PermissionItem(type: $0, status: .notDetermined) }

        tableView.reloadData()

        // 2) Asynchronously fetch actual statuses off the main thread so we never block UI.
        //    This prevents deadlocks from permission implementations that perform work/waits.
        for (index, perm) in permissions.enumerated() {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let actualStatus = PermissionKit.status(perm.type)
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    // ensure index is still valid (in case data changed)
                    guard index < self.permissions.count, self.permissions[index].type == perm.type else {
                        // fallback: try to find the permission by type
                        if let idx = self.permissions.firstIndex(where: { $0.type == perm.type }) {
                            self.permissions[idx].status = actualStatus
                            self.tableView.reloadRows(at: [IndexPath(row: idx, section: 0)], with: .automatic)
                        }
                        return
                    }
                    self.permissions[index].status = actualStatus
                    // update row if visible otherwise let cellForRow update when scrolled into view
                    let indexPath = IndexPath(row: index, section: 0)
                    if let visible = self.tableView.indexPathsForVisibleRows, visible.contains(indexPath) {
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
    }

}
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return permissions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PermissionTVCell", for: indexPath) as! PermissionTVCell
        let item = permissions[indexPath.row]
        cell.configure(with: item)
        cell.onTapAllow = { [weak self] in
            guard let self = self else { return }
            PermissionKit.request(item.type) { status in
                DispatchQueue.main.async {
                    self.permissions[indexPath.row].status = status
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
        return cell
    }
}

struct PermissionItem {
    let type: AppPermission
    var status: PermissionStatus
}
