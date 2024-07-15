# Clear existing data to start fresh (optional, be careful with this in production)
User.destroy_all

# Create users
user1 = User.create(name: 'Asbah 1', email: 'asbah@gmail.com', password: 'password')
user2 = User.create(name: 'Asbah 2', email: 'asbah2@gmail.com', password: 'password')

# Create income-expenditure statements for each user
ie_statement1 = user1.ie_statements.create(month: 'january')
ie_statement2 = user2.ie_statements.create(month: 'january')

# Create incomes for statement 1
income1_1 = ie_statement1.incomes.create(name: 'Salary', amount: 5000)
income1_2 = ie_statement1.incomes.create(name: 'Bonus', amount: 1000)

# Create expenditures for statement 1
expenditure1_1 = ie_statement1.expenditures.create(name: 'Rent', amount: 1500)
expenditure1_2 = ie_statement1.expenditures.create(name: 'Utilities', amount: 300)

# Create incomes for statement 2
income2_1 = ie_statement2.incomes.create(name: 'Consulting Fee', amount: 3000)
income2_2 = ie_statement2.incomes.create(name: 'Freelance Income', amount: 1200)

# Create expenditures for statement 2
expenditure2_1 = ie_statement2.expenditures.create(name: 'Food', amount: 500)
expenditure2_2 = ie_statement2.expenditures.create(name: 'Transportation', amount: 200)

puts "Seed data created successfully!"

puts "#{user1.id}  #{user2.id}"
puts "#{ie_statement1.id}  #{ie_statement2.id}"