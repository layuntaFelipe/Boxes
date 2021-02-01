//
//  Quotes.swift
//  Boxes
//
//  Created by Felipe Lobo on 01/02/21.
//

import Foundation

struct Quotes {
    public let listQuotes = [
        "'All our dreams can come true, if we have the courage to pursue them.' – Walt Disney",
        "'The secret of getting ahead is getting started.' – Mark Twain",
        "'The best time to plant a tree was 20 years ago. The second best time is now.' – Chinese Proverb",
        "'It’s hard to beat a person who never gives up.' – Babe Ruth",
        "“I wake up every morning and think to myself, ‘how far can I push this company in the next 24 hours.’” – Leah Busque",
        "“If people are doubting how far you can go, go so far that you can’t hear them anymore.” – Michele Ruiz",
        "“Write it. Shoot it. Publish it. Crochet it, sauté it, whatever. MAKE.” – Joss Whedon"
    ]
    
    func getRandomQuote() -> String {
        return listQuotes.randomElement()!
    }
}
