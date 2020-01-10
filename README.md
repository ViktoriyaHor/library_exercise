# Library exercise

Books page: the list with all the books, 20 per page. Shows basic info:
    * Image
    * Book name - this is a link to book /show page.
    * Author
    * Status (status can be in/out). If status is out then display user name who took a book.
    * Edit, delete and create new book.
    Top 5 books based on likes count and taken count. Top books are displayed regardless of pagination.
    
Each book has the information:
    * Image
    * Name
    * Description
    * Likes counter
    * Author
    * Status
    * Comments
    * History    
    History includes: name of user who took a book, when book has been taked, when returned back.    
    User allowed to comment, edit, delete, like, take or return a book.
    Take, return, like book without page reloading.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

You must install ruby 2.6.3 and gem install bundler. 

### Installing

A step by step series of examples that tell you how to get a development env running

Create gemset test_sales_history and install gem's. 
Execute commands:

```
$ rvm gemset create library
$ rvm use 2.6.3@library
$ bundle
```
Then execute commands for db seed:

```
$ rake db:seed
```

## Running the tests

Please do to run the automated tests for this system (model's and controller's tests)

```
$ rspec spec -fd
```
## Deployment

I deployed project on Heroku

https://fathomless-bastion-12372.herokuapp.com

## Built With

I used Ruby 2.6.3, Rails 6, MongoDB, UIkit, for the tests - rspec

## Author

Viktoriya Khoroshun




