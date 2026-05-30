# 🐦 Çivit — Twitter Clone (MVP)

> Ruby on Rails 7 + PostgreSQL + Hotwire (Turbo/Stimulus) + Tailwind CSS ile geliştirilmiş kapsamlı bir Twitter klonu.

## 📸 Özellikler

### ✅ Authentication (Devise)
- Kayıt olma (username, display_name, bio, email, password)
- Giriş / Çıkış
- Profil düzenleme
- Session yönetimi

### ✅ Tweet Sistemi
- Tweet oluşturma (max 280 karakter)
- Tweet silme
- Tweet düzenleme
- Karakter sayacı (gerçek zamanlı SVG progress)
- Ters kronolojik sıralama

### ✅ Beğeni (Like) Sistemi
- Tweet beğenme / beğeniyi geri alma
- Beğeni sayacı (counter cache)
- Turbo Stream ile anlık güncelleme (sayfa yenilenmeden)
- Kalp animasyonu

### ✅ Yorum (Comment) Sistemi
- Tweetlere yorum yapma
- Yorum silme
- Yorum sayacı
- Turbo Stream ile anlık güncelleme

### ✅ Takip (Follow) Sistemi
- Self-referential association (User → Relationship → User)
- Takip et / Takibi bırak
- Takipçi & Takip listesi
- Counter cache (followers_count, following_count)
- Turbo Stream ile anlık güncelleme

### ✅ Modern UX (Hotwire)
- **Turbo Streams**: Tweet atma, beğenme, yorum yapma sayfa yenilenmeden
- **Turbo Frames**: Tweet detayları ve yorumlar
- **Stimulus**: Karakter sayacı, flash mesaj animasyonu
- **Gerçek zamanlı**: Broadcasting desteği

### ✅ Tasarım
- **Tailwind CSS 3**: Utility-first CSS
- **Karanlık Mod**: Tam karanlık tema
- **Mobil Uyumlu**: Responsive sidebar layout
- **Animasyonlar**: fadeIn, likePop, slideIn/Out
- **Twitter-benzeri UI**: Avatar, header, action buttons

---

## 🛠️ Teknik Mimari

| Katman | Teknoloji |
|--------|-----------|
| Backend | Ruby on Rails 7.1 |
| Database | PostgreSQL |
| Auth | Devise |
| Frontend | Hotwire (Turbo + Stimulus) |
| CSS | Tailwind CSS 3 |
| Assets | Propshaft + importmap-rails |

### Veritabanı Şeması

```
User (Devise)
├── username (unique)
├── display_name
├── bio
├── followers_count
├── following_count
└── tweets_count

Tweet
├── content (max 280)
├── user_id (FK)
├── likes_count
└── comments_count

Comment
├── content
├── user_id (FK)
└── tweet_id (FK)

Like (Join Table)
├── user_id (FK)
└── tweet_id (FK, unique with user_id)

Relationship (Self-referential)
├── follower_id (FK → User)
└── followed_id (FK → User, unique with follower_id)
```

### Model İlişkileri

```ruby
User
  has_many :tweets
  has_many :comments
  has_many :likes
  has_many :liked_tweets, through: :likes
  has_many :active_relationships  (follower)
  has_many :passive_relationships (followed)
  has_many :following, through: :active_relationships
  has_many :followers, through: :passive_relationships

Tweet
  belongs_to :user (counter_cache)
  has_many :comments
  has_many :likes

Comment
  belongs_to :user
  belongs_to :tweet (counter_cache)

Like
  belongs_to :user
  belongs_to :tweet (counter_cache)

Relationship
  belongs_to :follower (User, counter_cache: :following_count)
  belongs_to :followed (User, counter_cache: :followers_count)
```

---

## 🚀 Kurulum

### Gereksinimler

- **Ruby** 3.3.0+
- **Rails** 7.1+
- **PostgreSQL** 14+
- **Node.js** 18+ (Tailwind CSS için)

