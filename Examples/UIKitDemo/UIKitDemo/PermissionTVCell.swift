//
//  PermissionTVCell.swift
//  UIKitDemo
//
//  Created by Nexios Technologies on 20/11/25.
//

import UIKit
import PermissionKit

class PermissionTVCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var allowButton: UIButton!
    
    var onTapAllow: (() -> Void)?
    
    func configure(with item: PermissionItem) {
        titleLabel.text = "\(item.type)"
        
        switch item.status {
        case .authorized:
            allowButton.setTitle("Allowed", for: .normal)
            allowButton.isEnabled = false
            allowButton.alpha = 0.5
        default:
            allowButton.setTitle("Allow", for: .normal)
            allowButton.isEnabled = true
            allowButton.alpha = 1
        }
    }
    
    @IBAction func didTapAllow() {
        onTapAllow?()
    }
}
