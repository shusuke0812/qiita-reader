//
//  DebugFloadtingButton.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/17.
//

import SwiftUI

struct DebugFloatingButton<ViewModel: DebugFloatingButtonViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    viewModel.input.call()
                }) {
                    Image(systemName: "apple.terminal")
                        .foregroundStyle(.white)
                        .padding()
                }
                .background(.red)
                .clipShape(Circle())
                .shadow(radius: 5)
                .padding(.bottom, 20)
                .padding(.trailing, 20)
            }
        }
    }
}
