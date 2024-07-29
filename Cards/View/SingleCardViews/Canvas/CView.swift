//
//  CView.swift
//  drawing
//
//  Created by Павел Калинин on 15.04.2024.
//

import SwiftUI

struct CView: View {
    @State var isCanvasShown = false
    var body: some View {
        ZStack{
            if isCanvasShown{
                CanvasView(isCanvasShwon: $isCanvasShown)
            }else{
                Image(systemName: "pencil.tip.crop.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        withAnimation(.spring){
                            isCanvasShown.toggle()
                        }
                    }
            }
        }
    }
}

#Preview {
    CView()
}
