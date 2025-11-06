import Foundation
import UIKit
import Combine

class OrientationManager: ObservableObject {
  static let shared = OrientationManager()
  
  @Published var isFullScreenPresented = false
  
  private init() {}
}

