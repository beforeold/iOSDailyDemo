//
//  DebugReceiptsView.swift
//  AIGC
//
//  Created by xipingping on 6/13/24.
//

import StoreKit
import SwiftUI

struct DebugReceiptsView: View {
  typealias Receipt = String

  @State
  private var receipts: [Receipt] = []

  @State
  private var isRestoring = false

  @State
  private var isLoading = false

  var body: some View {
    Form {
      Section {
        HStack {
          self.restoreTransactionsButton

          if self.isRestoring {
            ProgressView()
          }
        }

        HStack {
          self.loadReceiptsButton

          if self.isLoading {
            ProgressView()
          }
        }
      }

      self.receiptsInfo
    }
    .task {
      await self.load()
    }
  }

  @ViewBuilder
  private var restoreTransactionsButton: some View {
    Button("Restore") {
      Task {
        if self.isRestoring { return }

        self.isRestoring = true
        defer {
          self.isRestoring = false
        }

        do {
          try await AppStore.sync()
          SKPaymentQueue.default().restoreCompletedTransactions()
        } catch {
          print("DebugReceiptsView sync failed \(error)")
        }
      }
    }
  }

  @ViewBuilder
  private var loadReceiptsButton: some View {
    Button("Load Receipts") {
      Task {
        await self.load()
      }
    }
  }

  @ViewBuilder
  private var receiptsInfo: some View {
    Section {
      if self.receipts.isEmpty {
        Text("empty")
      } else {
        ForEach(self.receipts, id: \.self) { receipt in
          Text("receipt length \(receipt.count)")
        }
      }
    }
  }

  private func load() async {
    if self.isLoading { return }

    self.isLoading = true
    defer {
      self.isLoading = false
    }

    // load storekit receipt from main bundle
    guard let receiptStr = await ReceiptLoader.load() else {
      return
    }

    self.receipts = [receiptStr]
  }
}

struct ReceiptLoader {
  static func load() async -> String? {
    // load storekit receipt from main bundle
    guard let url = Bundle.main.appStoreReceiptURL else {
      print("DebugReceiptsView nil appStoreReceiptURL")
      return nil
    }

    guard let receiptData = try? Data(contentsOf: url) else {
      print("DebugReceiptsView nil data")
      return nil
    }

    print("DebugReceiptsView receipt data count \(receiptData.count)")

    let utf8String = String(decoding: receiptData, as: UTF8.self)
    print("DebugReceiptsView utf8String \(utf8String)")

    let base64String = receiptData.base64EncodedString(options: [])
    let receiptStr = base64String
    print("DebugReceiptsView receipt \(receiptStr)")

    return receiptStr
  }
}

#Preview {
  DebugReceiptsView()
}
