user = User.create(name: "alex", username: "alx", password: "123")
user1 = User.create(name: "michael", username: "mikey", password: "321")

bag = Bag.create(ownersname: "alex's bag", user: user)
bag1 = Bag.create(ownersname: "michael's bag", user: user1)

Pokeball.create(cost:200, kind:"pokeball", bag: bag)
Pokeball.create(cost:200, kind:"pokeball", bag: bag1)