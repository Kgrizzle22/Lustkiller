import Foundation

struct Verse: Codable, Hashable, Identifiable {
    let reference: String
    let text: String

    var id: String { reference }
    var formatted: String { "\u{201C}\(text)\u{201D} \u{2014} \(reference)" }
}

/// Verses on purity and temptation, King James Version (public domain).
enum Verses {
    static let all: [Verse] = [
        Verse(reference: "1 Corinthians 6:18", text: "Flee fornication. Every sin that a man doeth is without the body; but he that committeth fornication sinneth against his own body."),
        Verse(reference: "Matthew 5:28", text: "But I say unto you, That whosoever looketh on a woman to lust after her hath committed adultery with her already in his heart."),
        Verse(reference: "Job 31:1", text: "I made a covenant with mine eyes; why then should I think upon a maid?"),
        Verse(reference: "Psalm 119:9", text: "Wherewithal shall a young man cleanse his way? by taking heed thereto according to thy word."),
        Verse(reference: "Psalm 119:37", text: "Turn away mine eyes from beholding vanity; and quicken thou me in thy way."),
        Verse(reference: "Psalm 119:11", text: "Thy word have I hid in mine heart, that I might not sin against thee."),
        Verse(reference: "Psalm 101:3", text: "I will set no wicked thing before mine eyes."),
        Verse(reference: "Psalm 51:10", text: "Create in me a clean heart, O God; and renew a right spirit within me."),
        Verse(reference: "2 Timothy 2:22", text: "Flee also youthful lusts: but follow righteousness, faith, charity, peace, with them that call on the Lord out of a pure heart."),
        Verse(reference: "1 Corinthians 10:13", text: "There hath no temptation taken you but such as is common to man: but God is faithful, who will not suffer you to be tempted above that ye are able; but will with the temptation also make a way to escape, that ye may be able to bear it."),
        Verse(reference: "Galatians 5:16", text: "This I say then, Walk in the Spirit, and ye shall not fulfil the lust of the flesh."),
        Verse(reference: "Romans 13:14", text: "But put ye on the Lord Jesus Christ, and make not provision for the flesh, to fulfil the lusts thereof."),
        Verse(reference: "Romans 12:2", text: "And be not conformed to this world: but be ye transformed by the renewing of your mind."),
        Verse(reference: "Romans 6:14", text: "For sin shall not have dominion over you: for ye are not under the law, but under grace."),
        Verse(reference: "Philippians 4:8", text: "Whatsoever things are true, whatsoever things are honest, whatsoever things are just, whatsoever things are pure, whatsoever things are lovely, whatsoever things are of good report; if there be any virtue, and if there be any praise, think on these things."),
        Verse(reference: "1 Thessalonians 4:3", text: "For this is the will of God, even your sanctification, that ye should abstain from fornication."),
        Verse(reference: "Proverbs 4:23", text: "Keep thy heart with all diligence; for out of it are the issues of life."),
        Verse(reference: "Proverbs 6:25", text: "Lust not after her beauty in thine heart; neither let her take thee with her eyelids."),
        Verse(reference: "Matthew 26:41", text: "Watch and pray, that ye enter not into temptation: the spirit indeed is willing, but the flesh is weak."),
        Verse(reference: "Matthew 5:8", text: "Blessed are the pure in heart: for they shall see God."),
        Verse(reference: "James 1:14-15", text: "But every man is tempted, when he is drawn away of his own lust, and enticed. Then when lust hath conceived, it bringeth forth sin: and sin, when it is finished, bringeth forth death."),
        Verse(reference: "1 John 2:16", text: "For all that is in the world, the lust of the flesh, and the lust of the eyes, and the pride of life, is not of the Father, but is of the world."),
        Verse(reference: "1 John 1:9", text: "If we confess our sins, he is faithful and just to forgive us our sins, and to cleanse us from all unrighteousness."),
        Verse(reference: "Hebrews 4:15", text: "For we have not an high priest which cannot be touched with the feeling of our infirmities; but was in all points tempted like as we are, yet without sin."),
        Verse(reference: "2 Corinthians 10:5", text: "Casting down imaginations, and every high thing that exalteth itself against the knowledge of God, and bringing into captivity every thought to the obedience of Christ."),
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
