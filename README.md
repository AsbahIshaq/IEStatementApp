# IeStatementApp

## Description of the app
The app manages IE (Income and Expenditure) statements of users. Currently there are no admins and each user can create or update their own IE statements. A user can have multiple statements, 1 for each month but currently year is not considered so we assume that the statements are for only the current year.

## How to run locally
First of all install the gems using bundle install and then setup the db.

```bash
bundle install
rails db:create db:migrate db:seed
rails s
```

Now it is available to run.

## How to manage your statements

### Login
After running the server use this url to log in using POST request:
```
http://localhost:3000/auth/login
```
add params:
```
{
  "auth": {
    "email": "asbah@gmail.com",
    "password": "password"
  }
}
```

This will generate a token that you can use to authenticate further requests.

### Create a statement
Use the following url in POST request:
```
http://localhost:3000/users/{user_id}/ie_statements
```
add params like this:
```
{
    "ie_statement":
    {
    "month": "february",
    "income": [
        {
            "name": "salary",
            "amount": 2800
        },
        {
            "name": "other",
            "amount": 200
        }
    ],
    "expenditure": [
        {
            "name": "gas",
            "amount": 100
        }
    ]
    }
}
```
If a statement already exists for the same month it will add the new incomes and expenditures in it otherwise it will create it.

### Retrieve a statement
Use GET request
```
http://localhost:3000/users/7/ie_statements/monthly_statement
```
params:
```
month = "february"
```

Use this url for downloading it in csv:
```
http://localhost:3000/users/7/ie_statements/monthly_statement_download
```

This will include all the details including incomes and expenditures.
Sample response:
```
{
    "id": 3,
    "user_id": 7,
    "total_income": "6000.0",
    "total_expenditure": "200.0",
    "disposable_income": "5800.0",
    "rating": "A",
    "month": "february",
    "created_at": "2024-07-17T11:57:19.636Z",
    "updated_at": "2024-07-17T11:58:41.376Z",
    "incomes": [
        {
            "id": 5,
            "name": "salary",
            "amount": "2800.0",
            "ie_statement_id": 3,
            "created_at": "2024-07-17T11:57:19.669Z",
            "updated_at": "2024-07-17T11:57:19.669Z"
        },
        {
            "id": 6,
            "name": "other",
            "amount": "200.0",
            "ie_statement_id": 3,
            "created_at": "2024-07-17T11:57:19.678Z",
            "updated_at": "2024-07-17T11:57:19.678Z"
        },
        {
            "id": 7,
            "name": "salary",
            "amount": "2800.0",
            "ie_statement_id": 3,
            "created_at": "2024-07-17T11:58:41.335Z",
            "updated_at": "2024-07-17T11:58:41.335Z"
        },
        {
            "id": 8,
            "name": "other",
            "amount": "200.0",
            "ie_statement_id": 3,
            "created_at": "2024-07-17T11:58:41.339Z",
            "updated_at": "2024-07-17T11:58:41.339Z"
        }
    ],
    "expenditures": [
        {
            "id": 5,
            "name": "gas",
            "amount": "100.0",
            "ie_statement_id": 3,
            "created_at": "2024-07-17T11:57:19.716Z",
            "updated_at": "2024-07-17T11:57:19.716Z"
        },
        {
            "id": 6,
            "name": "gas",
            "amount": "100.0",
            "ie_statement_id": 3,
            "created_at": "2024-07-17T11:58:41.362Z",
            "updated_at": "2024-07-17T11:58:41.362Z"
        }
    ]
}
```

You can also use IE statement id to retrieve your statement. Use GET request.
```
http://localhost:3000/users/{user_id}/ie_statements/{statement_id}
```

The sample response for it:
```
{
    "user_id": 7,
    "total_income": "6000.0",
    "total_expenditure": "200.0",
    "disposable_income": "5800.0",
    "rating": "A",
    "id": 3,
    "month": "february",
    "created_at": "2024-07-17T11:57:19.636Z",
    "updated_at": "2024-07-17T11:58:41.376Z"
}
```

## Improvements
This is a very basic version. In future it can be improved to:
1. Allow the ability to update or delete a IE statement.
2. Better authorization. Currently it is a basic authorization that a IE statement can only be managed by the person themselves
3. Admins and other roles can be added who would have different levels of access.
4. API documentation is missing. It can be added in proper format
5. Gemfile could be improved with version numbers with each gem and removing some extra gems
6. Add a docker file

## Though Process
I read the doument and understood it. It asked to create an API application so I initialized rails with api. Next I went through the requirments and decided which ones to do first.
If I save the statements in db then I can also add users and the association between user and statements easily. That would complete the first MUST requirment along it the first SHOULD statement.
Also I will be able to get the disposible income and rating easily if I added them to the table
I realized that most of the requirments are very much interconnected.

I decided to skip this one:
"Should have the ability for customers to define their own customer’s income and expenditures"
It will not be much difficult to add customers of a customer, it can be done by adding association of a user with itself. A user has many users. But then I will have to add better authorization, a customer should be able to create a statement for him/herself and also his/her customers. But he/she shouldn't be able to manage statements of other customers.

"Could respond in JSON" is also easy with REST.

Starting implementation I thought about the main entities. These would be user and ie statements. Looking at the ie statement sample I figured it would be best to create separate models/tables for incomes and expenses. Then I decided to use service based architecture.

I searched how to add user authentication in rails because it's been a while. I added token based authentication.