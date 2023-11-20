//
//  ContentView.swift
//  ChartDemoApp
//
//  Created by fanbaoying on 2023/11/15.
//

import SwiftUI
import Accessibility

struct DataPoint: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
    let color: Color
}

struct BarChartView: View {
    let dataPoints: [DataPoint]

    var body: some View {
        HStack(spacing: 10) {
            ForEach(dataPoints) { point in
                VStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(point.color)
                        .frame(width: 30, height: CGFloat(point.value * 50))
                        .overlay(Text(point.label).padding(.top, 4).font(.footnote).foregroundColor(.primary))
                }
            }
        }
    }
}

struct ContentView: View, AXChartDescriptorRepresentable {
    @State private var dataPoints = [
        DataPoint(label: "1", value: 3, color: .red),
        DataPoint(label: "2", value: 5, color: .blue),
        DataPoint(label: "3", value: 2, color: .green),
        DataPoint(label: "4", value: 4, color: .orange),
        DataPoint(label: "5", value: 6, color: .purple),
        DataPoint(label: "6", value: 7, color: .pink),
        DataPoint(label: "7", value: 4, color: .yellow),
        DataPoint(label: "8", value: 3, color: .cyan),
        DataPoint(label: "9", value: 8, color: .gray),
        DataPoint(label: "10", value: 5, color: .brown),
        DataPoint(label: "11", value: 6, color: .red),
        DataPoint(label: "12", value: 3, color: .blue),
        DataPoint(label: "13", value: 2, color: .green),
        DataPoint(label: "14", value: 4, color: .orange),
        DataPoint(label: "15", value: 6, color: .purple),
        DataPoint(label: "16", value: 7, color: .pink),
        DataPoint(label: "17", value: 4, color: .yellow),
        DataPoint(label: "18", value: 3, color: .cyan),
    ]

    @State private var selectedColor: Color = .blue
    @State private var barHeight: Double = 50.0

    var body: some View {
        HStack {
            BarChartView(dataPoints: dataPoints)
                .accessibilityElement()
                .accessibilityLabel("Chart representing some data")
                .accessibilityChartDescriptor(self)

            VStack {
                Text("Adjust Bar Height:")
                    .font(.headline)
                    .padding()

                Slider(value: $barHeight, in: 10...100, step: 1)
                    .padding()

                Text("Selected Color:")
                    .font(.headline)
                    .padding()

                ColorPicker("", selection: $selectedColor)
                    .labelsHidden()
                    .frame(width: 30, height: 30)
                    .padding()

                Button("Update Chart") {
                    // Update chart with the selected color and bar height
                    updateChart(with: selectedColor, barHeight: barHeight)
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
            }
        }
        .padding()
    }

    func makeChartDescriptor() -> AXChartDescriptor {
        let xAxis = AXCategoricalDataAxisDescriptor(
            title: "Labels",
            categoryOrder: dataPoints.map(\.label)
        )

        let min = dataPoints.map(\.value).min() ?? 0.0
        let max = dataPoints.map(\.value).max() ?? 0.0

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Values",
            range: min...max,
            gridlinePositions: []
        ) { value in "\(value) points" }

        let series = AXDataSeriesDescriptor(
            name: "",
            isContinuous: false,
            dataPoints: dataPoints.map {
                .init(x: $0.label, y: $0.value)
            }
        )

        return AXChartDescriptor(
            title: "Chart representing some data",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [series]
        )
    }

    func updateChart(with color: Color, barHeight: Double) {
        // Update the chart with the selected color and bar height
        dataPoints = dataPoints.map { point in
            DataPoint(label: point.label, value: barHeight / 50.0, color: color)
        }
    }
}
