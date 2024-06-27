//
//  SwiftUIViewBP.swift
//  TestViewBPTemplate
//
//  Created by Brook_Mobius on 6/27/24.
//

import ObservationBP
import SwiftUI

@Observable
class Model {
  var name = "brook"
}

struct SwiftUIViewBP: ViewBP {
  @BindableBP var model: Model = .init()

  var bodyBP: some View {
    Text(model.name)
  }
}

#Preview {
    SwiftUIViewBP()
}
