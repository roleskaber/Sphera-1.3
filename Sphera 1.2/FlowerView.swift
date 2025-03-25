import SwiftUI

struct AnimatedFigureView: View {
    @State private var shapes: Double = 100
    @State private var infinAnima: Bool = false
    
    var body: some View {
        VStack{
            ZStack {
                Figure(shapes: $shapes)
                    .scaleEffect(infinAnima ? 1 : 0)
                    .rotationEffect(.degrees(infinAnima ? 45: 0))
                    .opacity(infinAnima ? 0 : 1)
                    .animation(.interactiveSpring(response: 5, dampingFraction: 1, blendDuration: 1).repeatForever(autoreverses: false), value: infinAnima)
                Figure(shapes: $shapes)
                    .scaleEffect(infinAnima ? 1 : 0)
                    .rotationEffect(.degrees(infinAnima ? 45: 0))
                    .opacity(infinAnima ? 0 : 1)
                    .animation(.interactiveSpring(response: 7, dampingFraction: 1, blendDuration: 1).repeatForever(autoreverses: false), value: infinAnima)
                Figure(shapes: $shapes)
                    .scaleEffect(infinAnima ? 1 : 0)
                    .rotationEffect(.degrees(infinAnima ? 45: 0))
                    .opacity(infinAnima ? 0 : 1)
                    .animation(.interactiveSpring(response: 10, dampingFraction: 1, blendDuration: 1).repeatForever(autoreverses: false), value: infinAnima)
                
                
                
            }
            .onAppear {
                infinAnima = true
            }
        }
        Slider(value: $shapes, in: 10...500)
            .accentColor(.blue)
            .padding()
    }
}

struct Figure: View {
    var maincolor: Color?
    @Binding var shapes: Double
    var body: some View {
        ZStack {
            ForEach([0, 45, 90, -45], id: \.self) { angle in
                Ellipse()
                    .stroke(Color.white, lineWidth: 5)
                    .frame(width: shapes, height: 500)
                    .rotationEffect(.degrees(Double(angle)))
                    .shadow(radius: 10)
            }
            ForEach([0, 45, 90, -45], id: \.self) { angle in
                Ellipse()
                    .fill(maincolor ?? Color.white)
                    .frame(width: shapes, height: 500)
                    .rotationEffect(.degrees(Double(angle)))
                    .opacity(maincolor == nil ? 0.5 : 1)
                
            }
        }

        .scaleEffect(1.1)
        .padding()
    }
}

#Preview {
    AnimatedFigureView()
}
