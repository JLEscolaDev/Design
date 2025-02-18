//import Foundation
//import SwiftUI

//class EventTableViewCell: UITableViewCell {
//    private var host: UIHostingController<EventCard>? = nil
//
//    // Add a SwiftUI view to the cell
//    func addSwiftUIView(_ event: Event) {
//        // Create a hosting controller with the SwiftUI view
//        let view = EventCard(event: event)
//        self.host = UIHostingController(rootView: view)
//        
//        // Add as a child of the current view controller
//        guard let hostView = host?.view else { return }
//        hostView.translatesAutoresizingMaskIntoConstraints = false
//        self.contentView.addSubview(hostView)
//        
//        // Set constraints to match the parent view
//        NSLayoutConstraint.activate([
//            hostView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
//            hostView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
//            hostView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
//            hostView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
//        ])
//    }
//}

//import UIKit
//import SwiftUI

//class EventTableViewCell<Content: View>: UITableViewCell {
//    private var hostingView: SwiftUIHostingView<Content>?
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        commonInit()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//
//    private func commonInit() {
//        hostingView = SwiftUIHostingView<Content>()
//        hostingView?.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(hostingView!)
//        NSLayoutConstraint.activate([
//            hostingView!.topAnchor.constraint(equalTo: contentView.topAnchor),
//            hostingView!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            hostingView!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            hostingView!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
//        ])
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        hostingView?.clearSwiftUIView()
//    }
//
//    func addSwiftUIView(_ view: Content) {
//        hostingView?.setSwiftUIView(view)
//    }
//}
import SwiftUI
#if os(macOS)
import AppKit

public class SwiftUIHostingView<Content: View>: NSView {
    private var hostingController: NSHostingController<AnyView>?

    public func setSwiftUIView(_ view: Content) {
        let typeErasedView = AnyView(view)

        // If there's no existing hosting controller, create one and add its view.
        if hostingController == nil {
            hostingController = NSHostingController(rootView: typeErasedView)
            guard let hostView = hostingController?.view else { return }

            hostView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(hostView)

            NSLayoutConstraint.activate([
                hostView.leadingAnchor.constraint(equalTo: leadingAnchor),
                hostView.trailingAnchor.constraint(equalTo: trailingAnchor),
                hostView.topAnchor.constraint(equalTo: topAnchor),
                hostView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        } else {
            // If we already have a hosting controller, just update its rootView.
            hostingController?.rootView = typeErasedView
        }
    }

    public func clearSwiftUIView() {
        hostingController?.rootView = AnyView(EmptyView())
    }
}

#else

public class SwiftUIHostingView<Content: View>: UIView {
    private var hostingController: UIHostingController<AnyView>?

    public func setSwiftUIView(_ view: Content) {
        let typeErasedView = AnyView(view)
        if hostingController == nil {
            hostingController = UIHostingController(rootView: typeErasedView)
            hostingController?.view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(hostingController!.view)
            NSLayoutConstraint.activate([
                hostingController!.view.topAnchor.constraint(equalTo: topAnchor),
                hostingController!.view.bottomAnchor.constraint(equalTo: bottomAnchor),
                hostingController!.view.leadingAnchor.constraint(equalTo: leadingAnchor),
                hostingController!.view.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        } else {
            hostingController?.rootView = typeErasedView
        }
    }

    func clearSwiftUIView() {
        hostingController?.rootView = AnyView(EmptyView())
    }
}

public final class TableViewCell<Content: View>: UITableViewCell {
    private let hostingController = UIHostingController<Content?>(rootView: nil)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        hostingController.view.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func set(rootView: Content, parentController: UIViewController) {
        self.hostingController.rootView = rootView
        self.hostingController.view.invalidateIntrinsicContentSize()

        let requiresControllerMove = hostingController.parent != parentController
        if requiresControllerMove {
            parentController.addChild(hostingController)
        }

        if !self.contentView.subviews.contains(hostingController.view) {
            self.contentView.addSubview(hostingController.view)
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            hostingController.view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
            hostingController.view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
            hostingController.view.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
            hostingController.view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        }

        if requiresControllerMove {
            hostingController.didMove(toParent: parentController)
        }
    }
}
#endif

//public final class TableViewCell<Content: View>: UITableViewCell {
//    private var hostingController: UIHostingController<AnyView>?
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        hostingController = UIHostingController<AnyView>(rootView: AnyView(EmptyView()))
//        hostingController?.view.backgroundColor = .clear
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    public func set(rootView: Content, parentController: UIViewController) {
//        if hostingController?.rootView == nil {
//            hostingController = UIHostingController(rootView: AnyView(rootView))
//            hostingController?.view.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview(hostingController!.view)
//
//            NSLayoutConstraint.activate([
//                hostingController!.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//                hostingController!.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//                hostingController!.view.topAnchor.constraint(equalTo: contentView.topAnchor),
//                hostingController!.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//            ])
//
//            if hostingController?.parent != parentController {
//                parentController.addChild(hostingController!)
//                hostingController?.didMove(toParent: parentController)
//            }
//        } else {
//            let updatedController = UIHostingController(rootView: AnyView(rootView))
//            updatedController.view.translatesAutoresizingMaskIntoConstraints = false
//            hostingController?.view.removeFromSuperview()
//            hostingController?.removeFromParent()
//            hostingController = updatedController
//            contentView.addSubview(hostingController!.view)
//
//            NSLayoutConstraint.activate([
//                hostingController!.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//                hostingController!.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//                hostingController!.view.topAnchor.constraint(equalTo: contentView.topAnchor),
//                hostingController!.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//            ])
//
//            parentController.addChild(hostingController!)
//            hostingController?.didMove(toParent: parentController)
//        }
//    }
//
//    public override func prepareForReuse() {
//        super.prepareForReuse()
//
//        hostingController?.view.removeFromSuperview()
//        hostingController?.removeFromParent()
//        hostingController = nil
//    }
//}
