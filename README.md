# reedsy-challenge-backend

Reedsy would like to expand its business to include a merchandise store for our professionals. It will be comprised of 3 items:

```
Code         | Name                   |  Price
-------------------------------------------------
MUG          | Reedsy Mug             |   6.00
TSHIRT       | Reedsy T-shirt         |  15.00
HOODIE       | Reedsy Hoodie          |  20.00
```

We would like you to provide us with a small web application to help us manage this store.

## Preface
Hello Reedsy Team!

My name is Alejandro, I live in Andorra, and I've been a software engineer for more than 10 years. I've worked in a variety of projects, always in product companies that ranged from 10 to 900 people, and in different areas like retail or delivery. 
I've worked with a variety of technologies, but I'm most comfortable with Ruby on Rails.
When I’m not working, I enjoy outdoor sports, practicing Krav Maga, and I’m really passionate about cooking. I’m also interested in trading and have developed some TradingView scripts.

Hope you like the project! For sure there is a lot I can improve, but I think I did enough to kickstart a good conversation.

## How to run the server
- Install bundler:
  `gem install bundler`
- Install gems:
  `bundle install`
- Launch Rails server:
  `rails s`

After this, the server will be available at http://localhost:3000

### Database creation
The first time running the server you need to setup the database:
`rails db:setup`
Since this is SQLite, it will create the database files under `./storage/` 

### Some considerations
- The project was generated using the --api flag, so it doesn't include views.
- I used SQLite to avoid the need of an external database, but for a production environment, I would use PostgreSQL or MySQL instead. For a more professional dev environment, I would also use Docker.
- I've added the three initial products to the database using seeds, and also all the discounts from question 4.
- I used RSpec for testing. Minitest is also fine, but I'm more familiar with RSpec. I'm not using FactoryBot, since the models are simple and I can create them directly in the tests.
- I would assume that the API would evolve over time, so in a prod environment, I would use versioning in the API. For the sake of simplicity, I didn't do it here.
- I've not used any cache system, like Redis, for simplicity. In a production environment it's a must.
- In Questions 3 and 4, I've ignored all non-existent codes. In a production implementation, I would return an error message instead.
- I realized when implementing question 4 that the API design for calculating the total could have been better if instead of accepting a list of elements, it accepted a list of hashes with the product code and quantity. I didn't change it because it would require a lot of changes in the tests and I'm running out of time.

## Guidelines

Some important notes before diving into the specifics:

- we expect this challenge to be done using Ruby on Rails;
- any detail that is not specified throughout this assignment is for you to decide. Our questions and examples are agnostic on purpose, so as to not bias your toward a specific format. If you work at Reedsy you will make decisions and we want that to reflect here. This being said, if you spot anything that you **really** think should be detailed here, feel free to let us know;
- the goal of this challenge is to see if you're able to write code that follows development best practices and is maintainable. It shouldn't be too complicated (you don't need to worry about authentication, for example) but it should be solid enough to ship to production;
- regarding dependencies:
    - try to keep them to a minimum. It's OK to add a dependency that adds a localized and easy to understand functionality;
    - avoid dependencies that significantly break away from standard Rails or that have a big DSL to learn (e.g., [Grape](https://github.com/ruby-grape/grape)). It makes it much harder for us to evaluate the challenge if it deviates a lot from vanilla Rails. If in doubt, err on the side of using less dependencies or check with us if it's OK to use;
- in terms of database any of SQLite, PostgreSQL or MySQL will be fine;
- include also with your solution:
    - instructions on how to setup and run your application;
    - a description of the API endpoints with cURL examples.

    
### Question 1

Implement an API endpoint that allows listing the existing items in the store, as well as their attributes.

cURL:
```
curl -X GET http://localhost:3000/products
```
response example:
```
[{"code":"MUG","name":"Reedsy Mug","price":"1.99"},{"code":"TSHIRT","name":"Reedsy T-shirt","price":"15.0"},{"code":"HOODIE","name":"Reedsy Hoodie","price":"20.0"}]%  
```

### Question 2

Implement an API endpoint that allows updating the price of a given product.

cURL:
```
curl -X PATCH -H "Content-Type: application/json" -d '{"price": "6.0"}' http://localhost:3000/products/MUG
```

### Question 3

Implement an API endpoint that allows one to check the price of a given list of items.

Some examples on the values expected:

curl:
```
curl -X POST -H "Content-Type: application/json" -d '{"product_codes":["MUG", "TSHIRT", "HOODIE"]}' http://localhost:3000/total_price
```
response:
```
{"items":"1 MUG, 1 TSHIRT, 1 HOODIE","total":"41.0"}%
```

curl:
```
curl -X POST -H "Content-Type: application/json" -d '{"product_codes":["MUG", "MUG", "TSHIRT"]}' http://localhost:3000/total_price
```
response:
```
{"items":"2 MUG, 1 TSHIRT","total":"27.0"}
```

curl:
```
curl -X POST -H "Content-Type: application/json" -d '{"product_codes":["MUG", "MUG", "MUG", "TSHIRT"]}' http://localhost:3000/total_price
```
response:
```
{"items":"3 MUG, 1 TSHIRT","total":"33.0"}%
```

curl:
```
curl -X POST -H "Content-Type: application/json" -d '{"product_codes":["MUG", "MUG", "TSHIRT", "TSHIRT", "TSHIRT", "TSHIRT", "HOODIE"]}' http://localhost:3000/total_price
```
response:
```
{"items":"2 MUG, 4 TSHIRT, 1 HOODIE","total":"92.0"}%
```

### Question 4

We'd like to expand our store to provide some discounted prices in some situations.

- 30% discounts on all `TSHIRT` items when buying 3 or more.
- Volume discount for `MUG` items:
    - 2% discount for 10 to 19 items
    - 4% discount for 20 to 29 items
    - 6% discount for 30 to 39 items
    - ... (and so forth with discounts increasing in steps of 2%)
    - 30% discount for 150 or more items

Make the necessary changes to your code to allow these discounts to be in place and to be reflected in the existing endpoints. Also make your discounts flexible enough so that it's easy to change a discount's percentage (i.e., with minimal impact to the source code).

Here's how the above price examples would be updated with these discounts:

curl:
```
curl -X POST -H "Content-Type: application/json" -d '{"product_codes":["MUG", "TSHIRT", "HOODIE"]}' http://localhost:3000/total_price
```
response:
```
{"items":"1 MUG, 1 TSHIRT, 1 HOODIE","total":"41.0"}%
```

curl:
```
curl -X POST -H "Content-Type: application/json" -d '{"product_codes":["MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "TSHIRT"]}' http://localhost:3000/total_price
```
response:
```
{"items":"9 MUG, 1 TSHIRT","total":"69.0"}%
```

curl:
```
curl -X POST -H "Content-Type: application/json" -d '{"product_codes":["MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "TSHIRT"]}' http://localhost:3000/total_price
```
response:
```
{"items":"10 MUG, 1 TSHIRT","total":"73.8"}%
```

curl:
```
curl -X POST -H "Content-Type: application/json" -d '{"product_codes":["MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "TSHIRT", "TSHIRT", "TSHIRT"]}' http://localhost:3000/total_price
```
response:
```
{"items":"45 MUG, 3 TSHIRT","total":"279.90"}%
```

curl:
```
curl -X POST -H "Content-Type: application/json" -d '{"product_codes":["MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "MUG", "TSHIRT", "TSHIRT", "TSHIRT", "TSHIRT", "HOODIE"]}' http://localhost:3000/total_price
```
response:
```
{"items":"200 MUG, 4 TSHIRT, 1 HOODIE","total":"902.0"}%
```
