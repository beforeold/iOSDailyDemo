//
//  ObservableViewModelPublisher.swift
//  KMPObservableViewModelCore
//
//  Created by Rick Clephas on 20/09/2023.
//

import Combine
import KMPObservableViewModelCoreObjC

/// Publisher for `ObservableViewModel` that connects to the `ViewModelScope`.
public final class ObservableViewModelPublisher: Publisher {
    public typealias Output = Void
    public typealias Failure = Never
    
    internal weak var viewModel: (any ViewModel)?
    
    private let publisher = ObservableObjectPublisher()
    private var objectWillChangeCancellable: AnyCancellable? = nil
    
    internal init(_ viewModel: any ViewModel, _ objectWillChange: ObservableObjectPublisher) {
        self.viewModel = viewModel
        viewModel.viewModelScope.setSendObjectWillChange { [weak self] in
            self?.publisher.send()
        }
        objectWillChangeCancellable = objectWillChange.sink { [weak self] _ in
            self?.publisher.send()
        }
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Void == S.Input {
        viewModel?.viewModelScope.increaseSubscriptionCount()
        publisher.receive(subscriber: ObservableViewModelSubscriber(self, subscriber))
    }
    
    deinit {
        guard let viewModel else { return }
        if let cancellable = viewModel as? Cancellable {
            cancellable.cancel()
        }
        viewModel.clear()
    }
}

/// Subscriber for `ObservableViewModelPublisher` that creates `ObservableViewModelSubscription`s.
private class ObservableViewModelSubscriber<S>: Subscriber where S : Subscriber, Never == S.Failure, Void == S.Input {
    typealias Input = Void
    typealias Failure = Never
    
    private let publisher: ObservableViewModelPublisher
    private let subscriber: S
    
    init(_ publisher: ObservableViewModelPublisher, _ subscriber: S) {
        self.publisher = publisher
        self.subscriber = subscriber
    }
    
    func receive(subscription: Subscription) {
        subscriber.receive(subscription: ObservableViewModelSubscription(publisher, subscription))
    }
    
    func receive(_ input: Void) -> Subscribers.Demand {
        subscriber.receive(input)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        subscriber.receive(completion: completion)
    }
}

/// Subscription for `ObservableViewModelPublisher` that decreases the subscription count upon cancellation.
private class ObservableViewModelSubscription: Subscription {
    
    private let publisher: ObservableViewModelPublisher
    private let subscription: Subscription
    
    init(_ publisher: ObservableViewModelPublisher, _ subscription: Subscription) {
        self.publisher = publisher
        self.subscription = subscription
    }
    
    func request(_ demand: Subscribers.Demand) {
        subscription.request(demand)
    }
    
    private var cancelled = false
    
    func cancel() {
        subscription.cancel()
        guard !cancelled else { return }
        cancelled = true
        publisher.viewModel?.viewModelScope.decreaseSubscriptionCount()
    }
}
