//
//  RecordsTableViewCell.swift
//  Rublex
//
//  Created by Macbook on 26.10.2023.
//

import UIKit

class RecordsTableViewCell: UITableViewCell {
    
    static var identifier: String { "\(Self.self)" }

//    private
    let label: UILabel = {
        let label = UILabel()
        let labelWidth = 50
        let labelHeight = 30
        let labelY = 10
        label.frame = CGRect(x: 0, y: labelY, width: labelWidth , height: labelHeight)
        label.font = UIFont.systemFont(ofSize: 25.0)
        label.textColor = .black
        label.numberOfLines = 0

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.autoresizingMask = .flexibleHeight
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with string: String) {
        label.text = string
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
}
