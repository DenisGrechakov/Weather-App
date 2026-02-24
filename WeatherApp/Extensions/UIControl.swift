//
//  UIControl.swift
//  Overtone
//
//  Created by Гречаков Денис on 02.02.2026.
//

import UIKit
import Combine

extension UIControl {

    struct EventPublisher: Publisher {
        typealias Output = Void
        typealias Failure = Never

        let control: UIControl
        let event: UIControl.Event

        func receive<S>(subscriber: S)
        where S : Subscriber, Never == S.Failure, Void == S.Input {

            let subscription = EventSubscription(
                subscriber: subscriber,
                control: control,
                event: event
            )
            subscriber.receive(subscription: subscription)
        }
    }

    final class EventSubscription<S: Subscriber>: Subscription
    where S.Input == Void {

        private var subscriber: S?
        weak private var control: UIControl?
        let event: UIControl.Event

        init(subscriber: S, control: UIControl, event: UIControl.Event) {
            self.subscriber = subscriber
            self.control = control
            self.event = event
            control.addTarget(self, action: #selector(eventHandler), for: event)
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            subscriber = nil
        }

        @objc private func eventHandler() {
            _ = subscriber?.receive(())
        }
    }

    func publisher(for event: UIControl.Event) -> EventPublisher {
        EventPublisher(control: self, event: event)
    }
}
