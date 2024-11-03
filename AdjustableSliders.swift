//
//  AdjustableSliders.swift
//  hacknc
//
//  Created by Han Lee on 11/3/24.
//


import SwiftUI

struct AdjustableSliders: View {
    @Binding var income: Double
    @Binding var debt: Double
    @Binding var duration: Double

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Income: \(Int(income))")
                Slider(value: $income, in: 0...100000, step: 1000)
                    .accentColor(.blue)
            }
            .padding()

            VStack(alignment: .leading) {
                Text("Debt: \(Int(debt))")
                Slider(value: $debt, in: 0...50000, step: 500)
                    .accentColor(.red)
            }
            .padding()

            VStack(alignment: .leading) {
                Text("Duration (Months): \(Int(duration))")
                Slider(value: $duration, in: 0...60, step: 1)
                    .accentColor(.green)
            }
            .padding()
        }
    }
}
