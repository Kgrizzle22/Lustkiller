import Foundation

struct Verse: Codable, Hashable, Identifiable {
    /// A short first-person reminder of who you are in Christ, shown above the verse.
    let identity: String
    let reference: String
    let text: String

    var id: String { reference }
    var formatted: String { "\u{201C}\(text)\u{201D} \u{2014} \(reference)" }
}

/// Verses on who you are in Christ, King James Version (public domain).
enum Verses {
    static let all: [Verse] = [
        Verse(identity: "I am a new creation",
              reference: "2 Corinthians 5:17",
              text: "Therefore if any man be in Christ, he is a new creature: old things are passed away; behold, all things are become new."),
        Verse(identity: "Christ lives in me",
              reference: "Galatians 2:20",
              text: "I am crucified with Christ: nevertheless I live; yet not I, but Christ liveth in me: and the life which I now live in the flesh I live by the faith of the Son of God, who loved me, and gave himself for me."),
        Verse(identity: "I am no longer a slave to sin",
              reference: "Romans 6:6",
              text: "Knowing this, that our old man is crucified with him, that the body of sin might be destroyed, that henceforth we should not serve sin."),
        Verse(identity: "I am dead to sin and alive to God",
              reference: "Romans 6:11",
              text: "Likewise reckon ye also yourselves to be dead indeed unto sin, but alive unto God through Jesus Christ our Lord."),
        Verse(identity: "Sin is not my master",
              reference: "Romans 6:14",
              text: "For sin shall not have dominion over you: for ye are not under the law, but under grace."),
        Verse(identity: "I am not condemned",
              reference: "Romans 8:1",
              text: "There is therefore now no condemnation to them which are in Christ Jesus, who walk not after the flesh, but after the Spirit."),
        Verse(identity: "I am adopted by God",
              reference: "Romans 8:15",
              text: "For ye have not received the spirit of bondage again to fear; but ye have received the Spirit of adoption, whereby we cry, Abba, Father."),
        Verse(identity: "I am more than a conqueror",
              reference: "Romans 8:37",
              text: "Nay, in all these things we are more than conquerors through him that loved us."),
        Verse(identity: "I am the temple of the Holy Spirit",
              reference: "1 Corinthians 6:19-20",
              text: "What? know ye not that your body is the temple of the Holy Ghost which is in you, which ye have of God, and ye are not your own? For ye are bought with a price: therefore glorify God in your body, and in your spirit, which are God's."),
        Verse(identity: "I am washed, sanctified and justified",
              reference: "1 Corinthians 6:11",
              text: "And such were some of you: but ye are washed, but ye are sanctified, but ye are justified in the name of the Lord Jesus, and by the Spirit of our God."),
        Verse(identity: "God's Spirit lives in me",
              reference: "1 Corinthians 3:16",
              text: "Know ye not that ye are the temple of God, and that the Spirit of God dwelleth in you?"),
        Verse(identity: "I am the righteousness of God in Christ",
              reference: "2 Corinthians 5:21",
              text: "For he hath made him to be sin for us, who knew no sin; that we might be made the righteousness of God in him."),
        Verse(identity: "I am chosen and royal",
              reference: "1 Peter 2:9",
              text: "But ye are a chosen generation, a royal priesthood, an holy nation, a peculiar people; that ye should shew forth the praises of him who hath called you out of darkness into his marvellous light."),
        Verse(identity: "I am loved by the Father",
              reference: "1 John 3:1",
              text: "Behold, what manner of love the Father hath bestowed upon us, that we should be called the sons of God."),
        Verse(identity: "I am a child of God",
              reference: "John 1:12",
              text: "But as many as received him, to them gave he power to become the sons of God, even to them that believe on his name."),
        Verse(identity: "I am free indeed",
              reference: "John 8:36",
              text: "If the Son therefore shall make you free, ye shall be free indeed."),
        Verse(identity: "I am Christ's friend",
              reference: "John 15:15",
              text: "Henceforth I call you not servants; for the servant knoweth not what his lord doeth: but I have called you friends; for all things that I have heard of my Father I have made known unto you."),
        Verse(identity: "I am chosen to bear fruit",
              reference: "John 15:16",
              text: "Ye have not chosen me, but I have chosen you, and ordained you, that ye should go and bring forth fruit, and that your fruit should remain."),
        Verse(identity: "I was chosen to be holy",
              reference: "Ephesians 1:4",
              text: "According as he hath chosen us in him before the foundation of the world, that we should be holy and without blame before him in love."),
        Verse(identity: "I am redeemed and forgiven",
              reference: "Ephesians 1:7",
              text: "In whom we have redemption through his blood, the forgiveness of sins, according to the riches of his grace."),
        Verse(identity: "I am God's workmanship",
              reference: "Ephesians 2:10",
              text: "For we are his workmanship, created in Christ Jesus unto good works, which God hath before ordained that we should walk in them."),
        Verse(identity: "I am light in the Lord",
              reference: "Ephesians 5:8",
              text: "For ye were sometimes darkness, but now are ye light in the Lord: walk as children of light."),
        Verse(identity: "My life is hidden with Christ",
              reference: "Colossians 3:3",
              text: "For ye are dead, and your life is hid with Christ in God."),
        Verse(identity: "I am complete in Him",
              reference: "Colossians 2:10",
              text: "And ye are complete in him, which is the head of all principality and power."),
        Verse(identity: "I stand in freedom",
              reference: "Galatians 5:1",
              text: "Stand fast therefore in the liberty wherewith Christ hath made us free, and be not entangled again with the yoke of bondage."),
        Verse(identity: "I am an heir of God",
              reference: "Galatians 4:7",
              text: "Wherefore thou art no more a servant, but a son; and if a son, then an heir of God through Christ."),
        Verse(identity: "I am an overcomer",
              reference: "1 John 4:4",
              text: "Ye are of God, little children, and have overcome them: because greater is he that is in you, than he that is in the world."),
        Verse(identity: "I am the light of the world",
              reference: "Matthew 5:14",
              text: "Ye are the light of the world. A city that is set on an hill cannot be hid."),
        Verse(identity: "I have power, love and a sound mind",
              reference: "2 Timothy 1:7",
              text: "For God hath not given us the spirit of fear; but of power, and of love, and of a sound mind."),
        Verse(identity: "I have strength in Christ",
              reference: "Philippians 4:13",
              text: "I can do all things through Christ which strengtheneth me."),
        Verse(identity: "God is finishing His work in me",
              reference: "Philippians 1:6",
              text: "Being confident of this very thing, that he which hath begun a good work in you will perform it until the day of Jesus Christ."),
    ]

    static func random() -> Verse {
        all.randomElement()!
    }

    /// The same verse all day, so the home screen has a steady "verse of the day".
    static func ofTheDay(_ date: Date = Date()) -> Verse {
        let day = Calendar.current.ordinality(of: .day, in: .era, for: date) ?? 0
        return all[day % all.count]
    }
}
