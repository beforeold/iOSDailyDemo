import Foundation

class Repository<Service> {
  private let interface: Service

  init(interface: Service) {
    self.interface = interface
  }
}
