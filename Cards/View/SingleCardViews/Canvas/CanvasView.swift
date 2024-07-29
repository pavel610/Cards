//
//  ContentView.swift
//  drawing
//
//  Created by Павел Калинин on 15.04.2024.
//

import SwiftUI

struct ContentViewContentViewContentView: View {
    @State private var currentLine = Line()
    @State private var lines = [Line]()
    @State private var selectedColor: Color = .red
    @Binding var isCanvasShwon: Bool
    var body: some View {
        
        NavigationStack {
            Canvas{context, size in
                for line in lines {
                    var path = Path()
                    path.addLines(line.points)
                    context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
                }
            }
            
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged{ value in
                    let point = value.location
                    currentLine.points.append(point)
                    self.lines.append(currentLine)
                }
                .onEnded{value in
                    self.currentLine = Line(points: [], color: selectedColor)
                }
            )
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Image(systemName: "arrow.uturn.left")
                        .onTapGesture {
                            withAnimation(.spring){
                                isCanvasShwon.toggle()
                            }
                        }
                }
                ToolbarItem(placement: .topBarTrailing){
                    ColorPicker(selectedColor: $selectedColor)
                        .onChange(of: selectedColor) { newValue in
                            currentLine.color = newValue
                        }
                }
                
                ToolbarItem(placement: .topBarLeading){
                    Image(systemName: "trash")
                        .padding(.leading)
                        .onTapGesture {
                            self.lines = []
                        }
                }
            }
        }
        
        .padding()
    }
}

#Preview {
    ContentViewContentViewContentView(isCanvasShwon: .constant(false))
}
