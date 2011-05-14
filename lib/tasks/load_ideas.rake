task :load => :environment do
  ideas = "Turn-based-starcraft tactile environment
    MMORPG for Android
    Realworld RPG - Games for good
    Real world Network of ppl w/ similar interests
    100 pushups a day game
    Brandeis mobile app
    Giraffe Adventure
    Tycoon game for Android
    Game using speech recognition/location-aware
    Defcon for android
    Portable resume
    In Attendence - add friend feature
    Brandeis events achievements
    Brandeis Scavenger Hunt/BucketList/Virtual items
    Settlers of Brandeis
    Brandeis Monopoly (Anyplace/Real-World)
    Network realy app - extend the network
    Touch screen/accelerometer pen flipper
    Paper football
    Assassins for Android
    Brandeis King of the Hill
    General platform for mobile multi-player
    Crowd-source chess/other game
    Mobile flashmob generator
    Protest app where you select how long/loudly your protest
    Group hug (flashmob)
    Dodgeball anywhere
    Activism app
    Yardsale app
    Virtual book exchange
    Location-based anonymous chat
    Enhanced reality for travelers
    Find recycling + haz. waste disposal location"

  for idea in ideas.split(/\n/) do
    Post.create(:title => idea, :id => 0)
  end


end