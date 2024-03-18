CONFIG = {
    RESTAURANTS = {
        BURGERSHOT = {
            JOB_NAME = "burgershot",
            REGISTER = {
                COORDS = vector3(-1195.634, -893.85, 13.88616),
                MENU = {
                    {
                        header = "($500) Money Shot Burger",
                        context = "Double patty burger",
                        event = "bs:addOrderItem",
                        args = {
                            "Money Shot Burger",
                            "BURGERSHOT"
                        }
                    },
                    {
                        header = "($375) The Bleeder Burger",
                        context = "Single patty burger",
                        event = "bs:addOrderItem",
                        args = {
                            "The Bleeder Burger",
                            "BURGERSHOT"
                        }
                    },
                    {
                        header = "($375) Torpedo Sandwich",
                        context = "Sandwich",
                        event = "bs:addOrderItem",
                        args = {
                            "Torpedo Sandwich",
                            "BURGERSHOT"
                        }
                    },
                    {
                        header = "($375) Meat Free Burger",
                        context = "Plant based burger",
                        event = "bs:addOrderItem",
                        args = {
                            "Meat Free Burger",
                            "BURGERSHOT"
                        }
                    },
                    {
                        header = "($175) French Fries",
                        context = "Crispy french fries",
                        event = "bs:addOrderItem",
                        args = {
                            "French Fries",
                            "BURGERSHOT"
                        }
                    },
                    {
                        header = "($350) Coca Cola",
                        context = "A refreshing beverage",
                        event = "bs:addOrderItem",
                        args = {
                            "Coca Cola",
                            "BURGERSHOT"
                        }
                    },
                    {
                        header = "Done",
                        context = "Register the new order",
                        event = "bs:registerNewOrder",
                        args = {
                            "BURGERSHOT"
                        }
                    }
                }
            },
            COOKING = {
                COORDS = vector3(-1195.372, -897.1624, 14.808616)
            },
            COUNTER = {
                COORDS = vector3(-1192.118, -893.2803, 13.88616)
            },
            ITEMS = {
                ["Money Shot Burger"] = {
                    PRICE = 500
                },
                ["The Bleeder Burger"] = {
                    PRICE = 375
                },
                ["Torpedo Sandwich"] = {
                    PRICE = 375
                },
                ["Meat Free Burger"] = {
                    PRICE = 375
                },
                ["French Fries"] = {
                    PRICE = 175
                },
                ["Coca Cola"] = {
                    PRICE = 350
                },
            },
            JOB_VEHICLE = {
                MODEL = "nspeedo",
                SPAWN = {
                    X = -1204.4656982422,
                    Y = -901.98754882812,
                    Z = 13.473096847534
                }
            },
            PROPERTY_NAME = "Burgershot",
            OUTFIT = {
                MALE = {
                    TORSO = {
                        COMPONENT = 406,
                        TEXTURE = 1
                    },
                    ARMS = {
                        COMPONENT = 6,
                        TEXTURE = 0
                    }
                },
                FEMALE = {
                    TORSO = {
                        COMPONENT = 420,
                        TEXTURE = 2
                    },
                    ARMS = {
                        COMPONENT = 9,
                        TEXTURE = 0
                    }
                }
            }
        },
        CATCAFE = {
            JOB_NAME = "catcafe",
            REGISTER = {
                COORDS = vector3(-584.7996, -1061.443, 22.3442),
                MENU = {
                    {
                        header = "($250) Fruit Tart",
                        context = "A delicious fruit tart snack",
                        event = "bs:addOrderItem",
                        args = {
                            "Fruit Tart",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($450) Pancake",
                        context = "A delicious pancake",
                        event = "bs:addOrderItem",
                        args = {
                            "Pancake",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($400) Miso Soup",
                        context = "Delicious bowl of miso soup",
                        event = "bs:addOrderItem",
                        args = {
                            "Miso Soup",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($500) UWU Sandwich",
                        context = "A delicious cat cafe sandwich",
                        event = "bs:addOrderItem",
                        args = {
                            "UWU Sandwich",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($250) Weepy Cupcake",
                        context = "A delicious cat cafe cupcake",
                        event = "bs:addOrderItem",
                        args = {
                            "Weepy Cupcake",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($250) Moon Mochi",
                        context = "Rice cake wrapped ice cream",
                        event = "bs:addOrderItem",
                        args = {
                            "Moon Mochi",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($500) Buddha Bowl",
                        context = "The signature buddha bowl",
                        event = "bs:addOrderItem",
                        args = {
                            "Buddha Bowl",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($500) Bento Box",
                        context = "The signature bento box",
                        event = "bs:addOrderItem",
                        args = {
                            "Bento Box",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($350) Espresso",
                        context = "A cup of espresso",
                        event = "bs:addOrderItem",
                        args = {
                            "Espresso",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($350) Macchiato",
                        context = "A cup of macchiato",
                        event = "bs:addOrderItem",
                        args = {
                            "Macchiato",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($350) Latte",
                        context = "A classic latte",
                        event = "bs:addOrderItem",
                        args = {
                            "Latte",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($350) Mocha",
                        context = "A classic mocha coffee",
                        event = "bs:addOrderItem",
                        args = {
                            "Mocha",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($350) Blueberry Bubble Tea",
                        context = "A blueberry bubble tea",
                        event = "bs:addOrderItem",
                        args = {
                            "Blueberry Bubble Tea",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "Done",
                        context = "Register the new order",
                        event = "bs:registerNewOrder",
                        args = {
                            "CATCAFE"
                        }
                    }
                }
            },
            COOKING = {
                COORDS = vector3(-588.5706, -1059.424, 22.35617)
            },
            COUNTER = {
                COORDS = vector3(-585.158, -1063.622, 22.3442)
            },
            ITEMS = {
                ["Fruit Tart"] = {
                    PRICE = 250
                },
                ["Pancake"] = {
                    PRICE = 450
                },
                ["Miso Soup"] = {
                    PRICE = 400
                },
                ["UWU Sandwich"] = {
                    PRICE = 500
                },
                ["Weepy Cupcake"] = {
                    PRICE = 250
                },
                ["Moon Mochi"] = {
                    PRICE = 250
                },
                ["Buddha Bowl"] = {
                    PRICE = 500
                },
                ["Bento Box"] = {
                    PRICE = 500
                },
                ["Espresso"] = {
                    PRICE = 350
                },
                ["Macchiato"] = {
                    PRICE = 350
                },
                ["Latte"] = {
                    PRICE = 350
                },
                ["Mocha"] = {
                    PRICE = 350
                },
                ["Blueberry Bubble Tea"] = {
                    PRICE = 350
                },
            },
            JOB_VEHICLE = { -- todo: add heading
                MODEL = "rumpo",
                SPAWN = {
                    X = -561.71411132812,
                    Y = -1071.2105712891,
                    Z = 22.178901672363
                }
            },
            PROPERTY_NAME = "Cat Cafe",
            OUTFIT = {
                MALE = {
                    TORSO = {
                        COMPONENT = 38,
                        TEXTURE = 13
                    },
                    ARMS = {
                        COMPONENT = 1,
                        TEXTURE = 1
                    }
                },
                FEMALE = {
                    TORSO = {
                        COMPONENT = 63,
                        TEXTURE = 1
                    },
                    ARMS = {
                        COMPONENT = 1,
                        TEXTURE = 1
                    }
                }
            }
        }
    }
}