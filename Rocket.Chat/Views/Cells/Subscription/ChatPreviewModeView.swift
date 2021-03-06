//
//  ChatPreviewModeView.swift
//  Rocket.Chat
//
//  Created by Rafael K. Streit on 19/11/16.
//  Copyright © 2016 Rocket.Chat. All rights reserved.
//

import UIKit

protocol ChatPreviewModeViewProtocol: class {
    func userDidJoinedSubscription()
}

final class ChatPreviewModeView: UIView {

    weak var delegate: ChatPreviewModeViewProtocol?
    var subscription: Subscription! {
        didSet {
            let format = localized("chat.channel_preview_view.title")
            let string = String(format: format, subscription.displayName())
            labelTitle.text = string
        }
    }

    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonJoin: UIButton! {
        didSet {
            buttonJoin.layer.cornerRadius = 4
            buttonJoin.setTitle(localized("chat.channel_preview_view.join"), for: .normal)
        }
    }

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: IBAction

    @IBAction func buttonJoinDidPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        buttonJoin.setTitle("", for: .normal)

        SubscriptionManager.join(room: subscription.rid) { [weak self] _ in
            self?.activityIndicator.stopAnimating()
            self?.buttonJoin.setTitle(localized("chat.channel_preview_view.join"), for: .normal)
            self?.delegate?.userDidJoinedSubscription()
        }
    }

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    private let requiredBottomInset: CGFloat = 10

    var bottomInset: CGFloat {
        get {
            return bottomConstraint.constant - requiredBottomInset
        }
        set {
            bottomConstraint.constant = newValue + requiredBottomInset
        }
    }
}

extension ChatPreviewModeView {
    override func applyTheme() {
        super.applyTheme()
        guard let theme = theme else { return }
        labelTitle.textColor = theme.auxiliaryText
        seperatorView.backgroundColor = theme.mutedAccent
        buttonJoin.backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.2039215686, blue: 0.2392156863, alpha: 1)
        backgroundColor = theme.focusedBackground
    }
}
