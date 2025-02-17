//import SwiftUI
//
//class CardCollectionViewCell: UICollectionViewCell {
//    private var host: UIHostingController<EventCard>?
//
//    func configure(with event: Event) {
//        let eventCardView = EventCard(event: event)
//        self.host = UIHostingController(rootView: eventCardView)
//
//        // Add as a child of the current view controller
//        guard let hostView = host?.view else { return }
//        hostView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(hostView)
//
//        // Set constraints to match the parent view
//        NSLayoutConstraint.activate([
//            hostView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            hostView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            hostView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            hostView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//        ])
//    }
//}
import UIKit
import SwiftUI

//public class CollectionViewCell<Content: View>: UICollectionViewCell {
//    private var hostingController: UIHostingController<Content>?
//
//    public func configure(with content: Content) {
//        self.hostingController = UIHostingController(rootView: content)
//
//        // Add as a child of the current view controller
//        guard let hostingView = hostingController?.view else { return }
//        hostingView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(hostingView)
//
//        // Set constraints to match the parent view
//        NSLayoutConstraint.activate([
//            hostingView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            hostingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            hostingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            hostingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//        ])
//    }
//}

//public class CollectionViewCell<Content: View>: UICollectionViewCell {
//    private var hostingController: UIHostingController<Content>?
//
//    public override func prepareForReuse() {
//        super.prepareForReuse()
//        hostingController?.view.removeFromSuperview()
//        hostingController = nil
//    }
//
//
//    public func configure(with content: Content, frameSize: CGSize? = nil) {
//        if let hostingController = self.hostingController {
//            hostingController.rootView = content
//        } else {
//            self.hostingController = UIHostingController(rootView: content)
//            guard let hostingView = hostingController?.view else { return }
//            hostingView.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview(hostingView)
//
//            // Set constraints to match the parent view
//            NSLayoutConstraint.activate([
//                hostingView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//                hostingView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            ])
//            if let size = frameSize {
//                NSLayoutConstraint.activate([
//                    hostingView.widthAnchor.constraint(equalToConstant: size.width),
//                    hostingView.heightAnchor.constraint(equalToConstant: size.height)
//                ])
//            }else {
//                NSLayoutConstraint.activate([
//                    hostingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//                    hostingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
//                ])
//            }
//        }
//    }
//}

import SwiftUI
import UIKit

public class CollectionViewCell<Content>: UICollectionViewCell where Content: View {
    private var hostingController: UIHostingController<Content>?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func set(content: Content, size: CGSize? = nil) {
        if hostingController != nil {
            hostingController?.view.removeFromSuperview()
            hostingController = nil
        }

        let controller = UIHostingController(rootView: content)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        controller.view.frame.size = size
//        contentView.clipsToBounds = true
        contentView.addSubview(controller.view)
        hostingController = controller

        NSLayoutConstraint.activate([
            controller.view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            controller.view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        if let viewSize = size {
            NSLayoutConstraint.activate([
                controller.view.widthAnchor.constraint(equalToConstant: viewSize.width),
                controller.view.heightAnchor.constraint(equalToConstant: viewSize.height)
            ])
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        // Ensure the hosting controller's view is removed from the superview
        // and the hosting controller is set to nil when the cell is being prepared for reuse
        hostingController?.view.removeFromSuperview()
        hostingController = nil
    }
}

