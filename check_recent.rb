puts "Searching for 'beyza'..."
User.where('username LIKE ? OR email LIKE ?', '%beyza%', '%beyza%').each do |u|
  puts "#{u.id}: #{u.username} (#{u.email}) - #{u.created_at}"
end
