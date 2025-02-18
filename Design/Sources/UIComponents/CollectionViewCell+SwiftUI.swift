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
//import UIKit
//import SwiftUI

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

#if os(macOS)
import SwiftUI
import AppKit

public class CollectionViewItem<Content>: NSCollectionViewItem where Content: View {
    
    private var hostingController: NSHostingController<Content>?

    // MARK: - Lifecycle
    public override func loadView() {
        // On macOS, we need to create an NSView for this item manually.
        self.view = NSView(frame: .zero)
    }

    /// Configure the SwiftUI content for this collection item.
    /// - Parameters:
    ///   - content: The SwiftUI view you want to display
    ///   - size: Optional size for the view. If omitted, the view will size itself.
    public func set(content: Content, size: CGSize? = nil) {
        // Remove any existing hosting controller before configuring a new one
        if hostingController != nil {
            hostingController?.view.removeFromSuperview()
            hostingController = nil
        }

        let controller = NSHostingController(rootView: content)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the SwiftUI view to the NSCollectionViewItem's main view
        view.addSubview(controller.view)
        hostingController = controller

        // Centering constraints
        NSLayoutConstraint.activate([
            controller.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controller.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        // If a fixed size is provided, explicitly constrain the view
        if let viewSize = size {
            NSLayoutConstraint.activate([
                controller.view.widthAnchor.constraint(equalToConstant: viewSize.width),
                controller.view.heightAnchor.constraint(equalToConstant: viewSize.height)
            ])
        } else {
            // Otherwise, let the SwiftUI content size itself
            NSLayoutConstraint.activate([
                controller.view.topAnchor.constraint(equalTo: view.topAnchor),
                controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }

    // MARK: - Reuse
    public override func prepareForReuse() {
        super.prepareForReuse()
        // Ensure the hosting controller’s view is removed
        hostingController?.view.removeFromSuperview()
        hostingController = nil
    }
}

#else
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

#endif