### 1. Ruby Kurulumu (Windows)

```powershell
# RubyInstaller ile kur (https://rubyinstaller.org/)
# Ruby+Devkit 3.3.x (x64) indir ve kur

# Kontrol:
ruby --version
gem --version
```

### 2. PostgreSQL Kurulumu

```powershell
# https://www.postgresql.org/download/windows/ adresinden indir
# Veya winget ile:
winget install PostgreSQL.PostgreSQL

# Kontrol:
psql --version
```

### 3. Proje Kurulumu

```powershell
# Proje dizinine git
cd "web final ödevi"

# Gem'leri kur
bundle install

# Tailwind CSS'i kur
rails tailwindcss:install

# Veritabanını oluştur
rails db:create
rails db:migrate
rails db:seed

# Sunucuyu başlat
rails server
# veya Tailwind ile birlikte:
bin/dev
```

### 4. Tarayıcıda Aç

```
http://localhost:3000
```

### Demo Giriş Bilgileri

| E-posta | Şifre |
|---------|-------|
| admin@example.com | password123 |
| ayse@example.com | password123 |
| mehmet@example.com | password123 |

---

## 📁 Proje Yapısı

```
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   ├── tweets_controller.rb      # CRUD + Turbo Stream
│   │   ├── comments_controller.rb     # Create/Destroy + Turbo
│   │   ├── likes_controller.rb        # Like toggle + Turbo
│   │   ├── users_controller.rb        # Profile + Follow/Unfollow
│   │   └── users/                     # Devise custom controllers
│   ├── models/
│   │   ├── user.rb                    # Devise + Follow + Feed
│   │   ├── tweet.rb                   # Broadcasts + Scopes
│   │   ├── comment.rb                 # Counter cache
│   │   ├── like.rb                    # Uniqueness
│   │   └── relationship.rb           # Self-referential
│   ├── views/
│   │   ├── layouts/application.html.erb
│   │   ├── tweets/                    # Index, Show, Edit, Partials
│   │   ├── comments/                  # Partials
│   │   ├── likes/                     # Button partial
│   │   ├── users/                     # Show, Index, Follow list
│   │   ├── devise/                    # Login, Register, Edit
│   │   └── shared/                    # Sidebar, Right sidebar
│   ├── javascript/controllers/        # Stimulus controllers
│   └── helpers/
├── config/
│   ├── routes.rb                      # RESTful routes
│   ├── database.yml                   # PostgreSQL config
│   ├── tailwind.config.js            # Tailwind + Dark mode
│   └── initializers/devise.rb        # Devise config
├── db/
│   ├── migrate/                       # 5 migration files
│   ├── schema.rb
│   └── seeds.rb                       # Demo data
└── Gemfile
```

---

## 🎨 Turbo Stream Kullanımı

### Tweet Oluşturma (Sayfa Yenilenmeden)
```ruby
# tweets_controller.rb - create action
format.turbo_stream do
  render turbo_stream: [
    turbo_stream.prepend("tweets", partial: "tweets/tweet"),
    turbo_stream.replace("tweet_form", partial: "tweets/form"),
    turbo_stream.update("tweet_count", count)
  ]
end
```

### Beğeni Toggle (Sayfa Yenilenmeden)
```ruby
# likes_controller.rb - create/destroy
format.turbo_stream do
  render turbo_stream: turbo_stream.replace(
    "like_button_#{@tweet.id}",
    partial: "likes/button"
  )
end
```

### Takip (Sayfa Yenilenmeden)
```ruby
# users_controller.rb - follow/unfollow
format.turbo_stream do
  render turbo_stream: [
    turbo_stream.replace("follow_button_#{@user.id}", ...),
    turbo_stream.replace("followers_count_#{@user.id}", ...)
  ]
end
```

---

## 📝 Lisans

Bu proje eğitim amaçlı geliştirilmiştir.

---

*Rails 7 + Hotwire + Tailwind CSS ile ❤️ ile geliştirildi*
