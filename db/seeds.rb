# This file should ensure the existence of records required to run the application
# in every environment (production, development, test).

puts "🌱 Seeding database..."

# Create demo users
users_data = [
  { username: "admin", display_name: "Admin Kullanıcı", email: "admin@example.com", password: "password123", bio: "Platform yöneticisi 🛠️" },
  { username: "ayse", display_name: "Ayşe Yılmaz", email: "ayse@example.com", password: "password123", bio: "Yazılım geliştirici 💻 | Kahve bağımlısı ☕" },
  { username: "mehmet", display_name: "Mehmet Kaya", email: "mehmet@example.com", password: "password123", bio: "Full-stack developer | Ruby on Rails ❤️" },
  { username: "zeynep", display_name: "Zeynep Demir", email: "zeynep@example.com", password: "password123", bio: "UI/UX Designer 🎨 | Minimal tasarım sevdalısı" },
  { username: "ali", display_name: "Ali Öztürk", email: "ali@example.com", password: "password123", bio: "DevOps Engineer ⚙️ | Docker & Kubernetes" },
  { username: "fatma", display_name: "Fatma Şahin", email: "fatma@example.com", password: "password123", bio: "Data Scientist 📊 | Machine Learning enthusiast" },
]

users = users_data.map do |data|
  User.find_or_create_by!(email: data[:email]) do |user|
    user.username = data[:username]
    user.display_name = data[:display_name]
    user.password = data[:password]
    user.password_confirmation = data[:password]
    user.bio = data[:bio]
  end
end

puts "✅ #{users.count} kullanıcı oluşturuldu"

# Create sample tweets
tweets_data = [
  { user: users[0], content: "Çivit platformuna hoş geldiniz! 🐦 Bu platform Ruby on Rails 7, Hotwire ve Tailwind CSS ile geliştirildi." },
  { user: users[1], content: "Bugün yeni bir proje başlattım. Rails 7 ile geliştirme yapmak gerçekten çok keyifli! 🚀 #RubyOnRails #WebDev" },
  { user: users[2], content: "Hotwire ile Turbo Streams kullanarak sayfa yenilemeden anlık güncellemeler yapabiliyoruz. Müthiş bir teknoloji! ⚡" },
  { user: users[3], content: "Yeni bir UI tasarımı üzerinde çalışıyorum. Minimalist ve modern bir yaklaşım benimsedim. Tailwind CSS ile harikalar yaratılabiliyor! 🎨✨" },
  { user: users[4], content: "Docker container'larımızı optimize ettik. Artık deployment süresi %60 azaldı! 🐳💪" },
  { user: users[5], content: "Makine öğrenimi modelimiz %95 doğruluk oranına ulaştı! Veri bilimi harika bir alan. 📈🤖" },
  { user: users[1], content: "Stimulus.js ile karmaşık JavaScript davranışlarını bile çok temiz bir şekilde yönetebiliyoruz. Convention over configuration felsefesi burada da geçerli! 💡" },
  { user: users[2], content: "PostgreSQL'in JSONB desteği inanılmaz güçlü. NoSQL esnekliğini SQL dünyasına taşıyor. 🗄️" },
  { user: users[0], content: "Bu platform açık kaynak olarak geliştirilmektedir. Katkıda bulunmak isteyenler GitHub repo'muza göz atabilir! 🤝 #OpenSource" },
  { user: users[3], content: "Tasarımda karanlık mod (dark mode) artık bir tercih değil, zorunluluk. Gözleri yormayan, şık bir deneyim sunuyor. 🌙" },
]

tweets = tweets_data.map do |data|
  Tweet.create!(user: data[:user], content: data[:content])
end

puts "✅ #{tweets.count} tweet oluşturuldu"

# Create some follows
follow_pairs = [
  [users[0], users[1]], [users[0], users[2]], [users[0], users[3]],
  [users[1], users[0]], [users[1], users[2]], [users[1], users[4]],
  [users[2], users[0]], [users[2], users[1]], [users[2], users[5]],
  [users[3], users[0]], [users[3], users[1]], [users[3], users[2]],
  [users[4], users[0]], [users[4], users[2]],
  [users[5], users[0]], [users[5], users[1]], [users[5], users[3]],
]

follow_pairs.each do |follower, followed|
  follower.follow(followed)
end

puts "✅ Takip ilişkileri oluşturuldu"

# Create some likes
tweets.each_with_index do |tweet, i|
  likers = users.sample(rand(1..4))
  likers.each do |user|
    Like.find_or_create_by!(user: user, tweet: tweet)
  end
end

# Update counter caches
Tweet.find_each { |t| Tweet.reset_counters(t.id, :likes, :comments) }
User.find_each { |u| User.reset_counters(u.id, :tweets) }

puts "✅ Beğeniler oluşturuldu"

# Create some comments
comments_data = [
  { tweet: tweets[0], user: users[1], content: "Harika bir platform! Tebrikler 👏" },
  { tweet: tweets[0], user: users[2], content: "Rails 7 ile çok güzel olmuş, başarılar!" },
  { tweet: tweets[1], user: users[0], content: "Rails'i seviyoruz! ❤️" },
  { tweet: tweets[2], user: users[3], content: "Turbo Streams gerçekten oyun değiştirici!" },
  { tweet: tweets[3], user: users[1], content: "Tasarım harika görünüyor! 😍" },
  { tweet: tweets[4], user: users[5], content: "Docker optimizasyonu çok önemli, bravo!" },
]

comments_data.each do |data|
  Comment.create!(tweet: data[:tweet], user: data[:user], content: data[:content])
end

# Update comment counter caches
Tweet.find_each { |t| Tweet.reset_counters(t.id, :comments) }

puts "✅ Yorumlar oluşturuldu"
puts ""
puts "🎉 Seed tamamlandı!"
puts ""
puts "📧 Demo Giriş Bilgileri:"
puts "   E-posta: admin@example.com"
puts "   Şifre:   password123"
puts ""
