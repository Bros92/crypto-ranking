//
//  Extensions.swift
//  CryptoRanking
//
//  Created by Vincenzo Broscritto on 15/10/22.
//

import SwiftUI

extension Color {
    static let shimmerBackgroundColor = Color(red: 229/255, green: 231/255, blue: 232/255)
    static let lightGrey = Color(red: 219/255, green: 219/255, blue: 219/255)
}

extension UIColor {
    /// Initialize UIColor with hex value
    /// - Parameters:
    ///   - hex: hex value
    ///   - alpha: alpha value
    var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb: Int = (Int)(r * 255)<<16 | (Int)(g * 255)<<8 | (Int)(b*255)<<0
        
        return String(format: "#%06x", rgb)
    }
}

extension Font {
    static func openSansRegular(size: CGFloat) -> Font {
        return .custom("OpenSans-Regular", size: size)
    }
    static func openSansBold(size: CGFloat) -> Font {
        return .custom("OpenSans-Bold", size: size)
    }
}

extension UIFont {
    static let openSansRegular = UIFont(name: "OpenSans-Regular", size: 16)
}

extension UITextView {
    
    /// Update the value of height in relation to text
    /// - Returns: The calculated height
    func heightToFitContent() -> CGFloat {

        let maximumLabelSize : CGSize = CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        let expectedLabelSize : CGSize = self.sizeThatFits(maximumLabelSize);


        self.sizeToFit()

        return expectedLabelSize.height
    }
}

extension View {
    
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// Apply corner radius modifier
    /// - Parameters:
    ///   - radius: The radius of layer
    ///   - corners: The corners to round
    /// - Returns: The view with rounded corners for specified radius
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
    
    /// Create a view with border and corner radius
    /// - Parameters:
    ///   - radius: The radius of layer
    ///   - edges: The edges of view
    ///   - width: The width of border
    ///   - color: The color of border
    /// - Returns: A view with rounded edges and border
    func roundedEdge(radius: CGFloat, edges: UIRectCorner, width: CGFloat, color: Color) -> some View {
        ModifiedContent(content: self, modifier: RoundedEdge(width: width, color: color, cornerRadius: radius, edges: edges))
    }
    
    @ViewBuilder
    /// Use the updated navigation view api
    /// - Parameters:
    ///   - title: The title of navigation view
    ///   - displayMode: the display mode of navigation title
    /// - Returns: The navigation view with title and display mode
    func setNavigationTitle(title: String, displayMode: NavigationBarItem.TitleDisplayMode) -> some View {
        self.modifier(NavigationTitleViewModifier(text: title, displayMode: displayMode))
    }
}

extension Double {
    /// Convert double to currency
    /// - Returns: The currency converted
    func toCurrency(for code: Currency = .euro) -> String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = .current
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        formatter.currencyCode = code.rawValue
        switch code {
        case .euro:
            formatter.currencySymbol = "€"
        case .dollar:
            formatter.currencySymbol = "$"
        }
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    /// Trunk the value using abbrevation, adding Tr, Br, M or K
    /// - Returns: An abbrevated value of price with associated unit
    func formatterWithAbbrevation() -> String {
        let num = abs(Double(self))
        
        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.toDecimalString()
            return "\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.toDecimalString()
            return "\(stringFormatted)Br"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.toDecimalString()
            return "\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.toDecimalString()
            return "\(stringFormatted)K"
        case 0...:
            return self.toDecimalString()
        default:
            return "\(self)"
        }
    }
    
    /// Convert double to string with two decimal unit
    /// - Returns: A string with two decimal unit
    func toDecimalString() -> String {
        return String(format: "%.2f", self)
    }
}

extension String {
    
    /// Convert string having html tags in attributed string.
    /// Call this method on main thread because NSAttributedString uses WebKit to read the html document and this operation is not thread safe.
    /// - Parameters:
    ///   - font: font to use for conversion
    ///   - color: color to use for conversion
    ///   - textAlignment: the text alignment
    ///   - lineHeignt: the line heigt of thext
    /// - Returns: A converted attributed string using html tags.
    func toHtml(with font: UIFont? = .openSansRegular, color: UIColor? = .white, textAlignment: NSTextAlignment = .center, lineHeignt: CGFloat = 1.0) -> NSAttributedString {
        var attributedString = NSMutableAttributedString(string: "")
        guard let color = color else { return attributedString }
        let htmlString = "<style>" +
        "html *" +
        "{" +
        "font-size: \(font?.pointSize ?? UIFont.systemFontSize)px !important;" +
        "color: \(color.hexString) !important;" +
        "font-family: \(font?.familyName ?? "OpenSans-Regular") !important;" +
        "}</style> \(self)"
        let encodedData = htmlString.data(using: String.Encoding.utf8)!
        do {
            attributedString = try NSMutableAttributedString(data: encodedData,
                                                             options:
                                                                [.documentType: NSAttributedString.DocumentType.html,
                                                                 .characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)
                                                                ],
                                                             documentAttributes: nil)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = lineHeignt
            paragraphStyle.alignment = textAlignment
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
        return attributedString
    }
    
    /// Localize the string
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// Create a URL from string
    var url: URL? {
        URL(string: self)
    }
    
    /// Convert string to date using date format yyyy-MM-dd'T'HH:mm:ss.SSSZ
    /// - Returns: A date from string
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: self) ?? Date()
    }
}

extension Date {
    /// The short formatted date for the locale
    var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale.current
        return formatter
    }
    
    /// Convert the date in string with short formatter rules
    /// - Returns: The string value of the date
    func toShortDateString() -> String {
        return shortFormatter.string(from: self)
    }
}

extension URLRequest {
    
    private struct URLUtils {
        static func percentEscape(string: Any) -> String {
            guard let str = string as? String else {
                return "\(string)"
            }
            
            var characterSet = CharacterSet.alphanumerics
            characterSet.insert(charactersIn: "-._* ")
            
            return str
                .addingPercentEncoding(withAllowedCharacters: characterSet)!
                .replacingOccurrences(of: " ", with: "+")
        }
        
        static func encodeParameters(_ parameters: [[String: Any]]) -> String {
            let queryString = parameters.flatMap { elem in
                return elem.map { "\($0.key)=\(self.percentEscape(string: $0.value))" }
            }
            
            return queryString.joined(separator: "&")
        }
        
    }
    
    mutating func encode<T: Encodable>(object: T) throws {
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(object)
        self.httpBody = jsonData
    }
    
    mutating func appendGETParameters(_ parameters: [[String: Any]]) {
        // Retrieve the old baseURL
        let baseURL = self.url!.absoluteString
        
        // Construct a new url with the query string in it
        let newURL = baseURL + "?" + URLUtils.encodeParameters(parameters)
        
        // Assign the new url to the request
        self.url = URL(string: newURL)
    }
}
