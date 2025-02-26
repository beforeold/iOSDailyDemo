import Cocoa
import CoreBluetooth

class ViewController: NSViewController {

  var monitor: BluetoothMonitor!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.

    monitor = BluetoothMonitor()
  }

  override var representedObject: Any? {
    didSet {
      // Update the view, if already loaded.
    }
  }

}

class BluetoothMonitor: NSObject, CBCentralManagerDelegate {
  var centralManager: CBCentralManager?

  override init() {
    super.init()
    centralManager = CBCentralManager(delegate: self, queue: nil)
  }

  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state {
    case .poweredOn:
      print("Bluetooth is On")
      central.scanForPeripherals(withServices: nil, options: nil)
    default:
      print("Bluetooth is not available.")
    }
  }

  func centralManager(
    _ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi: NSNumber
  ) {
    let deviceName = peripheral.name ?? "Unknown Device"
    print("Discovered device: \(deviceName)")

    // Example: Check if the discovered device is your phone.
    if deviceName == "YourPhoneName" {
      print("Phone connected!")
      // Perform actions here, like unlocking the screen or toggling Bluetooth
    }
  }

  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    let deviceName = peripheral.name ?? "Unknown Device"
    print("\(deviceName) disconnected!")
    // Trigger unlocking and Bluetooth action
    //    unlockScreen()
    //    toggleBluetooth()
  }

  func unlockScreen() {
    let script = """
      tell application "System Events"
          key code 49 -- Presses the spacebar, unlocking the screen if password is entered
      end tell
      """
    executeAppleScript(script)
  }

  func toggleBluetooth() {
    let script = """
      tell application "System Events"
          tell process "System Preferences"
              click menu item "Bluetooth" of menu "View" of menu bar 1
              delay 1
              click button "Turn Bluetooth Off" of window "Bluetooth"
          end tell
      end tell
      """
    executeAppleScript(script)
  }

  func executeAppleScript(_ script: String) {
    var error: NSDictionary?
    if let appleScript = NSAppleScript(source: script) {
      appleScript.executeAndReturnError(&error)
    }
  }
}
