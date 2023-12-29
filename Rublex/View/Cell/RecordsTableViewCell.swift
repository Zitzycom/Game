//
//  RecordsTableViewCell.swift
//  Rublex
//
//  Created by Macbook on 26.10.2023.
//

import UIKit

final class RecordsTableViewCell: UITableViewCell {
    static var identifier: String { "\(Self.self)" }
    
    // MARK: -  Private properties
    
    private lazy var namelabel: UILabel = {
        cellsSetting()
    }()
    
    private lazy var recordLabel: UILabel = {
        cellsSetting()
    }()
    
    private lazy var dateLabel: UILabel = {
        cellsSetting()
    }()
    
    private lazy var avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(namelabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(recordLabel)
        contentView.addSubview(avatar)
        contentView.autoresizingMask = .flexibleHeight
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Other Methods
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        avatar.layer.cornerRadius = avatar.frame.height / .two
        avatar.clipsToBounds = true
    }

    func configure(player: Player) {
        let gameManager = GameManager()
        namelabel.text = player.name
        recordLabel.text = String(player.score)
        if player.date != nil {
            dateLabel.text = dateFormate(date: (player.date ?? .distantPast))
        }
        let image = gameManager.getImageFromUserDefaults(key: player.name ?? "")
        avatar.image = image
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        namelabel.text = nil
        recordLabel.text = nil
        dateLabel.text = nil
        avatar.image = nil
    }
    
    // MARK: - Private Methods
    
    private func cellsSetting() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: LocalConstants.fontSize)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func dateFormate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = LocalConstants.dateFormat
        return dateFormatter.string(from: date)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate(
            [avatar.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: LocalConstants.smallIndent),
         avatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
             avatar.widthAnchor.constraint(equalToConstant: LocalConstants.avatarSize),
             avatar.heightAnchor.constraint(equalToConstant: LocalConstants.avatarSize)])
        
        NSLayoutConstraint.activate([
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -LocalConstants.smallIndent),
            dateLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: LocalConstants.bigIndent)
        ])

        NSLayoutConstraint.activate([
            namelabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor , constant: LocalConstants.bigIndent),
            namelabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LocalConstants.smallIndent)
        ])

        NSLayoutConstraint.activate([
            recordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LocalConstants.smallIndent),
            recordLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

extension RecordsTableViewCell {
    private enum LocalConstants {
        static var dateFormat: String {"yyyy-MM-dd HH:mm:ss"}
        static var smallIndent : CGFloat {10}
        static var bigIndent: CGFloat {50}
        static var avatarSize: CGFloat {60}
        static var fontSize: CGFloat {20}
    }
}
