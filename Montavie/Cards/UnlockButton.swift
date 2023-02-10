//
//  UnlockButton.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 12/12/22.
//

import SwiftUI

struct UnlockButton: View {
    @GestureState var tap = false
    @Binding var unlocked: Bool
    
    var body: some View {
        ZStack {
            Image("LockIcon")
                .opacity(unlocked ? 0 : 1)
                .scaleEffect(unlocked ? 0.001 : 1)
            
            Image("LockIcon")
                .clipShape(
                    Rectangle()
                        .offset(y: tap ? 0 : 50.0)
                )
                .blending(color: Color("BrandBlue"))
                .animation(.easeInOut(duration: 2), value: unlocked)
                .opacity(unlocked ? 0 : 1)
                .scaleEffect(unlocked ? 0.001 : 1)
            
            Image("UnlockIcon")
                .blending(color: Color("BrandCoral"))
                .opacity(unlocked ? 1 : 0)
                .scaleEffect(unlocked ? 1 : 0.001)
        }
        .frame(width: 80, height: 80)
        .background(
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(unlocked ? #colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(unlocked ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                
                Circle()
                    .stroke(Color.clear, lineWidth: 10) // 10
                    .shadow(color: Color( #colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 3, x: -5, y: -5)
            }
        )
        .clipShape(Circle())
        .overlay(
            Circle()
                .trim(from: tap ? 0.001 : 1, to: 1)
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [Color("BrandCoral"), Color("BrandBlue")]), startPoint: .topTrailing, endPoint: .bottomLeading),
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
                .frame(width: 75, height: 75)
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                .shadow(color: Color( #colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 3, x: -5, y: -5)
                .animation(.easeInOut(duration: 2), value: tap)
        )
//        .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 20, x: -2, y: -2)
//        .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 2, y: 2)
        .scaleEffect(tap ? 1.2 : 1)
        .gesture(
            !unlocked ?
            LongPressGesture(minimumDuration: 2)
                .updating($tap) { currentState, gestureState, transaction in
                    gestureState = currentState
                    
                    let impactMed = UIImpactFeedbackGenerator(style: .light)
                    impactMed.impactOccurred()
                }
                .onEnded { value in
                    self.unlocked.toggle()
                    let impactMed = UIImpactFeedbackGenerator(style: .light)
                    impactMed.impactOccurred()
                }
            : nil
        )
    }
}

struct UnlockButton_Previews: PreviewProvider {
    static var previews: some View {
        UnlockButton(unlocked: .constant(false))
    }
}
