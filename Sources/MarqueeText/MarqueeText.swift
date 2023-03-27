import SwiftUI

public struct MarqueeText : View {
    public var text: String
    public var font: UIFont
    public var leftFade: CGFloat
    public var rightFade: CGFloat
    public var startDelay: Double
    public var alignment: Alignment
    public var autoReverses: Bool = false
    
    @State private var animate = false
    var isCompact = false
    
    public var body : some View {
        let stringWidth = text.widthOfString(usingFont: font)
        let stringHeight = text.heightOfString(usingFont: font)
        
        let animation = Animation
            .linear(duration: Double(stringWidth) / 60)
            .delay(startDelay)
            .repeatForever(autoreverses: autoReverses)
        
        let nullAnimation = Animation
            .linear(duration: 0)
        
        return ZStack {
            GeometryReader { geo in
                if stringWidth > geo.size.width { // don't use self.animate as conditional here
                    Group {
                        Text(self.text)
                            .lineLimit(1)
                            .font(.init(font))
                            .offset(x: self.animate ? -(stringWidth - geo.size.width + rightFade * 2.0) : 0)
                            .animation(self.animate ? animation : nullAnimation, value: self.animate)
                            .onAppear {
                                DispatchQueue.main.async {
                                    self.animate = geo.size.width < stringWidth
                                }
                            }
                            .fixedSize(horizontal: true, vertical: false)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                    }
                    .onValueChanged(of: self.text, perform: {text in
                        self.animate = geo.size.width < stringWidth
                    })
                    
                    .offset(x: leftFade)
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
                        })
                    .frame(width: geo.size.width + leftFade)
                    .offset(x: leftFade * -1)
                } else {
                    Text(self.text)
                        .font(.init(font))
                        .onValueChanged(of: self.text, perform: {text in
                            self.animate = geo.size.width < stringWidth
                        })
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: alignment)
                }
            }
        }
        .frame(height: stringHeight)
        .frame(maxWidth: isCompact ? stringWidth : nil)
        .onDisappear { self.animate = false }

    }
    
    public init(text: String, font: UIFont, leftFade: CGFloat, rightFade: CGFloat, startDelay: Double, alignment: Alignment? = nil, autoReverses: Bool = false) {
        self.text = text
        self.font = font
        self.leftFade = leftFade
        self.rightFade = rightFade
        self.startDelay = startDelay
        self.alignment = alignment != nil ? alignment! : .topLeading
        self.autoReverses = autoReverses
    }
}

extension MarqueeText {
    public func makeCompact(_ compact: Bool = true) -> Self {
        var view = self
        view.isCompact = compact
        return view
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
