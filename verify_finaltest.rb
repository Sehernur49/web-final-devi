u = User.find_by(username: 'finaltest')
puts "User: #{u.username}, Email: #{u.email}"
puts "Checking password 'password'..."
if u.valid_password?('password')
  puts "SUCCESS: Password matches!"
else
  puts "FAILURE: Password does NOT match!"
end
