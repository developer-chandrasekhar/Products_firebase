//
//  FontManager.swift
//  POC
//
//  Created by chandra sekhar p on 06/08/24.
//

import SwiftUI

struct FontManager {
    static func largeTitle(weight: Font.Weight = .regular) -> Font {
         return Font.system(size: 22, weight: weight, design: .default)
     }
     
     static func title(weight: Font.Weight = .regular) -> Font {
         return Font.system(size: 20, weight: weight, design: .default)
     }
     
     static func headline(weight: Font.Weight = .regular) -> Font {
         return Font.system(size: 18, weight: weight, design: .default)
     }
     
     static func body(weight: Font.Weight = .regular) -> Font {
         return Font.system(size: 16, weight: weight, design: .default)
     }
     
     static func caption(weight: Font.Weight = .regular) -> Font {
         return Font.system(size: 14, weight: weight, design: .default)
     }
    
    static func caption2(weight: Font.Weight = .regular) -> Font {
        return Font.system(size: 12, weight: weight, design: .default)
    }
}
