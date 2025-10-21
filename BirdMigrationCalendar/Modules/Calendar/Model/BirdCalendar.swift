enum BirdCalendar: Identifiable, Hashable {
    var id: String {
        title
    }
    
    case january([Bird])
    case february([Bird])
    case march([Bird])
    case april([Bird])
    case may([Bird])
    case june([Bird])
    case july([Bird])
    case august([Bird])
    case september([Bird])
    case october([Bird])
    case november([Bird])
    case december([Bird])
    
    var title: String {
        switch self {
            case .january:
                "January"
            case .february:
                "February"
            case .march:
                "March"
            case .april:
                "April"
            case .may:
                "May"
            case .june:
                "June"
            case .july:
                "July"
            case .august:
                "August"
            case .september:
                "September"
            case .october:
                "October"
            case .november:
                "November"
            case .december:
                "December"
        }
    }
    
    var birds: [Bird] {
        switch self {
            case .january(let birds),
                    .february(let birds),
                    .march(let birds),
                    .april(let birds),
                    .may(let birds),
                    .june(let birds),
                    .july(let birds),
                    .august(let birds),
                    .september(let birds),
                    .october(let birds),
                    .november(let birds),
                    .december(let birds):
                return birds
        }
    }
}

extension BirdCalendar {
    static let all: [BirdCalendar] = [
        .january([
            Bird(name: "Snowy Owl", image: "img_1", status: .rare, description: "Often seen in northern regions during winter."),
            Bird(name: "Common Redpoll", image: "img_2", status: .common, description: "Small finch that migrates south during winter.")
        ]),
        .february([
            Bird(name: "Whooper Swan", image: "img_3", status: .common, description: "Large migratory swan visiting wetlands."),
            Bird(name: "Lapland Longspur", image: "img_4", status: .rare, description: "Sparrow-like bird appearing during winter migration.")
        ]),
        .march([
            Bird(name: "European Starling", image: "img_5", status: .common, description: "Returns from southern wintering grounds."),
            Bird(name: "Barn Swallow", image: "img_6", status: .common, description: "Starts arriving in early spring."),
            Bird(name: "Fieldfare", image: "img_7", status: .common, description: "Seen in open fields during migration.")
        ]),
        .april([
            Bird(name: "White Stork", image: "img_8", status: .common, description: "Arrives in breeding areas from Africa."),
            Bird(name: "Eurasian Hoopoe", image: "img_9", status: .rare, description: "Appears in southern regions during spring.")
        ]),
        .may([
            Bird(name: "Common Swift", image: "img_10", status: .common, description: "Highly aerial bird arriving in spring."),
            Bird(name: "Yellow Wagtail", image: "img_11", status: .common, description: "Found in open fields and wetlands.")
        ]),
        .june([
            Bird(name: "Eurasian Blackcap", image: "img_12", status: .common, description: "Arrives in breeding habitats in early summer."),
            Bird(name: "Common Cuckoo", image: "img_13", status: .rare, description: "Famous for laying eggs in other birds’ nests.")
        ]),
        .july([
            Bird(name: "European Bee-eater", image: "img_14", status: .rare, description: "Brightly colored, migrates north in summer."),
            Bird(name: "Common Tern", image: "img_15", status: .common, description: "Found near rivers and coastal areas.")
        ]),
        .august([
            Bird(name: "Northern Wheatear", image: "img_16", status: .common, description: "Prepares for autumn migration to Africa."),
            Bird(name: "Red-backed Shrike", image: "img_17", status: .rare, description: "Seen in open fields during late summer.")
        ]),
        .september([
            Bird(name: "Barn Swallow", image: "img_6", status: .common, description: "Starts migrating south for the winter."),
            Bird(name: "Common Crane", image: "img_19", status: .common, description: "Large migratory bird flying in flocks.")
        ]),
        .october([
            Bird(name: "Fieldfare", image: "img_7", status: .common, description: "Returns from northern breeding grounds."),
            Bird(name: "Redwing", image: "img_16", status: .common, description: "Small thrush migrating in autumn.")
        ]),
        .november([
            Bird(name: "Bohemian Waxwing", image: "img_19", status: .rare, description: "Appears in flocks searching for berries."),
            Bird(name: "Common Redpoll", image: "img_2", status: .common, description: "Returns to southern areas for winter.")
        ]),
        .december([
            Bird(name: "Snowy Owl", image: "img_1", status: .rare, description: "Seen in northern regions during winter."),
            Bird(name: "Eurasian Siskin", image: "img_20", status: .common, description: "Small finch visiting coniferous forests.")
        ])
    ]
}
