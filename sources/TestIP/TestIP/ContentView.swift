//
//  ContentView.swift
//  TestIP
//
//  Created by xipingping on 5/28/24.
//

import SwiftUI

struct ContentView: View {
  @State var isValid: Bool? = nil

  @State var ipAddress: String? = nil

  var body: some View {
    Form {
      Section {
        Text("address: \(self.ipAddress ?? "null")")
        Text("isValid: \(self.isValid?.description ?? "null")")
      }
    }
    .task {
      await self.refresh()
    }
    .refreshable {
      await self.refresh()
    }
  }

  private func refresh() async {
    let (valid, addr) = isUserOnSpecificWiFi()
    self.isValid = valid
    self.ipAddress = addr
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}

import SystemConfiguration.CaptiveNetwork
import UIKit

func isUserOnSpecificWiFi() -> (Bool, String?) {
//  guard let interfaces = CNCopySupportedInterfaces() as? [String] else {
//    return false
//  }
//
//  for interface in interfaces {
//    guard let info = CNCopyCurrentNetworkInfo(interface as CFString) as? [String: AnyObject] else {
//      continue
//    }
//
//    if let ssid = info[kCNNetworkInfoKeySSID as String] as? String {
//      print("SSID: \(ssid)") // Optional: print the current SSID
//    }
//
//    if let ipAddress = getWiFiIPAddress(), isIPAddressInRange(ipAddress) {
//      return true
//    }
//  }

  if let ipAddress = getWiFiIPAddress() {
    if isIPAddressInRange(ipAddress) {
      return (true, ipAddress)
    } else {
      return (false, ipAddress)
    }
  }

  return (false, nil)
}

private func getWiFiIPAddress() -> String? {
  var address: String?

  // Get list of all interfaces on the device
  var ifaddr: UnsafeMutablePointer<ifaddrs>?
  guard getifaddrs(&ifaddr) == 0 else { return nil }
  guard let firstAddr = ifaddr else { return nil }

  // Loop through interfaces
  for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
    let interface = ptr.pointee

    // Check for IPv4 or IPv6 interface
    let addrFamily = interface.ifa_addr.pointee.sa_family
    if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

      // Check interface name
      let name = String(cString: interface.ifa_name)
      if name == "en0" {
        // Convert interface address to a human readable string
        var addr = interface.ifa_addr.pointee
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                    &hostname, socklen_t(hostname.count),
                    nil, socklen_t(0), NI_NUMERICHOST)
        address = String(cString: hostname)
      }
    }
  }
  freeifaddrs(ifaddr)
  return address
}

private func isIPAddressInRange(_ ipAddress: String) -> Bool {
  // Define the IP ranges
  let ipRanges = [
    (base: "10.0.0.0", mask: 8)
  ]

  for range in ipRanges {
    if isIP(ipAddress, inRange: range.base, withMask: range.mask) {
      return true
    }
  }
  return false
}

private func isIP(_ ip: String, inRange range: String, withMask maskBits: Int) -> Bool {
  guard let ipAddr = ipToUInt32(ip), let rangeAddr = ipToUInt32(range) else {
    return false
  }
  let mask = UInt32.max << (32 - maskBits)
  return (ipAddr & mask) == (rangeAddr & mask)
}

private func ipToUInt32(_ ip: String) -> UInt32? {
  var sin = sockaddr_in()
  if ip.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1 {
    return sin.sin_addr.s_addr.bigEndian
  }
  return nil
}
