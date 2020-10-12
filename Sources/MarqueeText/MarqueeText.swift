import SwiftUI

struct MarqueeText : View {
    @State var text = ""
    @State var font: UIFont
    @State var leftFade: CGFloat
    @State var rightFade: CGFloat
    @State var startDelay: Double

    @State private var animate = false

    var body : some View {
        let stringWidth = text.widthOfString(usingFont: font)
        let stringHeight = text.heightOfString(usingFont: font)
        return ZStack {
            GeometryReader { geometry in
                Group {
                    Text(self.text).lineLimit(1)
                        .font(.init(font))
                        .offset(x: self.animate ? -stringWidth - stringHeight * 2 : 0)
                        .animation(Animation.linear(duration: Double(stringWidth) / 30).delay(startDelay).repeatForever(autoreverses: false)
                        )
                        .onAppear() {
                            if geometry.size.width < stringWidth {
                                self.animate = true
                            }
                        }
                        .fixedSize(horizontal: true, vertical: false)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)

                    Text(self.text).lineLimit(1)
                        .font(.init(font))
                        .offset(x: self.animate ? 0 : stringWidth + stringHeight * 2)
                        .animation(Animation.linear(duration: Double(stringWidth) / 30).delay(startDelay).repeatForever(autoreverses: false)
                        )
                        .fixedSize(horizontal: true, vertical: false)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                }.offset(x: leftFade)
                .mask(
                    HStack(spacing:0) {
                        Rectangle()
                            .frame(width:2)
                            .opacity(0)
                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                            .frame(width:leftFade)
                        LinearGradient(gradient: Gradient(colors: [Color.black, Color.black]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                        LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0)]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                            .frame(width:rightFade)
                        Rectangle()
                            .frame(width:2)
                            .opacity(0)
                    }).frame(width: geometry.size.width + leftFade).offset(x: leftFade * -1)
            }
        }.frame(height: stringHeight)
    }
}

extension String {

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
}
