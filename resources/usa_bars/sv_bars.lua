-- Mostly taken from Bru & Lucillele's restaurant menus

local ITEMS = {
  ["Drinks"] = {
      ["Water"] = {name = "Water", price = 35, type = "drink", substance = 50.0, quantity = 1, legality = "legal", weight = 5, objectModel = "ba_prop_club_water_bottle", caption = "A simple yet hydrating glass of filtered water."},
      ["Corona Light Beer (4%)"] = {name = "Corona Light Beer (4%)", price = 40, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.01, caption = "A pale lager produced by Cervecería Modelo in Mexico"},
      ["Lagunitas IPA"] = {name = "Lagunitas IPA", price = 40, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.02, caption = "Big on the aroma with a hoppy-sweet finish that'll leave you wantin' another sip"},
      ["Budweiser"] = {name = "Budweiser", price = 40, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.02, caption = "An American-style pale lager produced by Anheuser-Busch"},
      ["Miller Lite"] = {name = "Miller Lite", price = 40, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.02, caption = "American light pale lager"},
      ["Grapefruit Sculpin"] = {name = "Grapefruit Sculpin", price = 40, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.02, caption = "Award-winning IPA, with a citrus twist"},
      ["Blue Moon"] = {name = "Blue Moon", price = 40, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.02, caption = "Belgian Style Wheat Ale"},
      ["Sex on the Beach"] = {name = "Sex on the Beach", price = 30, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.4, caption = "Archers Peach Schnapps, Smirnoff Vodka, a juicy blend of Cranberry and Orange Juice all mixed into a glass"},
      ["Modelo Especial"] = {name = "Modelo Especial", price = 40, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.02, caption = "Crisp, clean, and refreshing. The model Mexican beer"},
      ["Jack & Coke"] = {name = "Jack & Coke", price = 50, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.08, caption = "Jack Daniel's whiskey and Coca-Cola served with ice"},
      ["Cosmopolitan"] = {name = "Cosmopolitan", price = 50, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.45, caption = "Blending vodka, Cointreau and cranberry juice and traditionally served in a martini glass, the Cosmo is the cocktail of choice for many glamorous individuals."},
      ["Classic Negroni"] = {name = "Classic Negroni", price = 50, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.40, caption = "Combining equal parts of gin, vermouth and Campari, the Negroni is an iconic cocktail that will always be in style! Poured over ice and with a slice of orange to garnish."},
      ["Grey Goose Vodka"] = {name = "Grey Goose Vodka", price = 65, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.2, caption = "Grey Goose Vodka is distilled from French wheat and is made from spring water from Gensac that is naturally filtered through champagne limestone."},
      ["Sonoma-Cutrer Chardonnay"] = {name = "Sonoma-Cutrer Chardonnay", price = 60, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.09, caption = "A balance of fruit flavors and oak aging, creating a fuller-bodied wine."},
      ["Oyster Bay Sauvignon Blanc"] = {name = "Oyster Bay Sauvignon Blanc", price = 60, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.09, caption = "Marlborough, New Zealand- Earthy, herbal, somewhat subdued lemony aroma with hints of tropical fruit, gooseberry, and coconut. "},
      ["Meiomi Pinot Noir"] = {name = "Meiomi Pinot Noir", price = 60, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.09, caption = "lifted fruit aromas of bright strawberry and jammy fruit, mocha, and vanilla, along with toasty oak notes. Expressive boysenberry, blackberry, dark cherry, juicy strawberry, and toasty mocha flavors lend complexity and depth on the palate."},
      ["El Pepino"] = {name = "El Pepino", price = 60, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.16, caption = "Cool and refreshing with Casamigos Blanco Tequila, fresh cucumber, lime juice and agave nectar."},
      ["Fresh Watermelon Margarita"] = {name = "Fresh Watermelon Margarita", price = 60, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.15, caption = "1800 Reposado, Cointreau, agave nectar, with fresh watermelon and lime juice. Shaken, served on the rocks and topped with Fevertree Ginger Beer."},
      ["Old Fashioned"] = {name = "Old Fashioned", price = 60, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.50, caption = "Mixing Bourbon Whiskey, bitters, sugar and a dash of water led to this dark and delicious cocktail."},
      ["Rattler - Cornish Cyder"] = {name = "Rattler - Cornish Cyder", price = 50, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.25, caption = "Imported from the UK, this crisp apple cyder blend refreshes you with a bite. Perfect for casual drinking."},
      ["Margarita"] = {name = "Margarita", price = 60, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.3, caption = "Tequila, Triple Sec and lime juice. It's also often served with a salt rim for the perfect balance of sweet, sour and salty."},
      ["Cucumber Watermelon"] = {name = "Cucumber Watermelon", price = 60, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.23, caption = "Grey Goose Vodka, St. Germaine Elderflower Liqueur, fresh muddled cucumber, watermelon and lemon juice."},
      ["Voodoo"] = {name = "Voodoo", price = 60, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.3, caption = "Ketel One Vodka and Chambord, shaken ice cold with fresh blueberries, smoked jalapenos and lemon juice."},
      ["Mi Casa Es Su Casa"] = {name = "Mi Casa Es Su Casa", price = 60, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.28, caption = "A premium blend of Casamigos Blanco Tequila and Cointreau, shaken ice cold with fresh lime juice, agave, a hint of orange and olive juice."},
      ["Back Porch Strawberry Lemonade"] = {name = "Back Porch Strawberry Lemonade", price = 60, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.28, caption = "Skyy Infusions Wild Strawberry, Triple Sec, Strawberry Lemonade and a splash of soda. Served over ice in our 22 oz mug with fresh strawberries."},
      ["Pepsi"] = {name = "Pepsi", price = 75, type = "drink", substance = 38.0, quantity = 1, legality = "legal", weight = 5, caption = "A refreshing carbonated drink with a citrusy flavor burst."},
      ["Whiskey Sour"] = {name = "Whiskey Sour", price = 40, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.45, caption = "A mixture of whiskey, sugar, and lemon. Makes the whiskey SOUR."},
      ["Irish Coffee"] = {name = "Irish Coffee", price = 35, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.3, caption = "Freshly brewed coffee, Irish whiskey, and whipped cream."},
      ["Bloody Mary"] = {name = "Bloody Mary", price = 35, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.3, caption = "Bloody Mary is traditionally made with vodka, tomato juice, Worcestershire sauce, black pepper, celery salt, Tabasco, and lemon juice."},
      ["Gimlet"] = {name = "Gimlet", price = 40, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.5, caption = "The Gimlet is a simple cocktail combining gin and lime to create an ultra-refreshing drink."},
      ["Piña Colada"] = {name = "Piña Colada", price = 35, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.5, caption = "A tropical blend of rich coconut cream, white rum and tangy pineapple – serve with an umbrella for kitsch appeal."},
      ["Long Island Iced Tea"] = {name = "Long Island Iced Tea", price = 40, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.3, caption = "It's made with equal parts of vodka, gin, tequila, rum and triple sec, plus lime, cola and plenty of ice."},
      ["Blue Lagoon"] = {name = "Blue Lagoon", price = 40, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.5, caption = "Made with blue curaçao, vodka, lemon juice, orange juice, lime juice and soda water."},
      ["House Vodka Shot"] = {name = "House Vodka Shot", price = 20, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 3, strength = 0.4, caption = "25ml shot of the in-house vodka."},
      ["Cranberry Cookie"] = {name = "Cranberry Cookie", price = 20, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 3, strength = 0.4, caption = "25ml shot of cranberry juice and amaretto mixed to make a head-spinning shot."},
      ["Jäger Bomb"] = {name = "Jäger Bomb", price = 20, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 3, strength = 0.6, caption = "25ml shot of Jägermeister Liqueur and 1/2 a can of Redbull in a glass. This is the easiest way to get drunk."},
      ["Dry Martini"] = {name = "Dry Martini", price = 40, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.4, caption = "Dry gin, dry vermouth, and orange bitters is best served with a lemon twist."},
      ["Espresso Martini"] = {name = "Espresso Martini", price = 50, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.3, caption = "Combining vodka and coffee liqueur for a rich, robust and distinct flavour, this sophisticated cocktail will remain the stuff of myth and legend for years to come."},
      ["Passionfruit Martini"] = {name = "Passionfruit Martini", price = 60, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 0.4, caption = "This modern-classic popular cocktail is made with vanilla vodka, fresh passion fruit, passion fruit liqueur and lime juice. Also served with a shot of champagne or prosecco on the side."},
      ["Prosecco Shot"] = {name = "Prosecco Shot", price = 10, type = "alcohol", substance = 5.0, quantity = 1, legality = "legal", weight = 5, strength = 0.3, caption = "Classic shot of prosecco to go alongside your martini's and other cocktails of your choosing."},
      ["Bollinger Special Cuvée NV Champagne"] = {name = "Bollinger Special Cuvée NV Champagne", price = 90, type = "alcohol", substance = 15.0, quantity = 1, legality = "legal", weight = 5, strength = 1.0, caption = "Bollinger's Special Cuvée is rich in aromatic complexity, with hints of apple compote, spiced stone fruit and brioche on the nose, and pronounced bubbles on the palate. Best served straight up."},
      ["Coca Cola"] = {name = "Coca Cola", price = 20, type = "drink", substance = 40.0, quantity = 1, legality = "legal", weight = 4, objectModel = "ng_proc_sodacan_01b"},
      ["Diet Cola"] = {name = "Diet Cola", price = 20, type = "drink", substance = 40.0, quantity = 1, legality = "legal", weight = 4, objectModel = "ng_proc_sodacan_01b"},
      ["Root Beer"] = {name = "Root Beer", price = 20, type = "drink", substance = 40.0, quantity = 1, legality = "legal", weight = 4, objectModel = "ng_proc_sodacan_01b"},
      ["Peach Fanta"] = {name = "Peach Fanta", price = 20, type = "drink", substance = 40.0, quantity = 1, legality = "legal", weight = 4, objectModel = "ng_proc_sodacan_01b"},
      ["Pineapple Fanta"] = {name = "Pineapple Fanta", price = 20, type = "drink", substance = 35.0, quantity = 1, legality = "legal", weight = 4, objectModel = "ng_proc_sodacan_01b"},
      ["Monster Energy Drink"] = {name = "Monster Energy Drink", price = 20, type = "drink", substance = 40.0, quantity = 1, legality = "legal", weight = 4, objectModel = "prop_energy_drink"},
      ["Redbull Energy Drink"] = {name = "Redbull Energy Drink", price = 20, type = "drink", substance = 40.0, quantity = 1, legality = "legal", weight = 4, objectModel = "prop_energy_drink"},
      ["Rockstar Energy Drink"] = {name = "Rockstar Energy Drink", price = 20, type = "drink", substance = 40.0, quantity = 1, legality = "legal", weight = 4, objectModel = "prop_energy_drink"}
  },
  ["Food"] = {
      ["Fried Dill Pickles"] = { name = "Fried Dill Pickles", price = 30, type = "food", substance = 18.0, quantity = 1, legality = "legal", weight = 5, caption = "Dill pickle slices are breaded, then deep fried in peanut oil." },
      ["Onion Straws"] = { name = "Onion Straws", price = 35, type = "food", substance = 20.0, quantity = 1, legality = "legal", weight = 5, caption = "Flavorful, crispy, and addicting!" },
      ["Bacon Mac N Cheese"] = { name = "Bacon Mac N Cheese", price = 35, type = "food", substance = 20.0, quantity = 1, legality = "legal", weight = 5, caption = "The ultimate classic comfort food, is a house favorite. " },
      ["Pulled Pork Queso Dip"] = { name = "Pulled Pork Queso Dip", price = 45, type = "food", substance = 25.0, quantity = 1, legality = "legal", weight = 5, caption = "Pulled Pork Queso Dip made with all natural ingredients." },
      ["Artichoke Spinach Dip"] = { name = "Artichoke Spinach Dip", price = 45, type = "food", substance = 25.0, quantity = 1, legality = "legal", weight = 5, caption = "Artichokes and spinach blended with cheeses." },
      ["Chicken Wings"] = { name = "Chicken Wings", price = 45, type = "food", substance = 20.0, quantity = 1, legality = "legal", weight = 5, caption = "Coated in a sauce consisting of a vinegar-based cayenne pepper hot sauce and melted butter" },
      ["All American Hamburger"] = { name = "All American Hamburger", price = 50, type = "food", substance = 30.0, quantity = 1, legality = "legal", weight = 5, caption = "A delicious classic with 100% Angus Beef, lettuce, Tomato, Onion, and Cheddar Cheese" },
      ["Chopped Salad"] = { name = "Chopped Salad", price = 55, type = "food", substance = 20.0, quantity = 1, legality = "legal", weight = 5, caption = "Romaine lettuce, finely chopped Radicchio, Celery, Cherry Tomatoes, with a delicious Vinaigrette dressing." },
      ["2 Topping Pizza"] = { name = "Pizza", price = 45, type = "food", substance = 20.0, quantity = 1, legality = "legal", weight = 5, caption = "Personal pizzas, your choice of 2 toppings." },
      ["Pesto Chicken Sandwich"] = { name = "Chicken Sandwich", price = 45, type = "food", substance = 30.0, quantity = 1, legality = "legal", weight = 5, caption = "A pesto chicken sandwhich between Focaccia bread." },
      ["Ahi Tuna Sandwich"] = { name = "Ahi Tuna Sandwich", price = 50, type = "food", substance = 30.0, quantity = 1, legality = "legal", weight = 5, caption = "An Ahi Tuna Sandwich with  your  choice of bread." },
      ["French Dip Au Jus"] = { name = "French Dip Au Jus", price = 55, type = "food", substance = 30.0, quantity = 1, legality = "legal", weight = 5, caption = "Warm Roast beef on a baguette topped with Swiss Cheese, and onions and a side of beef juice." },
      ["Cheeseburger"] = { name = "Cheeseburger", price = 85, type = "food", substance = 15.0, quantity = 1, legality = "legal", weight = 5, caption = "Angus beef on a Brioche Bun with American Cheese."},
      ["Fries"] = { name = "Fries", price = 30, type = "food", substance = 10.0, quantity = 1, legality = "legal", weight = 5, caption = "Crispy potato fries, fried in vegetable oil scattered in salt."},
      ["Lamb Doner"] = { name = "Lamb Doner", price = 40, type = "food", substance = 30.00, quantity = 1, legality "legal", weight = 5, caption = "The best way to end one of those nights clubbing... just try not to puke it up."},
  }
}

RegisterServerEvent("bars:loadItems")
AddEventHandler("bars:loadItems", function()
  TriggerClientEvent("bars:loadItems", source, ITEMS)
end)

RegisterServerEvent("bars:buy")
AddEventHandler("bars:buy", function(itemCategory, itemName, business)
  local char = exports["usa-characters"]:GetCharacter(source)
  local item = ITEMS[itemCategory][itemName]
  if item and char then
      if char.get("money") >= item.price then
          if char.canHoldItem(item) then
              char.giveItem(item, 1)
              char.removeMoney(item.price)
              if business then
                exports["usa-businesses"]:GiveBusinessCashPercent(business, item.price)
              end
          else
            TriggerClientEvent("usa:notify", source, "Inventory full.")
          end
      else
          TriggerClientEvent("usa:notify", source, "Not enough money!")
      end
  end
end)
