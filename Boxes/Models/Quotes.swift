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
        "“Write it. Shoot it. Publish it. Crochet it, sauté it, whatever. MAKE.” – Joss Whedon",
        "“The Best Way To Get Started Is To Quit Talking And Begin Doing.” – Walt Disney",
        "“The Pessimist Sees Difficulty In Every Opportunity. The Optimist Sees Opportunity In Every Difficulty.” – Winston Churchill",
        "“Don’t Let Yesterday Take Up Too Much Of Today.” – Will Rogers",
        "“It’s Not Whether You Get Knocked Down, It’s Whether You Get Up.” – Inspirational Quote By Vince Lombardi",
        "“If You Are Working On Something That You Really Care About, You Don’t Have To Be Pushed. The Vision Pulls You.” – Steve Jobs",
        "“People Who Are Crazy Enough To Think They Can Change The World, Are The Ones Who Do.” – Rob Siltanen",
        "“Failure Will Never Overtake Me If My Determination To Succeed Is Strong Enough.” – Og Mandino",
        "“We May Encounter Many Defeats But We Must Not Be Defeated.” – Maya Angelou",
        "“Knowing Is Not Enough; We Must Apply. Wishing Is Not Enough; We Must Do.” – Johann Wolfgang Von Goethe",
        "“We Generate Fears While We Sit. We Overcome Them By Action.” – Dr. Henry Link",
        "“The Only Limit To Our Realization Of Tomorrow Will Be Our Doubts Of Today.” – Motivational Quote By Franklin D. Roosevelt",
        "“Creativity Is Intelligence Having Fun.” – Albert Einstein",
        "“What You Lack In Talent Can Be Made Up With Desire, Hustle And Giving 110% All The Time.” – Don Zimmer",
        "“Do What You Can With All You Have, Wherever You Are.” – Theodore Roosevelt",
        "“You Are Never Too Old To Set Another Goal Or To Dream A New Dream.” – C.S. Lewis",
        "“Fake It Until You Make It! Act As If You Had All The Confidence You Require Until It Becomes Your Reality.” – Brian Tracy",
        "“The Future Belongs To The Competent. Get Good, Get Better, Be The Best!” – Brian Tracy"
    ]
    
    func getRandomQuote() -> String {
        return listQuotes.randomElement()!
    }
}
