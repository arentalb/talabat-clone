import 'package:talabat/utils/models/food_item.model.dart';
import 'package:talabat/utils/models/store.model.dart';

List<Store> storesData = [
  Store(
    storeId: 1,
    isTrend: true,
    storeName: "Pizza Hub",
    storeImageUrl: "assets/PizzaHub.jpg",
    categories: ["Pizza", "Drinks", "Desserts"],
    foods: [
      FoodItem(
        foodId: 101,
        name: "Margherita Pizza",
        category: "Pizza",
        options: [
          Option(id: 1, name: "Small", price: 6000),
          Option(id: 2, name: "Medium", price: 8000),
          Option(id: 3, name: "Large", price: 10000),
        ],
        imageUrl: "assets/MargheritaPizza.jpg",
      ),
      FoodItem(
        foodId: 102,
        name: "Pepperoni Pizza",
        category: "Pizza",
        options: [
          Option(id: 1, name: "Small", price: 4000),
          Option(id: 2, name: "Medium", price: 6000),
          Option(id: 3, name: "Large", price: 8000),
        ],
        imageUrl: "assets/PepperoniPizza.jpg",
      ),
      FoodItem(
        foodId: 103,
        name: "Coke",
        category: "Drinks",
        options: [
          Option(id: 1, name: "Can", price: 1000),
          Option(id: 2, name: "Bottle", price: 2000),
        ],
        imageUrl: "assets/Cock.webp",
      ),
      FoodItem(
        foodId: 104,
        name: "Chocolate Lava Cake",
        category: "Desserts",
        options: [],
        imageUrl: "assets/ChocolateLavaCake.webp",
      ),
    ],
  ),
  Store(
    storeId: 2,
    isTrend: true,
    storeName: "Burger Haven",
    storeImageUrl: "assets/BurgerHaven.jpg",
    categories: ["Burgers", "Sides", "Drinks"],
    foods: [
      FoodItem(
        foodId: 201,
        name: "Cheeseburger",
        category: "Burgers",
        options: [
          Option(id: 1, name: "Cheese", price: 3000),
          Option(id: 2, name: "Bacon", price: 2000),
        ],
        imageUrl: "assets/Cheeseburger.jpg",
      ),
      FoodItem(
        foodId: 202,
        name: "Fries",
        category: "Sides",
        options: [
          Option(id: 1, name: "Small", price: 3000),
          Option(id: 2, name: "Large", price: 5000),
        ],
        imageUrl: "assets/Fries.jpg",
      ),
      FoodItem(
        foodId: 203,
        name: "Milkshake",
        category: "Drinks",
        options: [
          Option(id: 1, name: "Vanilla", price: 3000),
          Option(id: 2, name: "Chocolate", price: 5000),
          Option(id: 3, name: "Strawberry", price: 4000),
        ],
        imageUrl: "assets/Milkshake.jpg",
      ),
    ],
  ),
  Store(
    storeId: 3,
    isTrend: true,
    storeName: "Asian Express",
    storeImageUrl: "assets/AsianExpress.jpg",
    categories: ["Noodles", "Rice", "Soups", "Drinks"],
    foods: [
      FoodItem(
        foodId: 301,
        name: "Chicken Fried Rice",
        category: "Rice",
        options: [
          Option(id: 1, name: "Mild", price: 4000),
          Option(id: 2, name: "Medium", price: 7000),
          Option(id: 3, name: "Hot", price: 12000),
        ],
        imageUrl: "assets/ChickenFriedRice.jpeg",
      ),
      FoodItem(
        foodId: 302,
        name: "Beef Noodles",
        category: "Noodles",
        options: [
          Option(id: 1, name: "Medium", price: 7000),
          Option(id: 2, name: "Hot", price: 12000),
        ],
        imageUrl: "assets/BeefNoodles.jpg",
      ),
      FoodItem(
        foodId: 303,
        name: "Tom Yum Soup",
        category: "Soups",
        options: [
          Option(id: 1, name: "Small", price: 5000),
          Option(id: 2, name: "Large", price: 9000),
        ],
        imageUrl: "assets/TomYumSoup.jpg",
      ),
    ],
  ),
  Store(
    storeId: 4,
    isTrend: false,
    storeName: "Sweet Treats",
    storeImageUrl: "assets/SweetTreats.png",
    categories: ["Cakes", "Pastries", "Drinks"],
    foods: [
      FoodItem(
        foodId: 401,
        name: "Red Velvet Cake",
        category: "Cakes",
        options: [
          Option(id: 1, name: "Single", price: 4000),
          Option(id: 2, name: "Double", price: 7000),
        ],
        imageUrl: "assets/RedVelvetCake.webp",
      ),
      FoodItem(
        foodId: 402,
        name: "Chocolate Muffin",
        category: "Pastries",
        options: [],
        imageUrl: "assets/ChocolateMuffin.jpg",
      ),
      FoodItem(
        foodId: 403,
        name: "Latte",
        category: "Drinks",
        options: [
          Option(id: 1, name: "Small", price: 4000),
          Option(id: 2, name: "Medium", price: 6000),
          Option(id: 3, name: "Large", price: 8000),
        ],
        imageUrl: "assets/Latte.jpg",
      ),
    ],
  ),
  Store(
    storeId: 5,
    isTrend: false,
    storeName: "Taco Town",
    storeImageUrl: "assets/TacoTown.png",
    categories: ["Tacos", "Sides", "Drinks"],
    foods: [
      FoodItem(
        foodId: 501,
        name: "Beef Taco",
        category: "Tacos",
        options: [
          Option(id: 1, name: "Mild", price: 3000),
          Option(id: 2, name: "Medium", price: 4000),
          Option(id: 3, name: "Hot", price: 5000),
        ],
        imageUrl: "assets/BeefTaco.jpg",
      ),
      FoodItem(
        foodId: 502,
        name: "Nachos",
        category: "Sides",
        options: [],
        imageUrl: "assets/Nachos.webp",
      ),
      FoodItem(
        foodId: 503,
        name: "Margarita",
        category: "Drinks",
        options: [
          Option(id: 1, name: "Classic", price: 3000),
          Option(id: 2, name: "Strawberry", price: 4000),
        ],
        imageUrl: "assets/MargaritaDrink.jpg",
      ),
    ],
  ),
];
